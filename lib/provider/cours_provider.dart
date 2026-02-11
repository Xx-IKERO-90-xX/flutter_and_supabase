import 'package:flutter/foundation.dart';
import 'package:gestion_alumnos/model/entity/Cours.dart';
import 'package:gestion_alumnos/repository/cours_repository.dart';

class CoursProvider with ChangeNotifier {
  final CoursRepository _coursRepository = CoursRepository();

  List<Cours>? _courses;

  CoursProvider() {
    _loadDatabase();
  }

  Future<void> _loadDatabase() async {
    await _coursRepository.connectDB();
    _courses = await _coursRepository.getAllCourses();
    notifyListeners();
  }

  List<Cours>? get listCourses => _courses;

  _getAllCoursesAsync() async {
    await Future.delayed(const Duration(seconds: 5));
    _courses = await _coursRepository.getAllCourses();
    notifyListeners();
  }

  Future<void> refreshCourses() async {
    _courses = await _coursRepository.getAllCourses();
    notifyListeners();
  }

  Future<void> insertCours(Cours cours) async {
    await _coursRepository.insertCours(cours);
    await refreshCourses();
  }

  Future<void> deleteCourse(int id) async {
    await _coursRepository.deleteCours(id);
    await refreshCourses();
  }
}
