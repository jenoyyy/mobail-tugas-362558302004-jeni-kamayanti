import 'package:flutter/material.dart';
import '../models/course.dart';

// Banner header profil mahasiswa di bagian atas dashboard

class HeaderBanner extends StatelessWidget {
  final String studentName;
  final String nim;
  final List<Course> courses;

  const HeaderBanner({
    super.key,
    this.studentName = 'Jeni Kamayanti',
    this.nim = '362558302004',
    required this.courses,
  });

  // Menghitung total SKS dari semua mata kuliah
  int get totalSks {
    return courses.fold(0, (sum, course) => sum + course.sks);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0284C7).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Semester 5 (2026/2027)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.notifications_active_outlined,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            'Selamat Datang, $studentName ($nim)',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'Dashboard Akademik & Proyek',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Badge total SKS
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatPill(
                icon: Icons.school,
                label: '$totalSks SKS',
              ),
              _StatPill(
                icon: Icons.task_alt,
                label: '${courses.length} Matakuliah',
              ),
              const _StatPill(
                icon: Icons.grade,
                label: 'IPK 3.85',
              ),
              const _StatPill(
                icon: Icons.calendar_month,
                label: '100% Hadir',
              ),
            ],
          ),

          // Peringatan jika total SKS lebih dari 24
          if (totalSks > 24) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade700,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Peringatan: Total SKS melebihi batas maksimal 24 SKS per semester!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Widget kecil untuk menampilkan pill status
class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatPill({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}