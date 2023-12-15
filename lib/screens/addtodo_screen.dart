import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import '../apihel.dart';
import '../todom.dart';
import '../userm.dart';
import 'home_screen.dart';
//import 'package:image_picker/image_picker.dart';


class AddTodo_Screen extends StatefulWidget {
  const AddTodo_Screen({super.key, required this.user});
  final User user;

  @override
  _AddTodo_ScreenState createState() => _AddTodo_ScreenState();
}

class _AddTodo_ScreenState extends State<AddTodo_Screen> {
  final TextEditingController nameController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime _dateTime = DateTime.now();
  bool isToday = true;
  final AuthService authService =  AuthService();
  
  final TextEditingController todocontroller = TextEditingController();

  File? _image;

  // final ImagePicker _imagePicker = ImagePicker();

  // Future<void> _getImage(ImageSource source) async {
  //   final pickedFile = await _imagePicker.pickImage(source: source);

  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Task',style: TextStyle(fontWeight: FontWeight.w400),),
        centerTitle: true,
        shadowColor: Colors.black38,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.4),
          child: Container(
              color: Color.fromARGB(255, 117, 116, 113),
              height: 0.3,
          ),)
        
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                    'Add a task',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
              SizedBox(height: height*0.04,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Name',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: width*0.04,),
                  SizedBox(
                    width: width*0.70,
                    child: TextField(
                        controller: todocontroller,
                        decoration: const InputDecoration(
                          //suffixIcon: Icon(Icons.check,color: Colors.grey,),
                          hintText: "Type in your tasks...",
                        ),
                      ),
                  ),
                ],
              ),
              
              SizedBox(height: height*0.04,),
              Row(
                children: [
                  const Text(
                    'Hour',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10,),
                  Container(
                    //color: Color.fromARGB(255, 231, 227, 227),
                    child: TimePickerSpinner(
                        is24HourMode: false,
                        normalTextStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 167, 157, 157)
                        ),
                        highlightedTextStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 2, 2, 0)
                        ),
                        spacing: 10,
                        itemHeight: 28,
                        isForce2Digits: true,
                        onTimeChange: (time) {
                          setState(() {
                            _dateTime = time;
                          });
                        },
                      ),
                  ),
        
                ],
              ),
              
              SizedBox(height: height*0.04,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Today',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    activeColor: Colors.white,
                    activeTrackColor: Colors.green,
                    inactiveTrackColor: Colors.white,
                    inactiveThumbColor: Colors.grey,
                    value: isToday,
                    onChanged: (value) {
                      setState(() {
                        isToday = value;
                      });
                    },
                  ),
                ],
              ),
              
              SizedBox(height: height*0.04,),
              Row(
              children: [
                const Text(
                  'Image',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: width*0.04,),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Select Image Source'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                //_getImage(ImageSource.camera);
                              },
                              child: const Text('Camera'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                //_getImage(ImageSource.gallery);
                              },
                              child: const Text('Gallery'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Upload'),
                ),
              ],
            ),
            if (_image != null)
              Image.file(
                _image!,
                height: height*0.3,
                width: width*0.5,
                fit: BoxFit.cover,
              ),

              const SizedBox(height: 32),
              Container(
                width: width*0.7,
                height: height*0.1,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    onPressed: () async { 
                      final Todo newTodo = Todo(
                        todo: todocontroller.text,
                        completed: isToday,
                        userId: widget.user.userid
                      );   
                      final todo = await authService.addTodos(newTodo);
                      // ignore: use_build_context_synchronously
                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen(user: widget.user,todo: todo,)),
                                          (Route<dynamic> route) => false);            
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      minimumSize: Size(100, 40),
                      ),
                    child: const Text('Done',style: TextStyle(color: Colors.white,fontSize: 14),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
