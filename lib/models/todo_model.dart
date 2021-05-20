//tabel name of the database
final String tableTodo = "todo";

//column field names for the table
class TodoFields {
  static final List<String> values = [id, title, description, createdTime];

  static final String id = '_id';
  static final String title = 'title';
  static final String description = 'description';
  static final String createdTime = 'createdTime';
}

//column values of the table
class Todo {
  final int? id;
  final String title;
  final String description;
  final DateTime createdTime;

  const Todo(
      {this.id,
      required this.createdTime,
      required this.description,
      required this.title});

  Todo copy({
    int? id,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      Todo(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  Map<String, Object?> toJson() => {
        TodoFields.id: id,
        TodoFields.title: title,
        TodoFields.description: description,
        TodoFields.createdTime: createdTime.toIso8601String(),
      };

  static Todo fromJson(Map<String, Object?> json) => Todo(
        id: json[TodoFields.id] as int,
        title: json[TodoFields.title] as String,
        description: json[TodoFields.description] as String,
        createdTime: DateTime.parse(json[TodoFields.createdTime] as String),
      );
}
