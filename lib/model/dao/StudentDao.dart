import 'package:floor/floor.dart';
import 'package:gestion_alumnos/model/entity/Student.dart';

@dao
abstract class StudentDao {
  @Query('SELECT * FROM Student')
  Future<List<Student>> getAllStudents();

  @Query('SELECT * FROM Student')
  Stream<List<Student>> streamAllStudents();

  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<void> insertStudent(Student student);

  @Query('DELETE FROM Student WHERE id = :id')
  Future<void> deleteStudentById(int id);

  @update
  Future<int> updateStudent(Student student);
}
