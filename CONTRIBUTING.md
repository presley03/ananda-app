# Panduan Kontribusi — Ananda App

Terima kasih atas minat Anda untuk berkontribusi pada **Ananda**! Dokumen ini menjelaskan cara terlibat dalam pengembangan aplikasi ini.

---

## 📋 Prasyarat

Sebelum mulai, pastikan Anda memiliki:

- Flutter SDK 3.7.0+
- Android Studio atau VS Code dengan ekstensi Flutter/Dart
- Git
- Pemahaman dasar tentang Flutter & Dart

---

## 🚀 Setup Lingkungan Pengembangan

```bash
# 1. Fork repositori ini ke akun GitHub Anda

# 2. Clone fork Anda
git clone https://github.com/YOUR_USERNAME/ananda_app.git
cd ananda_app

# 3. Tambahkan upstream remote
git remote add upstream https://github.com/ORIGINAL_REPO/ananda_app.git

# 4. Install dependencies
flutter pub get

# 5. Jalankan aplikasi untuk memastikan semuanya berjalan
flutter run
```

---

## 🌿 Alur Kerja Git

Kami menggunakan **Git Flow** sederhana:

| Branch | Tujuan |
|---|---|
| `main` | Kode produksi stabil |
| `develop` | Branch integrasi pengembangan |
| `feature/nama-fitur` | Fitur baru |
| `fix/nama-bug` | Perbaikan bug |
| `docs/nama-perubahan` | Perubahan dokumentasi |

### Langkah-langkah

```bash
# 1. Sinkronisasi dengan upstream
git fetch upstream
git checkout develop
git merge upstream/develop

# 2. Buat branch baru
git checkout -b feature/nama-fitur-anda

# 3. Kerjakan perubahan Anda

# 4. Commit dengan pesan yang jelas
git commit -m "feat: tambahkan fitur X untuk kebutuhan Y"

# 5. Push ke fork Anda
git push origin feature/nama-fitur-anda

# 6. Buat Pull Request ke branch develop
```

---

## 📝 Konvensi Commit

Gunakan format **Conventional Commits**:

```
<type>: <deskripsi singkat>

[body opsional]
```

| Type | Kapan Digunakan |
|---|---|
| `feat` | Menambahkan fitur baru |
| `fix` | Memperbaiki bug |
| `docs` | Perubahan dokumentasi |
| `style` | Perubahan formatting (bukan logika) |
| `refactor` | Refactoring kode |
| `test` | Menambah atau memperbaiki tes |
| `chore` | Pemeliharaan & konfigurasi |

**Contoh:**
```
feat: tambahkan filter usia pada layar materi
fix: perbaiki crash saat membuka profil tanpa foto
docs: perbarui panduan instalasi di README
```

---

## 🎨 Standar Kode

### Dart / Flutter
- Ikuti [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style) resmi
- Gunakan `flutter analyze` sebelum commit — pastikan tidak ada warning
- Setiap file harus memiliki header komentar:

```dart
/// File: nama_file.dart
/// Path: lib/path/to/nama_file.dart
/// Description: Deskripsi singkat fungsi file ini
```

### Desain & UI
- Gunakan konstanta dari `AppColors` (`lib/utils/constants/colors.dart`) — **jangan hardcode warna**
- Gunakan konstanta dari `AppInfo` (`lib/utils/constants/app_info.dart`) untuk metadata
- Ikuti pola desain glassmorphism yang sudah ada
- Pastikan UI responsif untuk berbagai ukuran layar Android

### Database
- Setiap perubahan skema harus memperbarui `databaseVersion` di `AppInfo`
- Selalu perbarui `_onCreate` **dan** `_onUpgrade` secara konsisten
- Tambahkan entri di `CHANGELOG.md` untuk setiap perubahan skema

---

## 🧪 Testing

Sebelum membuat Pull Request:

```bash
# Analisis kode
flutter analyze

# Jalankan semua tes
flutter test

# Build debug untuk memastikan tidak ada error kompilasi
flutter build apk --debug
```

---

## 📥 Pull Request

### Checklist PR
Pastikan PR Anda memenuhi semua poin berikut:

- [ ] Kode sudah diuji di emulator/perangkat nyata
- [ ] `flutter analyze` tidak menampilkan error atau warning baru
- [ ] Dokumentasi diperbarui jika diperlukan
- [ ] `CHANGELOG.md` diperbarui
- [ ] Judul PR mengikuti konvensi commit

### Template Deskripsi PR

```markdown
## Ringkasan
[Deskripsi singkat perubahan yang dilakukan]

## Jenis Perubahan
- [ ] Bug fix
- [ ] Fitur baru
- [ ] Perubahan breaking (mempengaruhi fitur yang ada)
- [ ] Pembaruan dokumentasi

## Cara Menguji
[Langkah-langkah untuk menguji perubahan ini]

## Screenshot (jika ada perubahan UI)
```

---

## 🐛 Melaporkan Bug

Gunakan **GitHub Issues** dengan label `bug`. Sertakan informasi berikut:

- Versi aplikasi
- Versi Android & tipe perangkat
- Langkah-langkah untuk mereproduksi
- Perilaku yang diharapkan vs yang terjadi
- Screenshot atau log error (jika ada)

---

## 💡 Mengusulkan Fitur

Gunakan **GitHub Issues** dengan label `enhancement`. Jelaskan:

- Masalah yang ingin diselesaikan
- Solusi yang Anda usulkan
- Alternatif yang sudah dipertimbangkan

---

## 📬 Kontak

Untuk pertanyaan yang tidak cocok menjadi Issue:

- **Email:** support@example.com
- **Institusi:** Poltekkes Kemenkes Palangka Raya

---

*Terima kasih telah membantu membuat Ananda lebih baik untuk anak-anak Indonesia! 🌱*
