resource "aws_iam_instance_profile" "web_server" {
  name = "web_server-instance-role"
  role = aws_iam_role.web_server.name
}

data "aws_iam_policy_document" "assume_by_web_server" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "web_server" {
  name               = "web_server-instance-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_by_web_server.json

  tags = {
    Name        = "web_server-instance-role"
  }
}

data "aws_iam_policy_document" "web_server" {

  statement {
    sid    = ""
    effect = "Allow"
    actions = [
      "ec2:*"
    ]
    resources = ["*"]
  }
  statement {
    sid    = ""
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
        "arn:aws:s3:::mattiafedele-terraform-artifacts/*",
        "arn:aws:s3:::mattiafedele-terraform-artifacts"
    ]

  }

  statement {
    sid    = ""
    effect = "Allow"
    actions = [
      "s3:GetEncryptionConfiguration",
      "kms:Decrypt"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "web_server" {
  name   = "web_server-instance-policy"
  role   = aws_iam_role.web_server.id
  policy = data.aws_iam_policy_document.web_server.json
}