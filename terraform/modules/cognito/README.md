## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.52 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.52 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_cognito_resource_server.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_resource_server) | resource |
| [aws_cognito_user_pool.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) | resource |
| [aws_cognito_user_pool_client.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client) | resource |
| [aws_cognito_user_pool_domain.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_domain) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_config"></a> [config](#input\_config) | Cognito configuration | <pre>object({<br/><br/>    user_pool_name = string<br/>    client_name = string<br/>    resource_server_identifier = string<br/>    resource_server_name       = string<br/>    scope_name                 = string<br/>    scope_description          = string<br/>    domain = string<br/><br/>    tags = map(string)<br/><br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_client_id"></a> [client\_id](#output\_client\_id) | The ID of the Cognito User Pool client. |
| <a name="output_client_secret"></a> [client\_secret](#output\_client\_secret) | The client secret of the Cognito User Pool client. |
| <a name="output_domain"></a> [domain](#output\_domain) | Cognito user pool domain prefix used to build the OAuth2 token endpoint URL |
| <a name="output_user_pool_id"></a> [user\_pool\_id](#output\_user\_pool\_id) | The ID of the Cognito User Pool. |
