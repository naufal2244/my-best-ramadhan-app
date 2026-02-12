# Notification Priming Screen - Dokumentasi

## Overview
Telah ditambahkan layar **Notification Priming** (Soft Push) pada onboarding flow aplikasi My Best Ramadhan. Layar ini muncul sebagai halaman ke-4 dalam onboarding, setelah layar Tips.

## Tujuan
Memberikan konteks kepada pengguna dalam Bahasa Indonesia tentang manfaat mengizinkan notifikasi **SEBELUM** dialog sistem muncul. Ini meningkatkan kemungkinan pengguna memberikan izin notifikasi.

## Fitur Utama

### 1. **Animasi Menarik**
- Icon bell dengan animasi rotasi yang smooth
- Fade-in dan slide-up animation saat layar muncul
- Gradient hijau yang konsisten dengan brand aplikasi

### 2. **Mockup Dialog Sistem**
- Menampilkan preview dialog "Allow notifications" 
- Arrow indicator yang menunjuk ke tombol "Allow"
- Membantu pengguna memahami apa yang akan muncul selanjutnya

### 3. **Manfaat yang Jelas**
Menampilkan 3 manfaat utama:
- 📖 Ayat Al-Qur'an harian
- 🌙 Hadits pilihan setiap hari
- ⏰ Pengingat ibadah tepat waktu

### 4. **Dua Pilihan Aksi**
- **"Ya, Saya Mau"** (Primary button): Memicu dialog sistem untuk izin notifikasi
- **"Nanti Saja"** (Text button): Melewati dan langsung ke MainScreen

## Alur Kerja

```
Onboarding Flow:
1. Welcome Screen
2. Target Setting Screen
3. Tips Screen
4. Notification Priming Screen ← BARU!
   ├─ User klik "Ya, Saya Mau"
   │  ├─ Panggil NotificationService().requestPermissions()
   │  └─ Dialog sistem muncul (iOS/Android native)
   │     ├─ User klik "Allow" → Notifikasi aktif ✅
   │     └─ User klik "Don't Allow" → Notifikasi tidak aktif ❌
   └─ User klik "Nanti Saja"
      └─ Langsung ke MainScreen (skip permission)
```

## Perubahan Kode

### File: `lib/screens/onboarding_flow.dart`

#### 1. Import NotificationService
```dart
import '../services/notification_service.dart';
```

#### 2. Update Total Pages
```dart
final int _totalPages = 4; // Dari 3 menjadi 4
```

#### 3. Tambah Widget ke PageView
```dart
_NotificationPrimingScreen(onNext: _nextPage),
```

#### 4. Widget Baru: `_NotificationPrimingScreen`
- Stateful widget dengan AnimationController
- Method `_handleEnableNotifications()` untuk request permission
- UI yang premium dengan mockup dialog sistem

## Catatan Penting

### Tentang Dialog Sistem
❗ **Tombol "Allow/Don't Allow" tidak bisa diubah ke Bahasa Indonesia** karena dikontrol oleh sistem operasi (iOS/Android). Tombol tersebut akan mengikuti bahasa perangkat pengguna.

### Solusi yang Diterapkan
✅ Kita membuat layar custom dalam Bahasa Indonesia yang muncul **SEBELUM** dialog sistem. Ini memberikan konteks yang jelas kepada pengguna tentang mengapa mereka harus mengizinkan notifikasi.

## Best Practices yang Diikuti

1. **Permission Priming**: Memberikan konteks sebelum meminta izin
2. **Clear Value Proposition**: Menjelaskan manfaat dengan jelas
3. **Visual Preview**: Menampilkan mockup dialog yang akan muncul
4. **Soft Decline**: Memberikan opsi "Nanti Saja" tanpa pressure
5. **Consistent Design**: Menggunakan warna dan style yang konsisten dengan aplikasi

## Testing Checklist

- [ ] Layar muncul setelah Tips Screen
- [ ] Animasi berjalan dengan smooth
- [ ] Tombol "Ya, Saya Mau" memicu dialog sistem
- [ ] Tombol "Nanti Saja" skip ke MainScreen
- [ ] Page indicator menampilkan 4 dots
- [ ] Skip button tidak muncul di halaman terakhir
- [ ] Setelah allow/deny, navigasi ke MainScreen berjalan normal

## Referensi
- UX Pattern: [Permission Priming Best Practices](https://www.nngroup.com/articles/permission-requests/)
- Design inspired by: User's reference image (Gambar 1)
