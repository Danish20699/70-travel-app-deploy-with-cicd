# 🚀 Travel App CI/CD Pipeline & Multi-Environment Deployment

[![CI/CD](https://img.shields.io/badge/CI%2FCD-Pipelines-007ACC?style=for-the-badge&logo=githubactions&logoColor=white)](https://github.com/features/actions)
[![Jenkins](https://img.shields.io/badge/Jenkins-2.580%2B-D24939?style=for-the-badge&logo=jenkins&logoColor=white)](https://www.jenkins.io/)
[![Docker Compose](https://img.shields.io/badge/Docker%20Compose-v2.27%2B-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://docs.docker.com/compose/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15%20Alpine-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![PHP](https://img.shields.io/badge/PHP-8.2%20Apache-777BB4?style=for-the-badge&logo=php&logoColor=white)](https://www.php.net/)
[![GitHub Actions](https://img.shields.io/badge/CI-GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)](https://github.com/features/actions)
[![Build Status](https://img.shields.io/badge/Jenkins_Build_%233-SUCCESS-success?style=for-the-badge&logo=jenkins&logoColor=white)](assets/05-jenkins-build-3-pipeline-success.png)

An enterprise-grade **Continuous Integration & Continuous Delivery (CI/CD) Pipeline** for the **Jannat-e-Kashmir Travel Booking Platform** — orchestrating automated image builds, Docker Hub publishing, zero-downtime multi-node deployment, health probe validation, and an interactive **Approval Gate** promoting releases from **Staging** (`192.168.56.101`) to **Production** (`192.168.56.102`).

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
│     (Danish20699/70-travel-app-deploy-with-cicd)       │
│   • Source Code (PHP 8.2 / HTML / CSS / JS)            │
│   • Dockerfile & docker-compose.yml                    │
│   • Database Schema (./db/init.sql)                    │
│   • Declarative Pipeline (Jenkinsfile)                 │
└──────────────────────────┬─────────────────────────────┘
                           │
                           │ 2. Webhook / SCM Polling Trigger
                           ▼
┌────────────────────────────────────────────────────────┐
│         Jenkins LTS Automation Controller              │
│                  (http://localhost:9090)               │
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
│   • Database Adminer: http://192.168.56.101:8086       │
└──────────────────────────┬─────────────────────────────┘
                           │
                           │ 4. Interactive Approval Gate (Manual Sign-off)
                           ▼
┌────────────────────────────────────────────────────────┐
│            Production VM (192.168.56.102)              │
│   • Customer-Facing Live Workload                      │
│   • Web Frontend: http://192.168.56.102:8085           │
│   • Database Adminer: http://192.168.56.102:8086       │
│   • Persistent Storage: travel_pgdata named volume     │
│   • Zero-Downtime Rolling Container Replacement        │
└────────────────────────────────────────────────────────┘
```

---

## 📚 Multi-Container Application Stack

The application stack consists of three coordinated services running on an isolated bridge network (`travel-network`):

| Service | Container Name | Image / Runtime | Port Mapping | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **`travel-web`** | `travel-web-service` | Custom build (`Dockerfile`) | `8085:80` | Serves the dynamic PHP booking engine & Kashmir tour packages |
| **`travel-db`** | `travel-db-service` | `postgres:15-alpine` | `5432` (Internal) | Stores destination packages, pricing, bookings, and user inquiries |
| **`travel-adminer`** | `travel-adminer-service` | `adminer:latest` | `8086:8080` | Web-based relational database administration and SQL console |

---

## 🛠️ Jenkins CI/CD Pipeline Stages

The `Jenkinsfile` implements a **5-stage declarative pipeline**:

| Stage | Description | Security & Reliability Best Practices |
| :--- | :--- | :--- |
| **1. Checkout SCM** | Clones the latest source code from GitHub | Clean workspace guarantee |
| **2. Build & Push Docker Image** | Builds a versioned image (`v${BUILD_NUMBER}`) and pushes to Docker Hub | Tokens injected via `withCredentials` — never leaked |
| **3. Deploy to Staging** | SSH deploys to Staging VM (`192.168.56.101`) via Docker Compose | Project namespace isolation (`-p travel-app`) |
| **4. Approval Gate** | Interactive manual approval step | Allows QA to validate Staging before touching Production |
| **5. Deploy to Production** | SSH deploys to Production VM (`192.168.56.102`) via Docker Compose | Rolling container updates with persistent named volumes |

---

## 🔧 Real-World Troubleshooting & Errors Solved

During this lab, four critical production-like issues were identified and resolved:

### 1. WSL2 Idle Sleep & Jenkins Disconnect
- **Issue**: `http://localhost:9090` returned `ERR_CONNECTION_REFUSED` after host idle.
- **Cause**: WSL2 suspended itself, killing the Docker daemon and the Jenkins container.
- **Fix**: Booted Docker engine, restored container with `restart: unless-stopped`, and established a persistent background keepalive daemon (`sleep infinity`).

### 2. Production VM SSH Connection Timeout (`Exit Code 255`)
- **Issue**: Build #1 passed Staging and Approval Gate, but failed on `ssh: connect to host 192.168.56.102: Connection timed out`.
- **Cause**: VirtualBox host-only DHCP lease for `Danish-Target` expired overnight, leaving ARP incomplete.
- **Fix**: Reset `Danish-Target` VM using `VBoxManage controlvm "Danish-Target" reset`, renewing DHCP for `192.168.56.102` (`acked`), restoring ~2ms ping and passwordless SSH.

### 3. Database Schema Mismatch (`column "price" does not exist`)
- **Issue**: Staging returned HTTP 200 but threw `Undefined column: 7 ERROR: column "price" does not exist`.
- **Cause**: Initial `init.sql` schema had `price_inr` and only 4 packages, while `index.php` required `price`, `category`, `location`, `duration`, and 7 packages.
- **Fix**: Upgraded `db/init.sql` with unified schema aliases, seeded all 7 packages, migrated the database, and pushed commit `360920c`.

### 4. Port Conflict Avoidance on Multi-App Host (`8086:8080`)
- **Issue**: Adminer default port `8081` was already occupied by the previously deployed restaurant app.
- **Fix**: Remapped `travel-adminer` to port `8086:8080` with namespaced compose project (`-p travel-app`).

---

## 📸 Pipeline Execution & Verification Screenshots

### 1. Lab Tracker Initial State
![Lab Tracker Initial State](assets/01-lab-tracker-task70.png)

### 2. WSL2 Sleep & Connection Troubleshooting
![WSL Idle Connection Issue](assets/02-wsl-idle-connection-refused-issue.png)

### 3. Jenkins Build #1 — Staging Success, Production SSH Timeout
![Jenkins Build 1 Console Log](assets/03-jenkins-build-1-prod-ssh-timeout.png)

### 4. Jenkins Build #2 — Aborted Build
![Jenkins Build 2 Aborted](assets/04-jenkins-build-2-aborted.png)

### 5. Jenkins Build #3 — 100% SUCCESS Across All Stages!
![Jenkins Build 3 Success](assets/05-jenkins-build-3-pipeline-success.png)

### 6. Live Staging Web Application Verification
![Live Staging Verification](assets/06-staging-live-browser-verification.png)

---

## 🌐 Live Verification Matrix

| Environment | Service | URL | Response | Status |
|:---|:---|:---|:---:|:---:|
| **Staging** | Web Application | `http://192.168.56.101:8085` | `HTTP/1.1 200 OK` | 🟢 **LIVE** |
| **Staging** | Adminer Console | `http://192.168.56.101:8086` | `HTTP/1.1 200 OK` | 🟢 **LIVE** |
| **Production** | Web Application | `http://192.168.56.102:8085` | `HTTP/1.1 200 OK` | 🟢 **LIVE** |
| **Production** | Adminer Console | `http://192.168.56.102:8086` | `HTTP/1.1 200 OK` | 🟢 **LIVE** |

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
├── assets/                             # Execution screenshots & pipeline proofs
│   ├── 01-lab-tracker-task70.png
│   ├── 02-wsl-idle-connection-refused-issue.png
│   ├── 03-jenkins-build-1-prod-ssh-timeout.png
│   ├── 04-jenkins-build-2-aborted.png
│   ├── 05-jenkins-build-3-pipeline-success.png
│   └── 06-staging-live-browser-verification.png
├── db/
│   └── init.sql                        # PostgreSQL schema & 7 Kashmir packages
├── src/
│   └── index.php                       # Jannat-e-Kashmir booking web app
├── .env.example                        # Example environment variables
├── .gitignore                          # Ignore secrets, logs, OS files
├── 70-travel-app-deploy-with-cicd.md   # Complete lab documentation & case studies
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

# 2. Configure environment
cp .env.example .env

# 3. Launch full stack
docker compose up -d --build

# 4. Verify services
docker compose ps

# 5. Access endpoints:
#    Web Frontend: http://localhost:8085
#    Adminer UI:   http://localhost:8086
```

---

## 👤 Author

- **Engineer**: **Danish Nazir**
- **Track**: MLOps & DevOps Engineering
- **GitHub**: [@Danish20699](https://github.com/Danish20699)
- **LinkedIn**: [Danish Nazir](https://www.linkedin.com/in/danish-nazir-6359a624a/)
