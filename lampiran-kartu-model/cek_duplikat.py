"""Pemeriksaan duplikat dan teks hampir sama (kemiripan kosinus TF-IDF).

Memeriksa (1) duplikat persis dan hampir sama di dalam dataset latih+uji internal,
(2) pasangan uji-latih yang hampir sama, dan (3) uji eksternal terhadap seluruh data latih.
Pemakaian:  python cek_duplikat.py
"""
import os
import numpy as np
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

from hoax_pipeline import build_dataset, split_dataset
from text_preprocessing import normalize_text

BASE = os.path.dirname(os.path.abspath(__file__))
AMBANG = (0.8, 0.9, 0.95)


def norm(s):
    return s.map(normalize_text)


def terdekat(a, b, vec):
    """Kemiripan maksimum tiap teks di a terhadap seluruh b."""
    return cosine_similarity(vec.transform(a), vec.transform(b)).max(axis=1)


def laporan(nama, sim):
    sim = np.asarray(sim)
    baris = ", ".join(f">={t}: {int((sim >= t).sum())}" for t in AMBANG)
    print(f"{nama}: n={len(sim)}, median={np.median(sim):.3f}, maks={sim.max():.3f}; {baris}")


df = build_dataset()
train, test = split_dataset(df)
print("dataset", len(df), "latih", len(train), "uji", len(test))
df["n"] = norm(df["Teks"])
print("duplikat persis (teks ternormalisasi) dalam dataset:", int(df["n"].duplicated().sum()))
tr_n, te_n = norm(train["Teks"]), norm(test["Teks"])
print("teks uji yang persis sama dengan teks latih:", int(te_n.isin(set(tr_n)).sum()))
vec = TfidfVectorizer().fit(pd.concat([tr_n, te_n]))
laporan("uji vs latih", terdekat(te_n, tr_n, vec))
S = cosine_similarity(vec.transform(tr_n))
np.fill_diagonal(S, 0)
laporan("latih vs latih (selain diri sendiri)", S.max(axis=1))
ext = pd.read_csv(os.path.join(BASE, "dataset", "uji_100.csv"))
ex_n = norm(ext["Teks"].astype(str))
vec2 = TfidfVectorizer().fit(pd.concat([tr_n, te_n, ex_n]))
laporan("uji eksternal vs latih+uji", terdekat(ex_n, pd.concat([tr_n, te_n]), vec2))

# dampak pada akurasi uji internal
from sklearn.metrics import accuracy_score
from hoax_pipeline import build_pipeline
m = build_pipeline().fit(train["Teks"], train["Label"])
benar = (m.predict(test["Teks"]) == test["Label"].values)
sim = terdekat(te_n, tr_n, vec)
print(f"akurasi uji semua: {benar.mean():.4f} ({len(benar)}); tanpa pasangan >=0.8: {benar[sim<0.8].mean():.4f} ({int((sim<0.8).sum())}); pada pasangan >=0.8: {benar[sim>=0.8].mean():.4f} ({int((sim>=0.8).sum())})")
bersih = df.assign(_k=df["n"].duplicated(keep="first")).query("not _k").drop(columns=["_k","n"])
tr2, te2 = split_dataset(bersih)
m2 = build_pipeline().fit(tr2["Teks"], tr2["Label"])
print(f"setelah buang duplikat persis: n={len(bersih)}, akurasi uji={accuracy_score(te2['Label'], m2.predict(te2['Teks'])):.4f}")
