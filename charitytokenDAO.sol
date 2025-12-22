// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract CharityTokenDAO is ERC20 {
    struct Request {
        uint id;
        string description;
        uint value;
        address payable recipient;
        bool completed;
        bool cancelled; // <--- MỚI: Trạng thái hủy
        uint voteCount;
        uint startTime;
        uint duration;
    }

    Request[] public requests;
    mapping(uint => mapping(address => bool)) public hasVoted;
    address public admin;
    uint public constant RATE = 1000; 

    constructor() ERC20("Charity Governance Token", "CHT") {
        admin = msg.sender;
    }

    function donate() public payable {
        require(msg.value > 0, "Phai gui ETH > 0");
        uint tokensToMint = msg.value * RATE;
        _mint(msg.sender, tokensToMint);
    }

    function createRequest(string memory description, uint value, address payable recipient, uint durationInSeconds) public {
        require(msg.sender == admin, "Chi Admin moi duoc tao");
        requests.push(Request({
            id: requests.length,
            description: description,
            value: value,
            recipient: recipient,
            completed: false,
            cancelled: false, // Mặc định là chưa hủy
            voteCount: 0,
            startTime: block.timestamp,
            duration: durationInSeconds
        }));
    }

    function voteRequest(uint index) public {
        Request storage req = requests[index];
        require(!req.cancelled, "Yeu cau da bi huy"); // Check hủy
        require(balanceOf(msg.sender) > 0, "Can Token de vote");
        require(!hasVoted[index][msg.sender], "Da vote roi");
        require(block.timestamp < req.startTime + req.duration, "Het gio vote");

        req.voteCount += balanceOf(msg.sender);
        hasVoted[index][msg.sender] = true;
    }

    function finalizeRequest(uint index) public {
        require(msg.sender == admin, "Chi Admin");
        Request storage req = requests[index];

        require(!req.completed, "Da hoan thanh");
        require(!req.cancelled, "Da bi huy"); // Check hủy
        require(block.timestamp >= req.startTime + req.duration, "Chua het gio");
        require(address(this).balance >= req.value, "Thieu tien");
        require(req.voteCount > totalSupply() / 2, "Thieu phieu");
        
        req.completed = true;
        (bool success, ) = req.recipient.call{value: req.value}("");
        require(success, "Loi chuyen tien");
    }

    // --- HÀM MỚI: HỦY YÊU CẦU ---
    function cancelRequest(uint index) public {
        require(msg.sender == admin, "Chi Admin");
        Request storage req = requests[index];
        require(!req.completed, "Da hoan thanh khong the huy");
        require(!req.cancelled, "Da huy roi");
        
        req.cancelled = true; // Đánh dấu hủy
    }

    function getRequests() public view returns (Request[] memory) {
        return requests;
    }
    
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}