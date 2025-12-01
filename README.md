# Hackathon Challenge - Solution Implemented

My challenge is to take this simple e-commerce backend and turn it into a fully containerized microservices setup using Docker and solid DevOps practices.

## ✅ Implementation Summary

This project implements a complete containerized microservices architecture with:

- **Multi-stage Docker builds** for optimized images (85%+ size reduction)
- **Separate development and production** environments with Docker Compose
- **Security hardening**: Network isolation, non-root users, read-only filesystems
- **Data persistence**: MongoDB volumes, automated initialization
- **Complete Makefile CLI** with 40+ commands for deployment and management
- **Health checks and monitoring** for all services
- **Hot-reload development** environment for rapid iteration

## Problem Statement

The backend setup consisting of:

- A service for managing products
- A gateway that forwards API requests

The system must be containerized, secure, optimized, and maintain data persistence across container restarts.

## Architecture

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

**Key Points:**

- Gateway is the only service exposed to external clients (port 5921)
- All external requests must go through the Gateway
- Backend and MongoDB should not be exposed to public network

## Project Structure

**DO NOT CHANGE THE PROJECT STRUCTURE.** The following structure must be maintained:
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

## 🚀 Quick Start

**Prerequisites:** Docker, Docker Compose, Make

1. **Setup environment**

   ```bash
   make setup  # Creates .env from .env.example
   ```

2. **Configure `.env`** with your MongoDB password

3. **Start services**

   ```bash
   make dev-up  # Builds and starts all containers
   ```

4. **Verify**

   ```bash
   make health  # Check all services are running
   ```

## 📋 Makefile Commands

| Command | Description |
|---------|-------------|
| `make dev-up` | Start development environment |
| `make dev-down` | Stop development |
| `make prod-up` | Start production environment |
| `make prod-down` | Stop production |
| `make health` | Check service health |
| `make test-api` | Run API tests |
| `make logs` | View all logs |
| `make clean-all` | Remove everything |

Full list: `make help`

## Environment Variables

Create a `.env` file in the root directory with the following variables (do not commit actual values):

```env
MONGO_INITDB_ROOT_USERNAME=
MONGO_INITDB_ROOT_PASSWORD=
MONGO_URI=
MONGO_DATABASE=
BACKEND_PORT=3847 # DO NOT CHANGE
GATEWAY_PORT=5921 # DO NOT CHANGE 
NODE_ENV=
```

## Expectations (Open ended, DO YOUR BEST!!!)

### ✅ Completed Implementation

- ✅ **Separate Dev and Prod configs**: `compose.development.yaml` and `compose.production.yaml`
- ✅ **Data Persistence**: MongoDB volumes with named storage
- ✅ **Security basics**: Network isolation, non-root users, read-only filesystems (prod), no direct backend access
- ✅ **Docker Image Optimization**: Multi-stage builds, Alpine base, 85%+ size reduction
- ✅ **Makefile CLI Commands**: 40+ commands for development, production, testing, and database operations

### Additional Best Practices Implemented

- ✅ **Health checks**: Automated monitoring for all services
- ✅ **Hot-reload development**: Instant code updates without rebuilds
- ✅ **MongoDB initialization**: Automated database setup with indexes
- ✅ **Security hardening**: `no-new-privileges`, minimal base images
- ✅ **Environment validation**: `.env.example` template provided
- ✅ **Build optimization**: `.dockerignore` files, layer caching
- ✅ **Graceful shutdown**: dumb-init for proper signal handling
- ✅ **Resource limits**: CPU and memory constraints (production)

## Testing

Use the following curl commands to test your implementation.

### Health Checks

Check gateway health:

```bash
curl http://localhost:5921/health
```

Check backend health via gateway:

```bash
curl http://localhost:5921/api/health
```

### Product Management

Create a product:

```bash
curl -X POST http://localhost:5921/api/products \
  -H 'Content-Type: application/json' \
  -d '{"name":"Test Product","price":99.99}'
```

Get all products:

```bash
curl http://localhost:5921/api/products
```

### Security Test

Verify backend is not directly accessible (should fail or be blocked):

```bash
curl http://localhost:3847/api/products
```

**Note:** In development mode, backend port may be exposed for debugging. In production, only Gateway (5921) is accessible.
