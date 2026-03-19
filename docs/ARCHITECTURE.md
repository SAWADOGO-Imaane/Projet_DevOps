# 🏗️ Architecture DevSecOps - Réference

## 📐 Vue d'Ensemble

```
┌──────────────────────────────────────────────────────────────┐
│                    CLIENTS / END USERS                        │
└────────────────────┬─────────────────────────────────────────┘
                     │ HTTPS
                     ▼
┌──────────────────────────────────────────────────────────────┐
│                   INGRESS / LOAD BALANCER                     │
│                  (Nginx / AWS ALB)                            │
├──────────────────────────────────────────────────────────────┤
│  - TLS/SSL Termination                                        │
│  - Rate Limiting                                              │
│  - Request/Response Headers                                   │
└────────────────┬─────────────────────────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────────────────────────┐
│        KUBERNETES CLUSTER (Docker Desktop // Minikube)        │
├──────────────────────────────────────────────────────────────┤
│                                                                │
│  ┌────────────────────────────────────────────────────┐      │
│  │  NAMESPACE: prediction-app                          │      │
│  ├────────────────────────────────────────────────────┤      │
│  │                                                      │      │
│  │  ┌──────────────────┐  ┌──────────────────┐       │      │
│  │  │   DEPLOYMENT     │  │   DEPLOYMENT     │       │      │
│  │  │ prediction-app-1 │  │ prediction-app-2 │       │      │
│  │  │  (pod)           │  │  (pod)           │       │      │
│  │  │ ┌──────────────┐ │  │ ┌──────────────┐ │       │      │
│  │  │ │ App Container│ │  │ │ App Container│ │       │      │
│  │  │ │ (Streamlit)  │ │  │ │ (Streamlit)  │ │       │      │
│  │  │ │ Port: 8501   │ │  │ │ Port: 8501   │ │       │      │
│  │  │ └──────────────┘ │  │ └──────────────┘ │       │      │
│  │  │ ┌──────────────┐ │  │ ┌──────────────┐ │       │      │
│  │  │ │ Security Ctx │ │  │ │ Security Ctx │ │       │      │
│  │  │ │ - runAsUser  │ │  │ │ - runAsUser  │ │       │      │
│  │  │ │ - readOnly   │ │  │ │ - readOnly   │ │       │      │
│  │  │ └──────────────┘ │  │ └──────────────┘ │       │      │
│  │  │ Resources:       │  │ Resources:       │       │      │
│  │  │ - Req: 256Mi     │  │ - Req: 256Mi     │       │      │
│  │  │ - Limit: 512Mi   │  │ - Limit: 512Mi   │       │      │
│  │  └──────────────────┘  └──────────────────┘       │      │
│  │         ▲                        ▲                 │      │
│  │         │ Managed by             │                 │      │
│  │         └────────────────────────┘                 │      │
│  │              SERVICE (ClusterIP)                   │      │
│  │              Port 8501 → 8501                      │      │
│  │                                                      │      │
│  │  ┌──────────────────────────────────────────┐     │      │
│  │  │  HORIZONTAL POD AUTOSCALER (HPA)         │     │      │
│  │  │  Min: 2 pods | Max: 5 pods               │     │      │
│  │  │  Metric: CPU 70% | Memory 80%            │     │      │
│  │  └──────────────────────────────────────────┘     │      │
│  │                                                      │      │
│  │  ┌──────────────────────────────────────────┐     │      │
│  │  │  NETWORK POLICY                          │     │      │
│  │  │  - Ingress: Nginx seulement              │     │      │
│  │  │  - Egress: DNS, DB, API externes         │     │      │
│  │  │  - Deny All (par défaut)                 │     │      │
│  │  └──────────────────────────────────────────┘     │      │
│  │                                                      │      │
│  │  ┌──────────────────────────────────────────┐     │      │
│  │  │  CONFIGMAP & SECRETS                     │     │      │
│  │  │  - app-config: Configuration             │     │      │
│  │  │  - app-secrets: DB_PASS, API_KEY         │     │      │
│  │  │  - Chiffré au repos                      │     │      │
│  │  └──────────────────────────────────────────┘     │      │
│  │                                                      │      │
│  │  ┌──────────────────────────────────────────┐     │      │
│  │  │  RBAC (Role-Based Access Control)        │     │      │
│  │  │  - ServiceAccount: app-sa                │     │      │
│  │  │  - Role: Minimal permissions             │     │      │
│  │  │  - RoleBinding: Lié au service account   │     │      │
│  │  └──────────────────────────────────────────┘     │      │
│  │                                                      │      │
│  └────────────────────────────────────────────────────┘      │
│                                                                │
│  ┌────────────────────────────────────────────────────┐      │
│  │  PERSISTENT STORAGE (Optionnel)                    │      │
│  │  - PostgreSQL StatefulSet                         │      │
│  │  - PersistentVolume                               │      │
│  │  - PersistentVolumeClaim                          │      │
│  └────────────────────────────────────────────────────┘      │
│                                                                │
└──────────────────────────────────────────────────────────────┘
```

---

## 🔄 Pipeline CI/CD

```
┌─────────────────────────────────┐
│   GitHub/GitLab/Gitea PUSH      │
│   (New Commit to Main/Develop)   │
└────────────┬────────────────────┘
             │ Webhook
             ▼
┌─────────────────────────────────┐
│     JENKINS (CI/CD Server)      │
├─────────────────────────────────┤
│                                  │
│  1️⃣  CHECKOUT                   │
│      - Clone repo                │
│      - Fetch latest code         │
│                                  │
│  2️⃣  BUILD                      │
│      - Install dependencies      │
│      - Compile                   │
│                                  │
│  3️⃣  CODE QUALITY               │
│      - SonarQube scan            │
│      - Coverage report           │
│      - Quality gates             │
│                                  │
│  4️⃣  TEST                       │
│      - Unit tests (pytest)       │
│      - Integration tests         │
│      - Functional tests          │
│                                  │
│  5️⃣  SECURITY SCAN              │
│      - Dependency check (Snyk)   │
│      - SAST (Bandit)             │
│      - Secret scan               │
│                                  │
│  6️⃣  BUILD DOCKER               │
│      - Dockerfile build          │
│      - Multistage build          │
│      - Optimize image            │
│                                  │
│  7️⃣  IMAGE SCAN                 │
│      - Trivy scan                │
│      - Vulnerability report      │
│                                  │
│  8️⃣  PUSH REGISTRY              │
│      - Docker Hub / ECR / ACR   │
│      - Tag: latest + version     │
│      - Sign image                │
│                                  │
│  9️⃣  DEPLOY STAGING             │
│      - Update K8s deployment     │
│      - Rolling update            │
│      - Health checks             │
│                                  │
│  🔟  SMOKE TESTS                 │
│      - Endpoint tests            │
│      - Functional smoke tests    │
│                                  │
└────────────────────┬────────────┘
                     │
            ┌────────┴──────────┐
            │                   │
         Success            Failure
            │                   │
            ▼                   ▼
┌──────────────────┐  ┌──────────────────┐
│  APPROVE FOR     │  │  NOTIFY & ALERT  │
│  PRODUCTION      │  │  - Slack         │
│  (Manual Gate)   │  │  - Email         │
│                  │  │  - PagerDuty     │
└────────┬─────────┘  └──────────────────┘
         │
         ▼
┌──────────────────────────────────┐
│  11️⃣  DEPLOY PRODUCTION          │
│      - Update K8s (main cluster) │
│      - Canary deployment         │
│      - Rollback capability       │
│                                  │
└──────────────────────────────────┘
```

---

## 🔐 Couches de Sécurité

```
┌────────────────────────────────────────┐
│  NIVEAU 1: RÉSEAU                      │
│  - TLS/HTTPS (Ingress)                 │
│  - NetworkPolicy (East-West)           │
│  - WAF (optionnel)                     │
│  - DDoS Protection                     │
└────────────────────────────────────────┘
                  ▼
┌────────────────────────────────────────┐
│  NIVEAU 2: AUTHENTIFICATION            │
│  - TLS Client Certs                    │
│  - Service Account Tokens              │
│  - API Keys (Application)              │
└────────────────────────────────────────┘
                  ▼
┌────────────────────────────────────────┐
│  NIVEAU 3: AUTORISATION (RBAC)        │
│  - Role-Based Access Control           │
│  - ServiceAccount permissions          │
│  - Namespace isolation                 │
└────────────────────────────────────────┘
                  ▼
┌────────────────────────────────────────┐
│  NIVEAU 4: POD SECURITY               │
│  - Pod Security Policy / Standards    │
│  - Non-root users                     │
│  - Read-only filesystems             │
│  - No privilege escalation            │
│  - Capability dropping                │
└────────────────────────────────────────┘
                  ▼
┌────────────────────────────────────────┐
│  NIVEAU 5: SECRETS MANAGEMENT         │
│  - Kubernetes Secrets (encrypted)     │
│  - Vault integration                  │
│  - Secret rotation                    │
│  - Audit logging                      │
└────────────────────────────────────────┘
                  ▼
┌────────────────────────────────────────┐
│  NIVEAU 6: CODE SECURITY              │
│  - SAST (SonarQube, Bandit)           │
│  - Dependency scanning (Snyk)         │
│  - Container scanning (Trivy)         │
│  - SBOM (Software Bill of Materials)  │
└────────────────────────────────────────┘
                  ▼
┌────────────────────────────────────────┐
│  NIVEAU 7: AUDIT & LOGGING            │
│  - Kubernetes audit logs              │
│  - Container logs                     │
│  - Event logs                         │
│  - Access logs                        │
└────────────────────────────────────────┘
```

---

## 📦 Infrastructure Components

### Docker
- **Image**: Multi-stage build (optimize size)
- **Registry**: Docker Hub / ECR / ACR
- **Security**: User non-root, read-only FS
- **Scanning**: Trivy + Snyk

### Kubernetes
- **Cluster**: Docker Desktop / Minikube / EKS/AKS/GKE
- **Networking**: Service + Ingress + NetworkPolicy
- **Storage**: PersistentVolume (DB)
- **Scaling**: HPA (CPU/Memory based)

### Jenkins
- **CI/CD**: Declarative pipeline
- **Plugins**: Docker, Kubernetes, SonarQube
- **Agents**: Master + Workers
- **Persistence**: Jenkins Home volume

### Terraform
- **Infrastructure**: Kubernetes resources
- **State**: Local / S3 backend
- **Variables**: Tfvars files
- **Modules**: Reusable components

### Ansible
- **Automation**: Deployment playbooks
- **Roles**: Docker, Kubernetes, Jenkins
- **Vault**: Secret encryption
- **Inventory**: Hosts configuration

### SonarQube
- **Code Quality**: Static analysis
- **Metrics**: Coverage, bugs, vulnerabilities
- **Quality Gates**: Pass/fail criteria
- **Database**: PostgreSQL

---

## 🔄 Data Flow

### Application Flow
```
User Browser
    │
    ▼ HTTPS
Ingress/Nginx
    │
    ▼ HTTP
Kubernetes Service
    │
    ▼
Pod (Streamlit)
    │
    ├─→ Database (PostgreSQL)
    ├─→ Cache (Redis optional)
    └─→ External APIs
```

### Deployment Flow
```
Git Repository
    │
    ▼ Webhook
Jenkins Pipeline
    │
    ├─→ Build/Test/Scan
    │
    ▼
Docker Registry
    │
    ├─→ Staging Deploy
    │
    ├─→ Approval
    │
    ▼
Production Cluster
    │
    ▼
Kubernetes Deployment
    │
    ├─→ Rolling Update
    │
    ├─→ Health Checks
    │
    └─→ Smoke Tests
```

---

## 📊 Ressources Design

```
Pod Requests/Limits:
─────────────────────
CPU Request:     250m (0.25 cores)
CPU Limit:       500m  (0.5 cores)
Memory Request:  256Mi
Memory Limit:    512Mi

HPA Triggers:
─────────────────────
CPU Threshold:   70% of request (175m)
Memory Threshold: 80% of request (204Mi)
Min Replicas:    2
Max Replicas:    5

Node Resources (minimum):
─────────────────────
2 vCPUs
4GB RAM
20GB Disk
```

---

## 🎯 Design Principles

### High Availability
- Multi-pod deployment (≥2)
- Pod anti-affinity (spread across nodes)
- Health checks (liveness + readiness)
- Graceful shutdown (terminationGracePeriodSeconds)

### Security
- Principle of least privilege
- Defense in depth
- Encrypt everything
- Audit all actions

### Scalability
- Kubernetes HPA
- Stateless application
- Connection pooling
- Caching strategies

### Observability
- Centralized logging
- Metrics & monitoring
- Distributed tracing
- Health checks

### Reliability
- Rolling updates
- Rollback capability
- Circuit breakers
- Retry logic

---

## 🔗 Technology Stack

- **Language**: Python 3.11
- **Framework**: Streamlit
- **Container**: Docker 24
- **Orchestration**: Kubernetes 1.27+
- **CI/CD**: Jenkins 2.401
- **IaC**: Terraform 1.6+
- **Automation**: Ansible 2.10+
- **Database**: PostgreSQL 15
- **Monitoring**: Prometheus/Grafana (optional)
- **Code Quality**: SonarQube
- **Scanning**: Trivy, Snyk, Bandit
- **Logging**: Kubernetes native (+ ELK optional)
