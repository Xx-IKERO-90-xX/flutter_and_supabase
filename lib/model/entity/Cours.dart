class Cours {
  final int? id;
  final String name;
  final int? hours;

  Cours({this.id, required this.name, required this.hours});

  factory Cours.fromMap(Map<String, dynamic> map) {
    return Cours(id: map["id"], name: map["name"], hours: map["hours"]);
  }

  Map<String, dynamic> toInsert() {
    return {'name': name, 'hours': hours};
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'hours': hours};
  }

  Cours copyWith({int? id, String? name, int? hours}) {
    return Cours(
      id: id ?? this.id,
      name: name ?? this.name,
      hours: hours ?? this.hours,
    );
  }
}
