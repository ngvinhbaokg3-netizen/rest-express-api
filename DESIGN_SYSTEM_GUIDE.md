# Hướng Dẫn Sử Dụng Hệ Thống Thiết Kế Betino

## 1. Tổng Quan Hệ Thống Thiết Kế

Dự án Betino sử dụng một hệ thống thiết kế hiện đại dựa trên:
- **Tailwind CSS** với custom configuration
- **Radix UI** cho các component primitives
- **Class Variance Authority (CVA)** cho variant management
- **Dark theme** làm chủ đạo với accent màu vàng đặc trưng

## 2. Màu Sắc Chính (Color System)

### 2.1 Màu Chủ Đạo
```css
/* Betino Brand Colors */
--betino-gold: 45 93% 58%        /* Màu vàng chính */
--betino-gold-dark: 42 87% 55%   /* Màu vàng đậm */

/* Dark Theme Colors */
--background: 222.2 84% 4.9%     /* Nền tối chính */
--foreground: 210 40% 98%        /* Text trắng */
--card: 222.2 84% 4.9%           /* Nền card */
--secondary: 217.2 32.6% 17.5%   /* Màu phụ */
```

### 2.2 Cách Sử Dụng Màu
```tsx
// ✅ ĐÚNG - Sử dụng CSS variables
<div className="bg-background text-foreground">
<Button className="betino-gold text-black">Đăng nhập</Button>
<span className="text-betino-gold">Tỷ lệ cược</span>

// ❌ SAI - Không sử dụng màu cứng
<div className="bg-gray-900 text-white">
<Button className="bg-yellow-500">Đăng nhập</Button>
```

## 3. Typography & Text Styling

### 3.1 Hierarchy Text
```tsx
// Hero Title
<h1 className="hero-title text-4xl md:text-6xl font-bold gradient-text">

// Section Title  
<h2 className="text-2xl md:text-3xl font-semibold text-foreground">

// Card Title
<h3 className="text-lg font-medium text-foreground">

// Body Text
<p className="text-muted-foreground">
```

### 3.2 Responsive Text
```tsx
// ✅ ĐÚNG - Responsive typography
<h1 className="text-2xl md:text-4xl lg:text-6xl">
<p className="text-sm md:text-base">

// ❌ SAI - Fixed size
<h1 className="text-6xl">
```

## 4. Component System

### 4.1 Button Variants
```tsx
import { Button } from "@/components/ui/button";

// Primary Button (Betino Gold)
<Button className="btn-betino">Đăng ký ngay</Button>

// Secondary Button
<Button variant="secondary">Xem thêm</Button>

// Outline Button
<Button variant="outline">Hủy</Button>

// Ghost Button
<Button variant="ghost">Đóng</Button>

// Destructive Button
<Button variant="destructive">Xóa</Button>
```

### 4.2 Card Components
```tsx
// ✅ ĐÚNG - Sử dụng card system
<div className="card-hover bg-card border border-border rounded-lg p-6">
  <div className="game-card">
    {/* Content */}
  </div>
</div>

// Với hover effect
<div className="card-hover game-card bg-card">
  {/* Tự động có transform và shadow khi hover */}
</div>
```

### 4.3 Input Components
```tsx
import { Input } from "@/components/ui/input";

// ✅ ĐÚNG - Sử dụng form-input class
<Input 
  className="form-input bg-input border-border focus:border-betino-gold"
  placeholder="Nhập tên đăng nhập"
/>

// Search Input
<Input 
  className="search-input"
  placeholder="Tìm kiếm game..."
/>
```

## 5. Layout & Spacing

### 5.1 Container System
```tsx
// ✅ ĐÚNG - Responsive container
<div className="container mx-auto px-4 md:px-6 lg:px-8">

// Grid System
<div className="grid-responsive">
  {/* Auto-responsive grid */}
</div>

// Hot Games Grid
<div className="hot-games-grid">
  {/* Specific game grid */}
</div>
```

### 5.2 Spacing Guidelines
```tsx
// ✅ ĐÚNG - Consistent spacing
<div className="space-y-4 md:space-y-6">     // Vertical spacing
<div className="space-x-2 md:space-x-4">     // Horizontal spacing
<div className="p-4 md:p-6 lg:p-8">          // Padding
<div className="mb-4 md:mb-6">               // Margin
```

## 6. Animation & Transitions

### 6.1 Predefined Animations
```tsx
// Marquee cho odds ticker
<div className="animate-marquee">

// Slide in animation
<div className="animate-slide-in">

// Floating animation cho chat
<div className="floating-chat">

// Loading spinner
<div className="spinner">
```

### 6.2 Hover Effects
```tsx
// ✅ ĐÚNG - Sử dụng predefined hover classes
<div className="card-hover">           // Card hover effect
<img className="provider-logo">        // Logo hover effect  
<button className="btn-betino">        // Button hover effect
<a className="social-icon">            // Social icon hover
```

## 7. Responsive Design Patterns

### 7.1 Breakpoint Strategy
```tsx
// ✅ ĐÚNG - Mobile-first approach
<div className="block md:hidden">          // Mobile only
<div className="hidden md:block">          // Desktop only
<div className="grid-cols-1 md:grid-cols-2 lg:grid-cols-4">

// Navigation responsive
<div className="navigation-menu hidden lg:flex">
```

### 7.2 Component Responsive Behavior
```tsx
// Header responsive
<div className="hidden lg:flex items-center space-x-6">     // Desktop nav
<Button className="lg:hidden">☰ Menu</Button>               // Mobile menu

// Modal responsive
<div className="w-full max-w-md mx-auto">                   // Mobile modal
```

## 8. Utility Classes Đặc Biệt

### 8.1 Betino Specific Classes
```css
.betino-gold              /* Background vàng chính */
.betino-gold-dark         /* Background vàng đậm */
.text-betino-gold         /* Text màu vàng */
.border-betino-gold       /* Border màu vàng */
.gradient-text            /* Text gradient effect */
.hero-gradient            /* Hero overlay gradient */
.footer-gradient          /* Footer gradient */
```

### 8.2 Game & Betting Specific
```css
.odds-ticker              /* Ticker background */
.odds-match-card          /* Match card styling */
.category-tab             /* Game category tabs */
.nav-item-active          /* Active navigation */
.modal-backdrop           /* Modal backdrop blur */
```

## 9. Component Composition Patterns

### 9.1 Modal Pattern
```tsx
// ✅ ĐÚNG - Modal composition
<div className="modal-backdrop fixed inset-0 z-50">
  <div className="bg-card border border-border rounded-lg max-w-md mx-auto mt-20">
    <div className="p-6">
      {/* Modal content */}
    </div>
  </div>
</div>
```

### 9.2 Card Pattern
```tsx
// ✅ ĐÚNG - Game card pattern
<div className="game-card card-hover bg-card border border-border rounded-lg overflow-hidden">
  <div className="aspect-video bg-muted">
    {/* Game image */}
  </div>
  <div className="p-4">
    <h3 className="font-semibold text-foreground">{title}</h3>
    <p className="text-muted-foreground text-sm">{description}</p>
  </div>
</div>
```

### 9.3 Navigation Pattern
```tsx
// ✅ ĐÚNG - Navigation item pattern
<a className="text-gray-700 hover:text-betino-gold transition-colors text-sm font-semibold px-3 py-2 rounded hover:bg-yellow-100">
  {item.name}
</a>

// Active state
<a className="nav-item-active">
  {item.name}
</a>
```

## 10. Best Practices cho AI

### 10.1 DO's (Nên làm)
```tsx
// ✅ Sử dụng CSS variables thay vì hard-coded colors
className="bg-background text-foreground"

// ✅ Sử dụng predefined component variants
<Button variant="secondary" size="sm">

// ✅ Sử dụng responsive classes
className="text-sm md:text-base lg:text-lg"

// ✅ Sử dụng utility classes có sẵn
className="card-hover game-card"

// ✅ Kết hợp với cn() utility
className={cn("base-classes", conditionalClass && "additional-class")}
```

### 10.2 DON'Ts (Không nên làm)
```tsx
// ❌ Không sử dụng màu cứng
className="bg-yellow-500 text-black"

// ❌ Không tạo inline styles
style={{ backgroundColor: '#fbbf24' }}

// ❌ Không bỏ qua responsive
className="text-6xl"  // Should be "text-2xl md:text-6xl"

// ❌ Không sử dụng icon libraries
import { Star } from 'lucide-react'  // Tránh sử dụng

// ❌ Không sử dụng external images
src="https://unsplash.com/..."  // Tránh sử dụng
```

### 10.3 Component Creation Pattern
```tsx
// ✅ ĐÚNG - Tạo component theo pattern
import { cn } from "@/lib/utils";

interface GameCardProps {
  title: string;
  description: string;
  className?: string;
}

export function GameCard({ title, description, className }: GameCardProps) {
  return (
    <div className={cn(
      "game-card card-hover bg-card border border-border rounded-lg p-4",
      className
    )}>
      <h3 className="font-semibold text-foreground mb-2">{title}</h3>
      <p className="text-muted-foreground text-sm">{description}</p>
    </div>
  );
}
```

## 11. Theme Customization

### 11.1 Extending Colors
```tsx
// Trong tailwind.config.ts - đã có sẵn
colors: {
  'betino-gold': 'hsl(var(--betino-gold))',
  'betino-gold-dark': 'hsl(var(--betino-gold-dark))',
}

// Sử dụng trong component
<div className="bg-betino-gold text-black">
```

### 11.2 Custom Animations
```css
/* Đã có sẵn trong index.css */
@keyframes marquee { /* ... */ }
@keyframes float { /* ... */ }
@keyframes spin { /* ... */ }

/* Sử dụng */
.animate-marquee
.floating-chat  
.spinner
```

## 12. Performance Considerations

### 12.1 Class Optimization
```tsx
// ✅ ĐÚNG - Sử dụng cn() để optimize
const buttonClass = cn(
  "base-button-classes",
  variant === 'primary' && "betino-gold",
  size === 'large' && "px-8 py-4"
);

// ✅ ĐÚNG - Conditional classes
<div className={cn(
  "card-base",
  isActive && "nav-item-active",
  isHovered && "card-hover"
)}>
```

### 12.2 Bundle Size Optimization
```tsx
// ✅ ĐÚNG - Import specific components
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

// ❌ SAI - Import toàn bộ
import * as UI from "@/components/ui";
```

## Kết Luận

Hệ thống thiết kế Betino được xây dựng để:
1. **Consistency** - Đảm bảo giao diện nhất quán
2. **Scalability** - Dễ mở rộng và maintain
3. **Performance** - Tối ưu bundle size
4. **Accessibility** - Hỗ trợ accessibility tốt
5. **Responsive** - Hoạt động tốt trên mọi device

AI nên tuân thủ nghiêm ngặt các pattern và utility classes đã định nghĩa để đảm bảo chất lượng và tính nhất quán của ứng dụng.
