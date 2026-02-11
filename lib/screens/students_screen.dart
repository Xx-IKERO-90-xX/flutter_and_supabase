import 'package:flutter/material.dart';
import 'package:gestion_alumnos/model/entity/Student.dart';
import 'package:gestion_alumnos/provider/student_provider.dart';
import 'package:provider/provider.dart';
import 'package:gestion_alumnos/screens/editstudent_screen.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _showDeleteConfirm(
    StudentProvider appProvider,
    BuildContext context,
    Student student,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure that you want to delete this Student?'),
        content: Row(
          children: [
            TextButton(
              onPressed: () => {
                appProvider.deleteStudent(student.id!),
                Navigator.pop(context),
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

  void _showAddDialog(StudentProvider appProvider) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();

    showDialog(
      context: this.context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Student'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter student name',
              ),
              textCapitalization: TextCapitalization.words,
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(
                labelText: 'Age',
                hintText: 'Enter student age',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Validate input
              if (nameController.text.isEmpty || ageController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }

              int? age = int.tryParse(ageController.text);
              if (age == null || age <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid age')),
                );
                return;
              }

              // Save the student to the database
              await appProvider.insertStudent(
                Student(
                  name: nameController.text.trim(),
                  age: age,
                  imgUrl: null,
                  course: null,
                ),
              );

              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Definimos la referencia al provider
    var appProvider = Provider.of<StudentProvider>(context);

    return Scaffold(
      body: StreamBuilder<List<Student>>(
        stream: Stream.value(appProvider.listStudents ?? []),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No students yet! Tap the + button to add one.',
                textAlign: TextAlign.center,
              ),
            );
          }

          // Mostramos la lista de estudiantes
          final students = snapshot.data!;
          return _creaListViewStudents(students, appProvider);
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(appProvider),
        tooltip: 'Add Student',
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView _creaListViewStudents(
    List<Student> students,
    StudentProvider appProvider,
  ) {
    return ListView.separated(
      itemCount: students.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final student = students[index];
        return ListTile(
          leading: CircleAvatar(
            child: Image.network(
              student.imgUrl?.isNotEmpty == true
                  ? student.imgUrl!
                  : "https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png?20200919003010",
            ),
          ),
          title: Text(student.name),
          subtitle: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Age: ${student.age}"),
              if (student.course != null) ...[
                const SizedBox(width: 12),
                Text("Course: ${student.course!.name}"),
              ],
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  _showDeleteConfirm(appProvider, context, student);
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FormEditStudent(student),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
