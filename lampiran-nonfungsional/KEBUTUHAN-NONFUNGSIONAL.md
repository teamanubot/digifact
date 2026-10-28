# Kebutuhan Nonfungsional DigiFact (Lampiran 9)

Kebutuhan nonfungsional mencakup perangkat keras, perangkat lunak, dan sifat sistem yang diharapkan. Konfigurasi peladen merupakan usulan, bukan hasil pengukuran.

| Kategori | Kebutuhan |
| --- | --- |
| Perangkat keras pengembangan | Komputer berprosesor Intel Core i7-13700HX (24 *thread*) dengan RAM yang tersedia bagi WSL 2 sekitar 8 GB |
| Peladen | VPS dengan 2 vCPU, RAM 4 GB, dan penyimpanan SSD 40 GB |
| Perangkat uji | Ponsel Android fisik Xiaomi POCO F5 (Android 15, API 35, 1080 × 2400, RAM sekitar 11 GB) dan Linux *desktop* dengan jendela berukuran tablet (1080 × 1920) untuk uji otomatis; emulator Android 11 (API 30) dan Android 7.0 (API 24) berukuran 1080 × 1920 |
| Sistem operasi | Pengembangan: Windows dengan WSL 2 (Ubuntu 22.04.5 LTS). Peladen: Ubuntu Server 22.04 LTS. Perangkat sasaran: Android 7.0 atau lebih baru |
| Perangkat lunak aplikasi | Flutter 3.44.4, Dart 3.12.2, GetX 4.7.3, paket http dan shared_preferences |
| Perangkat lunak layanan | Python 3.10, FastAPI 0.104.1, Uvicorn 0.24.0, scikit-learn 1.7.2, SHAP 0.49.1, LIME 0.2.0.1 |
| Infrastruktur | Docker dan Docker Compose, Cloudflare Tunnel |
| Kinerja | Median latensi *end-to-end* di ponsel di bawah 5 detik dan tidak melebihi batas deteksi 30 detik (hasil awal: median 1,62 detik pada Wi-Fi dan 1,79 detik pada LTE) |
| Keandalan | Aplikasi menampilkan pesan yang jelas ketika layanan tidak tersedia atau melampaui batas waktu (4 detik untuk pengecekan layanan dan 30 detik untuk deteksi) |
| Batas masukan | Minimal 10 karakter pada aplikasi dan peladen; model dievaluasi pada 12 sampai 60 kata, dan teks yang lebih panjang dipotong pada 60 kata pertama |
| Keamanan komunikasi | Komunikasi antara aplikasi dan layanan memakai HTTPS |
