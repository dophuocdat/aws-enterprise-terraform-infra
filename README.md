# AWS Enterprise VPC Infrastructure with Terraform

Dự án thiết kế và triển khai hạ tầng mạng **AWS VPC chuẩn Enterprise** theo phương pháp **Infrastructure as Code (IaC)** sử dụng Terraform Module tái sử dụng.

## Điểm nổi bật trong kiến trúc (Key Highlights)
* **Quy hoạch IP chuẩn Enterprise (RFC 1918 Class B):** Sử dụng dải mạng `172.24.0.0/16` (Staging) thay vì dải mặc định `10.0.0.0/16` nhằm tránh xung đột IP (Overlapping CIDR) khi kết nối Site-to-Site VPN hoặc VPC Peering.
* **High Availability (Multi-AZ):** Phân bổ tự động các Public và Private Subnets trải đều trên 2 Availability Zones (`ap-southeast-1a`, `ap-southeast-1b`) bằng hàm `cidrsubnet`.
* **Tối ưu chi phí (FinOps):** 
  * Tích hợp sẵn công tắc bật/tắt linh hoạt `enable_nat_gateway` (Tiết kiệm ~$32/tháng cho môi trường Dev/Staging).
  * Sử dụng **S3 VPC Gateway Endpoint** miễn phí 100%, giúp các máy chủ trong Private Subnet giao tiếp trực tiếp với AWS S3 qua mạng nội bộ AWS mà không cần đi qua NAT Gateway.

## Cấu trúc thư mục
```text
aws-enterprise-infra/
├── modules/
│   └── vpc/                 # Reusable VPC Module (VPC, Subnets, IGW, Route Tables, S3 Endpoint)
└── environments/
    └── staging/             # Cấu hình triển khai thực tế cho môi trường Staging (172.24.0.0/16)
