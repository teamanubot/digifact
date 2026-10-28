# Lampiran Kartu Model — Kartu Model dan Evaluasi

| Berkas | Isi |
|---|---|
| `model_card.json` | Kartu model produksi: algoritma, jumlah data, akurasi uji, ambang 0,65, jendela 12–60 kata, keterbatasan |
| `evaluasi_eksternal_keluaran.txt` | Evaluasi pada 104 teks eksternal: akurasi 0,702, selang Wilson 95% 0,608–0,781, matriks per kelas, kesalahan di atas ambang |
| `cek_duplikat_keluaran.txt` | Pemeriksaan duplikat dan kemiripan: 11 duplikat persis, 18 pasangan uji-latih berkemiripan ≥0,8, dampak pada akurasi internal (88,7% menjadi 88,4%); uji eksternal tanpa kemiripan ≥0,8 |
| `evaluate_external.py`, `cek_duplikat.py` | Skrip penghasil keluaran (folder `hda/`) |

Mengulang: `cd hda && python3 evaluate_external.py dataset/uji_100.csv` dan `python3 cek_duplikat.py`.
