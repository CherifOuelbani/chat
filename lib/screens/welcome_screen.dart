import 'package:chat/screens/registration_screen.dart';
import 'package:chat/screens/sign_in.dart';
import 'package:chat/widgets/my_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const String screenRoute ='welcome_screen';
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:CrossAxisAlignment.stretch ,
          children: [
          Column(children: [
            Container(
              height: 180,
              child: Image.asset('images/logo.png') ),
            Text('MessageMe',style: TextStyle(fontSize: 40 , 
            fontWeight: FontWeight.w900 ,
            color: Color.fromARGB(255, 9, 44, 75)
            ),),  
            ]),
            SizedBox(height: 30,),
            myButton(
              color: const Color.fromARGB(255, 255, 147, 59),
              title: 'Sign in',
              onPressed: () {
                Navigator.pushNamed(context, SignIn.screenRoute);
              },
            ),
              myButton(
              color: Color.fromARGB(255, 41, 34, 243),
              title: 'Register',
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.screenRoute);
              },
            )
        ]),
      ),
    );
  }
}

