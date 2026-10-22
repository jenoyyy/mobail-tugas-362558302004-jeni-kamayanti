import 'package:flutter/material.dart';

import '../repositories/sesi_repository.dart';

class PapanDiagnostikPenyimpanan extends StatefulWidget {
  final SesiRepository repository;

  const PapanDiagnostikPenyimpanan({
    super.key,
    required this.repository,
  });

  @override
  State<PapanDiagnostikPenyimpanan> createState() =>
      _PapanDiagnostikPenyimpananState();
}

class _PapanDiagnostikPenyimpananState
    extends State<PapanDiagnostikPenyimpanan> {
  bool _sedangMengintip = false;
  bool _sudahMengintip = false;
  String? _hasilIntip;
  String? _pesanKesalahan;

  Future<void> _intip() async {
    setState(() {
      _sedangMengintip = true;
      _pesanKesalahan = null;
    });

    try {
      final String? hasil = await widget.repository.intipMentah();

      if (!mounted) return;

      setState(() {
        _hasilIntip = hasil;
        _sudahMengintip = true;
        _sedangMengintip = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _pesanKesalahan = 'Gagal membaca data: $e';
        _sudahMengintip = true;
        _sedangMengintip = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Diagnostik Penyimpanan Sesi',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('Repository: ${widget.repository.nama}'),
            const SizedBox(height: 4),
            Text(widget.repository.keterangan),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _sedangMengintip ? null : _intip,
                icon: const Icon(Icons.search),
                label: Text(
                  _sedangMengintip
                      ? 'Sedang memeriksa...'
                      : 'Intip Data Mentah',
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_sedangMengintip)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (_sudahMengintip && !_sedangMengintip) ...[
              const Text(
                'Hasil pemeriksaan:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SelectableText(
                _pesanKesalahan ??
                    (_hasilIntip ?? 'Tidak ada data mentah yang tersedia.'),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'Bertahan setelah aplikasi dimulai ulang: '
                  '${widget.repository.bertahanSetelahRestart ? "Ya" : "Tidak"}',
            ),
          ],
        ),
      ),
    );
  }
}