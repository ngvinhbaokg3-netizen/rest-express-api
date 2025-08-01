#!/bin/bash

# Script đưa code Betino lên GitHub
# Repository: https://github.com/ngvinhbaokg3-netizen/bet0108

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

REPO_URL="https://github.com/ngvinhbaokg3-netizen/bet0108.git"
REPO_NAME="bet0108"

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

echo "🚀 ĐANG ĐƯA CODE LÊN GITHUB..."
echo "📦 Repository: $REPO_URL"
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    log_error "Git chưa được cài đặt!"
    exit 1
fi

# Initialize git if not already initialized
if [ ! -d ".git" ]; then
    log_info "Khởi tạo Git repository..."
    git init
    log_success "Git repository đã được khởi tạo"
fi

# Create .gitignore if not exists
if [ ! -f ".gitignore" ]; then
    log_info "Tạo file .gitignore..."
    cat > .gitignore << 'EOF'
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Production builds
dist/
build/

# Environment files
.env
.env.local
.env.development
.env.production

# IDE files
.vscode/
.idea/
*.swp
*.swo

# OS files
.DS_Store
Thumbs.db

# Logs
logs/
*.log

# Runtime files
*.pid
.dev.pid
.app.pid

# Cache
.cache/
.parcel-cache/

# Temporary files
tmp/
temp/

# Database
*.db
*.sqlite

# Coverage
coverage/

# Misc
.nyc_output/
EOF
    log_success "File .gitignore đã được tạo"
fi

# Add all files
log_info "Thêm tất cả files vào Git..."
git add .

# Check if there are changes to commit
if git diff --staged --quiet; then
    log_warning "Không có thay đổi nào để commit"
else
    # Commit changes
    log_info "Commit changes..."
    git commit -m "🎰 Betino Casino - Complete betting platform

✨ Features:
- Modern React frontend with Tailwind CSS
- Express backend with TypeScript
- PostgreSQL database integration
- Responsive design system
- Multi-language support (Vietnamese/English)
- 1000+ games portfolio
- VIP program and promotions
- 24/7 customer support
- Automated deployment scripts

🎮 Game Categories:
- Lottery (Xổ số)
- Fish shooting (Bắn cá)  
- Live Casino
- Card games (Game bài)
- Slots (Nổ hũ)
- Sports betting (Thể thao)
- E-sports

🚀 Ready for production deployment!"

    log_success "Changes đã được commit"
fi

# Add remote origin if not exists
if ! git remote get-url origin &> /dev/null; then
    log_info "Thêm remote origin..."
    git remote add origin $REPO_URL
    log_success "Remote origin đã được thêm"
else
    log_info "Remote origin đã tồn tại, cập nhật URL..."
    git remote set-url origin $REPO_URL
fi

# Get current branch name
CURRENT_BRANCH=$(git branch --show-current)
if [ -z "$CURRENT_BRANCH" ]; then
    CURRENT_BRANCH="main"
    git checkout -b main
    log_info "Tạo và chuyển sang branch main"
fi

# Push to GitHub
log_info "Đang push code lên GitHub..."
echo ""
log_warning "⚠️  Bạn có thể cần nhập username và password/token GitHub"
echo ""

if git push -u origin $CURRENT_BRANCH; then
    log_success "🎉 CODE ĐÃ ĐƯỢC ĐƯA LÊN GITHUB THÀNH CÔNG!"
    echo ""
    echo "🌐 Repository URL: $REPO_URL"
    echo "📂 Branch: $CURRENT_BRANCH"
    echo "🎰 Betino Casino đã sẵn sàng trên GitHub!"
    echo ""
    echo "🔗 Truy cập tại: https://github.com/ngvinhbaokg3-netizen/bet0108"
else
    log_error "❌ Không thể push lên GitHub"
    echo ""
    echo "💡 Có thể bạn cần:"
    echo "   1. Kiểm tra quyền truy cập repository"
    echo "   2. Đăng nhập GitHub: git config --global user.name 'your-username'"
    echo "   3. Thiết lập token: git config --global user.email 'your-email'"
    echo "   4. Hoặc sử dụng SSH key"
    exit 1
fi

echo ""
echo "🎯 Next steps:"
echo "   - Repository: https://github.com/ngvinhbaokg3-netizen/bet0108"
echo "   - Clone: git clone $REPO_URL"
echo "   - Deploy: ./deploy-betino.sh production"
echo ""
