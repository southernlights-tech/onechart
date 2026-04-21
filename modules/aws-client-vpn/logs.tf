# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "vpn" {
  name              = "/aws/vpn/${var.name}/logs"
  retention_in_days = var.log_retention_days

  tags = local.tags
}

resource "aws_cloudwatch_log_stream" "vpn" {
  name           = "${var.name}-usage"
  log_group_name = aws_cloudwatch_log_group.vpn.name
}