#!/usr/bin/env python3
"""Mengukur indikator modularitas dari kode Dart (versi awal dan akhir dengan skrip yang sama).

Pemakaian:
    python3 tool/ukur_arsitektur.py <folder lib> [--versi awal|akhir]

Keluaran: jumlah berkas, jumlah baris tidak kosong, berkas terbesar, jumlah berkas di atas 300 dan 500
baris, jumlah impor lintas lapisan, serta Ca, Ce, dan instability (I = Ce / (Ca + Ce)) per lapisan.
Definisi (Martin, 2017): Ca = banyaknya berkas di luar lapisan yang bergantung pada berkas di dalam lapisan;
Ce = banyaknya berkas di dalam lapisan yang bergantung pada berkas di luar lapisan.
"""
import os, re, sys, json

def lapisan_akhir(rel):
    top = rel.split('/')[0]
    return {'domain':'domain','data':'data','presentation':'presentation','app':'app','core':'core'}.get(top,'(akar)')

def lapisan_awal(rel):
    top = rel.split('/')[0]
    return {'views':'views','services':'services','models':'models'}.get(top,'(akar)')

def baca_berkas(lib):
    out = {}
    for dp, _, fs in os.walk(lib):
        for f in fs:
            if f.endswith('.dart'):
                p = os.path.join(dp, f)
                rel = os.path.relpath(p, lib).replace(os.sep, '/')
                out[rel] = open(p, encoding='utf-8').read()
    return out

def resolve(rel_src, imp):
    if imp.startswith('package:'):
        m = re.match(r'package:[^/]+/(.+)', imp)
        return m.group(1) if m else None
    if imp.startswith('dart:'):
        return None
    base = os.path.dirname(rel_src)
    return os.path.normpath(os.path.join(base, imp)).replace(os.sep, '/')

def ukur(lib, versi):
    berkas = baca_berkas(lib)
    lap = lapisan_akhir if versi == 'akhir' else lapisan_awal
    baris = {k: sum(1 for l in v.splitlines() if l.strip()) for k, v in berkas.items()}
    edges = []  # (sumber, tujuan)
    for k, v in berkas.items():
        for imp in re.findall(r"^\s*import\s+'([^']+)'", v, flags=re.M):
            t = resolve(k, imp)
            if t and t in berkas:
                edges.append((k, t))
    layers = sorted(set(lap(k) for k in berkas))
    hasil = {}
    for L in layers:
        masuk = {s for s, t in edges if lap(t) == L and lap(s) != L}   # berkas luar yang bergantung ke L (Ca)
        keluar = {s for s, t in edges if lap(s) == L and lap(t) != L}  # berkas L yang bergantung ke luar (Ce)
        ca, ce = len(masuk), len(keluar)
        hasil[L] = {'berkas': sum(1 for k in berkas if lap(k) == L), 'Ca': ca, 'Ce': ce,
                    'I': round(ce / (ca + ce), 2) if (ca + ce) else None}
    n = len(berkas); tot = sum(baris.values()); terbesar = max(baris, key=baris.get)
    return {
        'versi': versi, 'berkas': n, 'baris_tidak_kosong': tot, 'rata_rata_baris': round(tot / n, 1),
        'terbesar': [terbesar, baris[terbesar]],
        'berkas_di_atas_300': sum(1 for b in baris.values() if b > 300),
        'berkas_di_atas_500': sum(1 for b in baris.values() if b > 500),
        'impor_lintas_lapisan': sum(1 for s, t in edges if lap(s) != lap(t)),
        'lapisan': hasil,
    }

if __name__ == '__main__':
    lib = sys.argv[1]
    versi = sys.argv[sys.argv.index('--versi') + 1] if '--versi' in sys.argv else 'akhir'
    print(json.dumps(ukur(lib, versi), indent=2, ensure_ascii=False))
