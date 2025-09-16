data "aws_region" "current" {}


data "archive_file" "sequester_zip" {
  count       = var.enable_sequester ? 1 : 0
  type        = "zip"
  output_path = "${path.module}/sequester.zip"

  source {
    content = templatefile("${path.module}/sequester.py.tftpl", {
      SEQUESTER_BUCKET = var.sequester_bucket_name
    })
    filename = "lambda_function.py"
  }
}
