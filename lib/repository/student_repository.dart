import 'package:gestion_alumnos/data/student_datasource.dart';
import 'package:gestion_alumnos/model/entity/Student.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentRepository {
  StudentDatasource? _dataSource;

  StudentRepository._();

  // Instancia única del repositorio. La podemos crear directamente
  // en la inicialización
  static final StudentRepository _instance = StudentRepository._();

  // Cuando se nos pida el repositorio, se devuelve la instancia única.
  factory StudentRepository() {
    return _instance;
  }

  // Connexión a la base de datos (datasource)
  Future<void> connectDB() async {
    if (_dataSource == null) {
      await Supabase.initialize(
        url: "https://hzcsvvlpdwdtwzosljxe.supabase.co",
        anonKey:
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh6Y3N2dmxwZHdkdHd6b3NsanhlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA1NTE2MzIsImV4cCI6MjA4NjEyNzYzMn0.m7CLsAonBLH3jKai58i58bXtOCb4FmjmPHzZ6lfSUlE",
      );
      _dataSource = StudentDatasource(Supabase.instance.client);
    }
  }

  Stream<List<Student>> streamAllStudents() {
    return _dataSource?.streamAllStudents() ?? const Stream.empty();
  }

  Future<List<Student>>? getAllStudents() {
    return _dataSource?.getAllStudents() ?? Future.value([]);
  }

  Future<void> updateStudent(Student student) async {
    return _dataSource?.updateStudent(student);
  }

  Future<void> insertStudent(Student student) {
    return _dataSource?.insertStudent(student) ?? Future.value();
  }

  Future<void> deleteStudent(int id) {
    return _dataSource?.deleteStudent(id) ?? Future.value();
  }
}
