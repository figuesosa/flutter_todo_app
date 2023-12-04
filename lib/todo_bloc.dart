// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

class Todo {
  String title;
  bool completed;

  Todo(this.title, this.completed);
}

class TodoBloc extends Bloc<Object, List<Todo>> {
  final _todoController = StreamController<List<Todo>>.broadcast();
  Timer? _debounceTimer;

  TodoBloc()
      : super(
            []); // Añadimos un constructor que invoca el constructor de la superclase

  @override
  Stream<List<Todo>> mapEventToState(Object event) async* {
    yield _todoController.stream.valueOrNull ?? [];
  }

  @override
  Future<void> close() {
    _todoController.close();
    _debounceTimer?.cancel();
    return super.close();
  }

  StreamSink<List<Todo>> get _inTodos => _todoController.sink;
  Stream<List<Todo>> get todos => _todoController.stream;

  void addTodo(Todo todo) {
    _todoController.stream.valueOrNull?.add(todo);
    _inTodos.add(_todoController.stream.valueOrNull ?? []);

    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      add(Object()); // Emitimos un evento vacío
    });
  }
}

// Extensión para obtener el valor de un Stream, o null si está vacío
extension StreamValueOrNull<T> on Stream<T> {
  T? get valueOrNull {
    late T? result;
    final subscription = take(1).listen((value) {
      result = value;
    }, onDone: () {
      subscription.cancel();
    });

    return result;
  }
}

final todoBloc = TodoBloc();
