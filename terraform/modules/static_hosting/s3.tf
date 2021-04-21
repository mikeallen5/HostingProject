resource "aws_s3_bucket" "website" {
  bucket = var.website_bucket_name

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_object" "html" {
  bucket       = aws_s3_bucket.website.id
  key          = "index.html"
  source       = "${path.module}/dist/index.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/dist/index.html")
}