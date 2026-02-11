import 'package:gestion_alumnos/model/entity/Cours.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoursDatasource {
  final SupabaseClient client;
  final String _tableName = 'courses';

  CoursDatasource(this.client);

  Stream<List<Cours>> streamAllCourses() {
    final response = client.from(_tableName).stream(primaryKey: ['id']);

    return response.map((event) {
      return event.map((user) => Cours.fromMap(user)).toList();
    });
  }

  Future<List<Cours>> getAllCourses() async {
    final response = await client.from(_tableName).select();

    return (response as List).map((user) => Cours.fromMap(user)).toList();
  }

  Future<void> insertCours(Cours cours) async {
    final response = await client.from(_tableName).insert(cours.toInsert());

    if (response != null) {
      throw response.error!;
    }
  }

  Future<void> updateCours(Cours cours) async {
    Map<String, dynamic> coursMap = cours.toMap();
    final response = await client
        .from(_tableName)
        .update(coursMap)
        .eq('id', coursMap["id"]);

    if (response != null) {
      throw response.error!;
    }
  }

  Future<void> deleteCours(int id) async {
    final response = await client.from(_tableName).delete().eq('id', id);

    if (response != null) {
      throw response.error!;
    }
  }
}
