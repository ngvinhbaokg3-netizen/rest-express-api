#!/bin/bash

# Script tự động triển khai ứng dụng lên server Ubuntu 22.04

SERVER_IP="160.30.44.126"
SERVER_USER="root"
SERVER_PASS="112233"
PROJECT_DIR="casino-app"

echo "Bắt đầu triển khai ứng dụng lên $SERVER_IP"

# Cài đặt Node.js, npm, git trên server
ssh $SERVER_USER@$SERVER_IP << EOF
  apt update && apt install -y curl git
  curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
  apt install -y nodejs
EOF

# Clone hoặc cập nhật project trên server
ssh $SERVER_USER@$SERVER_IP << EOF
  if [ ! -d "$PROJECT_DIR" ]; then
    git clone https://github.com/your-repo-url/$PROJECT_DIR.git
  fi
  cd $PROJECT_DIR
  git pull origin main
EOF

# Cài đặt dependencies và build project
ssh $SERVER_USER@$SERVER_IP << EOF
  cd $PROJECT_DIR
  npm install
  npm run build
EOF

# Chạy ứng dụng
ssh $SERVER_USER@$SERVER_IP << EOF
  cd $PROJECT_DIR
  pm2 stop casino-app || true
  pm2 start npm --name "casino-app" -- run start
  pm2 save
EOF

echo "Triển khai hoàn tất. Ứng dụng đang chạy trên $SERVER_IP"
