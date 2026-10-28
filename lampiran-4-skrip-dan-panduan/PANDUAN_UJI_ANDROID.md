# Panduan Menjalankan Pengujian DigiFact

Panduan ini untuk mengulang seluruh pengujian pada skripsi *Implementasi Clean Architecture dengan GetX untuk Aplikasi Pendeteksi Hoaks berbasis Mobile*, misalnya bila penguji meminta pembuktian. Semua perintah dijalankan dari folder `digifact` (`cd /root/project_mat/digifact`) di terminal WSL (Ubuntu).

| Yang diuji | Cara | Skrip |
|---|---|---|
| Tes aplikasi (unit, widget, golden, arsitektur), cakupan, tes API, ukuran arsitektur | Tanpa perangkat | `tool/uji_lokal.sh` |
| Uji integrasi pada ponsel Android fisik (Wi-Fi dan seluler) | Ponsel + kabel USB | `tool/uji_ponsel_rekam.sh` |
| Uji integrasi pada emulator Android 7.0 dan 11 | Emulator | `tool/emulator.sh` + `tool/uji_ponsel_rekam.sh` |
| Uji manual (peragaan langsung di depan penguji) | Ponsel | Daftar periksa pada Bagian 5 |

## 1. Prasyarat

- Windows 11 dengan WSL2 (Ubuntu 22.04) dan WSLg (agar jendela emulator tampil).
- Flutter di `/root/flutter/bin` (jalankan `flutter --version`). Jalur lain: `export FLUTTER_BIN=<folder bin Flutter>`.
- Android SDK di `~/Android/Sdk` (berisi `platform-tools`, `emulator`, `cmdline-tools`). Jalur lain: `export ANDROID_SDK_ROOT=<folder SDK>`.
- Python 3 dengan `pytest`, `fastapi`, `scikit-learn`, `shap`, `lime` untuk tes API (lihat `hoax-detector-api/requirements.txt`).
- `usbipd` di Windows (`winget install usbipd`) untuk menyambungkan ponsel USB ke WSL.
- Koneksi internet. Layanan yang diuji: `https://api.rmun.tech`.

Peringatan RAM: WSL hanya mendapat sekitar 7,8 GB. Jalankan **satu hal berat sekali waktu** (emulator, atau build Flutter/Gradle). Menjalankan emulator bersamaan dengan build pernah membuat laptop hang.

## 2. Pengujian tanpa perangkat

```
tool/uji_lokal.sh
```

Skrip menjalankan `flutter test --coverage`, menghitung cakupan per lapisan, menjalankan `tool/ukur_arsitektur.py`, dan menjalankan `pytest` pada API. Hasilnya di `docs/bukti_uji_lokal/<waktu>/`.

Hasil acuan (28 Oktober 2026): **110 tes aplikasi lulus**, cakupan **95,9%** (domain 96,3%, controller 94,9%, data 76,1%, presentation 97,7%, core 52,2%), **27 tes API lulus**, 104 berkas, terbesar 259 baris.

Cara manual tanpa skrip:

```
flutter test --coverage                  # tes aplikasi + cakupan (coverage/lcov.info)
python3 tool/ukur_arsitektur.py lib      # ukuran dan Ca/Ce/I per lapisan
cd ../hoax-detector-api && python3 -m pytest tests -q
```

Jika gambar acuan *golden* sengaja diubah: `flutter test test/golden --update-goldens` (hanya setelah tampilan memang berubah).

## 3. Uji di ponsel Android fisik

### 3.1 Persiapan ponsel (sekali)
1. Pengaturan → Tentang ponsel → ketuk **Nomor build** 7 kali (membuka Opsi pengembang).
2. Pengaturan → Opsi pengembang → aktifkan **Debugging USB**.
3. Atur waktu mati layar ke yang terpanjang dan nyalakan mode **Jangan ganggu** (agar notifikasi pribadi tidak masuk rekaman).
4. Colok kabel USB, pilih mode **Transfer file** bila ditanya.

### 3.2 Menyambungkan ponsel ke WSL
Di **PowerShell Windows sebagai Administrator**:

```
usbipd list                               # catat BUSID ponsel (contoh 1-11)
usbipd bind --busid 1-11                  # sekali saja
usbipd attach --wsl --busid 1-11          # ulangi bila kabel dicabut atau laptop restart
```

Di WSL:

```
adb kill-server; adb start-server
adb devices                               # harus tampil: <id>   device
```

- Bila tampil `unauthorized`: buka kunci ponsel dan ketuk **Izinkan** pada dialog debugging USB (centang "Selalu izinkan").
- Bila `usbipd attach` gagal "Device busy": ada `adb` Windows yang berjalan. Jalankan `adb.exe kill-server` di Windows lalu coba lagi, dan jangan menjalankan `adb` Windows selama uji.
- Bila `adb devices` kosong: ulangi `usbipd attach`, atau cabut dan colok kabel.

### 3.3 Menjalankan uji
```
tool/uji_ponsel_rekam.sh wifi <id perangkat>      # Wi-Fi aktif, data seluler mati
tool/uji_ponsel_rekam.sh seluler <id perangkat>   # Wi-Fi mati, data seluler aktif
```

`<id perangkat>` adalah kolom pertama `adb devices`. Satu putaran sekitar 1–2 menit (build pertama sampai beberapa menit). **Jangan menyentuh ponsel dan jangan mencabut kabel** selama uji berjalan. Skrip menyalakan kembali Wi-Fi dan data seluler di akhir.

Skrip memasang aplikasi sebagai paket terpisah (`com.teamanubot.digifact.uji`), sehingga DigiFact yang sudah terpasang dan riwayatnya tidak terhapus. Paket uji boleh dihapus setelahnya (`adb uninstall com.teamanubot.digifact.uji`).

## 4. Uji di emulator

```
tool/emulator.sh pasang android7          # sekali: unduh image Android 7.0 (±1 GB) dan buat emulator
tool/emulator.sh nyalakan android7        # jendela emulator tampil; tunggu pesan "Siap: emulator-5554"
tool/uji_ponsel_rekam.sh emulator emulator-5554
tool/emulator.sh matikan
```

- Ganti `android7` dengan `android11` untuk Android 11.
- Tanpa jendela (lebih hemat): `tool/emulator.sh nyalakan android7 --tanpa-jendela`.
- Emulator pertama kali menyala lambat (1–3 menit). Latensi di emulator hanya menunjukkan fungsi, bukan kinerja ponsel nyata.
- Setelah memakai emulator, matikan sebelum menjalankan build atau tes besar.

## 5. Uji manual (peragaan di depan penguji)

Pasang APK rilis: `flutter build apk --release`, berkasnya di `build/app/outputs/flutter-apk/app-release.apk`; salin ke ponsel lalu ketuk untuk memasang.

| No | Skenario | Hasil yang diharapkan |
|---|---|---|
| 1 | Buka aplikasi pertama kali, lanjutkan tiga slide pengantar | Slide 1–3 tampil, lalu beranda |
| 2 | Perhatikan lencana pada beranda | "Server Online" |
| 3 | Masukkan "pendek", tekan *Analisis Berita Sekarang* | Pesan validasi, permintaan tidak dikirim |
| 4 | Masukkan teks kurang dari 12 kata (≥10 karakter) | Hasil netral dengan catatan teks terlalu pendek |
| 5 | Masukkan teks berita valid (≥12 kata) | Vonis, probabilitas, tab SHAP dan LIME; waktu ±1,5 detik |
| 6 | Masukkan `http://127.0.0.1/rahasia` | Ditolak: "Tautan ditolak … alamat jaringan internal" |
| 7 | Buka Riwayat | Hasil sebelumnya tercantum; hapus satu dan hapus semua berfungsi |
| 8 | Aktifkan mode pesawat lalu periksa teks | Pesan galat jaringan |
| 9 | Salin laporan lalu tempel di catatan | Teks laporan tersalin |

Mengukur latensi manual: rekam layar ponsel (fitur bawaan), ulangi skenario 5 sebanyak 5 kali, lalu hitung selisih waktu dari video antara ketukan tombol dan munculnya hasil. Ambil median dan nilai maksimum.

## 6. Membaca dan memverifikasi bukti

Setiap putaran uji menghasilkan folder berisi:

| Berkas | Isi |
|---|---|
| `rekaman_layar.mp4` | Rekaman layar perangkat selama uji |
| `log_uji.txt` | Keluaran uji; baris `UJI|nama|LULUS/GAGAL|detail` adalah hasil tiap skenario |
| `perangkat.txt` | Model, versi Android, resolusi, jaringan aktif, ping ke server, waktu mulai dan selesai |
| `SHA256SUMS.txt` | Hash berkas untuk membuktikan bukti tidak diubah |

Memeriksa keutuhan: `cd docs/bukti_uji_ponsel/<folder> && sha256sum -c SHA256SUMS.txt` (semua harus `OK`).

Bukti yang sudah ada (28 Oktober 2026), semua 10 skenario lulus kecuali yang bertanda:

| Folder | Perangkat | Catatan |
|---|---|---|
| `wifi-20261028-043411` | POCO F5, Android 15, Wi-Fi | median latensi 1,62 detik |
| `seluler-20261028-043716` | POCO F5, Android 15, LTE | median latensi 1,79 detik |
| `emulator-android11-20261028-054045` | Emulator Android 11 | median 1,52 detik |
| `emulator-android7.0-sebelum-perbaikan-onboarding-…` | Emulator Android 7.0 | layar pengantar meluap 93 piksel; skenario jaringan gagal (sertifikat) |
| `emulator-android7.0-sebelum-perbaikan-sertifikat-…` | Emulator Android 7.0 | layar sudah diperbaiki; skenario jaringan gagal (sertifikat) |
| `emulator-android7.0-setelah-perbaikan-sertifikat-…` | Emulator Android 7.0 | 10 dari 10 lulus, median 1,24 detik |

Cara kerja uji: file `integration_test/ujian_perangkat_test.dart` menjalankan aplikasi sungguhan lalu memanggil API asli, mencatat latensi dari ketukan tombol sampai halaman hasil terbuka, dan membaca header `Server-Timing` dari layanan untuk memisahkan waktu prediksi, SHAP, LIME, dan jaringan.

## 7. Pemecahan masalah

| Gejala | Penyebab dan penanganan |
|---|---|
| `unauthorized` pada `adb devices` | Ketuk Izinkan di ponsel; atau Opsi pengembang → *Cabut otorisasi debugging USB*, colok ulang |
| `adb devices` kosong | `usbipd attach --wsl --busid <ID>` ulang; periksa kabel data (bukan kabel pengisi daya) |
| `usbipd attach` gagal "Device busy" | `adb.exe kill-server` di Windows; jangan jalankan `adb` Windows bersamaan |
| Pemasangan emulator macet | Emulator melambat; `tool/emulator.sh matikan`, lalu `nyalakan` lagi (data dihapus saat menyala) |
| Laptop hang | RAM habis; jalankan satu hal berat sekali waktu, tutup aplikasi lain |
| Skenario jaringan gagal pada Android 7.0 (`CERTIFICATE_VERIFY_FAILED`) | Penerbit sertifikat server tidak dikenal Android lama. Penerbit saat ini harus Google Trust Services: `echo | openssl s_client -connect api.rmun.tech:443 -servername api.rmun.tech 2>/dev/null \| openssl x509 -noout -issuer`. Bila kembali ke Let's Encrypt, ganti CA Universal SSL di Cloudflare (lihat Bagian 8) |
| "Status layanan" gagal di semua perangkat | Layanan di VPS mati: `curl https://api.rmun.tech/`; di VPS `docker compose ps` dan `docker compose logs -f hoax-api` |
| Rincian waktu gagal ("header=tidak ada") | API di VPS belum memakai `main.py` terbaru; deploy ulang (`docker compose up -d --build hoax-api`) |
| Rekaman layar tidak ada | Perangkat tidak mendukung `screenrecord`, atau uji lebih dari 175 detik |
| Peringatan "running flutter as root" | Aman diabaikan di lingkungan ini |

## 8. Catatan layanan (API)

- Alamat: `https://api.rmun.tech` (VPS, Docker, Cloudflare Tunnel). Deploy ulang: salin `main.py` dan `url_guard.py` ke folder API di VPS lalu `docker compose up -d --build hoax-api`.
- Pengaman tautan (`url_guard.py`): hanya http/https, menolak alamat loopback/privat/link-local, batas 10 detik dan 2 MB, maksimal 3 pengalihan.
- Header `Server-Timing` memuat `prediksi`, `shap`, `lime`, dan `total` dalam milidetik.
- Mengganti otoritas sertifikat Universal SSL Cloudflare dilakukan lewat API (butuh token dengan izin *Zone → SSL and Certificates → Edit* untuk zone `rmun.tech`; hapus token setelah dipakai):
  `curl -X PATCH "https://api.cloudflare.com/client/v4/zones/<ZONE_ID>/ssl/universal/settings" -H "Authorization: Bearer <TOKEN>" -H "Content-Type: application/json" --data '{"certificate_authority":"google"}'`
  Sertifikat baru biasanya terbit dalam beberapa menit. Cloudflare dapat mengubah otoritas sertifikat tanpa pemberitahuan, jadi periksa penerbitnya bila Android lama gagal tersambung.
