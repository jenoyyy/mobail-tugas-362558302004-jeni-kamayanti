# Starter Template & Laporan Praktikum Pemrograman Mobile

### Program Studi Sarjana Terapan Teknologi Rekayasa Perangkat Lunak (TRPL)

**Politeknik Negeri Banyuwangi — Semester Ganjil 2026**

Panduan interaktif lengkap: [Portal Codelabs TRPL Poliwangi](https://codelabs-poliwangi.github.io/MobileDev-Codelabs/)

---

## 1. Identitas Mahasiswa

> [!IMPORTANT]
>
> **Wajib Mengganti Data di Bawah Ini!**
>
> Autograding CI/CD akan memeriksa apakah nilai *placeholder* di bawah ini telah diganti dengan Nama dan NIM Anda yang sebenarnya. Jika belum diganti, pengujian `verify_documentation_test.dart` akan gagal.

| Informasi | Data Mahasiswa |
|---|---|
| **Nama Lengkap** | Jeni kamayanti |
| **NIM** | 362558302004 |
| **Kelas / Angkatan** | TRPL 2E / 2025 |
| **Dosen Pengampu** | Sepyan Purnama Kristanto, M.Kom. |

---

## 2. Peta Kemajuan Modul Praktikum

Aplikasi ini menggunakan **Sistem Kontrol Akses Modul Terpusat (Smart Gating)** di file `lib/main.dart` agar mahasiswa belajar selaras dengan ritme materi dosen di kelas:

| Modul | Topik & Arsitektur | Status Akses | Perintah Self-Test Lokal | Bobot CI |
|:---:|---|:---:|---|:---:|
| **#01** | Mobile Ecosystem, Toolchain & Profile App | `⚡ Aktif` | `flutter test test/modul_01_test.dart` | 20 Pts |
| **#02** | Declarative UI, BoxConstraints & Responsive Dashboard | `🔒 Terkunci (W02)` | `flutter test test/modul_02_test.dart` | 20 Pts |
| **#03** | Navigation (GoRouter), Riverpod & 4-State KRS App | `🔒 Terkunci (W03)` | `flutter test test/modul_03_test.dart` | 20 Pts |
| **#04** | Networking, REST API Dio & Repository Pattern | `🔒 Terkunci (W04)` | `flutter test test/modul_04_test.dart` | 15 Pts |
| **Dok** | Verifikasi Identitas Asli Mahasiswa di README | `Wajib` | `flutter test test/verify_documentation_test.dart` | 10 Pts |
| **Lint** | Dart Code Formatting & Static Analysis | `Wajib` | `flutter analyze --no-fatal-infos` | 15 Pts |
| **Total** | **Skor Maksimal Evaluasi Autograding** | — | `flutter test` | **100 Pts** |

> [!NOTE]
>
> **Membuka Modul Terkunci saat di Laboratorium:**
>
> Jika Anda sedang berada di sesi perkuliahan laboratorium dan dosen mengumumkan pembukaan modul, klik kartu modul yang terkunci di aplikasi lalu masukkan **Token Akses Kelas** yang dibagikan oleh dosen (misal: `TRPL-M02`, `TRPL-M03`, `TRPL-M04`, atau master passcode `POLIWANGI2026`).

---

## 3. Panduan Menjalankan & Menguji Kode

### A. Persiapan Lingkungan (Setup)

```bash
# 1. Unduh seluruh dependensi paket Flutter
flutter pub get

# 2. Jalankan aplikasi pada emulator atau perangkat fisik Android/iOS/Web
flutter run