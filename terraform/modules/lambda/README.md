## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.15.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.52 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_archive"></a> [archive](#provider\_archive) | ~> 2.8 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.52 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [archive_file.lambda](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_config"></a> [config](#input\_config) | Lambda configuration | <pre>object({<br/>    function_name = string<br/>    runtime       = string<br/>    handler       = string<br/><br/>    source_dir = string<br/>    role_arn = string<br/><br/>    timeout     = number<br/>    memory_size = number<br/><br/>    environment_variables = map(string)<br/><br/>    tags = map(string)<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the Lambda function |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | The name of the deployed Lambda function |
| <a name="output_invoke_arn"></a> [invoke\_arn](#output\_invoke\_arn) | The ARN used by API Gateway to invoke the Lambda function |
