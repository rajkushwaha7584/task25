# Terraform Guardrails + 3-Tier Application Verification Guide

## Step 1: Go to Terraform Dev Environment

```bash
cd /d/demo1/task25/terraform-guardrails-3tier/environments/dev
```

---

## Step 2: Check Terraform Outputs

```bash
terraform output
```

Expected output:

- ALB DNS
- Bastion Public IP
- WAF ARN
- Monitoring EC2 Public IP
- Grafana URL
- Prometheus URL
- Application metrics targets

Example:

```text
alb_dns_name = "guardrails-3tier-dev-alb-1303385156.ap-south-1.elb.amazonaws.com"

bastion_public_ip = "43.205.215.4"

grafana_url = "http://13.126.9.6:3000"

prometheus_url = "http://13.126.9.6:9090"

grafana_dashboard = "Project Monitoring / Three Tier Project - Grafana Monitoring"
```

---

## Grafana Monitoring Stack

Terraform creates a monitoring EC2 instance and installs this stack with Docker:

```text
Monitoring EC2
  -> Docker
  -> Grafana :3000
  -> Prometheus :9090
  -> Node Exporter :9100
  -> Worker application metrics :8000/metrics
```

CloudWatch alarms, CloudWatch dashboard, and AWS Managed Grafana are disabled. Grafana is the only active monitoring dashboard.

After apply:

```bash
terraform output monitoring_public_ip
terraform output grafana_url
terraform output prometheus_url
```

Grafana login:

```text
Username: admin
Password: admin123
```

Open Grafana and check the pre-provisioned dashboard:

```text
Dashboards -> Project Monitoring -> Three Tier Project - Grafana Monitoring
```

Verify containers on the monitoring EC2:

```bash
ssh -i LLB-new-ap-south-1.pem ec2-user@<monitoring_public_ip>
sudo docker ps
sudo docker logs grafana --tail 100
sudo docker logs prometheus --tail 100
```

Verify local ports:

```bash
curl http://localhost:3000
curl http://localhost:9090/-/healthy
curl http://localhost:9100/metrics
```

Verify Prometheus targets:

```text
http://<monitoring_public_ip>:9090/targets
```

Expected targets:

- `prometheus`
- `monitoring-node`
- `three-tier-application`

---

## Step 3: Verify Backend Health via ALB

```bash
curl http://guardrails-3tier-dev-alb-1303385156.ap-south-1.elb.amazonaws.com/api/health
```

Expected:

```json
{"status":"ok"}
```

---

## Step 4: Open Application

Open in browser:

```
http://guardrails-3tier-dev-alb-1303385156.ap-south-1.elb.amazonaws.com
```

Verify:

- Todo page opens
- Skills page opens
- Add Todo works
- Add Skill works

---

# Verify EC2 Instances

## Step 5: Get Worker Private IP

```bash
terraform state show module.ec2.aws_instance.worker1 | grep private_ip
```

Example:

```text
private_ip = "10.0.11.37"
```

---

## Step 6: Copy PEM Key to Bastion

Run from your local machine.

```bash
scp -i LLB-new-ap-south-1.pem \
LLB-new-ap-south-1.pem \
ec2-user@43.205.215.4:/home/ec2-user/
```

---

## Step 7: SSH into Bastion

```bash
ssh -i LLB-new-ap-south-1.pem ec2-user@43.205.215.4
```

---

## Step 8: Set Permission

```bash
chmod 400 ~/LLB-new-ap-south-1.pem
```

---

## Step 9: SSH into Worker

```bash
ssh -i ~/LLB-new-ap-south-1.pem ec2-user@10.0.11.37
```

---

# Verify Application Service

## Step 10: Check Service

```bash
sudo systemctl status three-tier-app
```

Expected:

```text
Active: active (running)
```

---

## Step 11: View Service Logs

```bash
sudo journalctl -u three-tier-app -n 100 --no-pager
```

Expected:

```text
GET /api/health HTTP/1.1 200
```

---

## Step 12: Test Backend Locally

```bash
curl http://localhost:8000/api/health
```

Expected:

```json
{"status":"ok"}
```

---

# Verify Database

## Step 13: Install SQLite

```bash
sudo dnf install sqlite -y
```

---

## Step 14: Open Database

```bash
sqlite3 /opt/three-tier-app/data/app.db
```

---

## Step 15: Show Tables

```sql
.tables
```

Expected:

```text
skills
todos
```

---

## Step 16: Better Output

```sql
.headers on
.mode column
```

---

## Step 17: Show Todos

```sql
SELECT * FROM todos;
```

---

## Step 18: Show Skills

```sql
SELECT * FROM skills;
```

---

## Step 19: Count Todos

```sql
SELECT COUNT(*) FROM todos;
```

---

## Step 20: Count Skills

```sql
SELECT COUNT(*) FROM skills;
```

---

## Step 21: Show Database Schema

```sql
.schema
```

---

## Step 22: Exit SQLite

```sql
.quit
```

---

# Verify Terraform Infrastructure

## List Resources

```bash
terraform state list
```

---

## Show Worker1

```bash
terraform state show module.ec2.aws_instance.worker1
```

---

## Show Worker2

```bash
terraform state show module.ec2.aws_instance.worker2
```

---

## Show ALB

```bash
terraform state show module.alb.aws_lb.this
```

---

## Show WAF

```bash
terraform state show module.waf.aws_wafv2_web_acl.this
```

---

## Validate Terraform

```bash
terraform validate
```

---

## Format Check

```bash
terraform fmt -recursive -check
```

---

# Guardrails Test

## Valid Dev

```bash
terraform apply
```

Works because:

```text
environment = dev
region = ap-south-1
```

---

## Invalid Dev

Change:

```hcl
aws_region = "us-east-1"
environment = "dev"
```

Run:

```bash
terraform plan
```

Expected:

```text
Error:

Environment dev must deploy only to ap-south-1
```

---

## Invalid Prod

Change:

```hcl
environment = "prod"
aws_region = "ap-south-1"
```

Run:

```bash
terraform plan
```

Expected:

```text
Error:

Environment prod must deploy only to us-east-1
```

---

# Architecture Verification

```
Browser
     │
     ▼
Application Load Balancer
     │
     ▼
Worker EC2 (Python App)
     │
     ▼
SQLite Database
```

---

# Project Components Verified

- Terraform Guardrails
- Multi-Region Support
- VPC
- Public Subnets
- Private Subnets
- Security Groups
- Bastion Host
- Kubernetes Worker EC2
- Monitoring EC2
- Application Load Balancer
- AWS WAF
- Grafana Dashboard
- Prometheus Metrics
- Node Exporter Metrics
- Application Metrics Endpoint
- Python Backend
- HTML/CSS/JavaScript Frontend
- SQLite Database
- Health Check Endpoint
- Todo CRUD APIs
- Skills CRUD APIs

Project Status: **SUCCESSFULLY DEPLOYED**
