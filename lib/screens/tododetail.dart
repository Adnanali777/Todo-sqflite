import 'package:flutter/material.dart';
import 'package:fluttter_todos_sqflite/models/todo_model.dart';
import 'package:fluttter_todos_sqflite/screens/createtodo.dart';
import 'package:fluttter_todos_sqflite/services/database_service.dart';

class TodoDetail extends StatefulWidget {
  final int todoid;
  final VoidCallback? updateTodos;
  TodoDetail({required this.todoid, this.updateTodos});
  @override
  _TodoDetailState createState() => _TodoDetailState();
}

class _TodoDetailState extends State<TodoDetail> {
  late Todo todo;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshtodos();
  }

  Future<void> refreshtodos() async {
    setState(() => isLoading = true);

    todo = await DatabaseService().readTodo(widget.todoid);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: [
          editbutton(),
          deletebutton(),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: EdgeInsets.all(size.width * 0.01),
              padding: EdgeInsets.all(size.width * 0.06),
              child: ListView(
                children: [
                  Text(
                    '${todo.title}',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Text(
                    '${todo.description}',
                    style: TextStyle(color: Colors.grey[700], fontSize: 17),
                  )
                ],
              ),
            ),
    );
  }

  Widget editbutton() {
    return IconButton(
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddTodoScreen(
                    todo: todo,
                    updateTodos: widget.updateTodos,
                  )));
          refreshtodos();
        },
        icon: Icon(Icons.edit, color: Colors.black));
  }

  Widget deletebutton() {
    return IconButton(
        onPressed: () async {
          await DatabaseService().deleteTodo(widget.todoid);
          Navigator.of(context).pop();
          widget.updateTodos!();
        },
        icon: Icon(
          Icons.delete,
          color: Colors.black,
        ));
  }
}
