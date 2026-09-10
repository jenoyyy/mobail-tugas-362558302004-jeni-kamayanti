// Model data untuk mata kuliah
class Course {
  final String code;
  final String name;
  final String lecturer;
  final int sks;
  final double progress; // progres silabus (0.0 - 1.0)
  final String room;
  final String category;

  const Course({
    required this.code,
    required this.name,
    required this.lecturer,
    required this.sks,
    required this.progress,
    this.room = 'Lab Komputer 3',
    required this.category,
  });

  // Data mata kuliah Semester 5
  static List<Course> getSampleCourses() {
    return const [
      Course(
        code: 'TRPL501',
        name: 'Pemrograman Web Lanjut + Praktikum',
        lecturer: 'Tim Dosen TRPL',
        sks: 3,
        progress: 0.25,
        room: 'Lab Komputer 3',
        category: 'Praktikum',
      ),
      Course(
        code: 'TRPL502',
        name: 'Interoperabilitas + Praktikum',
        lecturer: 'Tim Dosen TRPL',
        sks: 3,
        progress: 0.30,
        room: 'Lab Komputer 3',
        category: 'Praktikum',
      ),
      Course(
        code: 'TRPL503',
        name: 'Pancasila',
        lecturer: 'Tim Dosen',
        sks: 2,
        progress: 0.40,
        room: 'Ruang Teori 201',
        category: 'Teori',
      ),
      Course(
        code: 'TRPL504',
        name: 'Pemrograman Perangkat Bergerak + Praktikum',
        lecturer: 'Sepyan Purnama Kristanto',
        sks: 4,
        progress: 0.25,
        room: 'Lab Komputer 3',
        category: 'Praktikum',
      ),
      Course(
        code: 'TRPL505',
        name: 'Statistika',
        lecturer: 'Tim Dosen',
        sks: 2,
        progress: 0.35,
        room: 'Ruang Teori 201',
        category: 'Teori',
      ),
    ];
  }
}