"""Metrik lengkap pada data uji internal (638 teks) dengan model produksi.
Menjalankan ulang: cd hda && python3 evaluate_internal.py
Pembagian data memakai build_dataset() dan split_dataset() (seed 42), sama dengan pelatihan."""
import sys, warnings
warnings.filterwarnings("ignore")
sys.path.insert(0, "."); sys.path.insert(0, "../hoax-detector-api")
import joblib
import hoax_pipeline as H
from sklearn.metrics import (accuracy_score, precision_recall_fscore_support,
                             confusion_matrix, roc_auc_score, f1_score)
df = H.build_dataset(); tr, te = H.split_dataset(df)
print(f"Data: {len(df)} teks; latih {len(tr)}; uji {len(te)}; label uji {te['Label'].value_counts().to_dict()}")
m = joblib.load("../hoax-detector-api/pipeline_rf_hoax.pkl")
y = te["Label"].values
p = m.predict_proba(te["Teks"])[:, 1]
yp = (p >= 0.5).astype(int)
print(f"Akurasi {accuracy_score(y, yp):.4f}  F1 macro {f1_score(y, yp, average='macro'):.4f}  AUC {roc_auc_score(y, p):.4f}")
pr, rc, f, s = precision_recall_fscore_support(y, yp)
print(f"Presisi [Fakta, Hoaks] {pr.round(3).tolist()}  Recall {rc.round(3).tolist()}  F1 {f.round(3).tolist()}  n {s.tolist()}")
print("Matriks kebingungan [[TN FP] [FN TP]]:", confusion_matrix(y, yp).tolist())
