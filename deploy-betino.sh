#!/bin/bash

# Script triển khai Betino Casino - Phiên bản cải tiến
# Sử dụng: ./deploy-betino.sh [environment]

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PROJECT_NAME="betino-casino"
ENVIRONMENT=${1:-development}

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

get_app_port() {
    if [ -f ".env" ]; then
        PORT=$(grep "^PORT=" .env | cut -d'=' -f2 2>/dev/null || echo "8000")
    else
        PORT=8000
    fi
    echo ${PORT:-8000}
}

setup_environment() {
    log_info "Thiết lập môi trường $ENVIRONMENT..."
    
    if [ "$ENVIRONMENT" = "production" ]; then
        if [ -f ".env.production" ]; then
            cp .env.production .env
            log_success "Đã sao chép .env.production"
        else
            log_error "File .env.production không tồn tại"
            exit 1
        fi
    else
        # Tạo .env cho development với PORT=8000
        cat > .env << EOF
DATABASE_URL=postgresql://demo_user:demo_password@localhost:5432/betino_dev
PORT=8000
NODE_ENV=development
EOF
        log_success "Đã tạo file .env cho development"
    fi
}

install_dependencies() {
    log_info "Cài đặt dependencies..."
    
    if [ -d "node_modules" ]; then
        rm -rf node_modules
    fi
    
    npm ci --silent
    log_success "Dependencies đã được cài đặt"
}

start_application() {
    log_info "Khởi động ứng dụng..."
    
    APP_PORT=$(get_app_port)
    
    # Kill existing processes
    if lsof -ti:$APP_PORT &> /dev/null; then
        log_warning "Dừng process trên port $APP_PORT..."
        fuser -k $APP_PORT/tcp || true
        sleep 2
    fi
    
    if lsof -ti:5000 &> /dev/null; then
        log_warning "Dừng process trên port 5000..."
        fuser -k 5000/tcp || true
        sleep 2
    fi
    
    if [ "$ENVIRONMENT" = "production" ]; then
        npm start &
        APP_PID=$!
        echo $APP_PID > .app.pid
        log_success "Production server khởi động với PID: $APP_PID"
    else
        npm run dev &
        DEV_PID=$!
        echo $DEV_PID > .dev.pid
        log_success "Development server khởi động với PID: $DEV_PID"
    fi
}

check_health() {
    log_info "Kiểm tra health của ứng dụng..."
    
    APP_PORT=$(get_app_port)
    
    # Chờ ứng dụng khởi động
    sleep 8
    
    # Thử cả hai port
    for port in $APP_PORT 5000; do
        log_info "Kiểm tra port $port..."
        if curl -f -s http://localhost:$port > /dev/null 2>&1; then
            log_success "✅ Ứng dụng đang hoạt động tại http://localhost:$port"
            return 0
        fi
    done
    
    log_error "❌ Ứng dụng không phản hồi"
    return 1
}

show_status() {
    APP_PORT=$(get_app_port)
    
    echo ""
    echo "🎰 =================================="
    echo "   BETINO CASINO - ĐANG HOẠT ĐỘNG"
    echo "🎰 =================================="
    echo ""
    echo "🌐 URL chính: http://localhost:$APP_PORT"
    echo "🌐 URL dự phòng: http://localhost:5000"
    echo "📦 Environment: $ENVIRONMENT"
    echo "⚡ Node.js: $(node -v)"
    echo ""
    echo "🎯 Lệnh hữu ích:"
    if [ "$ENVIRONMENT" = "development" ]; then
        echo "   - Dừng server: kill \$(cat .dev.pid)"
    else
        echo "   - Dừng server: kill \$(cat .app.pid)"
    fi
    echo "   - Xem logs: npm run dev (trong terminal khác)"
    echo "   - Database: npm run db:push"
    echo ""
    echo "🎮 Truy cập ứng dụng tại: http://localhost:$APP_PORT"
    echo "🎮 Hoặc: http://localhost:5000"
    echo ""
}

cleanup_on_exit() {
    if [ -f ".dev.pid" ]; then
        DEV_PID=$(cat .dev.pid 2>/dev/null)
        if [ ! -z "$DEV_PID" ] && kill -0 $DEV_PID 2>/dev/null; then
            log_info "Dừng development server..."
            kill $DEV_PID 2>/dev/null || true
        fi
        rm -f .dev.pid
    fi
    
    if [ -f ".app.pid" ]; then
        APP_PID=$(cat .app.pid 2>/dev/null)
        if [ ! -z "$APP_PID" ] && kill -0 $APP_PID 2>/dev/null; then
            log_info "Dừng production server..."
            kill $APP_PID 2>/dev/null || true
        fi
        rm -f .app.pid
    fi
}

main() {
    echo "🚀 Đang khởi động Betino Casino..."
    echo "📋 Environment: $ENVIRONMENT"
    echo ""
    
    trap cleanup_on_exit EXIT
    
    setup_environment
    install_dependencies
    start_application
    
    if check_health; then
        show_status
        log_success "🎉 Triển khai thành công!"
        
        if [ "$ENVIRONMENT" = "development" ]; then
            log_info "💡 Development server đang chạy. Nhấn Ctrl+C để dừng."
            echo ""
            echo "🔥 Đang mở browser..."
            
            # Thử mở browser (nếu có thể)
            APP_PORT=$(get_app_port)
            if command -v xdg-open > /dev/null; then
                xdg-open "http://localhost:$APP_PORT" 2>/dev/null || true
            elif command -v open > /dev/null; then
                open "http://localhost:$APP_PORT" 2>/dev/null || true
            fi
            
            wait
        fi
    else
        log_error "❌ Triển khai thất bại"
        exit 1
    fi
}

# Handle arguments
case "$1" in
    "production"|"prod")
        ENVIRONMENT="production"
        ;;
    "development"|"dev"|"")
        ENVIRONMENT="development"
        ;;
    "help"|"-h"|"--help")
        echo "🎰 Betino Casino Deployment Script"
        echo ""
        echo "Sử dụng: $0 [environment]"
        echo ""
        echo "Environments:"
        echo "  development, dev    - Development server (mặc định)"
        echo "  production, prod    - Production server"
        echo ""
        echo "Ví dụ:"
        echo "  $0                  - Chạy development"
        echo "  $0 dev              - Chạy development"
        echo "  $0 production       - Chạy production"
        exit 0
        ;;
    *)
        log_error "Environment không hợp lệ: $1"
        echo "Sử dụng: $0 [development|production] hoặc $0 --help"
        exit 1
        ;;
esac

main
