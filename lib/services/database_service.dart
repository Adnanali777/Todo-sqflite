import 'package:fluttter_todos_sqflite/models/todo_model.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  //creating a database

  Future<Database> initializeDatabase() async {
    //getting the database path
    var dir = getDatabasesPath();

    //specifying the path and creating the table of database
    var path = p.join(await dir, "todo.db");
    var database = openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $tableTodo(
          ${TodoFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${TodoFields.description} TEXT NOT NULL,
          ${TodoFields.title} TEXT NOT NULL,
          ${TodoFields.createdTime} TEXT NOT NULL
        )''');
      },
    );
    return database;
  }

  //inserting values inside the table

  Future<Todo> create(Todo todo) async {
    final db = await this.database;

    final id = await db.insert(
      tableTodo,
      todo.toJson(),
    );
    final todowithId = todo.copy(id: id);
    return todowithId;
  }

  //reading from the databse
  Future<Todo> readTodo(int id) async {
    final db = await this.database;

    final maps = await db.query(
      tableTodo,
      columns: TodoFields.values,
      where: '${TodoFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Todo.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  //reading all todos
  Future<List<Todo>> readallTodos() async {
    final db = await this.database;
    final result =
        await db.query(tableTodo, orderBy: '${TodoFields.createdTime} ASC');

    return result.map((json) => Todo.fromJson(json)).toList();
  }

  //update a todo
  Future<int> updateTodo(Todo todo) async {
    final db = await this.database;
    return db.update(tableTodo, todo.toJson(),
        where: '${TodoFields.id} = ?', whereArgs: [todo.id]);
  }

  //delete a todo
  Future<int> deleteTodo(int id) async {
    final db = await this.database;
    return db.delete(
      tableTodo,
      where: '${TodoFields.id} = ?',
      whereArgs: [id],
    );
  }

  //closing the database
  Future close() async {
    final db = await this.database;
    db.close();
  }
}
