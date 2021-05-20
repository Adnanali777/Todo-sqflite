import 'package:flutter/material.dart';
import 'package:fluttter_todos_sqflite/models/todo_model.dart';
import 'package:fluttter_todos_sqflite/screens/tododetail.dart';
import 'package:fluttter_todos_sqflite/services/database_service.dart';
import 'package:intl/intl.dart';
import 'createtodo.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isloading = false;
  List<Todo> _todos = [];

  @override
  void initState() {
    getallTodos();
    super.initState();
  }

  @override
  void dispose() {
    DatabaseService().close();
    super.dispose();
  }

  Future getallTodos() async {
    if (mounted) {
      setState(() => isloading = true);

      _todos = await DatabaseService().readallTodos();

      setState(() => isloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Container(
                child: _todos.isEmpty
                    ? Center(
                        child: Text(
                          'No Todos',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      )
                    : CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            expandedHeight: size.height * 0.24,
                            backgroundColor: Colors.white,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Image.asset(
                                'assets/todoimg.png',
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                'Todos',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5),
                              ),
                              centerTitle: true,
                            ),
                          ),
                          SliverList(
                              delegate: SliverChildListDelegate([
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 25),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: _todos.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final todo = _todos[index];
                                          final time = DateFormat.yMMMd()
                                              .format(todo.createdTime);
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TodoDetail(
                                                            updateTodos:
                                                                getallTodos,
                                                            todoid: todo.id!,
                                                          )));
                                              getallTodos();
                                            },
                                            child: ListTile(
                                              title: Text('${todo.title}'),
                                              subtitle: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('$time'),
                                                  Text('${todo.description}'),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ]))
                        ],
                      ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddTodoScreen(
                    updateTodos: getallTodos,
                  )));
          getallTodos();
        },
      ),
    );
  }
}
