import 'package:flutter/material.dart';
import 'package:gestion_alumnos/model/entity/Cours.dart';
import 'package:gestion_alumnos/model/entity/Student.dart';
import 'package:gestion_alumnos/provider/student_provider.dart';
import 'package:provider/provider.dart';
import 'package:gestion_alumnos/provider/cours_provider.dart';

class FormEditStudent extends StatefulWidget {
  const FormEditStudent(this.student, {super.key});

  final Student student;

  @override
  State<FormEditStudent> createState() => _FormEditStudentState();
}

class _FormEditStudentState extends State<FormEditStudent> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController imgController;

  Cours? _selectedCourse;
  final _formKey = GlobalKey<FormState>();

  static const defaultAvatar =
      "https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png?20200919003010";

  @override
  void initState() {
    super.initState();

    final student = widget.student;

    nameController = TextEditingController(text: student.name);
    ageController = TextEditingController(text: student.age.toString());
    imgController = TextEditingController(text: student.imgUrl);
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    imgController.dispose();
    super.dispose();
  }

  void _showConfirm(StudentProvider appProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Do you want to keep editing?'),
        content: Row(
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // volver a lista
              },
              child: const Text('No'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirm(StudentProvider appProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure you want to delete this Student?'),
        content: Row(
          children: [
            TextButton(
              onPressed: () async {
                await appProvider.deleteStudent(widget.student.id!);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<StudentProvider>(context);
    final coursProvider = Provider.of<CoursProvider>(context);

    final courses = coursProvider.listCourses;

    /// Inicializar selección SOLO UNA VEZ
    if (_selectedCourse == null && courses != null) {
      _selectedCourse = courses.firstWhere(
        (c) => c.id == widget.student.course?.id,
        orElse: () => courses.first,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Student Database')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 590,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image.network(
                        imgController.text.isEmpty
                            ? defaultAvatar
                            : imgController.text,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: ageController,
                        decoration: const InputDecoration(labelText: 'Age'),
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: imgController,
                        decoration: const InputDecoration(
                          labelText: 'Image Url',
                        ),
                      ),

                      const SizedBox(height: 16),

                      DropdownButtonFormField<Cours>(
                        value: _selectedCourse,
                        decoration: const InputDecoration(
                          labelText: "Curso",
                          border: OutlineInputBorder(),
                        ),
                        items: courses?.map((course) {
                          return DropdownMenuItem<Cours>(
                            value: course,
                            child: Text(course.name),
                          );
                        }).toList(),
                        onChanged: (course) {
                          setState(() {
                            _selectedCourse = course;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),

                          TextButton(
                            onPressed: () async {
                              if (nameController.text.isEmpty ||
                                  ageController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Campos vacíos'),
                                  ),
                                );
                                return;
                              }

                              final ageInput = int.tryParse(ageController.text);

                              if (ageInput == null || ageInput <= 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Edad no válida'),
                                  ),
                                );
                                return;
                              }

                              final newStudent = widget.student.copyWith(
                                name: nameController.text,
                                age: ageInput,
                                imgUrl: imgController.text,
                                course: _selectedCourse,
                              );

                              await appProvider.updateStudent(newStudent);

                              _showConfirm(appProvider);
                            },
                            child: const Text('Save'),
                          ),

                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _showDeleteConfirm(appProvider),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
