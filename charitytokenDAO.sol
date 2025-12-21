// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import thư viện ERC-20 chuẩn từ OpenZeppelin
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract CharityTokenDAO is ERC20 {
    struct Request {
        uint id;
        string description;
        uint value;
        address payable recipient;
        bool completed;
        uint voteCount; // Đếm số lượng Token ủng hộ
        uint startTime;
        uint duration;
    }

    Request[] public requests;
    mapping(uint => mapping(address => bool)) public hasVoted;
    address public admin;
    
    // Tỷ lệ quy đổi: 1 ETH = 1000 Token CHT
    uint public constant RATE = 1000; 

    constructor() ERC20("Charity Governance Token", "CHT") {
        admin = msg.sender;
    }

    // 1. Quyên góp ETH -> Nhận Token CHT (Mint)
    function donate() public payable {
        require(msg.value > 0, "Phai gui ETH > 0");
        
        // Tính lượng token nhận được (Ví dụ: 0.1 ETH -> 100 Token)
        uint tokensToMint = msg.value * RATE;
        
        // In token ra và chuyển ngay cho người quyên góp
        _mint(msg.sender, tokensToMint);
    }

    // 2. Tạo yêu cầu rút tiền (Có thời hạn vote)
    function createRequest(string memory description, uint value, address payable recipient, uint durationInSeconds) public {
        require(msg.sender == admin, "Chi Admin moi duoc tao yeu cau");
        requests.push(Request({
            id: requests.length,
            description: description,
            value: value,
            recipient: recipient,
            completed: false,
            voteCount: 0,
            startTime: block.timestamp,
            duration: durationInSeconds
        }));
    }

    // 3. Vote bằng Token (Sức mạnh lá phiếu = Số Token đang giữ)
    function voteRequest(uint index) public {
        Request storage req = requests[index];
        
        require(balanceOf(msg.sender) > 0, "Ban phai co Token CHT moi duoc vote");
        require(!hasVoted[index][msg.sender], "Ban da vote cho yeu cau nay roi");
        require(block.timestamp < req.startTime + req.duration, "Da het thoi gian vote");

        // Cộng dồn sức mạnh vote
        req.voteCount += balanceOf(msg.sender);
        
        // Đánh dấu đã vote
        hasVoted[index][msg.sender] = true;
    }

    // 4. Rút tiền (Đã sửa lỗi transfer thành call)
    function finalizeRequest(uint index) public {
        require(msg.sender == admin, "Chi Admin moi duoc rut tien");
        Request storage req = requests[index];

        require(!req.completed, "Yeu cau nay da duoc giai ngan roi");
        require(block.timestamp >= req.startTime + req.duration, "Chua het thoi gian vote");
        require(address(this).balance >= req.value, "Quy khong du tien mat (ETH)");
        
        // Điều kiện: Số Token đồng ý phải > 50% tổng lượng Token đã phát hành
        // totalSupply() là hàm có sẵn của ERC20
        require(req.voteCount > totalSupply() / 2, "Chua du so phieu dong thuan (Token)");
        
        req.completed = true;

        // --- ĐOẠN ĐÃ SỬA ---
        // Thay thế transfer() bằng call() để an toàn và tránh cảnh báo
        (bool success, ) = req.recipient.call{value: req.value}("");
        require(success, "Giao dich chuyen tien that bai");
        // ------------------
    }

    // Hàm lấy danh sách yêu cầu
    function getRequests() public view returns (Request[] memory) {
        return requests;
    }
    
    // Hàm xem số dư ETH của quỹ
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}