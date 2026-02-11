import 'package:gestion_alumnos/data/cours_datasource.dart';
import 'package:gestion_alumnos/data/student_datasource.dart';
import 'package:gestion_alumnos/model/entity/Cours.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoursRepository {
  CoursDatasource? _dataSource;

  CoursRepository._();

  static final CoursRepository _instance = CoursRepository._();

  factory CoursRepository() {
    return _instance;
  }

  Future<void> connectDB() async {
    if (_dataSource == null) {
      await Supabase.initialize(
        url: "https://hzcsvvlpdwdtwzosljxe.supabase.co",
        anonKey:
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh6Y3N2dmxwZHdkdHd6b3NsanhlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA1NTE2MzIsImV4cCI6MjA4NjEyNzYzMn0.m7CLsAonBLH3jKai58i58bXtOCb4FmjmPHzZ6lfSUlE",
      );
      _dataSource = CoursDatasource(Supabase.instance.client);
    }
  }

  Stream<List<Cours>> streamAllCourses() {
    return _dataSource?.streamAllCourses() ?? const Stream.empty();
  }

  Future<List<Cours>>? getAllCourses() {
    return _dataSource?.getAllCourses() ?? Future.value([]);
  }

  Future<void> updateCours(Cours cours) async {
    return _dataSource?.updateCours(cours);
  }

  Future<void> insertCours(Cours cours) {
    return _dataSource?.insertCours(cours) ?? Future.value();
  }

  Future<void> deleteCours(int id) {
    return _dataSource?.deleteCours(id) ?? Future.value();
  }
}
