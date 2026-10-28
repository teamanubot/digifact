#!/bin/bash
# Uji integrasi DigiFact pada perangkat Android (ponsel atau emulator) dengan bukti:
# rekaman layar, log uji, data perangkat, dan hash berkas.
#
# Pemakaian:  tool/uji_ponsel_rekam.sh <wifi|seluler|emulator> <id perangkat>
#   wifi      ponsel fisik, Wi-Fi dinyalakan dan data seluler dimatikan
#   seluler   ponsel fisik, Wi-Fi dimatikan dan data seluler dinyalakan
#   emulator  emulator Android (jaringan mengikuti komputer)
# Id perangkat: lihat keluaran `adb devices` (mis. 4158773b atau emulator-5554).
# Hasil: docs/bukti_uji_ponsel/<mode>-<waktu>/ (rekaman_layar.mp4, log_uji.txt,
#        perangkat.txt, SHA256SUMS.txt). Panduan lengkap: tool/PANDUAN_UJI_ANDROID.md
set -u
cd "$(dirname "$0")/.."
MODE=${1:-}; DEV=${2:-}
case $MODE in wifi|seluler|emulator) ;; *) sed -n 2,12p "$0"; exit 1;; esac
[ -n "$DEV" ] || { echo "Id perangkat belum diisi."; adb devices; exit 1; }
export PATH=${FLUTTER_BIN:-/root/flutter/bin}:${ANDROID_PLATFORM_TOOLS:-$HOME/Android/Sdk/platform-tools}:$PATH
adb devices | awk 'NR>1 && $2=="device"{print $1}' | grep -qx "$DEV" || {
  echo "Perangkat $DEV tidak terhubung atau belum diizinkan. Keluaran adb devices:"; adb devices; exit 1; }
OUT=docs/bukti_uji_ponsel/$MODE-$(date +%Y%m%d-%H%M%S); mkdir -p "$OUT"
case $MODE in
  wifi) adb -s $DEV shell svc wifi enable;  adb -s $DEV shell svc data disable ;;
  seluler) adb -s $DEV shell svc wifi disable; adb -s $DEV shell svc data enable ;;
  emulator) ;;
esac
sleep 8
{
  echo "waktu_mulai=$(date -Is)"; echo "mode=$MODE"
  for p in ro.product.manufacturer ro.product.marketname ro.product.model ro.build.version.release ro.build.version.sdk ro.build.display.id; do echo "$p=$(adb -s $DEV shell getprop $p | tr -d '\r')"; done
  adb -s $DEV shell wm size | tr -d '\r'; adb -s $DEV shell wm density | tr -d '\r'
  adb -s $DEV shell "dumpsys connectivity" | tr -d '\r' | grep -E "Active default network|NetworkAgentInfo" | grep -o "Active default network: [0-9]*\|network{[0-9]*}.*ni{[A-Z]*\[*[A-Z]*\]* CONNECTED" | cut -c1-120
  echo "ping api.rmun.tech:"; adb -s $DEV shell "ping -c 3 -W 3 api.rmun.tech" | tail -2 | tr -d '\r'
} > "$OUT/perangkat.txt"
adb -s $DEV shell pm uninstall com.teamanubot.digifact.uji >/dev/null 2>&1
adb -s $DEV shell rm -f /sdcard/uji.mp4
adb -s $DEV shell "screenrecord --time-limit 175 --bit-rate 4000000 /sdcard/uji.mp4" &
REC=$!; sleep 2
flutter test integration_test/ujian_perangkat_test.dart -d $DEV > "$OUT/log_uji.txt" 2>&1
echo "waktu_selesai=$(date -Is)" >> "$OUT/perangkat.txt"
# Hentikan perekam (pkill tidak ada di Android lama, jadi memakai kill + pidof).
sleep 3; adb -s $DEV shell "kill -2 \$(pidof screenrecord)" 2>/dev/null; wait $REC 2>/dev/null; sleep 2
adb -s $DEV pull /sdcard/uji.mp4 "$OUT/rekaman_layar.mp4" >/dev/null 2>&1
adb -s $DEV shell rm -f /sdcard/uji.mp4
[ "$MODE" != emulator ] && { adb -s $DEV shell svc wifi enable; adb -s $DEV shell svc data enable; }
(cd "$OUT" && sha256sum * > SHA256SUMS.txt)
grep "UJI|\|All tests\|Some tests" "$OUT/log_uji.txt"; echo "bukti: $OUT"
