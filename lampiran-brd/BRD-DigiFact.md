# Business Requirements Document (BRD)

**Judul penelitian:** Implementasi *Clean Architecture* dengan GetX untuk Aplikasi Pendeteksi Hoaks berbasis Mobile Didukung Layanan Random Forest, SHAP, LIME
**Sistem:** DigiFact (aplikasi Android Flutter dan layanan klasifikasi FastAPI)
**Penyusun:** Rivai (NIM 20230801290), Program Studi Teknik Informatika, Fakultas Ilmu Komputer, Universitas Esa Unggul
**Versi / tanggal:** 1.0 / 28 Oktober 2026

> Catatan: angka pada dokumen ini bersumber dari pengukuran nyata pada proposal (hasil awal per 28 Oktober 2026). Nilai yang belum pernah diukur ditulis `[ISI DATA]`. Kolom "Target" adalah target usulan peneliti; kolom "Status" adalah hasil terukur.

---

## 1. Executive Summary

**Latar bisnis.** Hoaks beredar masif melalui gawai, sedangkan lembaga pemeriksa fakta tidak dapat menjangkau setiap unggahan. Warga membutuhkan alat bantu penilaian awal yang cepat dan dapat dijelaskan dari ponsel. Penelitian ini tidak berlokasi pada satu instansi; penggunanya masyarakat umum.

**Masalah nyata yang diamati.** Prototipe awal DigiFact (versi 1.0.0+4) mencampurkan logika bisnis, akses data, dan status tampilan di dalam kelas *State*: 5 dari 6 berkas tampilan mengimpor layanan konkret, terdapat 23 pemanggilan layanan dari *State*, dan berkas terbesar mencapai 1.185 baris (10 berkas, 4.784 baris). Akibatnya aturan bisnis tidak dapat diuji tanpa menjalankan Flutter, dan perubahan format atau kegagalan layanan klasifikasi merambat ke banyak layar. Pada aplikasi yang menyampaikan vonis kepada publik, kegagalan seperti ini dapat menghadirkan hasil yang keliru.

**Tujuan sistem.** Merestrukturisasi DigiFact dengan *Clean Architecture* dan GetX agar logika aplikasi terpisah dari antarmuka dan dari layanan klasifikasi, dapat diuji, serta terisolasi dari perubahan layanan; layanan klasifikasi (TF-IDF, *Random Forest*, SHAP, LIME) diperlakukan sebagai dependensi eksternal yang kinerjanya dilaporkan jujur. Hasil diukur terhadap kode awal.

---

## 2. Business Objectives & Success Metrics (SMART)

| Kode | *Objective* | Success Metric | Target | Status (terukur) |
|---|---|---|---|---|
| BO-01 | Memisahkan logika bisnis dari antarmuka | Berkas tampilan yang mengimpor layanan konkret; pemanggilan layanan dari *State* | 0 dan 0 | 5 → 0 dan 23 → 0 |
| BO-02 | Meningkatkan kemampuan uji | Tes otomatis lulus; cakupan kode | 100% lulus; ≥ 90% | 112/112 tes aplikasi dan 27/27 tes layanan; 96,1% |
| BO-03 | Mempercepat penilaian awal bagi pengguna | Median latensi *end-to-end* di ponsel (tombol sampai hasil) | < 5 detik; batas 30 detik | 1,62 detik (Wi-Fi), 1,79 detik (LTE) |
| BO-04 | Mengisolasi dampak perubahan | Berkas *domain* dan *presentation* yang berubah saat mengganti penyimpanan riwayat | 0 | 0 (1 berkas baru, 1 baris pemasangan) |
| BO-05 | Melaporkan kinerja model secara jujur | Akurasi dan F1 pada data uji internal dan eksternal, dengan selang Wilson 95% | Dilaporkan beserta selisihnya | 88,7% (internal); 70,2% (eksternal, selang 60,8–78,1%) |
| BO-06 | Memperbaiki modularitas | Berkas di atas 300 baris; berkas terbesar | 0; < 300 baris | 6 → 0; 1.185 → 259 baris |
| BO-07 | Meningkatkan penerimaan pengguna | Skor kegunaan (SUS) atau UAT | `[ISI DATA]` | `[ISI DATA]` (belum diukur; perlu survei pengguna) |

---

## 3. Scope

### In-Scope
- Aplikasi *mobile* Android (minimum Android 7.0, API 24) berbasis Flutter dengan *Clean Architecture* tiga lapisan (*presentation*, *domain*, *data*) dan GetX pada *presentation*.
- Masukan teks atau tautan berita berbahasa Indonesia; tautan diekstrak di peladen dan teks dievaluasi pada 60 kata pertama.
- Layanan klasifikasi FastAPI: TF-IDF *unigram*, *Random Forest* (300 pohon), ambang keputusan 0,65, penjelasan SHAP dan LIME, kartu model.
- Data: pelatihan dan uji internal 3.188 teks (Antara dan Komdigi), 5.306 teks hoaks era lama, uji eksternal 104 teks.
- Pengujian otomatis (unit, *widget*, *golden*, arsitektur, integrasi) dan pengukuran kualitas arsitektur (modularitas, kemampuan uji, keterisolasian perubahan, Ca/Ce/*instability*).
- Pengguna: masyarakat umum.

### Out-of-Scope
- Verifikasi kebenaran faktual suatu klaim (model hanya memprediksi pola bahasa).
- Platform selain Android (iOS, web, *desktop*).
- Perbandingan algoritma ML lain; pelatihan ulang model dengan data lebih beragam.
- Autentikasi, akun pengguna, dan penyimpanan riwayat di peladen.
- Survei penerimaan pengguna (SUS, UTAUT) — `[ISI DATA]` bila kelak dilakukan.
- Integrasi dengan platform media sosial atau lembaga pemeriksa fakta.

---

## 4. Stakeholder Analysis

| Stakeholder | Peran | Kepentingan | Influence |
|---|---|---|---|
| Pengguna umum | Pengguna akhir aplikasi | Penilaian awal yang cepat, jelas, dan dapat dipahami | Tinggi |
| Peneliti/pengembang (Rivai) | Pemilik dan pelaksana | Arsitektur yang terukur, dapat diuji, dan dapat dibuktikan | Tinggi |
| Dosen pembimbing — `[ISI DATA: nama]` | Pengarah penelitian | Kesahihan metode dan kecukupan bukti | Tinggi |
| Dosen penguji — `[ISI DATA: nama]` | Penilai | Ketepatan metodologi dan reprodusibilitas hasil | Tinggi |
| Penyedia infrastruktur (VPS, Cloudflare) | Pendukung layanan | Layanan dan sertifikat HTTPS berjalan | Sedang |
| Sumber data (Antara, Komdigi, pemeriksa fakta) | Penyedia data | Data dipakai wajar dan sesuai sumber | Rendah |

---

## 5. Functional Requirements (FR)

| ID | Requirement | Prioritas (MoSCoW) |
|---|---|---|
| FR-01 | Sistem dapat menerima masukan teks atau tautan berita dari pengguna | Must |
| FR-02 | Sistem dapat menolak masukan kurang dari 10 karakter tanpa mengirim permintaan ke layanan | Must |
| FR-03 | Sistem dapat mengirim masukan ke layanan klasifikasi dan menampilkan vonis (hoaks, fakta, atau netral/perlu verifikasi manual) | Must |
| FR-04 | Sistem dapat menampilkan probabilitas hoaks dan fakta serta analisis ringkas | Must |
| FR-05 | Sistem dapat menampilkan kata kunci berpengaruh dari penjelasan SHAP dan LIME | Must |
| FR-06 | Sistem dapat memberi vonis netral bila keyakinan model di bawah ambang 0,65 | Must |
| FR-07 | Sistem dapat memetakan kegagalan (tidak ada koneksi, waktu habis 30 detik, galat layanan) menjadi pesan yang jelas | Must |
| FR-08 | Sistem dapat tetap menampilkan vonis bila penjelasan SHAP atau LIME tidak tersedia | Must |
| FR-09 | Sistem dapat tetap menampilkan hasil bila penyimpanan riwayat gagal, disertai pesan | Must |
| FR-10 | Layanan dapat menolak tautan berskema selain http/https, beralamat jaringan internal, atau berukuran berlebih | Must |
| FR-11 | Sistem dapat menyimpan hasil ke riwayat lokal (maks. 50 item) dan membatalkan penyimpanan | Should |
| FR-12 | Sistem dapat menampilkan, membuka kembali, menghapus satu, dan menghapus seluruh riwayat | Should |
| FR-13 | Sistem dapat menampilkan status ketersediaan layanan | Should |
| FR-14 | Sistem dapat menampilkan pemberitahuan bahwa teks dikirim ke peladen dan riwayat hanya di perangkat | Should |
| FR-15 | Layanan dapat mengekstrak teks dari tautan dan mengevaluasi 60 kata pertama | Should |
| FR-16 | Sistem dapat menampilkan layar pembuka dan pengantar pada pemakaian pertama | Should |
| FR-17 | Sistem dapat menampilkan panduan literasi digital | Should |
| FR-18 | Sistem dapat menyalin laporan hasil pemeriksaan | Could |
| FR-19 | Layanan dapat menyajikan kartu model (ambang, metrik, keterbatasan) dan rincian waktu pemrosesan (*Server-Timing*) | Could |
| FR-20 | Layanan dapat mencatat kasus berprobabilitas dekat ambang untuk audit | Could |
| FR-21 | Sistem menyediakan akun pengguna, autentikasi, dan verifikasi fakta | Won't |

---

## 6. Non-Functional Requirements (NFR)

| Kategori | Requirement | Metrik / Status |
|---|---|---|
| **Performance** | Respons *end-to-end* di ponsel | Median < 5 detik, batas 30 detik; terukur 1,62 detik (Wi-Fi) dan 1,79 detik (LTE). Waktu layanan 0,82 detik (prediksi 0,06; SHAP 0,22; LIME 0,55) |
| **Security** | Komunikasi dan pengambilan tautan aman | HTTPS (Google Trust Services); pengaman tautan (skema, alamat, pengalihan ≤ 3, 10 detik, 2 MB); uji penolakan lulus |
| **Usability** | Kegunaan aplikasi | Skor SUS `[ISI DATA]` (belum diukur); batas masukan 10 karakter; pesan kegagalan berbahasa Indonesia |
| **Reliability** | Ketersediaan dan penanganan galat | *Uptime* `[ISI DATA]` (belum diukur); batas waktu 4 detik (status) dan 30 detik (deteksi); vonis tetap tampil saat penjelasan gagal |
| **Maintainability** | Modularitas dan kemampuan uji | 0 berkas > 300 baris; cakupan 96,1%; arah ketergantungan ditegakkan uji arsitektur |
| **Compatibility** | Versi Android | Minimum 7.0; terbukti pada 7.0, 11, dan 15; 7.1–10 `[ISI DATA]` (belum diuji) |

---

## 7. Business Process As-Is vs To-Be

**As-Is (kondisi saat ini).** Warga yang menerima kabar berantai atau unggahan harus memutuskan sendiri apakah akan menelusuri kebenarannya: membuka beberapa laman pemeriksa fakta, membandingkan banyak sumber, lalu menilai sendiri. *Pain point:* memakan waktu dan tersebar, sehingga penelusuran sering dilewati dan kabar langsung diteruskan atau dipakai untuk mengisi data pribadi.

**To-Be (kondisi yang diusulkan).** Warga menempelkan teks atau tautan ke aplikasi. Aplikasi memvalidasi masukan, mengirimkannya ke layanan, dan menampilkan vonis (hoaks, fakta, atau netral), probabilitas, serta kata kunci yang memengaruhi vonis dalam sekitar 1,5 detik. Warga membaca hasil sebagai penilaian awal, memeriksa sumber sebelum menyebarkan, dan hasil tersimpan di riwayat lokal. Kegagalan layanan (jaringan, waktu habis, galat, penjelasan kosong, vonis netral) ditangani aplikasi tanpa merusak tampilan.

**Gap perbaikan.** Dari penelusuran manual yang lambat menjadi penilaian awal otomatis yang dapat dijelaskan; dari kode yang terikat layanan (sulit diuji, mudah rusak saat layanan berubah) menjadi arsitektur berlapis yang dapat diuji dan terisolasi. Aplikasi tidak menggantikan pemeriksaan oleh lembaga pemeriksa fakta.

---

## 8. Assumptions & Constraints

**Assumptions**
- Pengguna memiliki koneksi internet saat memeriksa teks.
- Layanan klasifikasi di VPS (`api.rmun.tech`) tersedia selama pengujian.
- Masukan berbahasa Indonesia dan berupa teks berita umum.
- Sertifikat HTTPS dari otoritas yang dikenal perangkat sasaran.

**Constraints**
- Penelitian dikerjakan satu orang; praktik XP yang bergantung tim (pemrograman berpasangan, pelanggan di tempat) tidak diterapkan.
- Data pelatihan hanya dari dua sumber (Antara, Komdigi); data uji eksternal berukuran kecil (104 teks).
- Pengujian terbatas pada satu ponsel fisik (POCO F5, Android 15) dan dua emulator (Android 11 dan 7.0).
- Sumber daya pengembangan terbatas (RAM WSL sekitar 7,8 GB); jadwal penelitian Juli 2026–Februari 2027.
- Rujukan dibatasi jurnal SINTA 4 ke atas atau Scopus Q3 ke atas.

---

## 9. Risk Register

| ID | Risiko | Probabilitas | Dampak | Mitigasi |
|---|---|---|---|---|
| R-01 | Label berkorelasi dengan sumber teks (kebocoran data) sehingga akurasi internal menyesatkan | Sedang | Tinggi | Penyeragaman panjang teks, pembatasan tahun hoaks, normalisasi, uji eksternal dan pemeriksaan duplikat |
| R-02 | Otoritas sertifikat berubah sehingga Android lama gagal tersambung | Sedang | Tinggi | Pantau penerbit sertifikat; uji ulang Android 7.0; ganti CA di Cloudflare bila perlu |
| R-03 | Layanan VPS mati atau lambat | Sedang | Sedang | Batas waktu, pesan kegagalan bertipe, pengecekan status, vonis parsial |
| R-04 | Tautan dimanfaatkan untuk mengakses sumber daya internal (SSRF) | Rendah | Tinggi | `url_guard`: skema, alamat internal, pengalihan, ukuran, waktu; diuji otomatis |
| R-05 | Generalisasi model rendah pada data eksternal | Tinggi | Sedang | Opsi menolak (ambang 0,65), pelaporan selang kepercayaan, data latih lebih beragam (saran) |
| R-06 | Uji tampilan tidak stabil (*golden*) menurunkan kepercayaan pada tes | Sedang | Sedang | Font dan ikon dimuat sebelum pengambilan gambar; acuan diperbarui terkendali |
| R-07 | Ragam perangkat dan versi Android belum teruji | Sedang | Sedang | Uji emulator; ponsel kedua dan Android 7.1–10 `[ISI DATA]` bila memungkinkan |
| R-08 | Data pribadi pengguna terkirim ke peladen tanpa disadari | Rendah | Sedang | Pemberitahuan pengiriman di beranda; riwayat hanya lokal; kebijakan retensi *log* `[ISI DATA]` |

---

## 10. Acceptance Criteria

**Sistem dinyatakan BERHASIL apabila:**
1. BO-01 sampai BO-06 terpenuhi sebagaimana kolom Status pada Bagian 2 (berkas tampilan yang mengimpor layanan = 0; pemanggilan dari *State* = 0; seluruh berkas ≤ 300 baris; median latensi < 5 detik; berkas *domain*/*presentation* yang berubah pada studi kasus = 0).
2. Seluruh tes otomatis aplikasi dan layanan lulus, dengan cakupan kode ≥ 90%.
3. Seluruh skenario uji integrasi lulus pada ponsel Android fisik (Wi-Fi dan seluler) dan pada emulator Android 7.0 dan 11.
4. Kinerja model dilaporkan pada data internal dan eksternal beserta selang kepercayaan, dan selisihnya dijelaskan sebagai keterbatasan.
5. Seluruh bukti (kode awal dan akhir, keluaran tes, cakupan, skrip, bukti uji perangkat) tersedia dan dapat diverifikasi dengan hash.

**Sistem dinyatakan GAGAL apabila:**
1. Ada berkas *domain* atau *presentation* yang harus berubah ketika penyimpanan riwayat diganti.
2. Median latensi *end-to-end* di ponsel ≥ 5 detik, atau deteksi melampaui 30 detik.
3. Layanan menerima tautan beralamat internal, atau aplikasi gagal menampilkan vonis ketika penjelasan tidak tersedia.
4. Aplikasi gagal tersambung ke layanan pada versi Android yang diklaim didukung.
5. Pengujian otomatis gagal tanpa penjelasan penyebabnya.

---

## Lampiran: keterlacakan ke dokumen proposal

| Bagian BRD | Subbab proposal |
|---|---|
| 1, 2 | Subbab 1.1 sampai 1.4 |
| 3 | Subbab 1.5 |
| 5, 6 | Subbab 3.9 dan 3.6.2 (kontrak API, matriks kegagalan) |
| 7 | Subbab 3.4 |
| 9 | Subbab 3.7, 3.8.5, dan 3.9.3 |
| 10 | Subbab 3.8 |
