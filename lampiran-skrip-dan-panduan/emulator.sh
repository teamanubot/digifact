#!/bin/bash
# Mengelola emulator Android untuk pengujian DigiFact.
#
# Pemakaian:  tool/emulator.sh <perintah> [android7|android11] [--tanpa-jendela]
#   pasang    unduh system image dan buat emulator (sekali saja, butuh internet ~1 GB)
#   nyalakan  jalankan emulator dan tunggu sampai siap (bawaan: dengan jendela)
#   matikan   matikan emulator yang berjalan
#   status    tampilkan perangkat yang terhubung
# android7  = Android 7.0 (API 24), versi minimum aplikasi
# android11 = Android 11 (API 30)
# Jendela tampil lewat WSLg (Windows 11). Jalankan hanya SATU emulator sekali waktu
# dan jangan bersamaan dengan build besar: RAM WSL terbatas dan laptop bisa hang.
set -u
SDK=${ANDROID_SDK_ROOT:-$HOME/Android/Sdk}
export PATH=$SDK/cmdline-tools/latest/bin:$SDK/emulator:$SDK/platform-tools:$PATH
CMD=${1:-}; VER=${2:-android7}; WIN=jendela; [ "${3:-}" = "--tanpa-jendela" ] && WIN=tanpa
[ "${2:-}" = "--tanpa-jendela" ] && { VER=android7; WIN=tanpa; }
case $VER in
  android7)  IMG="system-images;android-24;default;x86_64";    AVD=uji_android7 ;;
  android11) IMG="system-images;android-30;google_apis;x86_64"; AVD=uji_android11 ;;
  *) echo "Versi tidak dikenal: $VER (android7 atau android11)"; exit 1 ;;
esac
case $CMD in
  pasang)
    yes | sdkmanager --install "$IMG" "emulator" "platform-tools"
    echo no | avdmanager create avd -n $AVD -k "$IMG" -d pixel_2 --force
    cfg=$HOME/.android/avd/$AVD.avd/config.ini
    sed -i 's/^hw.ramSize=.*/hw.ramSize=2048/; s/^hw.lcd.density=.*/hw.lcd.density=420/' "$cfg"
    echo "Emulator $AVD siap. Jalankan: tool/emulator.sh nyalakan $VER" ;;
  nyalakan)
    ARGS="-avd $AVD -no-audio -no-boot-anim -no-snapshot -wipe-data -gpu swiftshader_indirect -memory 2048"
    [ $WIN = tanpa ] && ARGS="$ARGS -no-window"
    mkdir -p /tmp/digifact; nohup emulator $ARGS > /tmp/digifact/emulator.log 2>&1 &
    echo "Menunggu emulator $AVD (bisa 1-3 menit)..."
    for i in $(seq 1 60); do
      e=$(adb devices | awk '/^emulator-/{print $1; exit}')
      [ -n "$e" ] && [ "$(adb -s $e shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = 1 ] && { sleep 10; echo "Siap: $e"; adb devices; exit 0; }
      sleep 5
    done
    echo "Emulator belum siap. Lihat /tmp/digifact/emulator.log"; exit 1 ;;
  matikan) adb -s "$(adb devices | awk '/^emulator-/{print $1; exit}')" emu kill ;;
  status) adb devices -l ;;
  *) sed -n 2,13p "$0"; exit 1 ;;
esac
