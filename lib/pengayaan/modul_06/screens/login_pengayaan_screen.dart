import 'package:flutter/material.dart';

import '../controllers/sesi_controller.dart';

class LoginPengayaanScreen extends StatefulWidget {
  final SesiController controller;
  final VoidCallback? onLoginBerhasil;

  const LoginPengayaanScreen({
    super.key,
    required this.controller,
    this.onLoginBerhasil,
  });

  @override
  State<LoginPengayaanScreen> createState() =>
      _LoginPengayaanScreenState();
}

class _LoginPengayaanScreenState
    extends State<LoginPengayaanScreen> {
  final TextEditingController _emailController =
      TextEditingController(text: 'student@trpl.test');

  final TextEditingController _sandiController =
      TextEditingController(text: 'belajar123');

  bool _memproses = false;
  bool _tampilkanSandi = false;
  String? _pesan;

  @override
  void dispose() {
    _emailController.dispose();
    _sandiController.dispose();
    super.dispose();
  }

  Future<void> _masuk() async {
    if (_memproses) return;

    FocusScope.of(context).unfocus();

    final String email = _emailController.text.trim();
    final String sandi = _sandiController.text;

    if (email.isEmpty || sandi.isEmpty) {
      setState(() {
        _pesan = 'Email dan kata sandi wajib diisi.';
      });
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      setState(() {
        _pesan = 'Masukkan alamat email yang valid.';
      });
      return;
    }

    setState(() {
      _memproses = true;
      _pesan = null;
    });

    debugPrint('TOMBOL MASUK DIKLIK');
    debugPrint('Memulai autentikasi untuk $email');

    try {
      await widget.controller.masuk(
        email: email,
        sandi: sandi,
      );

      debugPrint('CEK LAYAR: mounted = $mounted');
      if (!mounted) return;

      debugPrint(
        'Status login: ${widget.controller.status}',
      );

      if (widget.controller.status == StatusSesi.masuk &&
          widget.controller.sesi != null) {
        debugPrint('LOGIN BERHASIL');

        widget.onLoginBerhasil?.call();
      } else {
        setState(() {
          _pesan = widget.controller.pesan ??
              'Login gagal. Periksa email dan kata sandi.';
        });

        debugPrint('LOGIN GAGAL: $_pesan');
      }
    } catch (e, stackTrace) {
      debugPrint('KESALAHAN LOGIN: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _pesan = 'Terjadi kesalahan saat login: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _memproses = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme warna =
        Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Pengayaan Modul 06'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 450,
            ),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Login Pengayaan',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Masuk untuk mengakses Pengayaan Modul 06.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    TextField(
                      controller: _emailController,
                      keyboardType:
                          TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      enabled: !_memproses,
                      onSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon:
                            Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: _sandiController,
                      obscureText: !_tampilkanSandi,
                      textInputAction: TextInputAction.done,
                      enabled: !_memproses,
                      onSubmitted: (_) => _masuk(),
                      decoration: InputDecoration(
                        labelText: 'Kata sandi',
                        prefixIcon:
                            const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: _memproses
                              ? null
                              : () {
                                  setState(() {
                                    _tampilkanSandi =
                                        !_tampilkanSandi;
                                  });
                                },
                          icon: Icon(
                            _tampilkanSandi
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (_pesan != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: warna.errorContainer,
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                        child: Text(
                          _pesan!,
                          style: TextStyle(
                            color: warna.onErrorContainer,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            _memproses ? null : _masuk,
                        child: _memproses
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Masuk'),
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Akun demo: student@trpl.test',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
