# 🌍 Charity Token DAO - Nền tảng Từ thiện Phi tập trung thế hệ mới

![Ethereum](https://img.shields.io/badge/Blockchain-Ethereum-3C3C3D?style=for-the-badge&logo=ethereum)
![Solidity](https://img.shields.io/badge/Smart_Contract-Solidity-363636?style=for-the-badge&logo=solidity)
![Network](https://img.shields.io/badge/Network-Sepolia_Testnet-red?style=for-the-badge)
![Firebase](https://img.shields.io/badge/Database-Firebase-FFCA28?style=for-the-badge&logo=firebase)


---

## 📖 Giới thiệu (Overview)

**Charity Token DAO** là một ứng dụng phi tập trung (DApp) giải quyết vấn đề thiếu minh bạch trong hoạt động từ thiện truyền thống. Hệ thống áp dụng mô hình **Hybrid (Lai)** kết hợp giữa sức mạnh của Blockchain và trải nghiệm người dùng Web2.

Thay vì chỉ quyên góp và "mất hút", người dùng sẽ nhận lại **Token Quản trị (CHT)**. Số lượng Token này đại diện cho quyền lực của họ trong việc biểu quyết các khoản chi tiêu của quỹ.

---

## ✨ Tính năng nổi bật (Key Features)

### 1. 🪙 Tokenomics & ERC-20
- **Minting tự động:** Khi người dùng quyên góp ETH, Smart Contract tự động in (mint) và gửi lại Token **CHT** vào ví họ theo tỷ lệ **1 ETH = 1000 CHT**.
- **Stake-based Voting:** Sức mạnh lá phiếu khi bầu cử dựa trên số dư Token CHT mà người dùng nắm giữ (Góp nhiều -> Quyền lớn).

### 2. 🛡️ Cơ chế DAO (Decentralized Autonomous Organization)
- **Quỹ bị khóa:** Admin không thể tự ý rút tiền. Tiền ETH nằm an toàn trong Smart Contract.
- **Đề xuất có thời hạn:** Admin tạo yêu cầu rút tiền kèm theo thời gian đếm ngược (VD: 5 phút, 1 ngày).
- **Đồng thuận:** Tiền chỉ được giải ngân (Finalize) khi số phiếu đồng thuận (Vote) > **50% Tổng cung Token** trên thị trường.

### 3. 🔐 Hệ thống Hybrid (Web3 + Firebase)
- **Định danh kép:** Kết hợp đăng nhập Email (qua Firebase) để quản lý phiên làm việc và Ví MetaMask để ký giao dịch Blockchain.
- **Phân quyền:** Giao diện tự động ẩn/hiện các chức năng Admin dựa trên tài khoản đăng nhập.

### 4. 👁️ Minh bạch & Tiện ích
- Tích hợp link **Etherscan** xác thực từng giao dịch.
- Hỗ trợ thêm Token CHT vào ví MetaMask chỉ với 1 click.
- Giao diện Dark Mode hiện đại, thân thiện.

---

## 🛠️ Công nghệ sử dụng (Tech Stack)

| Thành phần | Công nghệ | Chi tiết |
| :--- | :--- | :--- |
| **Frontend** | HTML5, CSS3, JS | Bootstrap 5, SweetAlert2 |
| **Blockchain** | Solidity (v0.8.0) | OpenZeppelin ERC-20 Standard |
| **Kết nối Web3** | Ethers.js v5.7 | Provider & Signer |
| **Backend/Auth** | Firebase | Authentication & Hosting |
| **Ví điện tử** | MetaMask | Sepolia Network |
| **Môi trường** | Remix IDE | Deploy & Verify Contract |

---

## 🚀 Hướng dẫn cài đặt & Chạy (Installation)

### Yêu cầu tiên quyết
- Trình duyệt Chrome/Edge có cài **MetaMask**.
- Trong ví có sẵn **Sepolia ETH** (Lấy tại [Sepolia Faucet](https://sepoliafaucet.com/)).

### Bước 1: Tải mã nguồn
Clone repository này về máy:
```bash
https://github.com/ElmMinG/DoanNhom3-blockchain.git


Bước 2: Chạy ứng dụng
Mở thư mục dự án.
Chạy file index.html (Khuyên dùng Live Server trên VS Code).
Ứng dụng sẽ tự động chuyển hướng về trang Đăng nhập.
Bước 3: Đăng nhập & Kết nối
Tài khoản Admin (Demo):
Email: admin@gmail.com
Mật khẩu: 123
Kết nối Ví:
Chuyển MetaMask sang mạng Sepolia.
Bấm nút "Kết nối Ví" trên giao diện.
