# Lampiran 1 — Arsip Versi Kode DigiFact

Dua arsip pembanding untuk pengukuran kualitas arsitektur (Bab III, Subbab 3.3 dan 3.8.3).

| Berkas | Isi |
|---|---|
| `kode-awal-v1.0.0+4.tar.gz` | Prototipe awal DigiFact (versi 1.0.0+4): 10 berkas Dart |
| `kode-akhir.tar.gz` | Kode setelah restrukturisasi *Clean Architecture* dan GetX: 104 berkas Dart |
| `SHA256SUMS.txt` | Hash SHA-256 kedua arsip |
| `ukur_arsitektur.py` | Skrip pengukur yang sama untuk kedua versi |

Folder `.git`, hasil build, berkas biner (APK, AAB, video), dan tangkapan layar tidak disertakan.

## Memeriksa keutuhan dan mereproduksi angka

```
sha256sum -c SHA256SUMS.txt                       # keduanya harus OK
mkdir uji && tar xzf kode-awal-v1.0.0+4.tar.gz -C uji && tar xzf kode-akhir.tar.gz -C uji
python3 ukur_arsitektur.py uji/digifact-kode-awal/lib --versi awal
python3 ukur_arsitektur.py uji/digifact-kode-akhir/lib
```

Hasil yang diharapkan:

| Ukuran | Kode awal | Kode akhir |
|---|---|---|
| Berkas Dart | 10 | 104 |
| Baris tidak kosong | 4.784 | 6.049 |
| Berkas di atas 300 / 500 baris | 6 / 4 | 0 / 0 |
| Impor lintas lapisan | 16 | 169 |

Pemanggilan layanan langsung dari `State` pada kode awal (23): `grep -rn "widget.apiService\|widget.storageService" uji/digifact-kode-awal/lib | wc -l`.
