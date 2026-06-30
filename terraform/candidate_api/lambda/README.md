# 🧑‍💼 Candidate Management API

A serverless REST API built with **AWS Lambda**, **API Gateway (HTTP)**, **DynamoDB**, and **S3** for managing job candidates and their resumes.

---

## 📐 Architecture Overview

```
Client
  │
  ▼
API Gateway (HTTP API)
  │
  ├── POST /candidate       ──▶ Lambda Handler ──▶ create_candidate()
  │                                                      │
  │                                               ┌──────┴──────┐
  │                                               ▼             ▼
  │                                             S3 Bucket   DynamoDB Table
  │
  └── GET /candidate/{id}  ──▶ Lambda Handler ──▶ get_candidate()
                                                       │
                                               ┌───────┴───────┐
                                               ▼               ▼
                                          DynamoDB         S3 Presigned URL
```

---

## 🔌 API Endpoints

### `POST /candidate`

Creates a new candidate and uploads their resume to S3.

#### Request Body (`application/json`)

| Field         | Type     | Required | Description                                      |
|---------------|----------|----------|--------------------------------------------------|
| `firstName`   | `string` | ✅       | Candidate's first name                           |
| `lastName`    | `string` | ✅       | Candidate's last name                            |
| `birthDate`   | `string` | ✅       | Date of birth in `YYYY-MM-DD` format             |
| `specialty`   | `string` | ✅       | Candidate's specialty / domain                   |
| `fileName`    | `string` | ✅       | Original file name (used to determine extension) |
| `fileContent` | `string` | ✅       | Base64-encoded resume file content               |

#### Example Request

```json
{
  "firstName": "Jane",
  "lastName": "Doe",
  "birthDate": "1995-08-21",
  "specialty": "backend",
  "fileName": "jane_doe_resume.pdf",
  "fileContent": "JVBERi0xLjQK..."
}
```

#### Success Response — `201 Created`

```json
{
  "candidateId": "CA-3F9A2B",
  "message": "Candidate created"
}
```

#### Error Responses

| Status | Cause                                              |
|--------|----------------------------------------------------|
| `400`  | Missing required field                             |
| `400`  | Invalid `birthDate` format (not `YYYY-MM-DD`)      |
| `400`  | Unsupported file type                              |
| `400`  | Resume file exceeds 5 MB                           |
| `500`  | Failed to upload resume to S3                      |
| `500`  | Failed to save candidate to DynamoDB               |

---

### `GET /candidate/{id}`

Retrieves a candidate's details and a **pre-signed S3 URL** to download their resume.

#### Path Parameter

| Parameter | Type     | Description              |
|-----------|----------|--------------------------|
| `id`      | `string` | Candidate ID (e.g. `CA-3F9A2B`) |

#### Example Request

```
GET /candidate/CA-3F9A2B
```

#### Success Response — `200 OK`

```json
{
  "candidateId": "CA-3F9A2B",
  "specialty": "backend",
  "candidateFirstName": "Jane",
  "candidateLastName": "Doe",
  "candidateBirthDate": "1995-08-21",
  "cvS3Key": "backend/CA-3F9A2B.pdf",
  "resumeUrl": "https://your-bucket.s3.eu-west-3.amazonaws.com/backend/CA-3F9A2B.pdf?X-Amz-..."
}
```

> ⏱️ The `resumeUrl` pre-signed URL is valid for **15 minutes (900 seconds)**.

#### Error Responses

| Status | Cause                          |
|--------|--------------------------------|
| `400`  | Missing candidate ID           |
| `404`  | Candidate not found            |
| `500`  | Internal server error          |

---

## ✅ Validation Rules

| Field         | Rule                                                                 |
|---------------|----------------------------------------------------------------------|
| `firstName`   | Must be a non-empty string                                           |
| `lastName`    | Must be a non-empty string                                           |
| `specialty`   | Must be a non-empty string                                           |
| `birthDate`   | Must match `YYYY-MM-DD` format                                       |
| `fileName`    | Extension must be one of: `pdf`, `doc`, `docx`, `ppt`, `pptx`       |
| `fileContent` | Base64-encoded; decoded size must not exceed **5 MB**                |

---

## 📦 Supported Resume File Types

| Extension | Format                        |
|-----------|-------------------------------|
| `.pdf`    | Adobe PDF                     |
| `.doc`    | Microsoft Word (legacy)       |
| `.docx`   | Microsoft Word                |
| `.ppt`    | Microsoft PowerPoint (legacy) |
| `.pptx`   | Microsoft PowerPoint          |

---

## 🗄️ DynamoDB Schema

**Table name:** set via `DYNAMODB_TABLE` environment variable

| Attribute              | Type     | Description                        |
|------------------------|----------|------------------------------------|
| `candidateId` *(PK)*   | `String` | Unique ID — format: `CA-XXXXXX`    |
| `specialty`            | `String` | Candidate's specialty              |
| `candidateFirstName`   | `String` | First name                         |
| `candidateLastName`    | `String` | Last name                          |
| `candidateBirthDate`   | `String` | Birth date (`YYYY-MM-DD`)          |
| `cvS3Key`              | `String` | S3 object key for the resume file  |

---

## 🪣 S3 Storage

**Bucket name:** set via `S3_BUCKET` environment variable  
**Region:** `eu-west-3` (Paris)  

Resume files are stored using the following key pattern:

```
{specialty}/{candidateId}.{extension}
```

**Example:**
```
backend/CA-3F9A2B.pdf
```

---

## 🔁 Rollback Strategy

If the DynamoDB write fails **after** a successful S3 upload, the Lambda automatically attempts to **delete the uploaded S3 object** to avoid orphaned files. Any rollback failure is logged to CloudWatch.

```
S3 upload ✅ → DynamoDB write ❌ → S3 delete (rollback) 🔄
```

---

## ⚙️ Environment Variables

| Variable          | Description                          |
|-------------------|--------------------------------------|
| `DYNAMODB_TABLE`  | Name of the DynamoDB table           |
| `S3_BUCKET`       | Name of the S3 bucket for resumes    |

---

## 🚀 Deployment

This function is designed to be deployed as an **AWS Lambda** with an **API Gateway HTTP API** trigger.

### Minimum IAM Permissions Required

```json
{
  "Effect": "Allow",
  "Action": [
    "dynamodb:PutItem",
    "dynamodb:GetItem",
    "s3:PutObject",
    "s3:GetObject",
    "s3:DeleteObject"
  ],
  "Resource": [
    "arn:aws:dynamodb:eu-west-3:*:table/YOUR_TABLE_NAME",
    "arn:aws:s3:::YOUR_BUCKET_NAME/*"
  ]
}
```

---

## 📋 Route Handling Summary

| Route                  | Handler            | Description                  |
|------------------------|--------------------|------------------------------|
| `POST /candidate`      | `create_candidate` | Create candidate + upload CV |
| `GET /candidate/{id}`  | `get_candidate`    | Fetch candidate + resume URL |
| *(any other)*          | —                  | Returns `404 Route not found`|

---

## 📄 License

MIT — feel free to use and adapt this project.
