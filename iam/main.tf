locals {
  s3_bucket_name = "kelog-tmp"
}

resource "aws_iam_policy" "s3_bucket_access_policy" {
  name        = "s3_bucket_access_policy"
  description = "Policy for full access to ${local.s3_bucket_name} S3 bucket"

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:*"],
        Resource = [
          "arn:aws:s3:::${local.s3_bucket_name}",
          "arn:aws:s3:::${local.s3_bucket_name}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "scratch_ec2_fole" {
  name        = "scratch_ec2_role"
  description = "EC2 instance role with full access to ${local.s3_bucket_name} S3 bucket"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "scratch_ec2_s3_policy_attachment" {
  role       = aws_iam_role.scratch_ec2_fole.name
  policy_arn = aws_iam_policy.s3_bucket_access_policy.arn
}

resource "aws_iam_instance_profile" "scratch_instance_profile" {
  name = "scratch_instance_profile"
  role = aws_iam_role.scratch_ec2_fole.name
}

output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.scratch_instance_profile.name
}