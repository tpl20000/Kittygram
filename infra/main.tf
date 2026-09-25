terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      }
  }
  backend "s3" {
    endpoints                   = { 
      s3 = "https://storage.yandexcloud.net"
      }
    bucket                      = "kittygram-bucket-tfstate"
    region                      = "ru-central1"
    key                         = "tf-state.tfstate"
    workspace_key_prefix        = "tf-state"
    use_path_style              = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

provider "yandex" { 
  zone = "ru-central1-a"
  token = var.YC_IAM_TOKEN
  cloud_id = var.YC_CLOUD_ID
  folder_id = var.YC_FOLDER_ID
}

# Сеть и подсеть
resource "yandex_vpc_network" "net" {}

resource "yandex_vpc_subnet" "sub" {
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = ["10.128.0.0/24"]
}

# Группа безопасности
resource "yandex_vpc_security_group" "sg" {
  network_id = yandex_vpc_network.net.id

  ingress {
    protocol = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port = 22 
    }

  ingress {
    protocol = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port = 80 
    }

  egress  { 
    protocol = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 65535 
    }
}

# Виртуальная машина
resource "yandex_compute_instance" "vm" {
  zone        = "ru-central1-a"
  service_account_id = var.YC_SERVICER_ID
  resources   { 
    cores = 2
    memory = 2
    }

  boot_disk   {
    initialize_params { 
      image_id = var.YC_IMAGE_ID
      } 
    } 

  network_interface {
    subnet_id          = yandex_vpc_subnet.sub.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.sg.id]
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ubuntu\n    groups: sudo\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']\n    ssh_authorized_keys:\n      - ${var.ssh_public_key}"
  }
}

# Новый S3 бакет для приложения
resource "yandex_storage_bucket" "kittygram-bucket-2026" {
  bucket     = "kittygram-bucket-2026"
  folder_id  = var.YC_FOLDER_ID
}

# Переменная и Output для интеграции с CI/CD
variable "ssh_public_key" { 
  type = string 
}

variable "YC_CLOUD_ID" {
  type      = string
  sensitive = true
}

variable "YC_FOLDER_ID" {
  type      = string
  sensitive = true
}

variable "YC_IMAGE_ID" {
  type      = string
  sensitive = true
}

variable "YC_SERVICER_ID" {
  type      = string
  sensitive = true
}

variable "YC_IAM_TOKEN" {
  type      = string
  sensitive = true
}

output "vm_public_ip" { 
  value = yandex_compute_instance.vm.network_interface.0.nat_ip_address
  }