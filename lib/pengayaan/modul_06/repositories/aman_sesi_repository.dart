import 'dart:convert';

import '../../../modul_06/models/sesi_pengguna.dart';
import '../storage/penyimpanan_aman.dart';
import 'sesi_repository.dart';

class AmanSesiRepository implements SesiRepository {
  static const String kunciSesi = 'sesi_pengguna';

  final PenyimpananAman penyimpanan;

  AmanSesiRepository({
    required this.penyimpanan,
  });

  @override
  String get nama => 'Penyimpanan Aman';

  @override
  String get keterangan =>
      'Penyimpanan sesi menggunakan adapter penyimpanan aman.';

  @override
  bool get bertahanSetelahRestart => true;

  @override
  Future<SesiPengguna?> baca() async {
    final String? data = await penyimpanan.baca(kunciSesi);

    if (data == null || data.isEmpty) {
      return null;
    }

    final dynamic hasil = jsonDecode(data);

    if (hasil is! Map<String, dynamic>) {
      throw const FormatException('Format data sesi tidak valid.');
    }

    return SesiPengguna.fromJson(hasil);
  }

  @override
  Future<void> simpan(SesiPengguna sesi) async {
    final String data = jsonEncode(sesi.toJson());
    await penyimpanan.tulis(kunciSesi, data);
  }

  @override
  Future<void> hapus() async {
    await penyimpanan.hapus(kunciSesi);
  }

  @override
  Future<bool> adaSesi() async {
    return await penyimpanan.baca(kunciSesi) != null;
  }

  @override
  Future<String?> intipMentah() {
    return penyimpanan.bacaMentah(kunciSesi);
  }
}