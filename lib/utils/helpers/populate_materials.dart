/// File: populate_materials.dart
/// Path: lib/utils/helpers/populate_materials.dart
/// Description: Helper untuk populate materials database dengan data
/// 
/// Compatible dengan DatabaseService yang ada
/// Data format: Map<String, dynamic> untuk direct insertion
/// 
/// TODO: Replace with actual content from Word docs:
/// - Materi_0_1_Tahun.docx
/// - Materi_1_2_Tahun.docx  
/// - Materi_2_5_Tahun.docx

import '../../services/database_service.dart';

class PopulateMaterials {
  final DatabaseService _dbService = DatabaseService();

  /// Populate database dengan materials data
  /// Auto-check if already populated
  Future<void> populateAll() async {
    print('🔄 Starting materials population...');
    
    // Check if already populated using getDatabaseStats
    final stats = await _dbService.getDatabaseStats();
    final count = stats['materials'] ?? 0;
    
    if (count > 0) {
      print('⚠️ Database already has $count materials. Skipping population.');
      print('   Call clearAndRepopulate() to force repopulation.');
      return;
    }
    
    // Insert all materials using bulk insert
    await _dbService.insertMaterialsBulk(_allMaterialsData);
    
    final newStats = await _dbService.getDatabaseStats();
    final newCount = newStats['materials'] ?? 0;
    print('✅ Population complete! Total materials: $newCount');
  }

  /// Clear existing data and repopulate
  Future<void> clearAndRepopulate() async {
    print('🔄 Clearing existing materials...');
    
    // Delete all bookmarks first (foreign key constraint)
    final db = await _dbService.database;
    await db.delete('bookmarks');
    await db.delete('materials');
    
    print('🔄 Populating fresh materials...');
    
    // Insert all materials
    await _dbService.insertMaterialsBulk(_allMaterialsData);
    
    final stats = await _dbService.getDatabaseStats();
    final count = stats['materials'] ?? 0;
    print('✅ Repopulation complete! Total materials: $count');
  }

  /// All materials data in Map format (ready for database)
  /// 20+ comprehensive materials covering all categories & subcategories
  static final List<Map<String, dynamic>> _allMaterialsData = [
    // ========================================
    // KATEGORI: 0-1 TAHUN (6 materials)
    // ========================================
    
    // PERTUMBUHAN
    {
      'category': '0-1',
      'subcategory': 'Pertumbuhan',
      'title': 'Berat Badan Ideal Bayi 0-6 Bulan',
      'content': '''Berat badan bayi yang ideal adalah salah satu indikator kesehatan yang penting. Pada usia 0-6 bulan, bayi idealnya mengalami penambahan berat badan sekitar 150-200 gram per minggu. 

Pertumbuhan berat badan yang optimal menunjukkan bahwa bayi mendapatkan nutrisi yang cukup dari ASI atau susu formula. Faktor yang mempengaruhi berat badan bayi antara lain: kualitas dan kuantitas ASI, frekuensi menyusui, kesehatan bayi, dan faktor genetik dari orang tua.

Pantau pertumbuhan bayi secara rutin dengan menimbang berat badan setiap bulan di posyandu atau fasilitas kesehatan terdekat. Gunakan Kartu Menuju Sehat (KMS) untuk tracking pertumbuhan.''',
      'tags': 'berat badan, pertumbuhan, bayi, 0-6 bulan, ideal, KMS',
    },
    
    {
      'category': '0-1',
      'subcategory': 'Pertumbuhan',
      'title': 'Tinggi Badan Bayi 6-12 Bulan',
      'content': '''Pertumbuhan tinggi badan bayi pada usia 6-12 bulan melambat dibanding semester pertama, namun tetap konsisten. Rata-rata penambahan tinggi badan sekitar 1-1.5 cm per bulan.

Tinggi badan dipengaruhi oleh faktor genetik (tinggi orang tua), nutrisi yang adekuat, dan kondisi kesehatan umum. Pantau dengan mengukur panjang badan saat bayi berbaring (recumbent length) di fasilitas kesehatan.

Jika pertumbuhan tinggi badan terlalu lambat atau terlalu cepat, konsultasikan dengan dokter anak untuk evaluasi lebih lanjut.''',
      'tags': 'tinggi badan, pertumbuhan, bayi, 6-12 bulan, panjang badan',
    },
    
    // PERKEMBANGAN
    {
      'category': '0-1',
      'subcategory': 'Perkembangan',
      'title': 'Milestone Perkembangan Bayi 3 Bulan',
      'content': '''Pada usia 3 bulan, bayi mulai menunjukkan perkembangan yang signifikan:

MOTORIK KASAR:
- Mengangkat kepala 45-90 derajat saat tengkurap
- Menopang berat badan dengan lengan saat tengkurap
- Menggerakkan kaki dan tangan dengan aktif

MOTORIK HALUS:
- Membuka dan menutup tangan
- Menggenggam mainan sebentar
- Meraih objek di depannya

SOSIAL & BAHASA:
- Tersenyum sebagai respons sosial
- Mengikuti objek bergerak dengan mata
- Mengeluarkan suara "aah", "ooh"
- Tertawa kecil

Berikan stimulasi dengan tummy time, ajak bicara, tunjukkan mainan warna-warni.''',
      'tags': 'milestone, perkembangan, 3 bulan, motorik, sosial, bahasa',
    },
    
    // NUTRISI
    {
      'category': '0-1',
      'subcategory': 'Nutrisi',
      'title': 'ASI Eksklusif 6 Bulan Pertama',
      'content': '''ASI eksklusif selama 6 bulan pertama kehidupan bayi sangat penting untuk tumbuh kembang optimal.

MANFAAT ASI:
- Mengandung semua nutrisi yang dibutuhkan bayi
- Antibodi untuk melindungi dari infeksi
- Mudah dicerna
- Memperkuat ikatan ibu-bayi

CARA SUKSES ASI EKSKLUSIF:
- Menyusui on demand (setiap bayi mau)
- Posisi menyusui yang benar
- Ibu makan makanan bergizi
- Cukup istirahat
- Dukungan keluarga

Konsultasi dengan konselor laktasi jika ada kesulitan menyusui.''',
      'tags': 'ASI, eksklusif, nutrisi, bayi, menyusui, 0-6 bulan',
    },
    
    // STIMULASI
    {
      'category': '0-1',
      'subcategory': 'Stimulasi',
      'title': 'Tummy Time untuk Bayi 0-3 Bulan',
      'content': '''Tummy time adalah aktivitas menempatkan bayi dalam posisi tengkurap saat terjaga dan diawasi.

MANFAAT:
- Menguatkan otot leher, bahu, dan punggung
- Mencegah flat head syndrome
- Melatih koordinasi motorik
- Persiapan merangkak dan duduk

CARA MELAKUKAN:
- Mulai 2-3 menit beberapa kali sehari
- Tingkatkan durasi bertahap hingga 20-30 menit/hari
- Letakkan mainan di depan bayi
- Gunakan bantal menyusui sebagai penopang

Selalu awasi bayi dan hentikan jika bayi rewel.''',
      'tags': 'tummy time, stimulasi, bayi, motorik, tengkurap',
    },
    
    // PERAWATAN
    {
      'category': '0-1',
      'subcategory': 'Perawatan',
      'title': 'Cara Memandikan Bayi Baru Lahir',
      'content': '''Memandikan bayi baru lahir memerlukan perhatian khusus untuk keamanan dan kenyamanan.

PERSIAPAN:
- Siapkan semua perlengkapan sebelum mulai
- Handuk lembut, sabun bayi, shampo, waslap
- Air hangat (37-38°C)

LANGKAH-LANGKAH:
1. Bersihkan wajah dengan waslap lembab
2. Cuci kepala dengan shampo bayi
3. Bersihkan lipatan leher, ketiak, selangkangan
4. Cuci badan dengan sabun bayi
5. Keringkan dengan handuk lembut

TIPS KEAMANAN:
- Jangan tinggalkan bayi sendirian
- Tes suhu air dengan siku
- Waktu mandi 5-10 menit

Jaga suhu ruangan tetap hangat (25-27°C).''',
      'tags': 'mandi, bayi, perawatan, kebersihan, newborn',
    },
    
    // ========================================
    // KATEGORI: 1-2 TAHUN (6 materials)
    // ========================================
    
    // PERTUMBUHAN
    {
      'category': '1-2',
      'subcategory': 'Pertumbuhan',
      'title': 'Pertumbuhan Berat Badan 12-24 Bulan',
      'content': '''Pada usia 12-24 bulan, laju pertumbuhan berat badan melambat dibanding tahun pertama.

NORMAL WEIGHT GAIN:
- Penambahan 2-3 kg selama tahun kedua
- Sekitar 200-250 gram per bulan
- Berat badan usia 2 tahun ≈ 4x berat lahir

FAKTOR YANG MEMPENGARUHI:
- Nutrisi dan pola makan
- Aktivitas fisik
- Kesehatan umum
- Genetik

Pantau dengan KMS dan konsultasi rutin setiap bulan.''',
      'tags': 'berat badan, pertumbuhan, 12-24 bulan, toddler',
    },
    
    // PERKEMBANGAN
    {
      'category': '1-2',
      'subcategory': 'Perkembangan',
      'title': 'Perkembangan Bahasa 18-24 Bulan',
      'content': '''Pada usia 18-24 bulan, terjadi "language explosion" - ledakan perkembangan bahasa.

KEMAMPUAN BAHASA:
- Kosakata meningkat drastis (50-200 kata)
- Menggabungkan 2 kata ("mama makan")
- Memahami instruksi 2 langkah
- Mulai bertanya "apa itu?"

CARA STIMULASI:
- Ajak bicara terus dengan kalimat lengkap
- Bacakan buku cerita setiap hari
- Nyanyikan lagu anak-anak
- Ulangi kata yang diucapkan anak dengan benar
- Batasi screen time

Konsultasi ke dokter jika tidak mengeluarkan kata di usia 18 bulan.''',
      'tags': 'bahasa, bicara, perkembangan, 18-24 bulan, kosakata',
    },
    
    // NUTRISI
    {
      'category': '1-2',
      'subcategory': 'Nutrisi',
      'title': 'Menu Makanan Anak 12-18 Bulan',
      'content': '''Pada usia 12-18 bulan, anak sudah bisa mengonsumsi makanan keluarga yang dimodifikasi.

PRINSIP GIZI SEIMBANG:
- Karbohidrat: nasi, roti, pasta
- Protein hewani: ayam, ikan, telur
- Protein nabati: tahu, tempe
- Sayuran: wortel, brokoli, bayam
- Buah: pisang, apel, pepaya

FREKUENSI & PORSI:
- 3x makanan utama
- 2-3x snack sehat
- Porsi: 3-4 sendok makan nasi + lauk

Hindari: gula berlebih, garam berlebih, junk food.''',
      'tags': 'nutrisi, menu, makanan, 12-18 bulan, MPASI, gizi',
    },
    
    // STIMULASI
    {
      'category': '1-2',
      'subcategory': 'Stimulasi',
      'title': 'Permainan Edukatif Anak 18 Bulan',
      'content': '''Anak usia 18 bulan sangat aktif dan ingin tahu.

MOTORIK KASAR:
- Bermain bola
- Naik turun tangga
- Berlari di taman

MOTORIK HALUS:
- Menyusun balok (4-6 balok)
- Puzzle sederhana
- Menggambar dengan crayon
- Bermain play dough

KOGNITIF & BAHASA:
- Membaca buku bergambar
- Bermain dengan boneka
- Meniru aktivitas rumah

TIPS:
- Dampingi anak saat bermain
- Berikan pujian
- Batasi screen time maksimal 1 jam/hari

Bermain adalah cara anak belajar!''',
      'tags': 'stimulasi, permainan, edukatif, 18 bulan, mainan',
    },
    
    // PERAWATAN
    {
      'category': '1-2',
      'subcategory': 'Perawatan',
      'title': 'Toilet Training untuk Anak',
      'content': '''Toilet training adalah proses mengajarkan anak buang air di toilet.

TANDA KESIAPAN (18-24 bulan):
- Popok kering selama 2 jam
- Bisa duduk dan berdiri stabil
- Bisa menarik celana naik-turun
- Menunjukkan tanda akan BAK/BAB
- Tertarik pada toilet

LANGKAH-LANGKAH:
1. Kenalkan toilet/potty chair
2. Lepas popok, ajak ke toilet setiap 2 jam
3. Berikan pujian saat berhasil
4. Jangan marahi jika gagal
5. Konsisten dan sabar

Proses bisa 3-6 bulan. Setiap anak berbeda!''',
      'tags': 'toilet training, perawatan, kemandirian, potty',
    },
    
    // PERKEMBANGAN 2
    {
      'category': '1-2',
      'subcategory': 'Perkembangan',
      'title': 'Milestone Anak 12 Bulan',
      'content': '''Usia 12 bulan (1 tahun) adalah milestone penting.

MOTORIK KASAR:
- Berdiri sendiri tanpa pegangan
- Berjalan beberapa langkah
- Merangkak naik tangga

MOTORIK HALUS:
- Pincer grasp (ibu jari + telunjuk)
- Memasukkan benda ke wadah
- Mencoret-coret

BAHASA:
- Mengucapkan 1-3 kata (mama, papa)
- Memahami instruksi sederhana
- Menunjuk objek

SOSIAL:
- Menunjukkan kasih sayang
- Bermain ciluk-ba
- Melambaikan tangan

Stimulasi dengan buku, bicara, mainan edukatif.''',
      'tags': 'milestone, 12 bulan, 1 tahun, perkembangan',
    },
    
    // ========================================
    // KATEGORI: 2-5 TAHUN (8 materials)
    // ========================================
    
    // PERTUMBUHAN
    {
      'category': '2-5',
      'subcategory': 'Pertumbuhan',
      'title': 'Tinggi Badan Ideal Anak 2-5 Tahun',
      'content': '''Pertumbuhan tinggi badan anak 2-5 tahun melambat namun konsisten.

RATA-RATA:
- 5-7 cm per tahun
- Tinggi usia 2 tahun ≈ 50% tinggi dewasa

FAKTOR:
- Genetik orang tua
- Nutrisi (protein, kalsium, vitamin D)
- Aktivitas fisik
- Kualitas tidur

CARA MEMAKSIMALKAN:
- Nutrisi seimbang
- Susu 2-3 porsi/hari
- Aktivitas fisik teratur
- Tidur cukup (10-13 jam/hari)

Ukur tinggi setiap 6 bulan dan plot di growth chart.''',
      'tags': 'tinggi badan, pertumbuhan, 2-5 tahun, ideal',
    },
    
    // PERKEMBANGAN
    {
      'category': '2-5',
      'subcategory': 'Perkembangan',
      'title': 'Kesiapan Anak Masuk TK',
      'content': '''Kesiapan anak masuk TK meliputi fisik, emosional, sosial, dan kognitif.

KESIAPAN FISIK:
- Toilet training mandiri
- Bisa makan sendiri
- Motorik halus (memegang pensil)

KESIAPAN EMOSIONAL:
- Berpisah dengan orang tua
- Tidak terlalu cengeng
- Mengelola frustasi

KESIAPAN SOSIAL:
- Berinteraksi dengan teman
- Mengikuti aturan
- Berbagi mainan

KESIAPAN KOGNITIF:
- Memahami instruksi 2-3 langkah
- Fokus 10-15 menit
- Mengenal warna & bentuk

PERSIAPAN:
- Playdate dengan teman
- Latih kemandirian
- Kunjungi sekolah

Tidak semua anak siap di usia yang sama.''',
      'tags': 'TK, sekolah, kesiapan, perkembangan, anak',
    },
    
    // NUTRISI
    {
      'category': '2-5',
      'subcategory': 'Nutrisi',
      'title': 'Gizi Seimbang untuk Balita',
      'content': '''Anak 2-5 tahun butuh nutrisi seimbang.

KEBUTUHAN KALORI:
- 2-3 tahun: 1000-1400 kkal/hari
- 4-5 tahun: 1200-1600 kkal/hari

KOMPOSISI (Piring Gizi Seimbang):
- Karbohidrat 50-60%
- Protein 15-20%
- Lemak 25-30%
- Sayur & buah 5 porsi/hari

FREKUENSI:
- 3x makanan utama
- 2-3x snack sehat

NUTRISI PENTING:
- Kalsium: susu, keju
- Zat besi: daging, bayam
- Vitamin D: sinar matahari, susu
- Omega-3: ikan, kacang

HINDARI:
- Fast food berlebihan
- Minuman manis
- Snack tinggi garam''',
      'tags': 'gizi, nutrisi, balita, 2-5 tahun, makanan sehat',
    },
    
    // STIMULASI
    {
      'category': '2-5',
      'subcategory': 'Stimulasi',
      'title': 'Aktivitas Motorik Kasar Balita',
      'content': '''Motorik kasar penting untuk otot, keseimbangan, dan kesehatan.

USIA 2-3 TAHUN:
- Berjalan, berlari, melompat
- Naik turun tangga
- Menendang bola

USIA 3-4 TAHUN:
- Melompat dengan 1 kaki
- Menangkap bola
- Bersepeda roda 3

USIA 4-5 TAHUN:
- Melompat jauh
- Bersepeda roda 2
- Berenang
- Memanjat

REKOMENDASI:
- Minimal 3 jam aktivitas/hari
- Indoor & outdoor
- Variasi jenis

MANFAAT:
- Otot dan tulang kuat
- Jantung sehat
- Berat badan ideal
- Tidur nyenyak

Batasi screen time!''',
      'tags': 'motorik kasar, aktivitas, fisik, balita, olahraga',
    },
    
    // PERAWATAN
    {
      'category': '2-5',
      'subcategory': 'Perawatan',
      'title': 'Cara Merawat Gigi Anak Balita',
      'content': '''Kesehatan gigi anak perlu dijaga sejak dini.

CARA SIKAT GIGI:
- 2x sehari (pagi & malam)
- Durasi: 2 menit

PASTA GIGI:
- <3 tahun: seukuran biji beras
- 3-6 tahun: seukuran kacang polong
- Gunakan pasta berfluoride

TEKNIK:
- Sudut 45 derajat
- Gerakan memutar kecil
- Bersihkan semua permukaan
- Sikat lidah

PERAWATAN:
- Batasi makanan manis
- Hindari minuman manis
- Minum air putih

DOKTER GIGI:
- Pertama: usia 1 tahun
- Rutin: setiap 6 bulan

Gigi susu penting untuk gigi permanen!''',
      'tags': 'gigi, perawatan, kesehatan, sikat gigi, balita',
    },
    
    {
      'category': '2-5',
      'subcategory': 'Perawatan',
      'title': 'Pentingnya Tidur Cukup Balita',
      'content': '''Tidur cukup penting untuk pertumbuhan.

KEBUTUHAN:
- 2-3 tahun: 11-14 jam/hari
- 3-5 tahun: 10-13 jam/hari

MANFAAT:
- Pertumbuhan fisik (growth hormone)
- Perkembangan otak
- Sistem imun kuat
- Mood stabil

DAMPAK KURANG TIDUR:
- Pertumbuhan terhambat
- Mudah sakit
- Rewel
- Sulit konsentrasi

TIPS TIDUR BERKUALITAS:
- Rutinitas konsisten
- Kamar gelap, sejuk, tenang
- Tidak ada TV/gadget
- Mandi hangat sebelum tidur

RUTINITAS (30-60 menit):
1. Mandi
2. Sikat gigi
3. Baca buku
4. Doa/lagu
5. Lampu dimatikan

Tidur cukup = anak sehat!''',
      'tags': 'tidur, sleep, perawatan, balita, istirahat',
    },
    
    {
      'category': '2-5',
      'subcategory': 'Pertumbuhan',
      'title': 'Pemantauan Berat Badan Balita',
      'content': '''Pemantauan berat badan penting untuk deteksi dini masalah gizi.

CARA PANTAU:
- Timbang setiap bulan
- Plot di KMS atau growth chart WHO
- Perhatikan arah garis pertumbuhan

STATUS GIZI:
- Garis naik: Pertumbuhan baik
- Garis mendatar: Warning
- Garis turun: Masalah gizi

FAKTOR PENGARUH:
- Asupan nutrisi
- Aktivitas fisik
- Penyakit infeksi
- Pola makan

TINDAKAN:
- Jika garis mendatar >2 bulan: konsultasi
- Jika garis turun: segera ke dokter
- Jika obesitas: atur pola makan

Jangan skip penimbangan rutin di posyandu!''',
      'tags': 'berat badan, pemantauan, KMS, balita, gizi',
    },
    
    {
      'category': '2-5',
      'subcategory': 'Stimulasi',
      'title': 'Mengajarkan Anak Membaca Dini',
      'content': '''Membaca adalah keterampilan penting yang bisa dimulai sejak dini.

TAHAPAN:
1. Kenalkan buku sejak bayi
2. Bacakan cerita setiap hari
3. Tunjuk gambar dan kata
4. Ajarkan huruf (3-4 tahun)
5. Ajarkan suku kata (4-5 tahun)
6. Latih membaca kata sederhana

METODE:
- Phonics (bunyi huruf)
- Whole word (kata utuh)
- Kombinasi keduanya

TIPS SUKSES:
- Buat menyenangkan, bukan dipaksa
- Pilih buku menarik
- Baca 15-20 menit/hari
- Tunjukkan antusiasme
- Pujian saat kemajuan

JANGAN:
- Memaksa jika belum siap
- Membandingkan dengan anak lain
- Menjadikan tugas/tekanan

Kesiapan anak berbeda-beda. Yang penting cinta buku!''',
      'tags': 'membaca, literasi, stimulasi, balita, belajar',
    },
  ];
}
