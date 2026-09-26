provider "aws" {
    region = "us-east-2"
}


# S3 Bucket

resource "aws_s3_bucket" "nextjs_bucket" {
    bucket = "nextjs-portifolio-bucket-ep"

}

# Ownership Control
resource "aws_s3_bucket_ownership_controls" "nextjs_bucket_ownership_control" {
    bucket = aws_s3_bucket.nextjs_bucket.id 
    rule {
      object_ownership = "BucketOwnerPrefered"
    }
    
}

# Block Public Access
resource "aws_s3_bucket_public_access_block" "nextjs_bucket_public_access_block" {
  bucket = aws_s3_bucket.nextjs_bucket.id
  
  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false 
  restrict_public_buckets = false 

}

# Bucket ACL

resource "aws_s3_bucket_acl" "nextjs_bucket_acl" {
    bucket = aws_s3_bucket.nextjs_bucket.id
    acl = "public-read"
    depends_on = [ 
        aws_s3_bucket_ownership_controls.nextjs_bucket_ownership_control,
        aws_s3aws_s3_bucket_public_access_block.nextjs_bucket_public_access_block
     ]
  
}

# Bucket Policy 

resource "aws_s3_bucket_policy" "nextjs_bucket_poilcy" {
    bucket = aws_s3_bucket.nextjs_bucket.id

    policy = jsondecode(({        
        version = "2012-10-17"
        Statement = [
            {
                Sid = "Public"
                Effect = "Allow"
                Principal = "*"
                Action = "s3:GetObject"
                Resource = "${aws_s3_bucket.nextjs_bucket.arn}/*"
            }
        ]                
    }))
  
}