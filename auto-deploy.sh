#!/bin/bash

# Script tự động triển khai ứng dụng Betino
# Sử dụng: ./auto-deploy.sh [environment]
# Environment: development | production

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="betino-casino"
NODE_VERSION="18"
ENVIRONMENT=${1:-development}

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_requirements() {
    log_info "Kiểm tra yêu cầu hệ thống..."
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        log_error "Node.js chưa được cài đặt"
        exit 1
    fi
    
    NODE_CURRENT=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_CURRENT" -lt "$NODE_VERSION" ]; then
        log_error "Cần Node.js version $NODE_VERSION trở lên. Hiện tại: $(node -v)"
        exit 1
    fi
    
    # Check npm
    if ! command -v npm &> /dev/null; then
        log_error "npm chưa được cài đặt"
        exit 1
    fi
    
    # Check PostgreSQL connection (if production)
    if [ "$ENVIRONMENT" = "production" ]; then
        if [ -z "$DATABASE_URL" ]; then
            log_error "DATABASE_URL không được thiết lập cho production"
            exit 1
        fi
    fi
    
    log_success "Tất cả yêu cầu đã được đáp ứng"
}

setup_environment() {
    log_info "Thiết lập môi trường $ENVIRONMENT..."
    
    # Copy appropriate env file
    if [ "$ENVIRONMENT" = "production" ]; then
        if [ -f ".env.production" ]; then
            cp .env.production .env
            log_success "Đã sao chép .env.production"
        else
            log_error "File .env.production không tồn tại"
            exit 1
        fi
    else
        if [ -f ".env.development" ]; then
            cp .env.development .env
            log_info "Đã sao chép .env.development"
        else
            log_warning "File .env.development không tồn tại, tạo file mặc định..."
            cat > .env << EOF
DATABASE_URL=postgresql://demo_user:demo_password@localhost:5432/betino_dev
PORT=8000
NODE_ENV=development
EOF
        fi
    fi
}

install_dependencies() {
    log_info "Cài đặt dependencies..."
    
    # Clean install
    if [ -d "node_modules" ]; then
        log_info "Xóa node_modules cũ..."
        rm -rf node_modules
    fi
    
    if [ -f "package-lock.json" ]; then
        npm ci
    else
        npm install
    fi
    
    log_success "Dependencies đã được cài đặt"
}

setup_database() {
    log_info "Thiết lập database..."
    
    # Run database migrations
    if npm run db:push &> /dev/null; then
        log_success "Database migrations đã hoàn thành"
    else
        log_warning "Không thể chạy migrations hoặc lệnh không tồn tại"
    fi
}

build_application() {
    if [ "$ENVIRONMENT" = "production" ]; then
        log_info "Build ứng dụng cho production..."
        
        # Build the application
        npm run build
        
        if [ $? -eq 0 ]; then
            log_success "Build thành công"
        else
            log_error "Build thất bại"
            exit 1
        fi
    else
        log_info "Môi trường development - bỏ qua build step"
    fi
}

start_application() {
    log_info "Khởi động ứng dụng..."
    
    # Kill existing processes on port 8000
    if lsof -ti:8000 &> /dev/null; then
        log_warning "Đang dừng process trên port 8000..."
        fuser -k 8000/tcp || true
        sleep 2
    fi
    
    if [ "$ENVIRONMENT" = "production" ]; then
        # Check if PM2 is installed
        if command -v pm2 &> /dev/null; then
            log_info "Sử dụng PM2 để chạy ứng dụng..."
            
            # Stop existing PM2 process
            pm2 stop $PROJECT_NAME 2>/dev/null || true
            pm2 delete $PROJECT_NAME 2>/dev/null || true
            
            # Start with PM2
            pm2 start npm --name "$PROJECT_NAME" -- start
            pm2 save
            
            log_success "Ứng dụng đã được khởi động với PM2"
            log_info "Sử dụng 'pm2 logs $PROJECT_NAME' để xem logs"
            log_info "Sử dụng 'pm2 stop $PROJECT_NAME' để dừng ứng dụng"
        else
            log_warning "PM2 chưa được cài đặt, chạy trực tiếp..."
            npm start &
            APP_PID=$!
            echo $APP_PID > .app.pid
            log_success "Ứng dụng đã được khởi động với PID: $APP_PID"
        fi
    else
        log_info "Khởi động development server..."
        npm run dev &
        DEV_PID=$!
        echo $DEV_PID > .dev.pid
        log_success "Development server đã được khởi động với PID: $DEV_PID"
    fi
}

check_health() {
    log_info "Kiểm tra health của ứng dụng..."
    
    # Wait for application to start
    sleep 5
    
    # Check if application is responding
    if curl -f http://localhost:8000 &> /dev/null; then
        log_success "Ứng dụng đang hoạt động tại http://localhost:8000"
    else
        log_error "Ứng dụng không phản hồi"
        exit 1
    fi
}

show_status() {
    echo ""
    echo "=================================="
    echo "🎰 BETINO CASINO DEPLOYMENT"
    echo "=================================="
    echo "Environment: $ENVIRONMENT"
    echo "URL: http://localhost:8000"
    echo "Node.js: $(node -v)"
    echo "npm: $(npm -v)"
    
    if [ "$ENVIRONMENT" = "production" ] && command -v pm2 &> /dev/null; then
        echo ""
        echo "PM2 Status:"
        pm2 list | grep $PROJECT_NAME || echo "No PM2 processes found"
    fi
    
    echo ""
    echo "🎯 Useful Commands:"
    echo "  - View logs: tail -f logs/*.log"
    if [ "$ENVIRONMENT" = "production" ] && command -v pm2 &> /dev/null; then
        echo "  - PM2 logs: pm2 logs $PROJECT_NAME"
        echo "  - Stop app: pm2 stop $PROJECT_NAME"
        echo "  - Restart: pm2 restart $PROJECT_NAME"
    else
        echo "  - Stop dev: kill \$(cat .dev.pid)"
    fi
    echo "  - Database: npm run db:push"
    echo ""
}

cleanup_on_exit() {
    if [ "$ENVIRONMENT" = "development" ] && [ -f ".dev.pid" ]; then
        DEV_PID=$(cat .dev.pid)
        if kill -0 $DEV_PID 2>/dev/null; then
            log_info "Dừng development server..."
            kill $DEV_PID
        fi
        rm -f .dev.pid
    fi
}

# Main execution
main() {
    echo "🚀 Bắt đầu triển khai Betino Casino..."
    echo "Environment: $ENVIRONMENT"
    echo ""
    
    # Set up cleanup on exit
    trap cleanup_on_exit EXIT
    
    # Execute deployment steps
    check_requirements
    setup_environment
    install_dependencies
    setup_database
    build_application
    start_application
    check_health
    show_status
    
    log_success "🎉 Triển khai hoàn tất!"
    
    if [ "$ENVIRONMENT" = "development" ]; then
        log_info "Development server đang chạy. Nhấn Ctrl+C để dừng."
        wait
    fi
}

# Handle script arguments
case "$1" in
    "production"|"prod")
        ENVIRONMENT="production"
        ;;
    "development"|"dev"|"")
        ENVIRONMENT="development"
        ;;
    "help"|"-h"|"--help")
        echo "Sử dụng: $0 [environment]"
        echo ""
        echo "Environments:"
        echo "  development, dev    - Chạy development server (mặc định)"
        echo "  production, prod    - Build và chạy production server"
        echo ""
        echo "Ví dụ:"
        echo "  $0                  - Chạy development"
        echo "  $0 development      - Chạy development"
        echo "  $0 production       - Chạy production"
        exit 0
        ;;
    *)
        log_error "Environment không hợp lệ: $1"
        echo "Sử dụng: $0 [development|production]"
        exit 1
        ;;
esac

# Run main function
main
