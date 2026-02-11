# ⚙️ MY BEST RAMADHAN APP - BACKEND DOCUMENTATION

**Tanggal:** 11 Februari 2026  
**Status:** Tahap Logic & Backend Integration - Auth Done  
**Tech Stack:** Flutter, Firebase (Auth, Firestore), Provider

---

## 🏗️ ARCHITECTURE: Service-Provider-Model

Aplikasi ini menggunakan pola **Service-Provider-Model** untuk memisahkan logic bisnis, akses data, dan UI agar kode tetap rapi dan mudah di-maintain.

### 1. **Models** (`lib/models/`)
- **Fungsi:** Representasi data (Data Classes).
- **Isi:** Properti objek + logic JSON serialization (Map to Object).
- **Contoh:** `user_model.dart`, `habit_model.dart`.
- **Rules:** Jangan ada logic API atau UI di sini.

### 2. **Services** (`lib/services/`)
- **Fungsi:** Komunikasi dengan dunia luar (Firebase, API, Local DB).
- **Isi:** CRUD operations, Firebase Auth calls, Firestore triggers.
- **Contoh:** `auth_service.dart`, `firestore_service.dart`.
- **Rules:** "Dumb" services. Hanya return data/error, tidak mengurus state UI.

### 3. **Providers** (`lib/providers/`)
- **Fungsi:** State Management (Penyimpan data sementara aplikasi).
- **Isi:** Memanggil `Services`, menyimpan hasilnya, dan menjalankan `notifyListeners()`.
- **Contoh:** `auth_provider.dart`, `habit_provider.dart`.
- **Rules:** UI hanya boleh akses data melalui Provider, bukan langsung ke Service.

---

## 📂 FOLDER STRUCTURE

```
lib/
├── models/         ← Data classes & Serialization
├── services/       ← Firebase/Direct API interaction
├── providers/      ← State Management (Provider Package)
├── screens/        ← UI Pages (Divided by features)
├── widgets/        ← Reusable UI Components
└── utils/          ← Helpers, Colors, Constants
```

---

## 🔐 AUTHENTICATION STRATEGY

- **Provider:** `AuthProvider`
- **Method:** Email & Password (Firebase Auth).
- **Sync:** Data user disimpan di Firestore collection `users` untuk menyimpan metadata tambahan (nama, target khatam, foto).
- **Flow:**
  1. User tap Login/Register.
  2. UI memanggil `AuthProvider.login()` atau `register()`.
  3. `AuthProvider` memanggil `AuthService`.
  4. Jika sukses, `AuthStateChanges` otomatis update status di UI.

---

## 📰 CONTENT FEED STRATEGY (Anti-Scraping)

Untuk fitur Feed/Content agar tetap cepat dan tidak berat di sisi klien, kita menggunakan strategi **Metadata Cache**:

### **The Problem:**
Membaca website/sumber asli setiap kali Feed dibuka akan sangat lambat (latency) dan bisa diblokir oleh provider konten.

### **The Strategy:**
1. **Metadata-First:** Jangan simpan seluruh isi artikel. Simpan metadata saja di Firestore:
   - `id`, `title`, `thumbnailUrl`, `sourceUrl`, `category`, `publishedAt`.
2. **Pre-fetching:**
   - Kita (admin/bot) memasukkan metadata ke Firestore secara berkala.
   - App hanya baca list dari Firestore (sangat cepat).
3. **Lazy Loading:**
   - Saat user klik, barulah `WebView` atau `url_launcher` membuka konten aslinya.
4. **Offline Support:**
   - Gunakan `Firestore Offline persistence` agar feed tetap muncul walaupun sinyal jelek.

---

## 🗓️ DATA SYNC & FIRESTORE PATHS

| Collection | Path | Description |
|------------|------|-------------|
| **Users** | `/users/{uid}` | Profil user, email, target khatam |
| **Habits** | `/users/{uid}/habits/{date}` | Tracking ibadah harian |
| **Feeds** | `/feeds/{articleId}` | Metadata artikel/tips Ramadhan |

---

## 💰 COST & PLAN MANAGEMENT (Firebase Spark Plan)

Aplikasi ini didesain untuk berjalan sepenuhnya di atas **Firebase Spark Plan (Gratis)** dengan strategi optimasi berikut:

1. **Firestore Usage Optimization:**
   - Menggunakan model data yang ramping untuk menjaga kuota *Stored Data* (5GB).
   - Strategi Metadata Feed menjaga agar jumlah *Read Operations* tetap minimal.
2. **Authentication:**
   - Email/Password auth tidak memiliki limit biaya di Firebase (selama tidak menggunakan Identity Platform fitur advanced).
3. **No Cloud Functions (Initially):**
   - Menghindari penggunaan Cloud Functions (yang butuh billing/Blaze Plan). Semua logic ditaruh di sisi Client (App) atau manual entry untuk awal.

---

## 🛠️ DEVELOPER GUIDES

### **Menambah Fitur Baru (Backend):**
1. Buat **Model** di `lib/models/`.
2. Buat **Service** untuk handle Firebase di `lib/services/`.
3. Buat **Provider** di `lib/providers/`.
4. Daftarkan **Provider** di `main.dart` (di dalam `MultiProvider`).
5. Konekkan ke UI menggunakan `context.watch<T>()` atau `context.read<T>()`.

### **Best Practice Tools:**
- **Serialization:** Gunakan `factory fromMap`.
- **Error Handling:** Selalu gunakan `try-catch` di Service & Provider, lempar error ke UI via `rethrow`.
- **UI Interaction:** Gunakan `isLoading` boolean di Provider untuk menampilkan loading spinner di button.

---

**Last Updated:** 11 Feb 2026  
**Focus:** Service-Provider-Model Architecture ✅  
**Status:** Auth Integrated, Next: Habit Tracking Implementation ⏳
