terraform {
    backend "s3" {
        bucket = "ep-my-tf-website-state"
        key = "global/s3/terraform.tfstate"
        region = "us-east-2"
        use_lockfile = true
#        dynamodb_table = "s3-tf-table"

        
        }
}
