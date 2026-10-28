# Analisis Fishbone DigiFact

Tabel analisis fishbone: penyebab, akibat, dan penanganan.

| Kelompok | Penyebab | Akibat | Penanganan dalam Penelitian |
| --- | --- | --- | --- |
| Arsitektur kode | Logika bisnis dan akses data berada di *State* *widget*; layar memakai layanan konkret | Kode terikat pada implementasi dan perubahan merambat ke banyak layar | Pemisahan tiga lapisan dengan *Clean Architecture*; GetX di lapisan *presentation* |
| Pengujian | Tidak ada pengujian yang bermakna; berkas layar sangat panjang | Aturan bisnis tidak dapat diuji tanpa Flutter | Aturan bisnis dipindah ke *use case*; pengujian otomatis berlapis |
| Integrasi layanan | Format jawaban API dibaca langsung oleh tampilan; kegagalan jaringan tidak dipetakan | Perubahan format jawaban atau kegagalan layanan merusak tampilan | Kontrak repositori di *domain*, pemetaan model di *data*, kegagalan bertipe |
| Model dan data | Data latih hanya dari dua sumber; belum diuji pada data eksternal; hasil tanpa penjelasan | Akurasi internal menyesatkan dan pengguna tidak mengetahui alasan vonis | Pembersihan data, uji eksternal, ambang keputusan, serta penjelasan SHAP dan LIME |
