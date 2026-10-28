// Uji integrasi di perangkat: menjalankan aplikasi sungguhan terhadap API asli.
// Keluaran berbaris "UJI|nama|LULUS/GAGAL|detail" untuk dicatat sebagai bukti.
//
//   flutter test integration_test/ujian_perangkat_test.dart -d <id perangkat>
import 'package:digifact/app/routes/app_routes.dart';
import 'package:digifact/core/constants/api_constants.dart';
import 'package:digifact/main.dart' as app;
import 'package:digifact/presentation/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';

const teksValid =
    'Pemerintah daerah mengumumkan bahwa bantuan sosial tunai akan dibagikan kepada seluruh warga '
    'melalui tautan pendaftaran yang beredar di grup percakapan dengan tenggat hari ini juga '
    'sehingga masyarakat diminta segera mengisi data pribadi mereka pada laman tersebut.';
const teksPendekNetral = 'Bantuan tunai pemerintah dibagikan kepada seluruh warga hari ini.';
const tombol = 'ANALISIS BERITA SEKARANG';

void lapor(String nama, bool ok, [String detail = '']) =>
    // ignore: avoid_print
    print('UJI|$nama|${ok ? 'LULUS' : 'GAGAL'}|$detail');

Future<bool> tunggu(WidgetTester t, bool Function() syarat, {int detik = 20}) async {
  final sw = Stopwatch()..start();
  while (!syarat()) {
    await t.pump(const Duration(milliseconds: 100));
    if (sw.elapsed > Duration(seconds: detik)) return false;
  }
  return true;
}

Future<void> beri(WidgetTester t, int ms) async {
  for (var i = 0; i < ms ~/ 100; i++) {
    await t.pump(const Duration(milliseconds: 100));
  }
}

Future<void> ketuk(WidgetTester t, Finder f) async {
  await t.ensureVisible(f);
  await t.pump(const Duration(milliseconds: 300));
  await t.tap(f, warnIfMissed: false);
}

Future<int> ukur(WidgetTester t, String teks) async {
  await t.enterText(find.byType(TextField), teks);
  await t.pump();
  await beri(t, 500);
  final sw = Stopwatch()..start();
  await ketuk(t, find.text(tombol));
  final ok = await tunggu(t, () => Get.currentRoute == Routes.result, detik: 35);
  sw.stop();
  return ok ? sw.elapsedMilliseconds : -1;
}

Future<void> kembali(WidgetTester t) async {
  Get.back();
  await tunggu(t, () => Get.currentRoute == Routes.home, detik: 5);
  await beri(t, 600);
}

double median(List<double> x) {
  final u = [...x]..sort();
  return u[u.length ~/ 2];
}

/// Rincian waktu: permintaan langsung ke API dari ponsel (tanpa UI), dibandingkan
/// dengan header Server-Timing dari layanan. Selisihnya adalah jaringan dan koneksi.
Future<void> ukurRincian() async {
  final total = <double>[], pred = <double>[], shap = <double>[], lime = <double>[], srv = <double>[];
  for (var i = 0; i < 5; i++) {
    final sw = Stopwatch()..start();
    final r = await http
        .post(
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.detectPath}'),
          headers: {'Content-Type': 'application/json'},
          body: '{"teks_berita": "$teksValid"}',
        )
        .timeout(const Duration(seconds: 35));
    sw.stop();
    final h = r.headers['server-timing'];
    if (r.statusCode != 200 || h == null) {
      lapor('rincian waktu (Server-Timing)', false, 'status=${r.statusCode}; header=${h ?? 'tidak ada'}');
      return;
    }
    final m = {
      for (final x in RegExp(r'([A-Za-z0-9_-]+);dur=([0-9.]+)').allMatches(h)) x.group(1)!: double.parse(x.group(2)!),
    };
    if (!{'prediksi', 'shap', 'lime', 'total'}.every(m.containsKey)) {
      lapor('rincian waktu (Server-Timing)', false, 'header tidak lengkap: $h');
      return;
    }
    total.add(sw.elapsedMilliseconds.toDouble());
    pred.add(m['prediksi']!);
    shap.add(m['shap']!);
    lime.add(m['lime']!);
    srv.add(m['total']!);
  }
  final jaringan = [for (var i = 0; i < total.length; i++) total[i] - srv[i]];
  String f(double v) => v.toStringAsFixed(0);
  lapor('rincian waktu (Server-Timing)', true,
      'median ms: total=${f(median(total))}; layanan=${f(median(srv))} '
      '(prediksi=${f(median(pred))}, shap=${f(median(shap))}, lime=${f(median(lime))}); '
      'jaringan dan koneksi=${f(median(jaringan))}');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('uji perangkat DigiFact', (t) async {
    app.main();
    final lanjut = find.text('Lanjutkan');
    final adaPembuka = await tunggu(t, () => lanjut.evaluate().isNotEmpty, detik: 20);
    lapor('onboarding tampil pada pemasangan baru', adaPembuka);
    if (adaPembuka) {
      for (var i = 0; i < 2; i++) {
        await t.tap(lanjut);
        await beri(t, 1500);
      }
      await t.tap(find.text('Mulai Menggunakan DigiFact'));
    }
    final beranda = await tunggu(t, () => find.text(tombol).evaluate().isNotEmpty, detik: 15);
    lapor('onboarding sampai beranda', beranda);

    final online = await tunggu(t, () => find.text('Server Online').evaluate().isNotEmpty, detik: 10);
    lapor('status layanan online', online);

    // Validasi masukan: terlalu pendek, permintaan tidak dikirim.
    await t.enterText(find.byType(TextField), 'pendek');
    await t.pump();
    await ketuk(t, find.text(tombol));
    await beri(t, 1500);
    lapor('masukan kurang dari 10 karakter ditolak', Get.currentRoute == Routes.home);
    await beri(t, 5000); // tunggu notifikasi validasi hilang

    // Teks kurang dari 12 kata: vonis netral dari layanan.
    final netral = await ukur(t, teksPendekNetral);
    lapor('teks kurang dari 12 kata menghasilkan hasil', netral > 0, '${netral}ms');
    if (netral > 0) {
      await beri(t, 1500);
      await kembali(t);
    }

    // Latensi end-to-end, teks valid, 5 kali.
    final waktu = <int>[];
    for (var i = 0; i < 5; i++) {
      final ms = await ukur(t, teksValid);
      if (ms > 0) {
        waktu.add(ms);
        await beri(t, 1500);
        await kembali(t);
      }
    }
    if (waktu.isNotEmpty) {
      final urut = [...waktu]..sort();
      final median = urut[urut.length ~/ 2];
      lapor('latensi end-to-end teks valid', waktu.length == 5,
          'n=${waktu.length}; median=${median}ms; maks=${urut.last}ms; semua=$waktu');
    } else {
      lapor('latensi end-to-end teks valid', false, 'tidak ada hasil');
    }

    await ukurRincian();

    // Tautan ke alamat internal harus ditolak layanan.
    await t.enterText(find.byType(TextField), 'http://127.0.0.1/rahasia');
    await t.pump();
    await beri(t, 500);
    await ketuk(t, find.text(tombol));
    final ditolak = await tunggu(t, () => find.textContaining('ditolak').evaluate().isNotEmpty, detik: 20);
    lapor('tautan alamat internal ditolak', ditolak && Get.currentRoute == Routes.home);
    if (Get.isDialogOpen ?? false) Get.back();
    await beri(t, 800);

    // Riwayat tersimpan lokal.
    final ctrl = Get.find<HomeController>();
    ctrl.loadRecentHistory();
    lapor('riwayat tersimpan', ctrl.recentHistory.isNotEmpty, 'terbaru=${ctrl.recentHistory.length}');
    Get.toNamed(Routes.history);
    await beri(t, 1500);
    lapor('halaman riwayat terbuka', Get.currentRoute == Routes.history);
  });
}
