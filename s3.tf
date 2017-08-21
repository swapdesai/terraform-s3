provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "ap-southeast-2"
}

resource "aws_s3_bucket" "tf_s3_bucket" {
  bucket = "tf-my-test-bucket"
  region = "ap-southeast-2"

  versioning {
    enabled = true
  }

  tags {
    Name        = "My bucket"
    Environment = "Dev"
  }

  lifecycle_rule {
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      days          = 60
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      days = 90
    }
  }
}

resource "aws_s3_bucket_object" "tf_s3_bucket_object" {
  bucket = "${aws_s3_bucket.tf_s3_bucket.id}"
  key    = "test.jpg"
  source = "test.jpg"
  etag   = "${md5(file("test.jpg"))}"

  acl = "public-read"

  # BUG: Terraform does not chnage the storage class from the set class to the default class?
  #storage_class = "STANDARD_IA"
}

resource "aws_s3_bucket_object" "folder1" {
    bucket = "${aws_s3_bucket.tf_s3_bucket.id}"
    key    = "folder1/"
    source = "/dev/null"
}

# Upload object to S3 bucket folder ??
/*
resource "aws_s3_bucket_object" "tf_s3_bucket_folder_object" {
  bucket = "${aws_s3_bucket.tf_s3_bucket.id}/folder1"
  key    = "test1.jpg"
  source = "test.jpg"
  etag   = "${md5(file("test.jpg"))}"
}
*/
