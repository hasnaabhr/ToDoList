// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/models/task_model.dart';
import 'package:todolist/pages/auth_service.dart';

class HomePage extends StatefulWidget {
  final String? previousPage; // تعريف المتغير لتخزين اسم الصفحة السابقة

  const HomePage({Key? key, this.previousPage}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double deviceHeight, deviceWidth;
  String? newTaskContent;
  Box? box;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    checkIfSignedIn();
  }

  void checkIfSignedIn() async {
    final user = _authService.currentUser;
    if (user == null) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    } else {
      await Hive.initFlutter("hive_boxes");
      if (!Hive.isBoxOpen("tasks")) {
        await Hive.openBox("tasks");
      }
      setState(() {
        box = Hive.box("tasks");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.previousPage != null) {
              // التحقق مما إذا كان هناك صفحة سابقة
              Navigator.pushNamed(
                  context,
                  widget
                      .previousPage!); // إذا كانت هناك صفحة سابقة، قم بالانتقال إليها
            } else {
              // إذا لم يكن هناك صفحة سابقة، ارجع للصفحة الرئيسية
              Navigator.pop(context);
            }
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: deviceHeight * 0.1,
        backgroundColor: const Color(0xff00C8AC),
        title: const Text(
          'Tasks',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      body: _tasksView(),
      floatingActionButton: addTasks(),
    );
  }

  Widget _tasksView() {
    return FutureBuilder(
      future: Hive.openBox("tasks"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          box = Hive.box("tasks");
          return _tasksList();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _tasksList() {
    List tasks = box!.values.toList();
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        var task = Task.fromMap(tasks[index]);
        return ListTile(
          title: Text(
            task.title,
            style: TextStyle(
                decoration: task.done ? TextDecoration.lineThrough : null),
          ),
          subtitle: Text(task.timestamp.toString()),
          trailing: Icon(
            task.done
                ? Icons.check_box_outlined
                : Icons.check_box_outline_blank_outlined,
            color: const Color(0xff00C8AC),
          ),
          onTap: () {
            task.done = !task.done;
            box!.putAt(index, task.toMap());
            setState(() {});
          },
          onLongPress: () {
            box!.deleteAt(index);
            setState(() {});
          },
        );
      },
    );
  }

  Widget addTasks() {
    return FloatingActionButton(
      onPressed: _displayTask,
      backgroundColor: const Color(0xff00C8AC),
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  void _displayTask() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Task"),
          content: TextField(
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                var task = Task(
                  title: value,
                  timestamp: DateTime.now(),
                  done: false,
                );
                box!.add(task.toMap());
                Navigator.pop(context);
              }
            },
          ),
        );
      },
    );
  }
}
