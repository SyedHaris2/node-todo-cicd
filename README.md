# 🚀 Node.js Todo App – AWS ECS Fargate + Docker CI/CD

Production-grade **containerised** Node.js application deployed on **AWS ECS Fargate** with **GitHub Actions CI/CD pipeline**, **immutable Docker images**, **CloudWatch logs** and **Git-managed task definitions**.

---

## ✨ Features
- ✅ Add, edit, delete todos  
- ✅ Sanitised input (XSS safe)  
- ✅ RESTful routes (PUT/DELETE)  
- ✅ EJS server-side rendering  
- ✅ **Zero-downtime rolling updates**  
- ✅ **Immutable Docker images** (SHA-based)  
- ✅ **CloudWatch logs** per task  
- ✅ **Task definition stored in Git** (IaC)

---

## 📦 Container & AWS Highlights
- **Multi-stage Dockerfile** (Alpine Linux) – minimal & fast  
- **Unique SHA tag** on every build → **no “latest” cache issues**  
- **AWS ECS Fargate** – serverless containers, **no EC2 to manage**  
- **Task auto-registration** → **blue/green rolling deploys**  
- **CloudWatch Logs** – **one log stream per task**  
- **Task definition JSON** in repo → **infrastructure-as-code**

---

## 🏗️ Architecture Overview
```
GitHub Push
   ↓
GitHub Actions (build & tag)
   ↓
Amazon ECR Public (main-<sha>)
   ↓
AWS ECS Fargate (rolling update)
   ↓
Amazon CloudWatch Logs (one stream per task)
```

---

## 📺 30-sec Demo
![demo](https://user-images.githubusercontent.com/YOUR_USER/YOUR_REPO/raw/branch/main/demo.gif)

**Live URL (temporary IP)**  
🔗 http://54.82.232.196:8000/todo

---

## 🚀 One-command Local Run
```bash
git clone https://github.com/YOUR_USER/node-todo-cicd.git
cd node-todo-cicd
npm install
npm start
# open http://localhost:8000/todo
```

---

## 🔁 Deployment Flow
1. Push to `main`  
2. GitHub Actions builds **unique SHA image**  
3. **Renders task-definition.json** with new image tag  
4. **Force-deploys** to **ECS Fargate** → new task starts, old task dies  
5. **Health-check passes** → pipeline green  
6. **Updated UI live** in ~2 min

---

## 🛠️ Tech Stack
| Layer | Tech |
|-------|------|
| Language | Node.js 20 |
| View Engine | EJS |
| **Container** | **Docker (multi-stage Alpine)** |
| **Registry** | **Amazon ECR Public** |
| **Orchestration** | **AWS ECS Fargate** |
| **Logs** | **Amazon CloudWatch Logs** |
| **Task Definition** | **JSON in repo (IaC)** |
| CI/CD | GitHub Actions |

---

## 📄 Task Definition (Infrastructure-as-Code)
`task-definition.json` lives in the repo and is **rendered** on every push:

```json
{
  "family": "node-todo-app",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "1024",
  "memory": "3072",
  "executionRoleArn": "arn:aws:iam::YOUR_ACCOUNT:role/ecsTaskExecutionRole",
  "containerDefinitions": [
    {
      "name": "node-container",
      "image": "PLACEHOLDER",               // ← injected by GitHub Actions
      "portMappings": [{ "containerPort": 8000, "protocol": "tcp" }],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/node-todo-app",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
}
```

---

## 📝 CloudWatch Logs
- **One log stream per task** → easy debugging  
- View in **ECS console** → Task → **Logs** tab  
- Or CLI:  
  ```bash
  aws logs tail /ecs/node-todo-app --follow
  ```

---

## 🌍 Roadmap
- [ ] AWS Application Load Balancer + HTTPS  
- [ ] Custom domain (Route 53)  
- [ ] Terraform IaC  
- [ ] Prometheus + Grafana monitoring  
- [ ] Multi-environment (staging / prod)

---

## 🤝 Contributing
Feel free to open issues & pull requests.

---

### Next 5-min checklist
1. Fix EJS (`todo.item`) → commit / push  
2. Record 10-sec screen capture → save as `demo.gif`  
3. Replace `YOUR_USER`, `YOUR_REPO`, live IP → commit  
4. Pin repo on GitHub profile & LinkedIn → **recruiter magnet**

**Done!**