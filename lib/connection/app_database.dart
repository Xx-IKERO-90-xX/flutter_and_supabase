import 'dart:async';
import 'package:floor/floor.dart';
import 'package:gestion_alumnos/model/dao/StudentDao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:gestion_alumnos/connection/app_database.dart';
import 'package:gestion_alumnos/model/entity/Student.dart';

part 'app_database.g.dart'; // Generated file

@Database(version: 1, entities: [Student])
abstract class AppDatabase extends FloorDatabase {
  StudentDao get studentDao;

  static Future<AppDatabase> init() async {
    return await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }
}
