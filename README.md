# Lampiran Proposal Tugas Akhir — DigiFact

Berkas pendukung untuk proposal tugas akhir *Implementasi Clean Architecture dengan GetX untuk Aplikasi Pendeteksi Hoaks berbasis Mobile Didukung Layanan Random Forest, SHAP, LIME*. Nama lampiran sama dengan yang tercantum pada Daftar Lampiran dan tabel Lampiran Berkas Pendukung di dokumen. Versi terbaru ditandai tag `lampiran-sempro-v3`.

## Lampiran yang dimuat di dokumen dan repositori

| Lampiran | Folder | Isi |
|---|---|---|
| Lampiran BRD | [`lampiran-brd`](lampiran-brd) | Dokumen kebutuhan bisnis: tujuan bisnis, pemangku kepentingan, prioritas kebutuhan (MoSCoW), asumsi, batasan, dan risiko |
| Lampiran Kebutuhan Nonfungsional | [`lampiran-nonfungsional`](lampiran-nonfungsional) | Tabel kebutuhan nonfungsional: perangkat keras, perangkat lunak, dan sifat sistem |
| Lampiran Iterasi Pengembangan | [`lampiran-iterasi`](lampiran-iterasi) | Lima iterasi pengembangan beserta *user story*, bagian aplikasi, kasus uji, dan catatan perbaikan |
| Lampiran Fishbone | [`lampiran-fishbone`](lampiran-fishbone) | Tabel analisis *fishbone*: penyebab, akibat, dan penanganan |
| Lampiran Fitur yang Dibandingkan | [`lampiran-fitur`](lampiran-fitur) | Fitur yang setara pada kode awal dan kode akhir sebagai dasar perbandingan |

## Lampiran yang hanya tersedia di repositori

| Lampiran | Folder | Isi |
|---|---|---|
| Lampiran Arsip Kode | [`lampiran-arsip-kode`](lampiran-arsip-kode) | Arsip kode awal (1.0.0+4) dan kode akhir beserta hash SHA-256 |
| Lampiran Keluaran Pengujian | [`lampiran-keluaran-pengujian`](lampiran-keluaran-pengujian) | Keluaran `flutter test` (112 tes) dan `pytest` (27 tes) |
| Lampiran Cakupan Kode | [`lampiran-cakupan-kode`](lampiran-cakupan-kode) | Cakupan kode per lapisan (96,1%) dan data LCOV |
| Lampiran Skrip dan Panduan | [`lampiran-skrip-dan-panduan`](lampiran-skrip-dan-panduan) | Skrip pengukur arsitektur, skrip pengujian, panduan, serta hasil ukur awal dan akhir |
| Lampiran Kartu Model | [`lampiran-kartu-model`](lampiran-kartu-model) | Kartu model, evaluasi data uji eksternal dan internal, serta pemeriksaan duplikat |
| Lampiran Data Uji Eksternal | [`lampiran-data-uji-eksternal`](lampiran-data-uji-eksternal) | `uji_100.csv` (104 teks) |
| Lampiran Latensi | [`lampiran-latensi`](lampiran-latensi) | Latensi layanan, ponsel, dan emulator |
| Lampiran Bukti Uji Ponsel | [`lampiran-bukti-uji-ponsel`](lampiran-bukti-uji-ponsel) | Rekaman layar, *log*, data perangkat, dan hash uji pada ponsel dan emulator |
| Lampiran SLR dan Analisis Judul | [`lampiran-slr`](lampiran-slr) | Protokol tinjauan literatur terstruktur beserta hasil identifikasi Scopus (28 Oktober 2026), dan analisis kandidat judul |

## Memeriksa keutuhan berkas

Setiap folder memuat `README.md` dan `SHA256SUMS.txt`. Pemeriksaan hash dapat dijalankan dari dalam folder yang bersangkutan:

```bash
cd lampiran-brd
sha256sum -c SHA256SUMS.txt
```

## Riwayat versi

| Tag | Keterangan |
|---|---|
| `lampiran-sempro-v1` | Lampiran awal: arsip versi kode, pengujian, model, latensi, dan uji ponsel |
| `lampiran-sempro-v2` | Pembaruan angka pengujian dan arsip kode akhir |
| `lampiran-sempro-v3` | Penamaan lampiran deskriptif, evaluasi model internal, serta lampiran BRD, nonfungsional, iterasi, *fishbone*, fitur, dan SLR |
