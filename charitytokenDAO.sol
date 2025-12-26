// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract CharityEqualityDAO is ERC20 {
    struct Request {
        uint id;
        string description;
        uint value;
        address payable recipient;
        bool completed;
        bool cancelled;
        uint voteCount;
        uint startTime;
        uint duration;
    }

    Request[] public requests;
    mapping(uint => mapping(address => bool)) public hasVoted;
    address public admin;
    uint public totalContributors;
    mapping(address => bool) public isContributor;
    uint public constant RATE = 1000; 

    // Sự kiện để web biết tiền đã tự động chuyển
    event MoneySent(uint requestId, address recipient, uint amount);

    constructor() ERC20("Charity Governance Token", "CHT") {
        admin = msg.sender;
    }

    function donate() public payable {
        require(msg.value > 0, "Phai gui ETH > 0");
        uint tokensToMint = msg.value * RATE;
        _mint(msg.sender, tokensToMint);
        if (!isContributor[msg.sender]) {
            isContributor[msg.sender] = true;
            totalContributors++;
        }
    }

    function createRequest(string memory description, uint value, address payable recipient, uint durationInSeconds) public {
        require(msg.sender == admin, "Chi Admin");
        requests.push(Request({
            id: requests.length,
            description: description,
            value: value,
            recipient: recipient,
            completed: false,
            cancelled: false,
            voteCount: 0,
            startTime: block.timestamp,
            duration: durationInSeconds
        }));
    }

    // --- TỰ ĐỘNG CHUYỂN TIỀN ---
    function voteRequest(uint index) public {
        Request storage req = requests[index];
        
        require(!req.cancelled, "Da huy");
        require(!req.completed, "Yeu cau nay da hoan thanh (tien da chuyen)");
        require(balanceOf(msg.sender) > 0, "Phai la thanh vien");
        require(!hasVoted[index][msg.sender], "Da vote roi");
        require(block.timestamp < req.startTime + req.duration, "Het gio");

        // 1. Ghi nhận phiếu bầu
        req.voteCount += 1; 
        hasVoted[index][msg.sender] = true;

        // 2. KIỂM TRA NGAY LẬP TỨC: Đã đủ phiếu chưa?
        // Nếu số phiếu hiện tại > 50% tổng số người
        if (req.voteCount > totalContributors / 2) {
            // Đủ điều kiện -> TỰ ĐỘNG CHUYỂN TIỀN LUÔN
            if (address(this).balance >= req.value) {
                req.completed = true;
                (bool success, ) = req.recipient.call{value: req.value}("");
                require(success, "Loi tu dong chuyen tien");
                
                emit MoneySent(index, req.recipient, req.value);
            }
        }
    }

    // Hàm Hủy để Admin xử lý nếu cần
    function cancelRequest(uint index) public {
        require(msg.sender == admin, "Chi Admin");
        Request storage req = requests[index];
        require(!req.completed && !req.cancelled, "Khong the huy");
        req.cancelled = true;
    }

    function getRequests() public view returns (Request[] memory) { return requests; }
    function getBalance() public view returns (uint) { return address(this).balance; }
}