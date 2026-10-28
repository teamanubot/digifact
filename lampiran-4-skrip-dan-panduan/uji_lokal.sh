#!/bin/bash
# Menjalankan seluruh pengujian yang tidak butuh perangkat Android, dengan bukti tersimpan:
# tes aplikasi Flutter (termasuk golden dan cakupan), tes API, dan ukuran arsitektur.
#
# Pemakaian:  tool/uji_lokal.sh
# Hasil: docs/bukti_uji_lokal/<waktu>/ (log, cakupan, ukuran arsitektur, SHA256SUMS.txt)
set -u
cd "$(dirname "$0")/.."
export PATH=${FLUTTER_BIN:-/root/flutter/bin}:$PATH
API_DIR=${API_DIR:-../hoax-detector-api}
OUT=docs/bukti_uji_lokal/$(date +%Y%m%d-%H%M%S); mkdir -p "$OUT"
echo "== Tes aplikasi Flutter (dengan cakupan)"
flutter test --coverage > "$OUT/flutter_test.txt" 2>&1; tail -1 "$OUT/flutter_test.txt"
cp coverage/lcov.info "$OUT/lcov.info" 2>/dev/null
python3 - > "$OUT/cakupan_per_lapisan.txt" <<'P'
import collections
agg=collections.defaultdict(lambda:[0,0]);cur=None
for l in open('coverage/lcov.info'):
    l=l.strip()
    if l.startswith('SF:'):
        p=l[3:]; cur=next((k for k in ('lib/domain','lib/presentation/controllers','lib/presentation','lib/data','lib/app','lib/core') if p.startswith(k)),'lainnya')
    elif l.startswith('LF:'): agg[cur][1]+=int(l[3:]); agg['TOTAL'][1]+=int(l[3:])
    elif l.startswith('LH:'): agg[cur][0]+=int(l[3:]); agg['TOTAL'][0]+=int(l[3:])
for k,(h,f) in sorted(agg.items()): print(f'{k}: {100*h/f:.1f}% ({h}/{f} baris)')
P
cat "$OUT/cakupan_per_lapisan.txt"
echo "== Ukuran arsitektur"
python3 tool/ukur_arsitektur.py lib > "$OUT/ukur_arsitektur.json" 2>&1 && head -8 "$OUT/ukur_arsitektur.json"
echo "== Tes API"
( cd "$API_DIR" && python3 -m pytest tests -q ) > "$OUT/pytest_api.txt" 2>&1; tail -1 "$OUT/pytest_api.txt"
(cd "$OUT" && sha256sum * > SHA256SUMS.txt)
echo "bukti: $OUT"
