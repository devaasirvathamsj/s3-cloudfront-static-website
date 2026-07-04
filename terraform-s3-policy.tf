data "aws_iam_policy_document" "cloudfront_policy" {

  statement {

    sid = "AllowCloudFrontServicePrincipal"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*"
    ]

    principals {
      type = "Service"

      identifiers = [
        "cloudfront.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        aws_cloudfront_distribution.cloudfront.arn
      ]
    }

  }

}



resource "aws_s3_bucket_policy" "bucket_policy" {

  bucket = aws_s3_bucket.s3_bucket.id

  policy = data.aws_iam_policy_document.cloudfront_policy.json

}