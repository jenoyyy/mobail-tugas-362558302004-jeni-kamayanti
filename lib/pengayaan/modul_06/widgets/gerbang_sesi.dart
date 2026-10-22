import 'package:flutter/material.dart';

import '../controllers/sesi_controller.dart';
import '../../../modul_06/models/sesi_pengguna.dart';

class GerbangSesi extends StatelessWidget {
  final SesiController controller;

  final Widget Function(BuildContext context) form;

  final Widget Function(
      BuildContext context,
      SesiPengguna sesi,
      ) beranda;

  const GerbangSesi({
    super.key,
    required this.controller,
    required this.form,
    required this.beranda,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        switch (controller.status) {
          case StatusSesi.memeriksa:
          case StatusSesi.memproses:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );

          case StatusSesi.keluar:
            return form(context);

          case StatusSesi.masuk:
            final SesiPengguna? sesi = controller.sesi;

            if (sesi == null) {
              return form(context);
            }

            return beranda(context, sesi);

          case StatusSesi.kedaluwarsa:
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        controller.pesan ??
                            'Sesi telah berakhir. Silakan masuk kembali.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          controller.pulihkan();
                        },
                        child: const Text('Periksa Sesi Lagi'),
                      ),
                    ],
                  ),
                ),
              ),
            );

          case StatusSesi.gagal:
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        controller.pesan ??
                            'Terjadi kesalahan saat memeriksa sesi.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          controller.pulihkan();
                        },
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}