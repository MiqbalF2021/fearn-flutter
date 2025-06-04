# Dokumentasi Proyek Flutter: Aplikasi List Lokasi

Selamat datang di proyek aplikasi Flutter sederhana! Aplikasi ini memiliki 4 halaman utama:
1. **Login**: Halaman untuk masuk ke aplikasi.
2. **List Lokasi**: Menampilkan daftar lokasi yang diambil dari API.
3. **Urutan Koordinat Lokasi**: Menampilkan urutan koordinat dari lokasi tertentu.
4. **Geofence Lokasi**: Menampilkan informasi geofence dari lokasi.

Panduan ini akan membantu kamu menginstall dan menjalankan proyek ini di komputer lokalmu. Ikuti langkah-langkahnya dengan cermat, ya!

## Prasyarat
Sebelum memulai, pastikan kamu sudah memiliki:
1. **Flutter SDK** terinstall di komputermu (versi stabil terbaru dianjurkan).
2. **Dart SDK** (sudah termasuk saat install Flutter).
3. **Android Studio** atau **Visual Studio Code** sebagai editor kode.
4. **Emulator Android** atau **perangkat fisik Android** untuk menjalankan aplikasi.
5. **Git** untuk mengunduh proyek dari GitHub.
6. Koneksi internet untuk mengunduh dependensi.

Jika belum punya, ikuti panduan resmi Flutter untuk instalasi: [Install Flutter](https://flutter.dev/docs/get-started/install).

## Langkah-Langkah Instalasi

### 1. Clone Proyek dari GitHub
- Buka terminal (Command Prompt, PowerShell, atau Terminal di VS Code).
- Ketik perintah berikut untuk mengunduh proyek:
  ```bash
  git clone https://github.com/MiqbalF2021/fearn-flutter
  ```
- Masuk ke folder proyek:
  ```bash
  cd <NAMA_FOLDER_PROYEK>
  ```

### 2. Install Dependensi
- Pastikan kamu berada di folder proyek.
- Ketik perintah berikut untuk mengunduh semua package yang dibutuhkan:
  ```bash
  flutter pub get
  ```


### 3. Jalankan Aplikasi
- Hubungkan perangkat Android (atau jalankan emulator di Android Studio).
- Pastikan perangkat/emulator terdeteksi dengan perintah:
  ```bash
  flutter devices
  ```
- Jalankan aplikasi dengan perintah:
  ```bash
  flutter run
  ```
- Tunggu hingga aplikasi terbuka di perangkat/emulatormu.
