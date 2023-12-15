import 'package:flutter/material.dart';
import '../apihel.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService authService =  AuthService();
  bool isvispass = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          color: const Color.fromARGB(255, 226, 226, 156),
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(colors: [
          //     Color.fromARGB(255, 192, 190, 199),
          //     Color.fromARGB(255, 100, 88, 206),
          //   ]),
          // ),
          child: const Padding(
            padding: EdgeInsets.only(top: 60.0, left: 22),
            child: Text(
              'Sign in \nto continue...',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                  fontSize: 30,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              color: Colors.white,
              border: Border.all(
                          color: const Color.fromARGB(255, 0, 0, 0), // Border color
                          width: 0.5, // Border width
                        ),
            ),
            height: double.infinity,
            width: double.infinity,
            child:  Padding(
              padding: EdgeInsets.only(left: width*0.05,right: width*0.05),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      //suffixIcon: Icon(Icons.check,color: Colors.grey,),
                      label: Text('Gmail',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:Color.fromARGB(255, 63, 62, 62),
                      ),)
                    ),
                  ),
                  SizedBox(height: height*0.03,),
                  TextField(
                    controller: passwordController,
                    obscureText: !isvispass,
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: (){
                            setState(() {
                              isvispass = !isvispass;
                            });
                          },
                          child: Icon(isvispass?Icons.visibility_sharp:Icons.visibility_off,color:isvispass?Colors.blue :Colors.grey,)
                          ),
                        label: const Text('Password',style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:Color.fromARGB(255, 63, 62, 62),
                        ),)
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Forgot Password?',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Color(0xff281537),
                    ),),
                  ),
                  const SizedBox(height: 70,),
                  GestureDetector(
                    onTap: () async {
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        final username = usernameController.text;
                        final password = passwordController.text;

                        try {
                          final user = await authService.login(username, password);
                          // Navigate to the next screen or perform other actions after successful login
                        
                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen(user: user)),
                                        (Route<dynamic> route) => false);
                          
                          print('Login successful. Token: ${user.token}, ${user.userid}');
                        } catch (e) {
                          var snackBar = const SnackBar(content: Text('Incorrect credentials'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          print('Login failed: $e');
                        }
                    },
                    child: Container(
                      height: 45,
                      width: 125,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color.fromARGB(255, 0, 0, 0), // Border color
                          width: 1.0, // Border width
                        ),
                        color: const Color.fromARGB(255, 7, 0, 0)
                      ),
                      child: const Center(child: Text('LOGIN',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color.fromARGB(255, 255, 255, 255)
                      ),),),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}