variable "env_name" {
  description = "Ten dinh danh moi truong (dev, staging, prod)"
  type        = string
}
variable "aws_region" {
  description = "Region trien khai ha tang (Mac dinh la Singapore) "
  type        = string
  default     = "ap-southeast-1"
}

variable "vpc_cidr" {
  description = "Dai mang CIDR chuan Enterprise ( VD: 172.24.0.0/16 )"
  type        = string
}

variable "enable_nat_gateway" {
  description = "Bat/Tat Nat Gateway"
  type        = bool
  default     = false
}

