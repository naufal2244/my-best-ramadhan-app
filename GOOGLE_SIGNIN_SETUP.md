# 🔐 Google Sign-In Setup Guide - MyBest Ramadhan

## ✅ Yang Sudah Saya Kerjakan (Kode Flutter)

1. **Menambahkan Package:**
   - `google_sign_in: ^6.2.1` di `pubspec.yaml`
   - Sudah run `flutter pub get`

2. **Update AuthService (`lib/services/auth_service.dart`):**
   - Menambahkan method `signInWithGoogle()` yang:
     - Membuka dialog Google Sign-In
     - Mengautentikasi dengan Firebase
     - Membuat dokumen Firestore untuk user baru
     - Menangani pembatalan login oleh user

3. **Update AuthProvider (`lib/providers/auth_provider.dart`):**
   - Menambahkan method `signInWithGoogle()` untuk state management

4. **Update LoginScreen (`lib/screens/auth/login_screen.dart`):**
   - Mengimplementasikan fungsi `_handleGoogleLogin()` yang sebenarnya
   - Menambahkan error handling
   - Mengintegrasikan dengan flow notifikasi

---

## 📋 Yang Harus Kamu Lakukan di Firebase Console

### 1. Aktifkan Google Sign-In Provider

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Pilih project **my-best-ramadhan-app**
3. Di menu kiri, klik **Authentication**
4. Klik tab **Sign-in method**
5. Cari **Google** di daftar providers
6. Klik **Google**, lalu toggle **Enable**
7. Pilih **Project support email** (pilih email kamu)
8. Klik **Save**

### 2. Konfigurasi Android App

#### A. Download SHA-1 Certificate Fingerprint

Jalankan command ini di terminal (di folder project):

```bash
cd android
./gradlew signingReport
```

Cari bagian yang bertuliskan:
```
Variant: debug
Config: debug
Store: ~/.android/debug.keystore
Alias: AndroidDebugKey
MD5: XX:XX:XX:...
SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
SHA-256: XX:XX:XX:...
```

**Copy SHA-1 fingerprint** (yang panjang itu).

#### B. Tambahkan SHA-1 ke Firebase

1. Di Firebase Console, klik ikon **Settings** (roda gigi) → **Project settings**
2. Scroll ke bawah ke bagian **Your apps**
3. Klik aplikasi **Android** kamu
4. Scroll ke bagian **SHA certificate fingerprints**
5. Klik **Add fingerprint**
6. Paste SHA-1 yang tadi kamu copy
7. Klik **Save**

#### C. Download google-services.json Terbaru

1. Masih di halaman yang sama, scroll ke atas
2. Klik tombol **Download google-services.json**
3. **Replace** file lama di: `android/app/google-services.json`

### 3. Konfigurasi iOS App (Jika Deploy ke iOS)

#### A. Download GoogleService-Info.plist

1. Di Firebase Console → **Project settings**
2. Scroll ke **Your apps**
3. Klik aplikasi **iOS** kamu (atau tambahkan jika belum ada)
4. Download **GoogleService-Info.plist**
5. **Replace** file lama di: `ios/Runner/GoogleService-Info.plist`

#### B. Tambahkan URL Scheme

1. Buka file `ios/Runner/Info.plist`
2. Tambahkan kode berikut sebelum tag `</dict>` terakhir:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <!-- Ganti dengan REVERSED_CLIENT_ID dari GoogleService-Info.plist -->
            <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
        </array>
    </dict>
</array>
```

**Cara cari REVERSED_CLIENT_ID:**
- Buka file `GoogleService-Info.plist`
- Cari key `REVERSED_CLIENT_ID`
- Copy valuenya
- Paste di kode di atas (ganti `com.googleusercontent.apps.YOUR-CLIENT-ID`)

---

## 🧪 Testing

Setelah semua langkah di atas selesai:

1. **Restart aplikasi** (stop dan run ulang)
2. Di halaman Login, klik tombol **"Lanjutkan dengan Google"**
3. Pilih akun Google kamu
4. Aplikasi akan otomatis login dan redirect ke halaman utama

---

## ⚠️ Troubleshooting

### Error: "PlatformException(sign_in_failed)"
- **Penyebab:** SHA-1 fingerprint belum ditambahkan atau salah
- **Solusi:** Pastikan SHA-1 sudah ditambahkan di Firebase Console

### Error: "API not enabled"
- **Penyebab:** Google Sign-In API belum diaktifkan
- **Solusi:** 
  1. Buka [Google Cloud Console](https://console.cloud.google.com/)
  2. Pilih project yang sama dengan Firebase
  3. Cari "Google Sign-In API"
  4. Klik **Enable**

### User bisa login tapi data tidak tersimpan
- **Penyebab:** Firestore rules mungkin terlalu ketat
- **Solusi:** Pastikan Firestore rules mengizinkan write untuk authenticated users

---

## 📝 Catatan Penting

1. **SHA-1 untuk Production:**
   - Saat mau release APK production, kamu harus generate SHA-1 dari keystore production
   - Tambahkan juga SHA-1 production ke Firebase Console

2. **Email Verification:**
   - Google Sign-In otomatis memverifikasi email
   - User tidak perlu verifikasi email lagi

3. **Logout:**
   - Saya sudah update fungsi logout untuk sign out dari Google juga
   - User tidak akan auto-login lagi setelah logout

---

**Status:** ✅ Kode Flutter sudah siap  
**Next Step:** Konfigurasi Firebase Console (ikuti panduan di atas)  
**Estimated Time:** 10-15 menit
