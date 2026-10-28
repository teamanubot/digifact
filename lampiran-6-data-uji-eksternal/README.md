# Lampiran 6 — Data Uji Eksternal (`uji_100.csv`)

104 teks berlabel manual yang **tidak pernah dipakai** untuk pelatihan, pemilihan ambang, maupun penyetelan parameter model.

| Label | Jumlah | Sumber |
|---|---|---|
| hoax | 52 | TurnBackHoax (20), Cek Fakta Tempo (10), Liputan6.com (10), Kompas.com (10), Cekfakta.com (2) |
| fakta | 52 | 36 media berita |

Kolom: `Teks`, `Label` (`hoax` atau `fakta`), `Sumber`. Panjang teks kedua kelas disamakan (fakta median 21 kata, hoaks median 23 kata).

Hasil evaluasi model pada data ini ada di Lampiran 5 (`evaluasi_eksternal_keluaran.txt`): akurasi 0,702 (selang Wilson 95% 0,608–0,781). Pemeriksaan kemiripan terhadap data latih: tidak ada teks dengan kemiripan kosinus 0,8 atau lebih (maksimum 0,69).

Cara mengulang: `cd hda && python3 evaluate_external.py dataset/uji_100.csv`.
