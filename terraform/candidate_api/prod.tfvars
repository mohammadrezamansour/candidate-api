environment = "prod"

project_name = "candidate-api"

s3_buckets = {
  resume = {
    force_destroy     = true
    enable_versioning = false
    enable_encryption = true
    sse_algorithm     = "AES256"

    tags = {
      Environment = "prod"
      Team        = "CloudOps"
      Project     = "CandidateAPI"
    }
  }
}

dynamodb_tables = {

  candidates = {


    billing_mode = "PAY_PER_REQUEST"

    hash_key = "candidateId"

    attributes = [
      {
        name = "candidateId"
        type = "S"
      }
    ]

    tags = {
      Name = "candidate-table"
    }
  }
}

lambda = {

  runtime = "python3.12"
  handler = "app.lambda_handler"

  source_dir = "lambda"

  timeout     = 30
  memory_size = 128

  tags = {
    Environment = "prod"
  }
}


api_gateway = {


  stage_name = "$default"

  routes = {

    create_candidate = {
      method = "POST"
      path   = "/candidate"
    }

    get_candidate = {
      method = "GET"
      path   = "/candidate/{id}"
    }

  }

  tags = {
    Service = "API"
  }
}

cognito = {


  domain            = "candidate-api-auth"
  scope_name        = "access"
  scope_description = "Access Candidate API"


}