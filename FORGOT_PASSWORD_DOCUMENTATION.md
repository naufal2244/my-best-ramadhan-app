# 🔐 FORGOT PASSWORD FEATURE - DOCUMENTATION

**Tanggal:** 13 Februari 2026  
**Status:** ✅ Completed  
**Firebase:** Gratis (Spark Plan)

---

## 📋 OVERVIEW

Fitur Lupa Password memungkinkan user untuk reset password mereka melalui email. Firebase Authentication akan mengirim email dengan link reset password yang valid selama 1 jam.

---

## 🎨 DESIGN SCREENS

### **1. Forgot Password Screen**
Halaman pertama dimana user memasukkan email mereka.

**Layout:**
- Back button (kiri atas)
- Title: "Lupa Kata Sandi" (28px, bold)
- Subtitle: Instruksi singkat
- Email input field dengan icon
- Primary button: "Kirim Link Reset"
- Link: "Kembali ke Login"

**Warna:**
- Background: White (#FFFFFF)
- Title: Dark Grey (#1A1A1A)
- Subtitle: Grey (#9E9E9E)
- Input: Light Grey background (#F5F5F5)
- Button: Primary Green (#32D74B)
- Focus border: Primary Green (#32D74B)

---

### **2. Success Screen**
Halaman konfirmasi setelah email berhasil dikirim.

**Layout:**
- Success icon (circle dengan icon email, 120x120)
- Title: "Cek Email Anda!" (28px, bold)
- Subtitle: Menampilkan email yang digunakan
- Info card: Peringatan link kadaluarsa 1 jam
- Primary button: "Kembali ke Login"
- Text button: "Tidak menerima email? Kirim Ulang"

**Warna:**
- Icon background: Soft Green (#E8F9EC)
- Icon border: Primary Green (#32D74B)
- Icon: Primary Green (#32D74B)
- Info card background: Light Grey (#F5F5F5)

---

## 🔧 TECHNICAL IMPLEMENTATION

### **Files Created:**
```
lib/screens/auth/forgot_password_screen.dart
  ├── ForgotPasswordScreen (StatefulWidget)
  └── ForgotPasswordSuccessScreen (StatelessWidget)
```

### **Files Modified:**
```
lib/providers/auth_provider.dart
  └── Added: resetPassword(String email) method

lib/screens/auth/login_screen.dart
  └── Updated: "Lupa Kata Sandi?" button navigation
```

---

## 🚀 HOW IT WORKS

### **User Flow:**
1. User klik "Lupa Kata Sandi?" di Login Screen
2. User masuk ke Forgot Password Screen
3. User input email → klik "Kirim Link Reset"
4. App call Firebase: `sendPasswordResetEmail(email)`
5. Firebase kirim email ke user
6. User redirect ke Success Screen
7. User cek email → klik link reset password
8. User diarahkan ke halaman Firebase untuk set password baru
9. User kembali ke app → login dengan password baru

### **Firebase Backend:**
```dart
// Di AuthProvider
Future<void> resetPassword(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  } catch (e) {
    rethrow;
  }
}
```

### **Email Template:**
Firebase akan mengirim email dengan format:
- **Subject:** "Reset your password for My Best Ramadhan"
- **Body:** Link reset password + instruksi
- **Link:** Valid selama 1 jam
- **Sender:** noreply@[your-project-id].firebaseapp.com

---

## ✅ FEATURES IMPLEMENTED

- [x] Email validation (must contain @)
- [x] Loading state saat kirim email
- [x] Error handling dengan toast message
- [x] Success screen dengan email confirmation
- [x] Info card: link expiration warning
- [x] Back to login navigation
- [x] Resend email functionality
- [x] Responsive layout dengan scroll
- [x] Consistent dengan UI Documentation
- [x] Firebase Auth integration

---

## 🧪 TESTING GUIDE

### **Test Case 1: Valid Email**
1. Buka app → Login Screen
2. Klik "Lupa Kata Sandi?"
3. Input email yang terdaftar: `test@example.com`
4. Klik "Kirim Link Reset"
5. **Expected:** Success screen muncul
6. Cek inbox email
7. **Expected:** Email dari Firebase masuk (cek spam juga)

### **Test Case 2: Invalid Email**
1. Forgot Password Screen
2. Input email tanpa @: `testemail`
3. Klik "Kirim Link Reset"
4. **Expected:** Error "Email tidak valid"

### **Test Case 3: Empty Email**
1. Forgot Password Screen
2. Kosongkan email field
3. Klik "Kirim Link Reset"
4. **Expected:** Error "Email tidak boleh kosong"

### **Test Case 4: Email Not Registered**
1. Forgot Password Screen
2. Input email yang tidak terdaftar: `notexist@example.com`
3. Klik "Kirim Link Reset"
4. **Expected:** Firebase error toast (user not found)

### **Test Case 5: Resend Email**
1. Success Screen
2. Klik "Tidak menerima email? Kirim Ulang"
3. **Expected:** Kembali ke Forgot Password Screen
4. Input email lagi → kirim ulang

### **Test Case 6: Back Navigation**
1. Forgot Password Screen
2. Klik back button (kiri atas)
3. **Expected:** Kembali ke Login Screen
4. Success Screen → Klik "Kembali ke Login"
5. **Expected:** Kembali ke Login Screen

---

## 🔥 FIREBASE CONFIGURATION

### **Firebase Console Setup:**
1. Buka Firebase Console
2. Pilih project Anda
3. Authentication → Settings → Templates
4. Customize email template (optional):
   - Edit "Password reset" template
   - Ubah subject, body, dll
   - Save

### **Email Sender:**
Default sender: `noreply@[project-id].firebaseapp.com`

Untuk custom domain (perlu upgrade Blaze Plan):
- Setup custom email domain
- Verify domain ownership
- Update sender email

---

## 💡 BEST PRACTICES

### **Security:**
- ✅ Link reset hanya valid 1 jam
- ✅ Link hanya bisa digunakan 1x
- ✅ Email verification sebelum reset
- ✅ Firebase handle semua security

### **UX:**
- ✅ Clear error messages
- ✅ Loading indicator saat proses
- ✅ Success confirmation
- ✅ Easy navigation back to login
- ✅ Resend email option

### **Performance:**
- ✅ Async/await untuk Firebase calls
- ✅ Proper error handling
- ✅ Loading state management
- ✅ Form validation

---

## 🐛 COMMON ISSUES & SOLUTIONS

### **Issue 1: Email tidak masuk**
**Solution:**
- Cek folder spam
- Tunggu 1-2 menit (kadang delay)
- Pastikan email terdaftar di Firebase Auth
- Cek Firebase Console → Authentication → Users

### **Issue 2: Link kadaluarsa**
**Solution:**
- Kirim ulang email reset
- Link valid 1 jam dari waktu kirim

### **Issue 3: Error "user-not-found"**
**Solution:**
- Email belum terdaftar
- User harus register dulu
- Atau gunakan email yang benar

### **Issue 4: Error "too-many-requests"**
**Solution:**
- Firebase limit: max 5 request per jam per email
- Tunggu beberapa menit
- Atau gunakan email lain untuk testing

---

## 📱 SCREENSHOTS REFERENCE

### **Forgot Password Screen:**
```
+------------------+
| [←]              |
|                  |
| Lupa Kata Sandi  |
|                  |
| Silahkan masukkan|
| email Anda untuk |
| menerima link... |
|                  |
| Email Anda       |
| ┌──────────────┐ |
| │ 📧 Email     │ |
| └──────────────┘ |
|                  |
| ┌──────────────┐ |
| │ Kirim Link   │ |
| │    Reset     │ |
| └──────────────┘ |
|                  |
| [← Kembali Login]|
+------------------+
```

### **Success Screen:**
```
+------------------+
|                  |
|   [✓ Circle]     |
|    120x120       |
|                  |
| Cek Email Anda!  |
|                  |
| Kami telah kirim |
| link reset ke:   |
| user@email.com   |
|                  |
| [ℹ Info Card]    |
| Link kadaluarsa  |
| dalam 1 jam      |
|                  |
| ┌──────────────┐ |
| │ Kembali Login│ |
| └──────────────┘ |
|                  |
| Tidak terima?    |
| [Kirim Ulang]    |
+------------------+
```

---

## 🎯 NEXT IMPROVEMENTS (Optional)

### **Future Enhancements:**
- [ ] Custom email template dengan branding
- [ ] Rate limiting UI (disable button setelah 3x kirim)
- [ ] Email verification status indicator
- [ ] Deep linking untuk reset password in-app
- [ ] Multi-language support
- [ ] Analytics tracking (reset password events)

---

## 📞 QUICK REFERENCE

### **Navigation:**
```dart
// From Login to Forgot Password
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const ForgotPasswordScreen(),
  ),
);

// From Forgot Password to Success
Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => ForgotPasswordSuccessScreen(email: email),
  ),
);

// From Success back to Login
Navigator.of(context).popUntil((route) => route.isFirst);
```

### **Firebase Call:**
```dart
// Send reset email
await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
```

---

**Last Updated:** 13 Feb 2026  
**Status:** Production Ready ✅  
**Firebase Plan:** Spark (Free) ✅  
**Testing:** Passed ✅
