import os
import json
import uuid
import base64
from datetime import datetime

from botocore.config import Config
import boto3

s3 = boto3.client(
    "s3",
    region_name="eu-west-3",
    config=Config(
        signature_version="s3v4",
        s3={"addressing_style": "virtual"}
    )
)

table = boto3.resource("dynamodb").Table(os.environ["DYNAMODB_TABLE"])
BUCKET_NAME = os.environ["S3_BUCKET"]

ALLOWED_EXTENSIONS = {
    "pdf",
    "doc",
    "docx",
    "ppt",
    "pptx"
}


def response(status, body):
    return {
        "statusCode": status,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps(body)
    }


def validate_string(value, field):
    if not isinstance(value, str) or not value.strip():
        raise ValueError(f"{field} must be a non-empty string")


def validate_birth_date(date):
    try:
        datetime.strptime(date, "%Y-%m-%d")
    except ValueError:
        raise ValueError("birthDate must be in YYYY-MM-DD format")


def validate_extension(filename):
    extension = filename.split(".")[-1].lower()

    if extension not in ALLOWED_EXTENSIONS:
        raise ValueError(
            f"Unsupported file type: {extension}"
        )

    return extension


def create_candidate(event):
    try:
        body = json.loads(event["body"])

        specialty = body["specialty"]
        first_name = body["firstName"]
        last_name = body["lastName"]
        birth_date = body["birthDate"]

        filename = body["fileName"]
        file_content = body["fileContent"]

        decoded_file = base64.b64decode(file_content)

        MAX_FILE_SIZE = 5 * 1024 * 1024

        if len(decoded_file) > MAX_FILE_SIZE:
            raise ValueError("Resume size cannot exceed 5 MB")
        


        validate_string(specialty, "specialty")
        validate_string(first_name, "firstName")
        validate_string(last_name, "lastName")
        validate_birth_date(birth_date)

        extension = validate_extension(filename)

        candidate_id = f"CA-{uuid.uuid4().hex[:6].upper()}"
        s3_key = f"{specialty}/{candidate_id}.{extension}"

        try:
            s3.put_object(
                Bucket=BUCKET_NAME,
                Key=s3_key,
                Body=decoded_file
            )
        except Exception:
            return response(
                500,
                {"message": "Failed to upload resume to S3"}
            )

        try:
            table.put_item(
                Item={
                    "candidateId": candidate_id,
                    "specialty": specialty,
                    "candidateFirstName": first_name,
                    "candidateLastName": last_name,
                    "candidateBirthDate": birth_date,
                    "cvS3Key": s3_key
                }
            )

        except Exception:
            try:
                s3.delete_object(
                    Bucket=BUCKET_NAME,
                    Key=s3_key
                )
            except Exception as e:
                print(f"Failed to delete {s3_key} from S3 during rollback: {e}")
            
            return response(
                500,
                {"message": "Failed to save candidate in DynamoDB"}
            )

        return response(
            201,
            {
                "candidateId": candidate_id,
                "message": "Candidate created"
            }
        )

    except KeyError as e:
        return response(400, {"message": f"Missing field: {e}"})

    except ValueError as e:
        return response(400, {"message": str(e)})

    except Exception as e:
        return response(500, {"message": str(e)})
    


def get_candidate(event):
    try:
        candidate_id = event.get("pathParameters", {}).get("id")

        if not candidate_id:
            return response(400, {"message": "Candidate ID is required"})

        result = table.get_item(
            Key={
                "candidateId": candidate_id
            }
        )

        item = result.get("Item")

        if not item:
            return response(
                404,
                {"message": "Candidate not found"}
            )

        url = s3.generate_presigned_url(
            "get_object",
            Params={
                "Bucket": BUCKET_NAME,
                "Key": item["cvS3Key"]
            },
            ExpiresIn=900
        )

        item["resumeUrl"] = url

        return response(200, item)
    except Exception:
       return response(
           500,
           {"message": "Internal server error"}
       )