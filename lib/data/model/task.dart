class Task {
  String id;
  String name;
  DateTime time;

  Task({required this.id, required this.name, required this.time});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'time': time.toIso8601String()
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
        id: map['id'],
        name: map['name'],
        time: DateTime.parse(map['time'])
    );
  }
}