# Changelog

Semua perubahan penting pada proyek ini akan didokumentasikan di file ini.

Format mengikuti [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), dan proyek ini mengikuti [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.1] — 2026-02-25

### 🔧 Perbaikan (Audit Pra-Rilis)

#### Bug Kritis
- **Fix bookmark terhapus** — `MaterialListScreen` sebelumnya memanggil `clearAndRepopulate()` setiap kali halaman dibuka, sehingga seluruh bookmark pengguna terhapus secara otomatis. Diganti dengan `populateAll()` yang hanya mengisi database jika masih kosong
- **Fix tahun rilis** — `AppInfo.releaseYear` dikoreksi dari `'2025'` menjadi `'2026'`

#### Pembersihan Kode
- Hapus semua `print()` statements dari kode produksi (19 lokasi di 5 file)
- Hapus `library;` bare yang tidak diperlukan dari 4 file
- Hapus unused import `material_list_screen.dart` di `home_screen.dart`
- Ganti `withOpacity()` yang deprecated dengan `withValues(alpha:)` di `disclaimer_dialog.dart`
- Hapus unnecessary string interpolation di `user_profile_view_screen.dart`
- Tambah curly braces pada semua `if` statement tanpa blok (13 lokasi di 5 file)
- Perbaiki dangling library doc comment di `app_info.dart` dan `populate_materials.dart`
- Perbaiki angle bracket di doc comment `tdd_data_loader.dart`

#### Navigasi
- Implementasi navigasi tombol "Baca Selengkapnya" di `DisclaimerDialog` ke `DisclaimerScreen`
- Daftarkan route `/disclaimer` di `main.dart`

---

## [1.0.0] — 2026-02-24

### 🎉 Initial Release

#### Ditambahkan
- **Materi Edukatif** — konten berbasis usia untuk kategori 0–1, 1–2, dan 2–5 tahun
  - Topik: Pertumbuhan, Perkembangan, Nutrisi & MP-ASI, Stimulasi, Perawatan, Imunisasi, Pencegahan, Permainan
  - Fitur pencarian dan bookmark artikel
- **Skrining KPSP** — Kuesioner Pra Skrining Perkembangan untuk 16 rentang usia (3–72 bulan)
- **Kalkulator Status Gizi** — menggunakan tabel LMS WHO untuk Z-Score BB/U, TB/U, BB/TB, dan IMT/U
- **Tes Daya Dengar (TDD)** — skrining pendengaran untuk 6 kelompok usia
- **M-CHAT-R** — skrining risiko autisme untuk anak 16–30 bulan (20 pertanyaan)
- **Profil Anak** — manajemen multiple profil dengan riwayat skrining
- **Pengingat Jadwal** — notifikasi lokal untuk jadwal skrining KPSP
- **Mode Offline Penuh** — seluruh fitur berjalan tanpa koneksi internet
- **UI Glassmorphism** — desain modern dengan tema teal/cream gradient

---

## [Unreleased]

### Direncanakan
- Dark mode
- Export hasil skrining ke PDF
- Fitur berbagi hasil
- Sinkronisasi cloud (opsional)
- Dukungan bahasa tambahan

---

*Dikembangkan oleh Noordiati, SST, MPH & Presley F Felly, S.I.Kom — Poltekkes Kemenkes Palangka Raya*