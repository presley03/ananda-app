# Kebijakan Privasi — Ananda

**Terakhir diperbarui:** 24 Februari 2026  
**Berlaku sejak:** 24 Februari 2026

---

## 1. Pendahuluan

Selamat datang di **Ananda** ("Aplikasi", "kami"). Aplikasi ini dikembangkan oleh **Poltekkes Kemenkes Palangka Raya** sebagai alat bantu pemantauan tumbuh kembang anak.

Kebijakan Privasi ini menjelaskan bagaimana Aplikasi menangani informasi Anda. Dengan menggunakan Aplikasi, Anda menyetujui ketentuan yang tercantum dalam dokumen ini.

---

## 2. Informasi yang Dikumpulkan

### 2.1 Informasi yang Anda Berikan

Aplikasi mengumpulkan data berikut yang Anda masukkan secara langsung:

- **Data Profil Anak** — nama, tanggal lahir, jenis kelamin, foto (opsional)
- **Data Pengukuran** — berat badan, tinggi badan, lingkar kepala
- **Hasil Skrining** — jawaban dan hasil dari KPSP, TDD, M-CHAT-R
- **Preferensi Pengguna** — pengaturan notifikasi dan preferensi tampilan

### 2.2 Informasi yang TIDAK Dikumpulkan

Aplikasi **tidak mengumpulkan** informasi berikut:

- ❌ Nama, identitas, atau data pribadi orang tua/wali
- ❌ Lokasi perangkat (GPS)
- ❌ Data penggunaan aplikasi atau analytics
- ❌ Informasi perangkat (IMEI, nomor seri, dll.)
- ❌ Data dari aplikasi lain di perangkat Anda

---

## 3. Penyimpanan Data

### 3.1 Penyimpanan Lokal

**Semua data disimpan secara lokal di perangkat Anda.** Aplikasi menggunakan database SQLite yang tersimpan di penyimpanan internal perangkat. Data ini:

- **Tidak pernah dikirim ke server eksternal**
- **Tidak disinkronisasi ke cloud**
- **Tidak dapat diakses oleh pihak ketiga**
- Hanya dapat diakses melalui Aplikasi di perangkat yang sama

### 3.2 Keamanan Data

Keamanan data Anda bergantung pada keamanan perangkat Anda sendiri. Kami menyarankan:

- Menggunakan PIN/password/biometrik pada perangkat
- Tidak memberikan akses perangkat kepada orang yang tidak berwenang
- Melakukan backup perangkat secara berkala

---

## 4. Penggunaan Data

Data yang tersimpan di Aplikasi digunakan **semata-mata** untuk:

- Menampilkan profil dan riwayat skrining anak
- Menghitung hasil skrining dan status gizi
- Menampilkan pengingat jadwal skrining

Data tidak digunakan untuk tujuan periklanan, penelitian pihak ketiga, atau tujuan komersial apapun.

---

## 5. Berbagi Data

Kami **tidak membagikan, menjual, menyewakan, atau mentransfer** data Anda kepada pihak ketiga dalam kondisi apapun.

Aplikasi ini beroperasi sepenuhnya **offline** dan tidak memiliki kemampuan untuk mentransmisikan data ke luar perangkat.

---

## 6. Izin Aplikasi

Aplikasi memerlukan izin berikut:

| Izin | Tujuan |
|---|---|
| `RECEIVE_BOOT_COMPLETED` | Memulihkan pengingat jadwal setelah perangkat restart |
| `POST_NOTIFICATIONS` | Menampilkan notifikasi pengingat skrining |
| `READ_MEDIA_IMAGES` / `READ_EXTERNAL_STORAGE` | Memilih foto profil anak (opsional) |
| `SCHEDULE_EXACT_ALARM` | Menjadwalkan pengingat pada waktu yang tepat |
| `VIBRATE` | Getaran untuk notifikasi |

Aplikasi **tidak** memerlukan izin: kamera, lokasi, kontak, mikrofon, atau akses internet.

---

## 7. Data Anak

Kami memahami sensitivitas data yang berkaitan dengan anak-anak. Oleh karena itu:

- Aplikasi tidak mensyaratkan data identitas orang tua
- Data anak (nama, tanggal lahir) disimpan hanya di perangkat lokal
- Orang tua/wali memiliki kendali penuh atas data yang dimasukkan
- Data dapat dihapus kapan saja melalui fitur "Hapus Profil" di Aplikasi

---

## 8. Hak Pengguna

Sebagai pengguna, Anda memiliki hak penuh untuk:

- **Mengakses** semua data yang tersimpan melalui antarmuka Aplikasi
- **Mengubah** data kapan saja melalui fitur edit profil
- **Menghapus** sebagian atau seluruh data melalui Aplikasi
- **Menghapus** semua data dengan menghapus instalan (uninstall) Aplikasi

> ⚠️ **Perhatian:** Menghapus instalan Aplikasi akan menghapus semua data secara permanen. Pastikan Anda telah mencatat informasi penting sebelum melakukan uninstall.

---

## 9. Perubahan Kebijakan Privasi

Kami dapat memperbarui Kebijakan Privasi ini dari waktu ke waktu. Perubahan akan diinformasikan melalui:

- Pembaruan dokumen ini di repositori resmi
- Notifikasi dalam Aplikasi pada versi berikutnya

Penggunaan Aplikasi setelah pembaruan dianggap sebagai persetujuan terhadap perubahan tersebut.

---

## 10. Kontak

Jika Anda memiliki pertanyaan atau kekhawatiran mengenai Kebijakan Privasi ini, hubungi kami:

**Poltekkes Kemenkes Palangka Raya**  
Email: support@example.com  
Website: https://example.com

---

## 11. Disclaimer Medis

Ananda adalah **alat bantu skrining**, bukan alat diagnosis medis. Hasil yang ditampilkan bersifat informatif dan tidak dapat menggantikan penilaian tenaga kesehatan yang berkualifikasi. Selalu konsultasikan hasil skrining dengan dokter anak atau tenaga kesehatan terpercaya.

---

*© 2026 Poltekkes Kemenkes Palangka Raya. Semua hak dilindungi.*
