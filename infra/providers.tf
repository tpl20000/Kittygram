terraform {
    required_version = ">= 1.10.5"
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      }
  }
  backend "s3" {
    endpoints = { 
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
  }
}

provider "yandex" { 
  zone = "ru-central1-a"
  token = var.YC_IAM_TOKEN
  cloud_id = var.YC_CLOUD_ID
  folder_id = var.YC_FOLDER_ID
}