import 'package:floor/floor.dart';
import 'package:gestion_alumnos/model/entity/Cours.dart';

class Student {
  final int? id;
  final String name;
  final int age;
  final String? imgUrl;
  final Cours? course;

  Student({
    this.id,
    required this.name,
    required this.age,
    this.imgUrl,
    this.course,
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map["id"],
      age: map["age"],
      name: map["name"],
      imgUrl: map["imgUrl"],
      course: map["courses"] != null ? Cours.fromMap(map['courses']) : null,
    );
  }

  Map<String, dynamic> toInsert() {
    return {'name': name, 'age': age};
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'imgUrl': imgUrl,
      'course_id': course?.id,
    };
  }

  Student copyWith({
    int? id,
    String? name,
    int? age,
    String? imgUrl,
    Cours? course,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      imgUrl: imgUrl ?? this.imgUrl,
      course: course ?? this.course,
    );
  }
}
