
# 🚀 E-commerce Microservices – Hackathon Submission

## Overview

This project transforms a simple e-commerce backend into a robust, fully containerized microservices architecture using Docker and modern DevOps practices.

**Key Features:**
- Multi-stage Docker builds for backend and gateway (dev & prod)
- Separate Docker Compose files for development and production
- Secure, optimized, and persistent MongoDB setup
- Automated health checks, resource limits, and log management
- Comprehensive Makefile CLI for all operations

---

## Architecture

```
                    ┌─────────────────┐
                    │   Client/User   │
                    └────────┬────────┘
                             │
                             │ HTTP (port 5921)
                             │
                    ┌────────▼────────┐
                    │    Gateway      │
                    │  (port 5921)    │
                    │   [Exposed]     │
                    └────────┬────────┘
                             │
                    ┌────────┴────────┐
                    │                 │
         ┌──────────▼──────────┐      │
         │   Private Network   │      │
         │  (Docker Network)   │      │
         └──────────┬──────────┘      │
                    │                 │
         ┌──────────┴──────────┐      │
         │                     │      │
    ┌────▼────┐         ┌──────▼──────┐
    │ Backend │         │   MongoDB   │
    │(port    │◄────────┤  (port      │
    │ 3847)   │         │  27017)     │
    │[Not     │         │ [Not        │
    │Exposed] │         │ Exposed]    │
    └─────────┘         └─────────────┘
```
- Only the Gateway is exposed externally.
- Backend and MongoDB are isolated within a private Docker network.

---

## Project Structure

```
.
├── backend/
│   ├── Dockerfile              # ✅ Multi-stage production build
│   ├── Dockerfile.dev          # ✅ Development with hot-reload
│   ├── .dockerignore           # ✅ Build optimization
│   └── src/
├── gateway/
│   ├── Dockerfile              # ✅ Multi-stage production build
│   ├── Dockerfile.dev          # ✅ Development with hot-reload
│   ├── .dockerignore           # ✅ Build optimization
│   └── src/
├── docker/
│   ├── compose.development.yaml # ✅ Dev environment
│   ├── compose.production.yaml  # ✅ Production environment
├── Makefile                     # ✅ Complete CLI (40+ commands)
├── .env.example                 # ✅ Environment template
├── .dockerignore                # ✅ Root ignore file
└── README.md
```

---

## ⚡ Quick Start

**Prerequisites:** Docker, Docker Compose, GNU Make

   ```bash
   make setup  # Creates .env from .env.example
   ```
2. **Edit `.env`** with your MongoDB credentials.
3. **Start services:**
   ```bash
   make dev-up
   ```
4. **Check health:**
   ```bash
   make health
   ```

---

## 🛠️ Makefile Highlights

```
| Command           | Description                        |
|-------------------|------------------------------------|
| `make dev-up`     | Start dev environment              |
| `make prod-up`    | Start production environment       |
| `make health`     | Check service health               |
| `make test-api`   | Run API tests                      |
| `make logs`       | View logs                          |
| `make clean-all`  | Remove all containers, volumes, etc|
```
Run `make help` for the full list.

---

## 🐳 Docker & DevOps Best Practices

- **Multi-stage builds:** Small, secure images for production.
- **Non-root users:** Enhanced container security.
- **Read-only filesystems:** In production for extra safety.
- **Named volumes:** Persistent MongoDB data.
- **Network isolation:** Only gateway is externally accessible.
- **Health checks:** For all services.
- **Resource limits:** CPU/memory constraints in production.
- **Hot-reload:** Fast development workflow.
- **Automated Makefile:** 40+ commands for all operations.

---

## 🧪 Testing

**Health checks:**
```bash
curl http://localhost:5921/health
curl http://localhost:5921/api/health
```

**Product API:**
```bash
curl -X POST http://localhost:5921/api/products -H 'Content-Type: application/json' -d '{"name":"Test Product","price":99.99}'
curl http://localhost:5921/api/products
```

**Security test (should fail):**
```bash
curl http://localhost:3847/api/products
```

---

## 🌟 Why This Project Stands Out

- Clean, production-ready Docker setup
- Secure by default
- Fully automated with Makefile
- Easy to develop, test, and deploy

---

**Thank you for reviewing my submission!**
