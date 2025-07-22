# Scout AI - Development Workflow

## Branch Strategy

### Branch Structure
```
main (production) ← Production deployment (demo.x2501.com)
└── dev (development) ← Development integration branch
    ├── feature/new-ui-components
    ├── feature/custom-auth
    └── feature/advanced-rag
```

### Branch Purposes
- **`main`**: Production-ready code, deployed to demo.x2501.com
- **`dev`**: Development integration, deployed to staging environment
- **`feature/*`**: Individual feature development

## Development Environment Setup

### Local Development
```bash
# Clone your fork
git clone https://github.com/xkusanagi/Scout.git
cd Scout

# Install dependencies
npm install --legacy-peer-deps

# Start local development (uses pre-built images)
docker-compose up -d

# Access at http://localhost:3000
```

### Working on Features

#### 1. Create Feature Branch
```bash
# Switch to dev branch
git checkout dev
git pull origin dev

# Create feature branch
git checkout -b feature/your-feature-name

# Work on your feature...
```

#### 2. Development Cycle
```bash
# Make changes to code
# Test locally at http://localhost:3000

# Commit changes
git add .
git commit -m "feat: add new chat functionality

- Added message threading
- Improved UI responsiveness
- Fixed bug with file uploads

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

#### 3. Push Feature Branch
```bash
# Push feature branch
git push origin feature/your-feature-name

# Create Pull Request on GitHub
# Target: feature/your-feature-name → dev
```

#### 4. Merge to Development
```bash
# After PR approval, merge to dev
git checkout dev
git pull origin dev
git merge feature/your-feature-name
git push origin dev

# Delete feature branch
git branch -d feature/your-feature-name
git push origin --delete feature/your-feature-name
```

#### 5. Deploy to Production
```bash
# When dev is stable, merge to main
git checkout main
git pull origin main
git merge dev
git push origin main

# This triggers production deployment
```

## Environment Setup

### Local Environment (Development)
- **URL**: http://localhost:3000
- **Purpose**: Feature development and testing
- **Data**: Disposable test data

### Staging Environment (Optional)
- **URL**: https://staging.x2501.com (if you want to set one up)
- **Purpose**: Integration testing before production
- **Data**: Copy of production data for testing

### Production Environment
- **URL**: https://demo.x2501.com
- **Purpose**: Live application
- **Data**: Real user data

## Deployment Process

### Current Production Deployment
Your production is currently deployed manually. Here's how to update it:

```bash
# SSH into production server
ssh root@your-droplet-ip

# Navigate to Scout directory
cd Scout

# Pull latest main branch
git checkout main
git pull origin main

# Update containers
docker-compose -f docker-compose.production.yaml pull
docker-compose -f docker-compose.production.yaml up -d

# Check logs
docker-compose -f docker-compose.production.yaml logs -f
```

### Automated Deployment (Optional)
We can set up GitHub Actions to automatically deploy when you push to main.

## Development Best Practices

### Commit Message Format
```
type: short description

- Detailed change 1
- Detailed change 2
- Bug fixes

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

### Testing Locally
```bash
# Start local environment
docker-compose up -d

# Make changes to code
# Test at http://localhost:3000

# Check logs
docker-compose logs -f open-webui
```

### Code Quality
```bash
# Before committing, check code quality
npm run lint
npm run format

# Test frontend builds
npm run build
```

## Quick Commands Reference

### Branch Management
```bash
# List all branches
git branch -a

# Switch to dev
git checkout dev

# Create feature branch
git checkout -b feature/new-feature

# Delete branch
git branch -d feature/old-feature
```

### Deployment Commands
```bash
# Local development
docker-compose up -d

# Production deployment (on server)
docker-compose -f docker-compose.production.yaml up -d --pull always

# View logs
docker-compose logs -f
```

### Sync with Upstream (Open WebUI updates)
```bash
# Get latest from upstream Open WebUI
git fetch upstream
git checkout main
git merge upstream/main
git push origin main

# Update dev branch
git checkout dev
git merge main
git push origin dev
```

## Troubleshooting

### Local Development Issues
- **Port conflicts**: Change ports in docker-compose.yaml
- **Build failures**: Use `--legacy-peer-deps` with npm
- **Container issues**: Run `docker-compose down && docker-compose up -d`

### Production Deployment Issues
- **SSL renewal**: `certbot renew`
- **Container restart**: `docker-compose -f docker-compose.production.yaml restart`
- **View logs**: `docker-compose -f docker-compose.production.yaml logs -f`