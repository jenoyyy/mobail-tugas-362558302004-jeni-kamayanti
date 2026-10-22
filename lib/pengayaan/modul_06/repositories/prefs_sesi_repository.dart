import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../modul_06/models/sesi_pengguna.dart';
import 'sesi_repository.dart';

class PrefsSesiRepository implements SesiRepository {
  static const String kunciSesi = 'sesi_pengguna';

  @override
  String get nama => 'SharedPreferences';

  @override
  String get keterangan =>
      'Penyimpanan sesi menggunakan SharedPreferences.';

  @override
  bool get bertahanSetelahRestart => true;

  Future<SharedPreferences> get _prefs async {
    return SharedPreferences.getInstance();
  }

  @override
  Future<SesiPengguna?> baca() async {
    final prefs = await _prefs;
    final String? data = prefs.getString(kunciSesi);

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
    final prefs = await _prefs;
    final String data = jsonEncode(sesi.toJson());

    await prefs.setString(kunciSesi, data);
  }

  @override
  Future<void> hapus() async {
    final prefs = await _prefs;
    await prefs.remove(kunciSesi);
  }

  @override
  Future<bool> adaSesi() async {
    final prefs = await _prefs;
    return prefs.containsKey(kunciSesi);
  }

  @override
  Future<String?> intipMentah() async {
    final prefs = await _prefs;
    return prefs.getString(kunciSesi);
  }
}