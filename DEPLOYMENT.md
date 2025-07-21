# Scout AI - DigitalOcean Deployment Guide

This guide helps you deploy Scout AI (based on Open WebUI) to a DigitalOcean droplet.

## Quick Deployment

### 1. Create DigitalOcean Droplet
- **Minimum specs**: 2 vCPUs, 4GB RAM, 50GB SSD
- **Recommended**: 4 vCPUs, 8GB RAM, 100GB SSD
- **OS**: Ubuntu 22.04 LTS
- **Optional**: Enable monitoring and backups

### 2. Connect to Your Droplet
```bash
ssh root@your-droplet-ip
```

### 3. Clone and Deploy
```bash
# Clone your Scout repository
git clone https://github.com/xkusanagi/Scout.git
cd Scout

# Run the deployment script
./deploy.sh
```

### 4. Configure Domain (Optional)
If you have a domain name:
1. Point your domain's A record to your droplet IP
2. Update `WEBUI_URL` in `docker-compose.production.yaml`
3. Restart: `docker-compose -f docker-compose.production.yaml restart`

## Manual Deployment

If you prefer manual control:

```bash
# Install Docker and Docker Compose
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Start services
docker-compose -f docker-compose.production.yaml up -d
```

## Configuration

### Environment Variables

Edit `docker-compose.production.yaml` to customize:

- `WEBUI_NAME`: Your application name
- `WEBUI_URL`: Your domain or IP
- `ENABLE_SIGNUP`: Allow new user registrations
- `DEFAULT_USER_ROLE`: Default role for new users

### Security Settings

After creating your admin account:
1. Set `ENABLE_SIGNUP=False`
2. Restart services
3. Consider setting up SSL/TLS with Let's Encrypt

## Management Commands

```bash
# View logs
docker-compose -f docker-compose.production.yaml logs -f

# Restart services
docker-compose -f docker-compose.production.yaml restart

# Stop services
docker-compose -f docker-compose.production.yaml down

# Update to latest version
docker-compose -f docker-compose.production.yaml pull
docker-compose -f docker-compose.production.yaml up -d

# Backup data
docker run --rm -v open-webui_open-webui:/data -v $(pwd):/backup alpine tar czf /backup/scout-backup-$(date +%Y%m%d).tar.gz -C /data .
```

## Firewall Configuration

```bash
# Allow HTTP and SSH
ufw allow 22
ufw allow 80
ufw enable
```

## Troubleshooting

### Check Service Status
```bash
docker-compose -f docker-compose.production.yaml ps
```

### View Detailed Logs
```bash
docker-compose -f docker-compose.production.yaml logs open-webui
```

### Restart Individual Service
```bash
docker-compose -f docker-compose.production.yaml restart open-webui
```

## SSL/HTTPS Setup (Optional)

For production use, consider setting up SSL:

1. Install Nginx as reverse proxy
2. Use Let's Encrypt for SSL certificates
3. Configure Nginx to proxy to Scout AI

## Support

For issues specific to Scout AI customizations, check the repository issues.
For Open WebUI issues, refer to the [Open WebUI documentation](https://docs.openwebui.com/).