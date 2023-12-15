import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../apihel.dart';
import '../todom.dart';
import '../userm.dart';
import 'addtodo_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user, this.todo});
  final User user;
  final Todo? todo;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final AuthService authService =  AuthService();
  late Future<List<Todo>> _todos;
  bool hideCompleted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.todo!=null){
      _todos = authService.fetchTodos(widget.user.userid);
      _todos = _todos.then((List<Todo> todos) {
      todos.add(widget.todo!);
      return todos;
    });
    
    }
    else{
      _todos = authService.fetchTodos(widget.user.userid);
      
    }           
  }

  List<Todo> filterCompleted(List<Todo> todos) {
    return hideCompleted ? todos.where((todo) => !todo.completed).toList() : todos;
  }

  Widget _buildTaskTile(Todo todo) {
    return ListTile(
      title: Row(
        children: [
          todo.completed
              ? Icon(Icons.check_box, color: const Color.fromARGB(255, 0, 0, 0)) // Completed task
              : GestureDetector(
                child: Container(width: 24, height: 24, decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(255, 156, 154, 154))),)), // Incomplete task
          SizedBox(width: 8),
          Text(todo.todo,style: TextStyle(fontSize: 18,decoration: todo.completed ? TextDecoration.lineThrough : null,),),
        ],
      ),
      subtitle: Text('Time: Not Specified')
    );
  }

  Widget _buildTaskSection(String title, Future<List<Todo>> todos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                setState(() {
                  hideCompleted = !hideCompleted;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top:10.0,right: 8.0,left: 8.0),
                child: Text(
                  hideCompleted ? "Show completed" : "Hide completed",
                  style: const TextStyle(fontSize: 13,color: Color.fromARGB(255, 29, 66, 230)),
                  
                ),
              ),
            ),
          ],
        ),
        FutureBuilder<List<Todo>>(
          future: todos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final todos = filterCompleted(snapshot.data!);
              return ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return _buildTaskTile(todo);
                },
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Do you want to exit ?',
                textAlign: TextAlign.center,
              ),
              //actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: Scaffold(
        appBar: AppBar(
          //title: Text('Todo List'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.account_circle_rounded,color: Color.fromARGB(255, 112, 110, 110),size: 40,),
              ),
            ),
          ],
          shadowColor: Colors.black38,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
                color: Color.fromARGB(255, 117, 116, 113),
                height: 0.3,
            ),)
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTaskSection('Today', _todos),
                ],
              ),
           ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(15.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) => AddTodo_Screen(user: widget.user, )));
            },
            shape: const CircleBorder(),
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}


