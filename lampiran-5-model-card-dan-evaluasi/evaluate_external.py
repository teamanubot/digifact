"""Evaluasi model produksi pada data UJI EKSTERNAL (sumber di luar Antara/Komdigi).

Ini uji generalisasi yang sebenarnya: teks dari media/sumber lain yang TIDAK pernah
dipakai untuk melatih maupun memilih ambang model.

Format CSV (UTF-8), kolom wajib:  Teks, Label      (Label: Fakta atau Hoaks)
Kolom opsional:                   Sumber           (mis. kompas.com, turnbackhoax.id)

Pemakaian:
    python evaluate_external.py dataset/eksternal_uji.csv
"""
import json
import os
import pickle
import sys

import numpy as np
import pandas as pd
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix, f1_score

from text_preprocessing import take_window, word_count

BASE = os.path.dirname(os.path.abspath(__file__))
API_DIR = os.path.join(BASE, "..", "hoax-detector-api")
LABELS = {"fakta": 0, "hoaks": 1, "hoax": 1}


def main(path: str) -> None:
    with open(os.path.join(API_DIR, "pipeline_rf_hoax.pkl"), "rb") as f:
        model = pickle.load(f)
    with open(os.path.join(API_DIR, "model_card.json"), encoding="utf-8") as f:
        card = json.load(f)
    threshold = card["threshold"]
    max_words = card["input_window_words"][1]

    df = pd.read_csv(path)
    df["y"] = df["Label"].astype(str).str.strip().str.lower().map(LABELS)
    if df["y"].isna().any():
        bad = df.loc[df["y"].isna(), "Label"].unique()
        sys.exit(f"Label tidak dikenal: {bad}. Gunakan 'Fakta' atau 'Hoaks'.")
    df["y"] = df["y"].astype(int)

    print(f"Data uji eksternal: {len(df)} teks  ({(df.y == 0).sum()} Fakta, {(df.y == 1).sum()} Hoaks)")
    if len(df) < 60:
        print("PERINGATAN: kurang dari 60 teks, interval kepercayaan lebar; hasil hanya indikatif.")
    pendek = (df["Teks"].map(word_count) < card["input_window_words"][0]).sum()
    if pendek:
        print(f"Catatan: {pendek} teks lebih pendek dari {card['input_window_words'][0]} kata (di bawah rentang latih).")

    proba = model.predict_proba(df["Teks"].map(lambda t: take_window(str(t), max_words)))[:, 1]
    pred = (proba >= 0.5).astype(int)
    conf = np.maximum(proba, 1 - proba)
    decided = conf >= threshold

    print(f"\n== Tanpa ambang (semua kasus diputuskan)")
    print(f"Akurasi : {accuracy_score(df.y, pred):.3f}   F1 macro: {f1_score(df.y, pred, average='macro'):.3f}")
    print(classification_report(df.y, pred, target_names=["Fakta", "Hoaks"], digits=3, zero_division=0))
    print("Confusion matrix [[TN FP] [FN TP]]:\n", confusion_matrix(df.y, pred))

    print(f"\n== Dengan ambang {threshold} (seperti di API)")
    print(f"Cakupan (bukan Netral): {decided.mean():.3f}")
    if decided.any():
        print(f"Akurasi kasus yang diputuskan: {accuracy_score(df.y[decided], pred[decided]):.3f}")

    if "Sumber" in df.columns:
        print("\n== Per sumber")
        tabel = df.assign(benar=(pred == df.y)).groupby("Sumber")["benar"].agg(["count", "mean"])
        print(tabel.rename(columns={"count": "n", "mean": "akurasi"}).round(3).to_string())

    # --- Diagnosis kualitas set uji ---------------------------------------------
    df["n_kata"] = df["Teks"].map(word_count)
    df["p_hoaks"], df["pred"] = proba, pred
    print("\n== Diagnosis set uji")
    for lbl, nama in [(0, "Fakta"), (1, "Hoaks")]:
        n = df.loc[df.y == lbl, "n_kata"]
        print(f"Panjang {nama:5s}: min {n.min()}, median {n.median():.0f}, maks {n.max()} kata")
    tebak = max(
        (accuracy_score(df.y, (df["n_kata"] < t).astype(int)), t)
        for t in range(int(df["n_kata"].min()) + 1, int(df["n_kata"].max()) + 2)
    )
    acc_model = accuracy_score(df.y, pred)
    print(f"Aturan panjang saja (Hoaks jika < {tebak[1]} kata): akurasi {tebak[0]:.3f}  vs model {acc_model:.3f}")
    if tebak[0] >= acc_model:
        print("PERINGATAN: panjang teks saja sudah setara/lebih baik dari model. Set uji bias panjang;")
        print("            samakan sebaran panjang kedua kelas agar uji ini valid.")
    masuk = df["n_kata"] >= card["input_window_words"][0]
    if masuk.any() and not masuk.all():
        print(f"Hanya teks >= {card['input_window_words'][0]} kata (dalam rentang latih): "
              f"n={masuk.sum()}, akurasi {accuracy_score(df.y[masuk], pred[masuk]):.3f}")
    salah_yakin = df[decided & (pred != df.y)]
    print(f"\nKesalahan yang diputuskan model (di atas ambang): {len(salah_yakin)} dari {decided.sum()}")
    for _, r in salah_yakin.iterrows():
        print(f"  [{r['Label']}, p_hoaks={r['p_hoaks']:.2f}] {str(r['Teks'])[:110]}")

    # Interval kepercayaan Wilson 95% untuk akurasi
    n, k = len(df), int((pred == df.y).sum())
    z, p = 1.96, k / n
    centre = (p + z * z / (2 * n)) / (1 + z * z / n)
    half = z * np.sqrt(p * (1 - p) / n + z * z / (4 * n * n)) / (1 + z * z / n)
    print(f"\nAkurasi {p:.3f}, interval kepercayaan 95% (Wilson): [{centre - half:.3f}, {centre + half:.3f}]")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    main(sys.argv[1])
