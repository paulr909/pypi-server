resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = "${var.project_name}-lg"
  retention_in_days = 30

  tags = {
    Environment = "Production"
  }
}

resource "aws_iam_policy" "policy" {
  name   = "${var.project_name}-policy"
  policy = data.aws_iam_policy_document.log_publishing_policy.json
}

data "aws_iam_policy_document" "log_publishing_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]

    resources = ["arn:aws:logs:*"]
  }
}

output "rendered_policy" {
  value = data.aws_iam_policy_document.log_publishing_policy.json
}

resource "aws_cloudwatch_metric_alarm" "ec2_cpu" {
  alarm_name                = "${var.project_name}-cpu"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120" #seconds
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  dimensions = {
    InstanceId = aws_instance.ubuntu.id
  }
}
