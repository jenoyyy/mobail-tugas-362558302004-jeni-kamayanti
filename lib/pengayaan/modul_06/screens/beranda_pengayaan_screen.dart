import 'package:flutter/material.dart';

import '../../../modul_06/models/sesi_pengguna.dart';
import '../controllers/sesi_controller.dart';
import '../widgets/papan_diagnostik_penyimpanan.dart';

class BerandaPengayaanScreen extends StatelessWidget {
  final SesiController controller;
  final SesiPengguna sesi;
  final VoidCallback onGantiPenyimpanan;

  const BerandaPengayaanScreen({
    super.key,
    required this.controller,
    required this.sesi,
    required this.onGantiPenyimpanan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda Pengayaan Modul 06'),
        actions: [
          IconButton(
            tooltip: 'Perbarui sesi',
            onPressed: () async {
              await controller.perbaruiSesi();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.account_circle,
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              'Login Berhasil',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            Text('Nama: ${sesi.nama}'),
            const SizedBox(height: 8),
            Text('Email: ${sesi.email}'),
            const SizedBox(height: 8),
            Text(
              'Peran: ${SesiPengguna.labelPeran(sesi.peran)}',
            ),
            const SizedBox(height: 8),
            Text('Masuk pada: ${sesi.masukPada}'),
            const SizedBox(height: 8),
            Text('Kedaluwarsa pada: ${sesi.kedaluwarsaPada}'),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: onGantiPenyimpanan,
              icon: const Icon(Icons.storage),
              label: const Text('Ganti Penyimpanan'),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () async {
                await controller.pulihkan();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Periksa Sesi'),
            ),

            const SizedBox(height: 16),

            PapanDiagnostikPenyimpanan(
              repository: controller.repository,
            ),
          ],
        ),
      ),
    );
  }
}