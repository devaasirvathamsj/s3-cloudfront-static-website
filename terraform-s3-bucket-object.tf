resource "aws_s3_object" "s3_html_object" {
  bucket       = aws_s3_bucket.s3_bucket.id
  key          = "index.html"
  source       = "./Website/index.html"
  content_type = "text/html"
  etag         = filemd5("./Website/index.html")


}

resource "aws_s3_object" "s3_style_object" {
  bucket       = aws_s3_bucket.s3_bucket.id
  key          = "style.css"
  source       = "./Website/style.css"
  content_type = "text/css"
  etag         = filemd5("./Website/style.css")

}
