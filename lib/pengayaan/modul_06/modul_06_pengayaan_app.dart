import 'package:flutter/material.dart';

import '../../modul_06/models/sesi_pengguna.dart';
import '../../modul_06/services/auth_api.dart';
import 'controllers/sesi_controller.dart';
import 'repositories/sesi_repository.dart';
import 'repositories/memori_sesi_repository.dart';
import 'repositories/prefs_sesi_repository.dart';
import 'repositories/aman_sesi_repository.dart';
import 'storage/penyimpanan_aman_platform.dart';
import 'screens/login_pengayaan_screen.dart';
import 'screens/beranda_pengayaan_screen.dart';

class Modul06PengayaanApp extends StatefulWidget {
final SesiRepository repository;

const Modul06PengayaanApp({
super.key,
required this.repository,
});

@override
State<Modul06PengayaanApp> createState() =>
_Modul06PengayaanAppState();
}

class _Modul06PengayaanAppState
extends State<Modul06PengayaanApp> {
late SesiController _kendali;

SesiPengguna? _sesiLogin;
bool _pilihPenyimpanan = false;
bool _selesaiMemilih = false;
bool _menyimpan = false;

@override
void initState() {
super.initState();

_kendali = SesiController(
repository: widget.repository,
api: const AuthApi(),
);
}

@override
void dispose() {
_kendali.dispose();
super.dispose();
}

void _loginBerhasil() {
final sesi = _kendali.sesi;

if (sesi == null) {
debugPrint('Login berhasil dipanggil, tetapi sesi kosong.');
return;
}

debugPrint('Login berhasil. Membuka pilihan penyimpanan.');

setState(() {
_sesiLogin = sesi;
_pilihPenyimpanan = true;
});
}

void _gantiPenyimpananDariBeranda() {
if (_menyimpan || _kendali.sesi == null) return;

setState(() {
_sesiLogin = _kendali.sesi;
_pilihPenyimpanan = true;
});
}

Future<void> _pilihRepository(
SesiRepository repository,
) async {
final sesi = _sesiLogin;

if (sesi == null || _menyimpan) return;

setState(() {
_menyimpan = true;
});

SesiController? kendaliBaru;

try {
await repository.simpan(sesi);

if (!mounted) return;

kendaliBaru = SesiController(
repository: repository,
api: const AuthApi(),
);

await kendaliBaru.pulihkan();

if (!mounted) {
kendaliBaru.dispose();
return;
}

if (kendaliBaru.status != StatusSesi.masuk ||
kendaliBaru.sesi == null) {
kendaliBaru.dispose();

setState(() {
_menyimpan = false;
});

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(
'Sesi gagal dipulihkan. Silakan coba lagi.',
),
),
);
return;
}

final kendaliLama = _kendali;
final kendaliAktif = kendaliBaru;

setState(() {
_kendali = kendaliAktif;
_sesiLogin = kendaliAktif.sesi;
_pilihPenyimpanan = false;
_selesaiMemilih = true;
_menyimpan = false;
});

kendaliLama.dispose();
} catch (e, stackTrace) {
kendaliBaru?.dispose();

debugPrint('Gagal memilih penyimpanan: $e');
debugPrintStack(stackTrace: stackTrace);

if (!mounted) return;

setState(() {
_menyimpan = false;
});

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('Gagal menyimpan sesi: $e'),
),
);
}
}

Widget _halamanPilihPenyimpanan() {
return Scaffold(
appBar: AppBar(
leading: IconButton(
tooltip: 'Kembali',
icon: const Icon(Icons.arrow_back),
onPressed: _menyimpan
? null
    : () {
if (_selesaiMemilih) {
setState(() {
_pilihPenyimpanan = false;
});
} else {
setState(() {
_pilihPenyimpanan = false;
_sesiLogin = null;
});
}
},
),
title: const Text('Pilih Penyimpanan Sesi'),
),
body: Center(
child: SingleChildScrollView(
padding: const EdgeInsets.all(24),
child: ConstrainedBox(
constraints: const BoxConstraints(maxWidth: 420),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
const Icon(Icons.storage, size: 64),
const SizedBox(height: 16),
const Text(
'Pilih Penyimpanan Sesi',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 8),
const Text(
'Pilih metode penyimpanan untuk sesi login.',
textAlign: TextAlign.center,
),
const SizedBox(height: 24),
ElevatedButton.icon(
onPressed: _menyimpan
? null
    : () => _pilihRepository(
MemoriSesiRepository(),
),
icon: const Icon(Icons.memory),
label: const Text('Memori'),
),
const SizedBox(height: 12),
ElevatedButton.icon(
onPressed: _menyimpan
? null
    : () => _pilihRepository(
PrefsSesiRepository(),
),
icon: const Icon(Icons.settings),
label: const Text('SharedPreferences'),
),
const SizedBox(height: 12),
ElevatedButton.icon(
onPressed: _menyimpan
? null
    : () => _pilihRepository(
AmanSesiRepository(
penyimpanan:
PenyimpananAmanPlatform(),
),
),
icon: const Icon(Icons.lock),
label: const Text('Penyimpanan Aman'),
),
if (_menyimpan) ...[
const SizedBox(height: 20),
const Center(
child: CircularProgressIndicator(),
),
const SizedBox(height: 8),
const Text(
'Menyimpan dan memeriksa sesi...',
textAlign: TextAlign.center,
),
],
],
),
),
),
),
);
}

@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
title: 'Pengayaan Modul 06',
theme: ThemeData(
colorScheme: ColorScheme.fromSeed(
seedColor: Colors.blue,
),
useMaterial3: true,
),
home: AnimatedBuilder(
animation: _kendali,
builder: (context, child) {
if (_pilihPenyimpanan) {
return _halamanPilihPenyimpanan();
}

if (_selesaiMemilih &&
_kendali.status == StatusSesi.masuk &&
_kendali.sesi != null) {
return BerandaPengayaanScreen(
controller: _kendali,
sesi: _kendali.sesi!,
onGantiPenyimpanan:
_gantiPenyimpananDariBeranda,
);
}

return LoginPengayaanScreen(
key: const ValueKey('login-pengayaan'),
controller: _kendali,
onLoginBerhasil: _loginBerhasil,
);
},
),
);
}
}


