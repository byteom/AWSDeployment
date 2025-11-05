# AWS Deployment Guide - MicroCourses Full-Stack Application

Complete guide for deploying your Node.js + Express + MongoDB backend and React + Vite frontend to AWS with automated CI/CD.

## 📚 Documentation

### Main Guide
- **[MANUAL_DEPLOYMENT_GUIDE.md](./MANUAL_DEPLOYMENT_GUIDE.md)** - Complete step-by-step manual deployment guide
  - AWS setup (EC2, S3, CloudFront)
  - MongoDB configuration
  - Backend deployment
  - Frontend deployment
  - CORS configuration (detailed)
  - GitHub Actions auto-deployment
  - Security setup
  - Troubleshooting

### Supporting Guides
- **[GITHUB_SECRETS_SETUP.md](./GITHUB_SECRETS_SETUP.md)** - Detailed guide for configuring GitHub Secrets
- **[DEPLOYMENT_CHECKLIST.md](./DEPLOYMENT_CHECKLIST.md)** - Pre-deployment verification checklist

## 🚀 Quick Start

1. **Read the manual guide**: [MANUAL_DEPLOYMENT_GUIDE.md](./MANUAL_DEPLOYMENT_GUIDE.md)
2. **Follow each step** carefully
3. **Configure GitHub Secrets**: [GITHUB_SECRETS_SETUP.md](./GITHUB_SECRETS_SETUP.md)
4. **Use checklist**: [DEPLOYMENT_CHECKLIST.md](./DEPLOYMENT_CHECKLIST.md)
5. **Deploy**: Push to `main` branch for auto-deployment

## 📋 Architecture

```
Frontend (React + Vite) → S3 + CloudFront
Backend (Node.js + Express) → EC2 + PM2 + Nginx
Database → MongoDB Atlas
CI/CD → GitHub Actions
```

## 🛠️ CI/CD Workflows

- **`.github/workflows/deploy-backend.yml`** - Automatic backend deployment to EC2
- **`.github/workflows/deploy-frontend.yml`** - Automatic frontend deployment to S3/CloudFront

## 📖 Key Topics Covered

### CORS Configuration
Complete guide on configuring CORS for your frontend-backend communication:
- Backend CORS setup (Express.js)
- Frontend API configuration
- Environment variables
- Testing and troubleshooting

### Auto-Deployment
How GitHub Actions automatically deploys your application:
- Workflow triggers
- Backend deployment process
- Frontend deployment process
- Manual triggers

### Security
- IAM roles and policies
- Security groups
- SSL certificates
- Environment variables

## 🆘 Troubleshooting

See the troubleshooting section in [MANUAL_DEPLOYMENT_GUIDE.md](./MANUAL_DEPLOYMENT_GUIDE.md) for:
- Common deployment issues
- CORS problems
- Database connection issues
- GitHub Actions failures

## 📝 Quick Reference

### EC2 Commands
```bash
# SSH to EC2
ssh -i aws-deployment-key.pem ubuntu@EC2_IP

# Check application status
pm2 status
pm2 logs micorCourses-backend

# Restart application
pm2 restart micorCourses-backend
```

### S3 & CloudFront
```powershell
# Upload frontend
aws s3 sync .\dist\ s3://bucket-name/ --delete

# Invalidate CloudFront cache
aws cloudfront create-invalidation --distribution-id ID --paths "/*"
```

---

**Start with [MANUAL_DEPLOYMENT_GUIDE.md](./MANUAL_DEPLOYMENT_GUIDE.md) for complete instructions!**
