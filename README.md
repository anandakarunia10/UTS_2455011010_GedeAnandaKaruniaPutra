# 🪴 PlantCare - Botanical Wiki & Personal Garden Tracker

Aplikasi **PlantCare** adalah platform manajemen perawatan tanaman dan katalog botani interaktif berbasis **Flutter**. Aplikasi ini mengintegrasikan **Perenual REST API** untuk menyajikan katalog tanaman publik serta backend **Supabase (PostgreSQL)** untuk mencatat dan mengelola jurnal perawatan tanaman pribadi secara *real-time*.

Proyek ini disusun untuk memenuhi kriteria Penilaian Perhitungan Tengah Semester (UTS) Mata Kuliah **Pemrograman Berbasis Mobile**.

---

## 👨‍💻 Informasi Mahasiswa

- **Nama**: Gede Ananda Karunia Putra
- **NIM**: 2455011010
- **Program Studi**: Teknologi Rekayasa Perangkat Lunak (TRPL)
- **Kelas**: 5A
- **Instansi**: Universitas Pendidikan Ganesha (Undiksha)

---

## ✨ Fitur Utama

1. **Dashboard Ringkasan (Home)**
   - Menampilkan profil pemilik kebun dan statistik jumlah tanaman tersimpan.
   - Perhitungan otomatis indikator tanaman dengan kondisi *Healthy*.

2. **Katalog Tanaman & Botanical Wiki (REST API)**
   - *Fetch data* langsung dari **Perenual API** secara dinamis.
   - Fitur pencarian (*Search Bar*) untuk memfilter tanaman berdasarkan kata kunci.
   - Tampilan responsif yang menyesuaikan ukuran layar (*GridView* untuk layar lebar / *ListView* untuk mobile portrait).

3. **Detail Informasi Tanaman**
   - Menampilkan rincian gambar, nama ilmiah, jadwal rekomendasi penyiraman, dan intensitas sinar matahari.
   - Akses langsung untuk menambahkan tanaman pilihan ke daftar "Kebunku".

4. **Manajemen "Kebunku" (Full CRUD - Supabase Backend)**
   - **Create**: Menambahkan tanaman baru beserta jadwal siram kustom, status kesehatan awal, dan catatan perawatan.
   - **Read**: Memuat daftar tanaman pribadi dari tabel `my_plants` di database Supabase.
   - **Update**: Memperbarui catatan perawatan, status kesehatan (*Healthy* / *Needs Care*), dan jadwal siram.
   - **Delete**: Menghapus data tanaman dari database dengan *Confirmation Dialog*.

5. **Antarmuka & Arsitektur Bersih**
   - Penggunaan komponen kustom (*CustomButton*, *PlantCard*, *StatusBadge*).
   - Pengelolaan state yang reaktif dan terpisah dari UI menggunakan **Provider**.

---

## 🛠️ Stack Teknologi & Packages

- **Framework**: Flutter (Dart)
- **State Management**: `provider: ^6.1.2`
- **Database Backend**: `supabase_flutter: ^2.8.3`
- **Networking**: `http: ^1.2.1`
- **Typography & Formatting**: `google_fonts: ^6.2.1`, `intl: ^0.19.0`

---

## 📁 Arsitektur Proyek

```text
uts_plant_care/
├── lib/
│   ├── models/            # Data Models (MyPlantModel, PlantApiModel)
│   ├── services/          # API & Supabase Connection Services
│   ├── repositories/      # Layer Abstraksi Data
│   ├── providers/         # State Management (PlantProvider, MyPlantProvider)
│   ├── screens/           # 6 Screen Fungsional (Home, Catalog, Detail, Garden, Add, Edit)
│   ├── widgets/           # Reusable Custom Widgets
│   └── main.dart          # Entry Point & MultiProvider Setup
├── pubspec.yaml           # Dependencies & Assets Configuration
└── README.md              # Dokumentasi Proyek