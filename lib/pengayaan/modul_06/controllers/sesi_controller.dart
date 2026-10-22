
import 'package:flutter/foundation.dart';

import '../../../modul_06/models/sesi_pengguna.dart';
import '../../../modul_06/services/auth_api.dart';
import '../repositories/sesi_repository.dart';

enum StatusSesi {
  memeriksa,
  keluar,
  memproses,
  masuk,
  gagal,
  kedaluwarsa,
}

class SesiController extends ChangeNotifier {
  final SesiRepository repository;
  final AuthApi api;
  final DateTime Function() jam;

  SesiController({
    required this.repository,
    required this.api,
    DateTime Function()? jam,
  }) : jam = jam ?? DateTime.now;

  StatusSesi _status = StatusSesi.memeriksa;
  SesiPengguna? _sesi;
  String? _pesan;

  StatusSesi get status => _status;
  SesiPengguna? get sesi => _sesi;
  String? get pesan => _pesan;

  void _ubah(
    StatusSesi status, {
    SesiPengguna? sesi,
    String? pesan,
    bool bersihkanPesan = false,
  }) {
    _status = status;

    if (sesi != null ||
        status == StatusSesi.keluar ||
        status == StatusSesi.kedaluwarsa) {
      _sesi = sesi;
    }

    if (bersihkanPesan) {
      _pesan = null;
    } else if (pesan != null) {
      _pesan = pesan;
    }

    notifyListeners();
  }

  Future<void> masuk({
    required String email,
    required String sandi,
    Duration masaBerlaku = const Duration(hours: 2),
    bool simpanSesi = true,
  }) async {
    _ubah(
      StatusSesi.memproses,
      bersihkanPesan: true,
    );

    try {
      print('CEK 1: Mulai proses login');
      final SesiPengguna sesiBaru = await api.masuk(
        email: email,
        sandi: sandi,
        masaBerlaku: masaBerlaku,
      );
      print('CEK 2: API login selesai');

      if (simpanSesi) {
        print('CEK 3: Mulai simpan sesi');
        await repository.simpan(sesiBaru);
        print('CEK 4: Sesi berhasil disimpan');
      }

      _ubah(
        StatusSesi.masuk,
        sesi: sesiBaru,
      );
      print('CEK 5: Status masuk sudah diubah');
    } on AuthException catch (e) {
      _ubah(
        StatusSesi.gagal,
        pesan: e.pesan,
      );
    } catch (_) {
      _ubah(
        StatusSesi.gagal,
        pesan: 'Terjadi kesalahan. Silakan coba lagi.',
      );
    }
  }

  Future<void> pulihkan() async {
    _ubah(
      StatusSesi.memeriksa,
      bersihkanPesan: true,
    );

    try {
      final SesiPengguna? tersimpan = await repository.baca();

      if (tersimpan == null) {
        _ubah(StatusSesi.keluar, sesi: null);
        return;
      }

      if (tersimpan.sudahKedaluwarsa(jam())) {
        await repository.hapus();

        _ubah(
          StatusSesi.kedaluwarsa,
          sesi: null,
          pesan: 'Sesi Anda sudah berakhir. Silakan masuk kembali.',
        );
        return;
      }

      _ubah(
        StatusSesi.masuk,
        sesi: tersimpan,
      );
    } catch (_) {
      _ubah(
        StatusSesi.gagal,
        sesi: null,
        pesan: 'Sesi gagal dipulihkan. Silakan coba lagi.',
      );
    }
  }

  Future<void> perbaruiSesi({
    Duration masaBerlaku = const Duration(hours: 2),
  }) async {
    final SesiPengguna? sekarang = _sesi;

    if (sekarang == null) return;

    if (sekarang.sudahKedaluwarsa(jam())) {
      await repository.hapus();

      _ubah(
        StatusSesi.kedaluwarsa,
        sesi: null,
        pesan: 'Sesi sudah berakhir dan tidak dapat diperbarui.',
      );
      return;
    }

    _ubah(
      StatusSesi.memproses,
      bersihkanPesan: true,
    );

    try {
      final SesiPengguna baru = await api.perbaruiSesi(
        sekarang,
        masaBerlaku: masaBerlaku,
      );

      await repository.simpan(baru);

      _ubah(
        StatusSesi.masuk,
        sesi: baru,
      );
    } catch (_) {
      _ubah(
        StatusSesi.gagal,
        sesi: sekarang,
        pesan: 'Sesi gagal diperbarui. Silakan coba lagi.',
      );
    }
  }
}



