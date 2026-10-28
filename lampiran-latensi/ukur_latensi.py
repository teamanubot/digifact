"""Mengukur waktu pemrosesan layanan (prediksi, SHAP, LIME) pada komputer ini.

Memakai header Server-Timing yang dikirim endpoint /api/deteksi. Teks uji diambil dari
hda/dataset/uji_100.csv (teks 12-60 kata). Pemakaian:  python3 ukur_latensi.py [jumlah teks]
"""
import csv
import os
import statistics
import sys

from fastapi.testclient import TestClient

import main

n = int(sys.argv[1]) if len(sys.argv) > 1 else 20
csv_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "hda", "dataset", "uji_100.csv")
with open(csv_path, encoding="utf-8") as f:
    teks = [r["Teks"] for r in csv.DictReader(f) if 12 <= len(r["Teks"].split()) <= 60][:n]
klien = TestClient(main.app)
klien.post("/api/deteksi", json={"teks_berita": teks[0]})  # pemanasan
kolom = {"prediksi": [], "shap": [], "lime": [], "total": []}
for t in teks:
    h = klien.post("/api/deteksi", json={"teks_berita": t}).headers["server-timing"]
    for bagian in h.split(","):
        nama, dur = bagian.strip().split(";dur=")
        kolom[nama].append(float(dur) / 1000)
print(f"n={len(teks)} teks; komputer: {os.cpu_count()} thread")
for k, v in kolom.items():
    print(f"{k:9s} median={statistics.median(v):.3f} s  maks={max(v):.3f} s")
