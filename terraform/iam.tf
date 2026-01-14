resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [ data.tls_certificate.github.certificates[0].sha1_fingerprint ]
}

data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })  
}

resource "aws_iam_role_policy" "lambda_role_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda_policy_doc.json
  
}

data "aws_iam_policy_document" "lambda_policy_doc" {
  statement {
    actions = [
      "cloudwatch:GetMetricData",
      "cloudwatch:ListMetrics"
    ]
    resources = ["*"]
  }
  statement {
    actions = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.lambda_reports.arn}/*"]
  }
  statement {
    actions = [
      "cloudwatch:GetMetricData",
      "cloudwatch:ListMetrics",
      "s3:PutObject",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"] 
  }
}
data "aws_caller_identity" "me" {}

data "aws_iam_policy_document" "oidc_policy" {
  version = "2012-10-17"
  statement {

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:Eren-san/iac-practice:ref:refs/heads/main"]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.me.account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }
  }
}

resource "aws_iam_role" "github_oidc_role" {
  name = "GitHubActionRole" 

assume_role_policy = data.aws_iam_policy_document.oidc_policy.json
}

resource "aws_iam_role_policy" "github_actions_limited_policy" {
  name = "GitHubActionsLimitedPolicy"
  role = aws_iam_role.github_oidc_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"

        Action = [
          "*"       
        ]
        Resource = "*"
      }
    ]
  })
}