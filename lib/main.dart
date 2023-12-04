// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'todo_bloc.dart'; // Asegúrate de que el nombre del archivo sea correcto y la ruta sea adecuada

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoScreen(),
    );
  }
}

class TodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do App'),
      ),
      body: TodoList(),
    );
  }
}

class TodoList extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(labelText: 'Nueva tarea'),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  final todoText = _textEditingController.text;
                  if (todoText.isNotEmpty) {
                    todoBloc.addTodo(Todo(todoText, false));
                    _textEditingController.clear();
                  }
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Todo>>(
            stream: todoBloc.todos,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final todos = snapshot.data!;
                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return ListTile(
                      title: Text(todo.title),
                      leading: Checkbox(
                        value: todo.completed,
                        onChanged: (value) {
                          // Implementar la lógica para marcar tareas como completadas
                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Implementar la lógica para eliminar tareas
                        },
                      ),
                    );
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ],
    );
  }
}
