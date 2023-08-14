terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "rfojta-state"
    key = "python-covid-data/terraform.state"
    region = "eu-central-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "rfojta-covid-data" {
    bucket = "rfojta-covid-data"
}

data "aws_iam_user" "rfojta" {
    user_name = "rfojta"
}

resource "aws_s3_bucket_policy" "allow_access_by_iam_user" {
  bucket = aws_s3_bucket.rfojta-covid-data.id
  policy = data.aws_iam_policy_document.allow_access_by_iam_user.json
}

data "aws_iam_policy_document" "allow_access_by_iam_user" {
  policy_id = "Policy1691957931462"
  statement {
    principals {
      type        = "AWS"
      identifiers = [ data.aws_iam_user.rfojta.arn ]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.rfojta-covid-data.arn}/*",
      aws_s3_bucket.rfojta-covid-data.arn,
    ]
    sid = "Stmt1691957926872"
  }
}