# Lampiran 7 — Hasil Pengukuran Latensi

Median dalam detik. Layanan: `https://api.rmun.tech` (VPS). Komponen layanan dibaca dari header `Server-Timing`.

| Komponen | Komputer pengembang | Ponsel, Wi-Fi | Ponsel, LTE | Emulator Android 11 | Emulator Android 7.0 |
|---|---|---|---|---|---|
| Prediksi | 0,051 | 0,059 | 0,059 | 0,059 | 0,059 |
| SHAP | 0,135 | 0,218 | 0,217 | 0,213 | 0,214 |
| LIME | 0,226 | 0,549 | 0,554 | 0,538 | 0,539 |
| Total layanan | 0,41 | 0,82 | 0,83 | 0,81 | 0,82 |
| Jaringan dan koneksi | tidak ada | 0,41 | 0,80 | 0,36 | 0,23 |
| *End-to-end* di aplikasi | tidak ada | 1,62 | 1,79 | 1,52 | 1,24 |

Maksimum *end-to-end*: 1,79 detik (Wi-Fi), 1,90 detik (LTE), 1,62 detik (Android 11), 1,34 detik (Android 7.0). Batas deteksi pada aplikasi 30 detik; target median 5 detik.

| Berkas | Isi |
|---|---|
| `latensi_komputer_pengembang.txt` | Keluaran `ukur_latensi.py` (20 teks, Intel Core i7-13700HX) |
| `latensi_ponsel_dan_emulator_dari_log.txt` | Baris hasil latensi dari log uji tiap perangkat (log lengkap dan video ada di Lampiran 8) |
| `ukur_latensi.py` | Skrip pengukur lokal (folder `hoax-detector-api/`) |

Angka emulator hanya menunjukkan fungsi, bukan kinerja ponsel nyata.
