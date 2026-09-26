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

# Origin Access Identity

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {

    comment = "OAI for Next.JS Portfolio site"

  
}

# Cloudfront distribution

resource "aws_cloudfront_distribution" "nextjs_distribution" {
    origin {
      domain_name = aws_s3_bucket.nextjs_bucket.bucket_regional_domain_name
      origin_id = S3_nextjs-portfolio-bucket
      s3_origin_config {
        origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
      }
    }
    enabled = true
    is_ipv6_enabled = true
    comment = "Next.js portfolio site"
    default_root_object = "idex.html"

    default_cache_behavior {
      allowed_methods = [ "GET", "HEAD", "OPTIONS" ]
      cached_methods = [ "GET", "HEAD" ]
      target_origin_id = "S3-nextjs-portfolio-bucket"

      forwarded_values {
        query_string = false 
        cookies {
          forward = "none"
        }
      }
      viewer_protocol_policy = "redirect-to-https"
      min_ttl = 0
      default_ttl = 3600
      max_ttl = 86400
    }

    restrictions {
      geo_restriction {
        restriction_type = none
      }
    }
    viewer_certificate {
      cloudfront_default_certificate = true
    }

}