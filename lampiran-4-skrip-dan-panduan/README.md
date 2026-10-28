# Lampiran 4 — Skrip Pengukur, Skrip Pengujian, dan Panduan

| Berkas | Fungsi |
|---|---|
| `PANDUAN_UJI_ANDROID.md` | Cara menjalankan seluruh pengujian (tanpa perangkat, ponsel fisik, emulator, uji manual) dan cara memeriksa bukti |
| `ukur_arsitektur.py` | Pengukur arsitektur: berkas, baris, impor lintas lapisan, Ca/Ce/I (`--versi awal` untuk kode awal) |
| `uji_lokal.sh` | Semua uji tanpa perangkat dengan bukti tersimpan |
| `uji_ponsel_rekam.sh` | Uji integrasi di ponsel atau emulator dengan rekaman layar, log, dan hash |
| `emulator.sh` | Memasang, menyalakan, dan mematikan emulator Android 7.0 dan 11 |
| `ujian_perangkat_test.dart` | Skenario uji integrasi yang dijalankan di perangkat |
| `hasil_ukur_arsitektur_awal.json`, `hasil_ukur_arsitektur_akhir.json` | Keluaran pengukur pada kode awal (10 berkas, 4.784 baris) dan kode akhir (104 berkas, 6.026 baris) |

Dalam proyek, skrip berada di folder `digifact/tool/` dan `digifact/integration_test/`.
