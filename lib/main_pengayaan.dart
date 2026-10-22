import 'package:flutter/material.dart';

import 'pengayaan/modul_06/modul_06_pengayaan_app.dart';
import 'pengayaan/modul_06/repositories/memori_sesi_repository.dart';

void main() {
  runApp(
    Modul06PengayaanApp(
      repository: MemoriSesiRepository(),
    ),
  );
}