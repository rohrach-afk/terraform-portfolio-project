terraform {
    backend "s3" {
        bucket = "my-terraform-state-ep"
        key = "global/s3/terraform.tfstate"
        region = "us-east-2"
        use_lockfile = true
#        dynamodb_table = "s3-tf-table"

        
        }
}
