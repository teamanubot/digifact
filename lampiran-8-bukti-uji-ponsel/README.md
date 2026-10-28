# Lampiran 8 — Bukti Uji pada Ponsel dan Emulator Android

Setiap folder berisi `rekaman_layar.mp4`, `log_uji.txt` (baris `UJI|…` = hasil tiap skenario), `perangkat.txt` (model, versi Android, jaringan, ping, waktu), dan `SHA256SUMS.txt`. Periksa keutuhan: `sha256sum -c SHA256SUMS.txt` di tiap folder.

| Folder | Perangkat | Hasil |
|---|---|---|
| `wifi-20261028-043411` | POCO F5, Android 15, Wi-Fi | 10 dari 10 lulus; median latensi 1,62 detik |
| `seluler-20261028-043716` | POCO F5, Android 15, LTE | 10 dari 10 lulus; median 1,79 detik |
| `emulator-android11-20261028-054045` | Emulator Android 11 | 10 dari 10 lulus; median 1,52 detik |
| `emulator-android7.0-sebelum-perbaikan-onboarding-20261028-044704` | Emulator Android 7.0 | Layar pengantar meluap 93 piksel; skenario jaringan gagal (sertifikat) |
| `emulator-android7.0-sebelum-perbaikan-sertifikat-20261028-053312` | Emulator Android 7.0 | Layar sudah diperbaiki; skenario jaringan gagal (sertifikat) |
| `emulator-android7.0-setelah-perbaikan-sertifikat-20261028-060533` | Emulator Android 7.0 | 10 dari 10 lulus; median 1,24 detik |

Dua folder "sebelum" sengaja disimpan sebagai bukti kegagalan awal dan perbaikannya. Cara mengulang: `tool/PANDUAN_UJI_ANDROID.md` (Lampiran 4).
