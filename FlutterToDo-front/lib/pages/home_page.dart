// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/util/dialogue_box.dart';
import 'package:flutter_application_1/util/fetched_tile.dart';
import 'package:flutter_application_1/util/todo_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//Controller Text
  final _controller = TextEditingController();

  // Task List
  List toDoList = [];
  List<FetchedTile> things = [];

  //Fetch tasks

  Future<http.Response> fetchTasks() async {
    setState(() {
      toDoList.clear();
    });
    final res = await http.get(Uri.parse("http://10.0.2.2:5214/api/TodoItems"));
    print('the response is... ${res.body}');

    //List to pass into Map/List
    List<dynamic> jsonList = jsonDecode(res.body);
    things = jsonList
        .map((jsonItem) =>
            FetchedTile.fromJson(jsonItem as Map<String, dynamic>))
        .toList();
    //This for loop goes through every item in the map and adds them to the list to be displayed
    for (var el in things) {
      print('ID: ${el.id}, Name: ${el.name} , Status: ${el.isComplete}');
      if (!toDoList.any((item) => item[0] == el.name)) {
        setState(() {
          toDoList.add([el.name, el.isComplete, el.id]);
        });
      }
    }

    print('The map is...${toDoList}');

    return res;
  }

//Updating a task's completed status

  Future<FetchedTile> updateStatus(int id, String name, bool isComplete) async {
    final update = await http.put(
      Uri.parse('http://10.0.2.2:5214/api/TodoItems/${id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'name': name,
        'isComplete': isComplete,
      }),
    );

    if (update.statusCode == 200) {
      return FetchedTile.fromJson(
          jsonDecode(update.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to update task...');
    }
  }

  // Create Tasks

  Future<FetchedTile> createTask(String name, isComplete) async {
    final create = await http.post(
      Uri.parse("http://10.0.2.2:5214/api/TodoItems"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'isComplete': isComplete,
      }),
    );
    if (create.statusCode == 200 && !toDoList.any((item) => item[0] == name)) {
      return FetchedTile.fromJson(
          jsonDecode(create.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create task...');
    }
  }

//Delete Tasks

  Future<http.Response> removeTask(int id) async {
    final delete = await http.delete(
      Uri.parse('http://10.0.2.2:5214/api/TodoItems/${id}'),
      headers: <String, String>{
        'Content-Type': 'application.json; charset=UTF-8'
      },
    );

    return delete;
  }

  //Chackbox tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
      updateStatus(toDoList[index][2], toDoList[index][0], toDoList[index][1]);
    });
    print('Tasks ID: ${toDoList[index][2]}');
    print('Tasks Status: ${toDoList[index][1]}');
  }

//Save Task

  void saveNewTask() {
    setState(() {
      toDoList.add([_controller.text, false]);
      createTask(_controller.text, false);
      _controller.clear();
      fetchTasks();
    });
    Navigator.of(context).pop();
  }

//Create task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogueBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

//Delete Task

  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
      removeTask(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF393856),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 19, 18, 31),
          title: Text(
            "2Do",
            style: TextStyle(
                fontFamily: GoogleFonts.expletusSans().fontFamily,
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color(0xFF24916d)),
          ),
          centerTitle: true,
          elevation: 100,
        ),
        floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: FloatingActionButton(
                  onPressed: fetchTasks,
                  child: Icon(Icons.replay_outlined),
                  backgroundColor: Color(0xFF24916d),
                ),
              ),
              FloatingActionButton(
                onPressed: createNewTask,
                child: Icon(Icons.add),
                backgroundColor: Color(0xFF24916d),
              ),
            ]),
        body: ListView.builder(
          itemCount: toDoList.length,
          itemBuilder: (context, index) {
            return TodoTile(
              taskName: toDoList[index][0],
              completed: toDoList[index][1],
              onChanged: (value) => checkBoxChanged(value, index),
              deleteFunction: (context) => deleteTask(index),
            );
          },
        ));
  }
}
