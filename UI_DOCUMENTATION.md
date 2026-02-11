# 🌙 MY BEST RAMADHAN APP - UI DOCUMENTATION

**Tanggal:** 11 Februari 2026  
**Status:** Tahap UI Development - Login Screen Done  
**Platform:** Flutter (iOS & Android)

---

## 📱 OVERVIEW PROJECT

**Nama:** My Best Ramadhan  
**Konsep:** Aplikasi untuk target ibadah dan baca Qur'an selama Ramadhan  
**Tagline:** "Jadikan Ramadhan Tahun ini Ramadhan terbaik mu!"

---

## 🎨 COLOR PALETTE

```dart
// File: lib/utils/colors.dart

Primary Colors:
- primaryGreen:  #32D74B  (Button, Accent, Logo)
- lightGreen:    #63E677  (Gradient, Hover)
- softGreenBg:   #E8F9EC  (Badge, Highlight)

Neutral Colors:
- white:         #FFFFFF  (Background)
- darkGrey:      #1A1A1A  (Text)
- grey:          #9E9E9E  (Subtitle)
- lightGrey:     #F5F5F5  (Input Background)

Gradient:
- primaryGreen → lightGreen (diagonal/vertical)
```

---

## 📐 DESIGN TOKENS

```dart
// File: lib/utils/constants.dart

Spacing:
- S = 8px    M = 16px    L = 24px    XL = 32px

Border Radius:
- S = 8px    M = 12px (default)    L = 16px    Circle = 999px

Font Sizes:
- S = 14px   M = 16px   L = 18px   XL = 24px   XXL = 32px

Button Height:
- Default = 54px

Logo Size:
- Default = 120px
```

---

## ✅ UI YANG SUDAH DIBUAT

### **1. SPLASH SCREEN** ✅
**File:** `lib/screens/splash_screen.dart`

**Design:**
- Background: Gradient hijau (vertical)
- Logo: Circle putih dengan icon buku, size 140px
- Text: "My Best Ramadhan" (32px, bold, white)
- Tagline: "Ramadhan Terbaik Dimulai Dari Sini" (16px, white)
- Loading indicator (white)
- Animasi: Fade in + Scale (1.5 detik)
- Auto redirect ke Login setelah 3 detik

---

### **2. LOGIN SCREEN** ✅
**File:** `lib/screens/auth/login_screen.dart`

**Design:**
```
┌─────────────────────┐
│   [LOGO Gradient]   │  ← 120x120, gradient circle + shadow
│   120x120 circle    │
│                     │
│  My Best Ramadhan   │  ← 28px, bold, darkGrey
│                     │
│ ┌─────────────────┐ │
│ │ Jadikan Ramadhan│ │  ← Badge soft green background
│ │ Tahun ini...    │ │
│ └─────────────────┘ │
│                     │
│ ┌─────────────────┐ │
│ │ 📧 Email        │ │  ← TextField, filled, radius 12px
│ └─────────────────┘ │
│                     │
│ ┌─────────────────┐ │
│ │ 🔒 Password  👁 │ │  ← Show/hide password toggle
│ └─────────────────┘ │
│                     │
│ ┌─────────────────┐ │
│ │     MASUK       │ │  ← Primary green button, 54px height
│ └─────────────────┘ │
│                     │
│ ───── atau ──────   │  ← Divider
│                     │
│ ┌─────────────────┐ │
│ │ G  Lanjutkan... │ │  ← Outline button dengan Google icon
│ └─────────────────┘ │
│                     │
│ Belum punya akun?   │
│    [Buat Akun]      │  ← Link hijau
│                     │
│  [Lupa Kata Sandi?] │  ← Link hijau
└─────────────────────┘
```

**Fitur:**
- ✅ Logo dengan gradient + shadow
- ✅ Tagline dalam badge soft green
- ✅ Input Email (validasi ada @)
- ✅ Input Password (show/hide, min 6 char)
- ✅ Button Login (loading state)
- ✅ Button Google Sign In
- ✅ Link Register & Forgot Password
- ✅ Responsive dengan scroll

**TextField Style:**
- Background: #F5F5F5
- Radius: 12px
- Border: None (normal), 2px hijau (focus)
- Icon kiri (email/lock)

**Button Style:**
- Primary: Solid green, white text, radius 12px
- Google: Outline grey, icon kiri, radius 12px

---

## 📂 STRUKTUR FILE UI

```
lib/
├── main.dart                      ✅ Entry point + Theme setup
├── screens/
│   ├── splash_screen.dart        ✅ Splash dengan animasi
│   └── auth/
│       └── login_screen.dart     ✅ Login lengkap
└── utils/
    ├── colors.dart               ✅ Color palette
    └── constants.dart            ✅ Spacing, radius, dll
```

---

## 🎯 UI YANG BELUM DIBUAT

### **Register Screen** ⏳
- Form: Nama, Email, Password, Confirm Password
- Button Register
- Link ke Login

### **Forgot Password Screen** ⏳
- Input Email
- Button Send Reset Link
- Link ke Login

### **Home Screen** ⏳
- Welcome card
- Progress tilawah (circular progress)
- Quick actions (3 card)
- Konten harian
- Bottom Navigation Bar

### **Qur'an Screen** ⏳
- List Surah (card dengan progress bar)
- Search bar
- Last read marker

### **Feed Screen** ⏳
- List artikel (card image + title)
- Categories filter

### **Profile Screen** ⏳
- Avatar + nama
- Stats (ayat dibaca, dll)
- Menu settings
- Button logout

---

## 📥 CARA AMBIL FILE UI

### **Copy File Ini:**

```bash
lib/
├── main.dart
├── screens/
│   ├── splash_screen.dart
│   └── auth/
│       └── login_screen.dart
└── utils/
    ├── colors.dart
    └── constants.dart

pubspec.yaml
```

### **Quick Setup:**

1. **Buat folder:**
```bash
mkdir -p lib/screens/auth
mkdir -p lib/utils
```

2. **Copy files ke folder masing-masing**

3. **Install dependencies:**
```bash
flutter pub get
```

4. **Run:**
```bash
flutter run
```

---

## 🎨 DESIGN GUIDELINES

### **Typography:**
- **Display:** 32px, Bold
- **Heading:** 24-28px, Bold
- **Subheading:** 18px, SemiBold
- **Body:** 14-16px, Regular
- **Button:** 16px, SemiBold
- **Caption:** 12px, Regular

### **Spacing Pattern:**
- Section: 24-32px
- Element: 16px
- Small: 8px

### **Shadow:**
```dart
// Logo/Card shadow
BoxShadow(
  color: primaryGreen.withOpacity(0.3),
  blurRadius: 20,
  offset: Offset(0, 10),
)
```

### **Border Radius:**
- Input/Button: 12px
- Card: 16px
- Badge/Chip: 20px
- Logo: Circle (999px)

---

## 💡 COMPONENT PATTERNS

### **TextField Standard:**
```dart
TextFormField(
  decoration: InputDecoration(
    labelText: 'Email',
    prefixIcon: Icon(Icons.email_outlined),
    filled: true,
    fillColor: Color(0xFFF5F5F5),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Color(0xFF32D74B), width: 2),
    ),
  ),
)
```

### **Primary Button:**
```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF32D74B),
    foregroundColor: Colors.white,
    minimumSize: Size(double.infinity, 54),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: Text('Button Text'),
)
```

### **Outline Button:**
```dart
OutlinedButton(
  onPressed: () {},
  style: OutlinedButton.styleFrom(
    minimumSize: Size(double.infinity, 54),
    side: BorderSide(color: Colors.grey[300]!, width: 1.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: Text('Button Text'),
)
```

---

## 📱 MOCKUP REFERENCE

### **Splash Screen:**
```
+------------------+
|                  |
| [GRADIENT GREEN] |
|                  |
|   [WHITE LOGO]   |
|    (circle)      |
|                  |
| My Best Ramadhan |
|                  |
|  Ramadhan Terbaik|
|  Dimulai Dari Sini|
|                  |
|   ● ● ● ●       |  Loading
|                  |
+------------------+
```

### **Login Screen:**
```
+------------------+
|  [GREEN LOGO]    |  Gradient circle
|                  |
| My Best Ramadhan |
|                  |
| [Tagline Badge]  |  Soft green bg
|                  |
| [Email Input]    |  Grey filled
|                  |
| [Password Input] |  With eye icon
|                  |
| [  MASUK  ]      |  Green button
|                  |
| ---- atau ----   |
|                  |
| [G  Google  ]    |  Outline button
|                  |
| Belum punya akun?|
|    Buat Akun     |  Links
|                  |
| Lupa Kata Sandi? |
+------------------+
```

---

## 🚀 NEXT UI TASKS

**Priority Order:**

1. **Register Screen** → Copy login screen, modif form
2. **Forgot Password** → Simple form, 1 input
3. **Home Dashboard** → Card-based layout
4. **Bottom Navigation** → 4 tabs (Home, Feed, Quran, Profile)
5. **Qur'an List** → ListView dengan card
6. **Feed List** → ListView dengan image card
7. **Profile Screen** → Header + menu list

---

## 🎯 DESIGN INSPIRATION

- **Style:** Clean, Modern, Minimalist
- **Vibe:** Calm, Spiritual, Friendly
- **Reference:** 
  - Instagram (clean cards)
  - Spotify (music app, card-based)
  - Apple Health (progress circles)

---

## 📞 QUICK REFERENCE

**Import Colors:**
```dart
import 'package:my_best_ramadhan_app/utils/colors.dart';

// Usage:
color: AppColors.primaryGreen
gradient: AppColors.primaryGradient
```

**Import Constants:**
```dart
import 'package:my_best_ramadhan_app/utils/constants.dart';

// Usage:
padding: EdgeInsets.all(AppConstants.spacingM)
borderRadius: BorderRadius.circular(AppConstants.radiusM)
```

---

**Last Updated:** 11 Feb 2026  
**Focus:** UI Development First, Backend Later  
**Status:** Login UI Complete ✅
