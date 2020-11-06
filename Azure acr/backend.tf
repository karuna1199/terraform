terraform {
  backend "s3" {
    bucket   = "aks-terraform-state"
    key      = "terraform.tfstate"
    region   = "us-standard"
    endpoint = "https://s3api-core.uhc.com"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_get_ec2_platforms      = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}