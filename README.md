# 🚀 Travel App CI/CD Pipeline & Multi-Environment Deployment

[![CI/CD](https://img.shields.io/badge/CI%2FCD-Pipelines-007ACC?style=for-the-badge&logo=githubactions&logoColor=white)](https://github.com/features/actions)
[![Jenkins](https://img.shields.io/badge/Jenkins-2.580%2B-D24939?style=for-the-badge&logo=jenkins&logoColor=white)](https://www.jenkins.io/)
[![Docker Compose](https://img.shields.io/badge/Docker%20Compose-v2.27%2B-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://docs.docker.com/compose/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15%20Alpine-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![PHP](https://img.shields.io/badge/PHP-8.2%20Apache-777BB4?style=for-the-badge&logo=php&logoColor=white)](https://www.php.net/)
[![GitHub Actions](https://img.shields.io/badge/CI-GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)](https://github.com/features/actions)

An enterprise-grade **CI/CD pipeline** for the **Jannat-e-Kashmir Travel Booking Platform** — automating build, test, push, and multi-environment deployment through Jenkins declarative pipelines. Every `git push` triggers an automated workflow that builds a versioned Docker image, deploys to **Staging**, gates behind manual approval, and promotes to **Production**.

---

## 🏗️ End-to-End CI/CD Architecture

```text
  Developer Workstation
  (VS Code / Ubuntu WSL)
           │
           │ 1. git commit && git push origin main
           ▼
┌────────────────────────────────────────────────────────┐
│            GitHub Remote Repository                    │
│             (Danish20699/travel-app-compose)           │
│   • Source Code (PHP / HTML / CSS / JS)                │
│   • Dockerfile & docker-compose.yml                    │
│   • Database Schema (./db/init.sql)                    │
│   • Declarative Pipeline (Jenkinsfile)                 │
└──────────────────────────┬─────────────────────────────┘
                           │
                           │ 2. Webhook / SCM Polling Trigger
                           ▼
┌────────────────────────────────────────────────────────┐
│         Jenkins LTS Automation Controller              │
│ ┌────────────────────────────────────────────────────┐ │
│ │ Stage 1: Checkout SCM (Clean workspace)            │ │
│ ├────────────────────────────────────────────────────┤ │
│ │ Stage 2: Build Image & Tag (v${BUILD_NUMBER})      │ │
│ ├────────────────────────────────────────────────────┤ │
│ │ Stage 3: Authenticate & Push to Docker Hub         │ │
│ │          (danishdopsa/travel-app:v${BUILD_NUMBER}) │ │
│ └────────────────────────┬───────────────────────────┘ │
└──────────────────────────┼─────────────────────────────┘
                           │
                           │ 3. Automated SSH Deployment via compose
                           ▼
┌────────────────────────────────────────────────────────┐
│             Staging VM (192.168.56.101)                │
│   • Project Isolation: docker compose -p travel-app    │
│   • Database Healthcheck: pg_isready                   │
│   • Web Frontend: http://192.168.56.101:8085           │
│   • Database Admin: http://192.168.56.101:8081         │
└──────────────────────────┬─────────────────────────────┘
                           │
                           │ 4. Jenkins Approval Gate (Manual Sign-off)
                           ▼
┌────────────────────────────────────────────────────────┐
│            Production VM (192.168.56.102)              │
│   • Customer-Facing Live Workload                      │
│   • Persistent Storage: travel_pgdata named volume     │
│   • Zero-Downtime Rolling Container Replacement        │
└────────────────────────────────────────────────────────┘
```

---

## 📚 Multi-Container Application Stack

The application consists of three coordinated services running on an isolated bridge network (`travel-network`):

| Service | Container Name | Image / Runtime | Port Mapping | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **`travel-web`** | `travel-web-service` | Custom build (`Dockerfile`) | `8085:80` | Serves the dynamic PHP booking engine & Kashmir tour packages |
| **`travel-db`** | `travel-db-service` | `postgres:15-alpine` | `5432` (Internal) | Stores destination packages, pricing, bookings, and user inquiries |
| **`travel-adminer`** | `travel-adminer-service` | `adminer:latest` | `8086:8080` | Web-based relational database administration and SQL console |

---

## 🛠️ Jenkins CI/CD Pipeline Stages

The `Jenkinsfile` implements a **5-stage declarative pipeline**:

| Stage | Description |
| :--- | :--- |
| **1. Checkout SCM** | Clones the latest source code from GitHub |
| **2. Build & Push Docker Image** | Builds a versioned image (`v${BUILD_NUMBER}`) and pushes to Docker Hub using secure credentials |
| **3. Deploy to Staging** | SSH deploys to Staging VM (`192.168.56.101`) via Docker Compose |
| **4. Approval Gate** | Interactive manual approval — QA validates Staging before Production |
| **5. Deploy to Production** | SSH deploys to Production VM (`192.168.56.102`) via Docker Compose |

---

## 🗂️ Repository Structure

```text
70-travel-app-deploy-with-cicd/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.md               # Structured bug report template
│   │   └── feature_request.md          # Feature request template
│   └── workflows/
│       └── ci.yml                      # GitHub Actions CI pipeline
├── db/
│   └── init.sql                        # PostgreSQL schema & seed data
├── src/
│   └── index.php                       # Full travel booking web application
├── .env.example                        # Example environment variables
├── .gitignore                          # Ignore secrets, logs, OS files
├── 70-travel-app-deploy-with-cicd.md   # Complete lab documentation
├── CODE_OF_CONDUCT.md                  # Contributor Covenant v2.1
├── CONTRIBUTING.md                     # Contribution guidelines
├── docker-compose.yml                  # 3-service stack definition
├── Dockerfile                          # PHP 8.2 + Apache + PostgreSQL
├── Jenkinsfile                         # Declarative CI/CD pipeline
├── LICENSE                             # MIT License
└── README.md                           # This file
```

---

## 🔧 Quick Start (Local Development)

```bash
# 1. Clone the repository
git clone https://github.com/Danish20699/70-travel-app-deploy-with-cicd.git
cd 70-travel-app-deploy-with-cicd

# 2. Copy and configure environment variables
cp .env.example .env

# 3. Launch the full stack
docker compose up -d --build

# 4. Verify services
docker compose ps

# 5. Access the application
#    Web App:  http://localhost:8085
#    Adminer:  http://localhost:8086

# 6. View aggregated logs
docker compose logs -f

# 7. Tear down everything
docker compose down -v
```

---

## 🔍 Healthcheck & Dependency Orchestration

The `docker-compose.yml` uses strict health probe conditions to prevent race conditions:

```yaml
travel-db:
  healthcheck:
    test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER:-danish} -d ${POSTGRES_DB:-travel_db}"]
    interval: 5s
    timeout: 5s
    retries: 10
    start_period: 10s

travel-web:
  depends_on:
    travel-db:
      condition: service_healthy
```

- **`pg_isready` Probe:** Actively pings the PostgreSQL server process
- **`start_period: 10s`:** Grace time for schema migrations before failures count
- **`condition: service_healthy`:** Delays web and adminer until DB returns exit code `0`

---

## 🌐 Verification Commands

```bash
# Verify Staging Web Application
curl -I http://192.168.56.101:8085
# HTTP/1.1 200 OK

# Verify Staging Adminer Console
curl -I http://192.168.56.101:8081
# HTTP/1.1 200 OK

# Verify Production Web Application
curl -I http://192.168.56.102:8085
# HTTP/1.1 200 OK

# Check container status on VMs
ssh verjenkins@192.168.56.101 "docker compose -p travel-app ps"
```

---

## 🧠 Key Takeaways

1. **Project Isolation (`-p travel-app`):** Always specify a project namespace with Docker Compose so services from different apps run independently.
2. **Deterministic Build Tags:** Images tagged with `v${BUILD_NUMBER}` ensure every release is immutable and traceable.
3. **Automated Secret Injection:** Docker Hub tokens and SSH keys stored in Jenkins Credentials — never hardcoded in Git.
4. **Controlled Production Promotions:** Interactive Approval Gate ensures QA validation before live customers receive updates.

---

## 👤 Author

- **Engineer**: **Danish Nazir**
- **Track**: MLOps & DevOps Engineering
- **GitHub**: [@Danish20699](https://github.com/Danish20699)
- **LinkedIn**: [Danish Nazir](https://www.linkedin.com/in/danish-nazir-6359a624a/)
