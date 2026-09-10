import 'package:flutter/material.dart';
import 'models/course.dart';
import 'widgets/course_card.dart';
import 'widgets/header_banner.dart';

class AcademicDashboardScreen extends StatefulWidget {
  const AcademicDashboardScreen({super.key});

  @override
  State<AcademicDashboardScreen> createState() => _AcademicDashboardScreenState();
}

class _AcademicDashboardScreenState extends State<AcademicDashboardScreen> {
  final List<Course> _courses = Course.getSampleCourses();
  bool _isDarkMode = false;
  String _selectedCategory = 'Semua';

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  List<Course> get _filteredCourses {
    if (_selectedCategory == 'Semua') {
      return _courses;
    }

    return _courses
        .where((course) => course.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0284C7),
          brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        ),
        useMaterial3: true,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Dashboard Akademik TRPL',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF0284C7),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(
                _isDarkMode
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
              ),
              tooltip: _isDarkMode ? 'Mode Terang' : 'Mode Gelap',
              onPressed: _toggleDarkMode,
            ),
          ],
        ),

        body: LayoutBuilder(
          builder: (context, constraints) {
            // Tampilan tablet / landscape
            if (constraints.maxWidth >= 600) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
  flex: 2,
  child: SingleChildScrollView(
    child: HeaderBanner(
      courses: _courses,
    ),
  ),
),

                    const SizedBox(width: 20),

                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8.0,
                            children: [
                              'Semua',
                              'Teori',
                              'Praktikum',
                            ].map((category) {
                              return ChoiceChip(
                                label: Text(category),
                                selected:
                                    _selectedCategory == category,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedCategory = category;
                                    });
                                  }
                                },
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 16),

                          Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 340,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                mainAxisExtent: 240,
                              ),
                              itemCount: _filteredCourses.length,
                              itemBuilder: (context, index) {
                                return CourseCard(
                                  course: _filteredCourses[index],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            // Tampilan smartphone
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
              HeaderBanner(
  courses: _courses,
),

                const SizedBox(height: 16),

                Wrap(
                  spacing: 8.0,
                  children: [
                    'Semua',
                    'Teori',
                    'Praktikum',
                  ].map((category) {
                    return ChoiceChip(
                      label: Text(category),
                      selected: _selectedCategory == category,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                Text(
                  'Mata Kuliah Semester 5 (${_filteredCourses.length} Terdaftar)',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                ..._filteredCourses.map(
                  (course) => CourseCard(course: course),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}