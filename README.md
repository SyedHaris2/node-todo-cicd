# Node Todo App – AWS ECS (Fargate) Deployment

A fully containerized **Node.js Todo application** (EJS-based UI) deployed on **Amazon ECS Fargate**, using **AWS ECR for image storage**, **Application Load Balancer** for traffic routing, **GitHub Actions for CI/CD**, and **CloudWatch Logs** for monitoring.

This README covers:

* Architecture Overview
* Local Development
* Docker Build & ECR Push
* AWS ECS Deployment (Fargate)
* Load Balancer + Target Group Setup
* GitHub Actions CI/CD workflow
* IAM Roles
* CloudWatch Logs
* Accessing the App
* Autoscaling (Optional)
* Troubleshooting

---

## 🚀 Architecture Diagram

```
Developer → GitHub → GitHub Actions → ECR → ECS Service (Fargate) → ALB → User
```

---

## 📁 Project Structure

```
node-todo-app/
├── .github/workflows/ (CI/CD pipeline)
├── views/
│   ├── edititem.ejs
│   └── todo.ejs
├── .gitignore
├── Dockerfile
├── README.md
├── app.js
├── docker-compose.yml
├── package.json
└── test.js
```

---

## 🔧 Tech Stack

* **Node.js** (Express + EJS templates)
* **Docker** for container packaging
* **AWS ECR** for storing images
* **AWS ECS Fargate** for running containers
* **AWS ALB** for HTTP routing
* **AWS CloudWatch** for logs
* **GitHub Actions** for CI/CD

---

## ▶️ Running Locally

```
npm install
npm start
```

Default URL:

```
http://localhost:8000
```

---

# 🐳 Docker Setup

### Build Docker Image

```
docker build -t node-todo-app .
```

### Run Locally

```
docker run -p 8000:8000 node-todo-app
```

---

# 🏗 AWS ECR Setup

### 1. Authenticate Docker to ECR

```
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com
```

### 2. Push image with SHA tag

```
IMAGE_SHA=$(git rev-parse --short HEAD)
docker tag node-todo-app:latest <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/node-todo-app:$IMAGE_SHA
docker push <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/node-todo-app:$IMAGE_SHA
```

---

# 🚀 AWS ECS (Fargate) Deployment

## ECS Cluster

* **Cluster:** `node-app-cluster`

## ECS Service

* **Service Name:** `node-todo-app-service`
* **Tasks:** Fargate
* **Desired Count:** 1

## Task Definition

* **Family:** `node-todo-app`
* **Revision:** `14`
* **CPU:** 1 vCPU
* **Memory:** 3GB
* **Network Mode:** awsvpc
* **Port:** `8000`
* **Execution Role:** `ecsTaskExecutionRole`

---

# 🌐 ALB + Target Group Setup

## Application Load Balancer

* **Name:** node-app-alb
* **DNS:** `http://node-app-alb-77108825.us-east-1.elb.amazonaws.com`
* **Listener:** HTTP:80 → node-app-tg

## Target Group

* **Name:** `node-app-tg`
* **Target Type:** `ip`
* **Port:** 8000
* **Health Check Path:** `/`

## Security Groups

### ALB Security Group

* Allow HTTP (80) from `0.0.0.0/0`

### ECS Task Security Group

* Allow port `8000` **ONLY from ALB SG**

---

# 🔁 CI/CD – GitHub Actions

GitHub Actions workflow automatically:

1. Builds Docker image
2. Tags with Git SHA
3. Pushes to ECR
4. Updates ECS Service with `force-new-deployment`

---

# 🔐 IAM Roles

### `ecsTaskExecutionRole`

Required permissions:

* ecr:GetAuthorizationToken
* ecr:BatchCheckLayerAvailability
* ecr:GetDownloadUrlForLayer
* ecr:BatchGetImage
* logs:CreateLogStream
* logs:PutLogEvents

---

# 📊 CloudWatch Logs

Log group:

```
/ecs/node-todo-app
```

Check logs via:

```
aws logs tail /ecs/node-todo-app --follow
```

---

# 🌍 Accessing the Application

Use the ALB DNS:

```
http://node-app-alb-77108825.us-east-1.elb.amazonaws.com/todo
```

---

# 📈 ECS Autoscaling (Optional)

* Min: 1
* Max: 3
* Policy: Target Tracking
* CPU Target: 60%

---

# ❗ Troubleshooting Guide

### 1. Target Group shows **Unhealthy**

* Wrong health check path
* App not listening on correct port
* Security group misconfigured

### 2. ALB shows **503**

* No healthy targets

### 3. ECS Task not starting

Check events tab:

```
Service → Events
```

### 4. Debug task logs

```
aws logs tail /ecs/node-todo-app --follow
```

---

# 📝 Author

**Syed Haris**

---

# ✅ Status

This deployment is live and functional using ECS Fargate + ALB.
