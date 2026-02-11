import 'package:gestion_alumnos/model/entity/Student.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentDatasource {
  final SupabaseClient client;
  final String _tableName = 'students';

  StudentDatasource(this.client);

  Stream<List<Student>> streamAllStudents() {
    final response = client.from(_tableName).stream(primaryKey: ['id']);

    return response.map((event) {
      return event.map((user) => Student.fromMap(user)).toList();
    });
  }

  Future<List<Student>> getAllStudents() async {
    final response = await client.from('students').select('*, courses(*)');

    return (response as List).map((user) => Student.fromMap(user)).toList();
  }

  Future<void> insertStudent(Student student) async {
    final response = await client.from(_tableName).insert(student.toInsert());

    if (response != null) {
      throw response.error!;
    }
  }

  Future<void> updateStudent(Student student) async {
    Map<String, dynamic> studentMap = student.toMap();
    final response = await client
        .from(_tableName)
        .update(studentMap)
        .eq('id', studentMap["id"]);

    if (response != null) {
      throw response.error!;
    }
  }

  Future<void> deleteStudent(int id) async {
    final response = await client.from(_tableName).delete().eq('id', id);

    if (response != null) {
      throw response.error!;
    }
  }
}
