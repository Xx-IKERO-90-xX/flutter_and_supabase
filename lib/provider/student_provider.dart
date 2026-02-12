import 'package:flutter/foundation.dart';
import 'package:gestion_alumnos/model/entity/Student.dart';
import 'package:gestion_alumnos/repository/student_repository.dart';

class StudentProvider with ChangeNotifier {
  final StudentRepository _studentRepository = StudentRepository();

  List<Student>? _students;

  StudentProvider() {
    _loadDatabase();
  }

  Future<void> _loadDatabase() async {
    // Esperamos a tener una conexion lista a la BD.
    await _studentRepository.connectDB();
    _students = await _studentRepository.getAllStudents();
    notifyListeners();
  }

  List<Student>? get listStudents => _students;

  get listCourses => null;

  // Método local para obtener la lista de estudiantes de manera asincrona
  // y notificar a los listeners.
  _getAllStudentsAsync() async {
    await Future.delayed(const Duration(seconds: 5));
    _students = await _studentRepository.getAllStudents();
    notifyListeners();
  }

  Future<void> refreshStudents() async {
    _students = await _studentRepository.getAllStudents();
    notifyListeners();
  }

  Future<void> insertStudent(Student student) async {
    await _studentRepository.insertStudent(student);
    await refreshStudents();
  }

  Future<void> updateStudent(Student student) async {
    await _studentRepository.updateStudent(student);
    await refreshStudents();
  }

  Future<void> deleteStudent(int id) async {
    await _studentRepository.deleteStudent(id);
    await refreshStudents();
  }
}
