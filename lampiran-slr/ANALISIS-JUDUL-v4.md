# Analisis Celah Penelitian dan Rekomendasi Judul (v4)

**Sumber:** BRD-DigiFact.md (FR-01 s.d. FR-21, BO-01 s.d. BO-07) dan SLR-DigiFact.md (S1–S19, matriks celah).
**Penyusun:** Rivai (NIM 20230801290) — 28 Oktober 2026.
**Pemisahan isi:** **(A)** fakta dari BRD/SLR, **(B)** interpretasi pola, **(C)** usulan novelty. Skor 1–10 adalah penilaian peneliti, bukan data. Tidak ada angka di luar dokumen BRD/SLR.

> **Judul penelitian pada dokumen proposal (v3 dan v4) tidak diubah:**
> *Implementasi Clean Architecture dengan GetX untuk Aplikasi Pendeteksi Hoaks berbasis Mobile Didukung Layanan Random Forest, SHAP, LIME.*
> Rekomendasi di bawah hanya bahan diskusi dengan dosen pembimbing.

---

## TAHAP 1 — Matriks Silang FR × SLR

**(A) Fakta.** Pemetaan hanya terhadap 19 studi (S1–S19) pada SLR.

| FR | Kebutuhan (BRD) | Solusi eksisting (SLR) | Status |
|---|---|---|---|
| FR-01 | Menerima teks atau tautan berita | S6, S7, S8 (aplikasi *mobile* ke layanan); S14–S18 (teks) | ✅ Terpenuhi |
| FR-02 | Menolak masukan < 10 karakter tanpa kirim permintaan | S11 (uji validitas skenario, aplikasi web) | ⚠️ Sebagian |
| FR-03 | Mengirim ke layanan, menampilkan vonis | S8 (*mobile*+ML via REST); S14, S15 (klasifikasi hoaks) | ⚠️ Sebagian |
| FR-04 | Probabilitas dan analisis ringkas | S14–S16 (metrik model) | ⚠️ Sebagian |
| FR-05 | Kata kunci SHAP dan LIME | S16 (LIME) | ⚠️ Sebagian (tidak sampai aplikasi *mobile*) |
| FR-06 | Vonis netral di bawah ambang | S19 (opsi menolak) | ⚠️ Sebagian (bukan pada aplikasi) |
| FR-07 | Memetakan kegagalan ke pesan yang jelas | — (T3: kegagalan bertipe belum dibahas) | ❌ Belum ada |
| FR-08 | Vonis tetap tampil saat penjelasan gagal | — | ❌ Belum ada |
| FR-09 | Hasil tetap tampil saat simpan riwayat gagal | — | ❌ Belum ada |
| FR-10 | Menolak tautan berbahaya | — (SLR tidak mencakup keamanan) | ❌ Belum ada |
| FR-11 | Simpan dan batal simpan riwayat | — | ❌ Belum ada |
| FR-12 | Kelola riwayat | — | ❌ Belum ada |
| FR-13 | Status layanan | — | ❌ Belum ada |
| FR-14 | Pemberitahuan pengiriman data | — | ❌ Belum ada |
| FR-15 | Ekstraksi teks dari tautan | — | ❌ Belum ada |
| FR-16 | Layar pengantar | — | ❌ Belum ada |
| FR-17 | Panduan literasi | — | ❌ Belum ada |
| FR-18 | Salin laporan | — | ❌ Belum ada |
| FR-19 | Kartu model dan *Server-Timing* | S8 (dokumentasi *endpoint*) | ⚠️ Sebagian |
| FR-20 | Catat kasus dekat ambang | S19 (opsi menolak) | ⚠️ Sebagian |
| FR-21 | Akun dan verifikasi fakta | — | *Won't* (di luar lingkup) |

**Hitungan:** ✅ 1, ⚠️ 7, ❌ 12 (FR-21 tidak dihitung).

**(B) Interpretasi.** Tidak semua ❌ layak menjadi gap riset. FR-11, 12, 13, 16, 17, 18 adalah fitur umum yang memang bukan topik penelitian. Yang bermakna hanya kelompok yang menyentuh perilaku sistem terhadap layanan ML:

- **K1 (FR-07, 08, 09):** degradasi layanan dan kegagalan bertipe hingga ke tampilan.
- **K2 (FR-10, 14, 15):** keamanan dan privasi integrasi layanan.
- **K3 (FR-05, 06, 20):** penjelasan dan *abstain* di antarmuka.
- **Non-FR (matriks gap SLR, BO-02, BO-04):** kemampuan uji dan keterisolasian perubahan, serta latensi *end-to-end*.

---

## TAHAP 2 — Skoring Kandidat Gap

**(C) Usulan.** Skor adalah penilaian peneliti.

| Kandidat gap | Jenis | Novelty | Kelayakan | Dampak | Total |
|---|---|---|---|---|---|
| **A.** Kemampuan uji dan keterisolasian perubahan arsitektur *Clean Architecture* dengan GetX pada aplikasi Flutter yang bergantung layanan ML | Metodologis | 8 | 9 | 8 | **25** |
| **B.** Penanganan kegagalan bertipe, vonis parsial, dan *abstain* hingga ke tampilan (K1+K3) | Konteks | 8 | 8 | 7 | 23 |
| **C.** Latensi *end-to-end* di ponsel termasuk SHAP dan LIME | Performa | 6 | 9 | 6 | 21 |

**Pemenang: Gap A.**

- **(A) Dasar fakta:** SLR menunjukkan penelitian arsitektur menilai satu aspek (T1, T2) dan pengujian dibahas pada tingkat persepsi (T4). BRD sudah memiliki BO-02 dan BO-04 yang terukur: 0 impor layanan, 0 berkas *domain* berubah, 112 tes aplikasi.
- **(B) Interpretasi:** gap ini paling terukur dan dapat direproduksi dengan skrip, dan mewadahi gap B sebagai bagian pengujian.
- **Gap B dan C** menjadi pendukung (Subbab 3.6.2 dan 3.8.5 proposal).

---

## TAHAP 3 — Lima Rekomendasi Judul

**(C) Usulan.** Semua ≤ 20 kata, tanpa "Implementasi", "Rancang Bangun", atau "Studi Kasus". Struktur: [Metode] untuk [Outcome] pada [Objek].

| No | Judul | Daya tarik | Novelty | Kelayakan | Total |
|---|---|---|---|---|---|
| 1 | *Clean Architecture* dan GetX untuk Meningkatkan Kemampuan Uji dan Keterisolasian Perubahan pada Aplikasi Flutter Pendeteksi Hoaks Berbasis Layanan Klasifikasi (19 kata) | 8 | 8 | 9 | **25** |
| 2 | *Clean Architecture* dan GetX untuk Meningkatkan Modularitas Aplikasi Flutter Pendeteksi Hoaks yang Bergantung pada Layanan *Random Forest*, SHAP, dan LIME (20 kata) | 8 | 7 | 9 | 24 |
| 3 | Penanganan Kegagalan Bertipe dan Opsi Menolak untuk Aplikasi *Mobile* yang Bergantung pada Layanan Klasifikasi Hoaks: Pengukuran Kemampuan Uji dan Latensi (20 kata) | 8 | 8 | 8 | 24 |
| 4 | *Clean Architecture* dan GetX untuk Mengisolasi Perubahan Layanan Klasifikasi pada Aplikasi Android Pendeteksi Hoaks dengan Uji Integrasi di Ponsel Fisik (20 kata) | 8 | 7 | 9 | 24 |
| 5 | Arsitektur Berlapis dengan GetX untuk Menekan Ketergantungan Antarberkas dan Pemanggilan Layanan Langsung pada Aplikasi Flutter Pendeteksi Hoaks (17 kata) | 7 | 7 | 9 | 23 |

**Pembanding — judul saat ini (17 kata):** *Implementasi Clean Architecture dengan GetX untuk Aplikasi Pendeteksi Hoaks berbasis Mobile Didukung Layanan Random Forest, SHAP, LIME.* Memakai kata "Implementasi" (kata klise) dan tidak menyebut hasil yang diukur.

---

## TAHAP 4 — Analisis Final

### 1. Mengapa judul 1 paling kuat
- **(A)** Menyebut dua hal yang menurut SLR belum diukur bersama (kemampuan uji dan keterisolasian perubahan; Gap A), dan keduanya sudah punya bukti terukur di BRD (BO-02, BO-04).
- **(B)** Strukturnya mengikuti "[metode] untuk [outcome] pada [objek]" dengan objek jelas; layanan ML ditempatkan sebagai konteks ("berbasis layanan klasifikasi"), sejalan dengan fokus *mobile*.
- **(C)** Novelty ada pada irisan arsitektur *mobile* dengan layanan ML yang dapat gagal atau lambat; irisan ini tidak muncul pada satu pun dari 19 studi SLR.

### 2. Alternatif
- **Akademik (paper):** *Testability and Change Isolation of a Clean Architecture–GetX Flutter Application Dependent on a Hoax Classification Service: A Before–After Measurement.*
- **Praktis (industri):** *Aplikasi Flutter Pendeteksi Hoaks yang Mudah Diuji dan Tahan Perubahan Layanan dengan Clean Architecture dan GetX.*

### 3. Rekomendasi final dan kalimat pembuka
Rekomendasi: **judul 1**, bila Anda dan dosen pembimbing memutuskan mengganti judul. Kalimat pembuka latar belakang:

> "Aplikasi pendeteksi hoaks di ponsel pada umumnya memanggil layanan klasifikasi melalui API yang dapat lambat, gagal, berubah format, atau memilih tidak memutuskan; bila seluruh tanggung jawab itu ditempatkan di kelas antarmuka, seperti pada prototipe awal DigiFact (lima dari enam berkas tampilan mengimpor layanan konkret dan 23 pemanggilan layanan dari *State*), aplikasi menjadi sulit diuji dan mudah rusak ketika layanan berubah."

---

## Catatan

- **Koreksi hitungan:** pada versi awal analisis tertulis "8 sebagian dan 11 belum ada"; hitungan yang benar adalah **1 terpenuhi, 7 sebagian, 12 belum ada** (total 20).
- Gap pemenang sama dengan yang sudah dikerjakan di proposal, sehingga isi proposal sudah selaras; mengganti judul tidak wajib dan lebih menyangkut kepatuhan pada aturan judul dan penajaman *outcome*.
- Bila judul diganti, perubahan perlu dilakukan pada sampul, pengesahan, persetujuan publikasi, Kata Pengantar, dan abstrak (Indonesia dan Inggris).
- Dokumen proposal v4 memuat ringkasan analisis ini pada Subbab 2.14, 2.15, dan 3.10.
