import 'package:flutter/material.dart';
import 'package:gestion_alumnos/model/entity/Cours.dart';
import 'package:gestion_alumnos/provider/cours_provider.dart';
import 'package:provider/provider.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<CoursesScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _showDeleteConfirm(
    CoursProvider appProvider,
    BuildContext context,
    Cours cours,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure that you want to delete this Cours?'),
        content: Row(
          children: [
            TextButton(
              onPressed: () => {
                appProvider.deleteCourse(cours.id!),
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

  void _showAddDialog(CoursProvider appProvider) {
    final nameController = TextEditingController();
    final hoursController = TextEditingController();

    showDialog(
      context: this.context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Cours'),
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
              controller: hoursController,
              decoration: const InputDecoration(
                labelText: 'Hours',
                hintText: 'Enter hours',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Validate input
              if (nameController.text.isEmpty || hoursController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }

              int? hours = int.tryParse(hoursController.text);
              if (hours == null || hours <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid age')),
                );
                return;
              }

              // Save the student to the database
              await appProvider.insertCours(
                Cours(name: nameController.text.trim(), hours: hours),
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
    var appProvider = Provider.of<CoursProvider>(context);

    return Scaffold(
      body: StreamBuilder<List<Cours>>(
        stream: Stream.value(appProvider.listCourses ?? []),
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
          return SingleChildScrollView(
            child: _creaListViewStudents(students, appProvider),
          );
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
    List<Cours> courses,
    CoursProvider appProvider,
  ) {
    return ListView.separated(
      shrinkWrap: true, // IMPORTANTE
      physics: NeverScrollableScrollPhysics(),
      itemCount: courses.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final cours = courses[index];
        return ListTile(
          leading: CircleAvatar(child: Text("${cours.id!}")),
          title: Text(cours.name),
          subtitle: Text('Age: ${cours.hours}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  _showDeleteConfirm(appProvider, context, cours);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
