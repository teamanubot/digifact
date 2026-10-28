# Iterasi Pengembangan DigiFact (Lampiran 9)

Pekerjaan restrukturisasi dikelompokkan menjadi lima iterasi. Pengelompokan disusun dari catatan pengembangan pada dokumen arsitektur DigiFact; setiap iterasi menghasilkan bagian aplikasi yang dapat dijalankan dan kasus uji yang menyertainya.

| Iterasi | *User story* | Bagian Aplikasi Selesai | Kasus Uji | Catatan Perbaikan |
| --- | --- | --- | --- | --- |
| 1 | Sebagai pengembang, saya ingin kondisi kode awal terukur dan tampilannya terekam agar perubahan dapat dibandingkan. | Skrip pengukur arsitektur; daftar fitur setara; gambar acuan 10 keadaan layar. | 10 uji *golden* sebagai acuan tampilan. | Seluruh pengukuran memakai skrip yang sama pada kode awal dan akhir. |
| 2 | Sebagai pengguna, saya ingin teks yang saya periksa divalidasi dan dikirim ke layanan dengan benar. | Lapisan *domain* (*entity*, *use case*, kontrak repositori) dan *data* (model, sumber data, repositori). | 16 uji *domain* dan 20 uji *data*, termasuk *contract test*. | Daftar riwayat bertipe keliru saat disisipkan hasil biasa, diperbaiki setelah *contract test*. |
| 3 | Sebagai pengguna, saya ingin melihat status pemuatan dan hasil dengan benar. | Pengendali GetX, *binding*, dan rute bernama. | 22 uji pengendali. | Status memuat tetap menyala selama halaman hasil terbuka; diperbaiki dengan mematikannya sebelum berpindah halaman. Kegagalan simpan riwayat tidak lagi menyembunyikan vonis. |
| 4 | Sebagai pengembang, saya ingin layar yang panjang dipecah tanpa mengubah tampilan. | *Screen* sebagai perakit *widget* kecil; penanda tebal pada analisis dirender. | 10 uji *golden* identik, 14 uji alur antarmuka, 3 uji penanda tebal (4 uji *golden* tambahan pada perbaikan berikutnya). | Teks analisis menampilkan penanda tebal mentah; ditambah pengurai penanda. |
| 5 | Sebagai peneliti, saya ingin aturan arsitektur ditegakkan otomatis dan klaim isolasi perubahan dibuktikan. | Pengujian arsitektur, studi kasus perubahan, dan perbandingan pustaka pengelola status. | 7 uji arsitektur dan 12 uji pembanding. | Pengujian arsitektur mula-mula tidak mendeteksi pelanggaran karena jalur relatif; diperbaiki dan divalidasi dengan pelanggaran sengaja. |
