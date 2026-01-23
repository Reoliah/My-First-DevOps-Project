# AWS EKS GitOps Infrastructure Project

## Project Overview
This project demonstrates a production-grade Cloud Infrastructure on AWS, built from scratch using Infrastructure as Code (IaC) and GitOps principles.

It provisions an **Amazon EKS (Elastic Kubernetes Service)** cluster using **Terraform**, packages a simple custom Node.js application with **Helm**, and automates delivery and deployment using **ArgoCD**. It also includes  Traffic Management (NGINX Ingress) and Observability using AWS CloudWatch.

## Architecture
* **Infrastructure:** AWS VPC, Subnets, Internet Gateway, EKS Cluster (managed with Terraform).
* **CI:** GitHub (Version Control)
* **CD:** ArgoCD (GitOps Sync)
* **Orchestration:** Kubernetes (Pods, Services, Deployments).
* **Networking:** NGINX Ingress Controller for Load Balancing.
* **Observability:** AWS CloudWatch.

## Tech Stack
* **Cloud Provider:** AWS (EKS, VPC, EC2, IAM)
* **IaC:** Terraform
* **Containerization:** Docker
* **Orchestration:** Kubernetes & Helm
* **CI/CD:** ArgoCD (GitOps)
* **Monitoring:** Prometheus & Grafana

## Project Structure
```bash
├── terraform/          # Infrastructure as Code (AWS EKS, VPC)
├── my-chart/           # Helm Chart for the Application
├── app.js              # Node.js Application Source Code
├── Dockerfile          # Container Definition
└── values.yaml         # Configuration for Deployment
```
# How to Deploy
## Prerequisites
* **AWS CLI configured**
* **Terraform installed**
* **Kubectl & Helm installed**

## 1. Provision Infrastructure
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

## 2. Configure Kubernetes
```bash
aws eks update-kubeconfig --region af-south-1 --name devops-cluster
kubectl get nodes
```

## 3. Deploy ArgoCD
```bash
kubectl create namespace argocd
helm repo add argo [https://argoproj.github.io/argo-helm](https://argoproj.github.io/argo-helm)
helm install argocd argo-cd --namespace argocd
```
## 4. Access Dashboards
```
* ArgoCD: https://localhost:8080
* App Ingress: http://my-first-devops-project.local
```
# Contact
## Isaiah Omoboriowo
* https://www.linkedin.com/in/thedevisaiah
* isaiahomoboriowo.framer.website