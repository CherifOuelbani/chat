import 'package:chat/screens/chat.dart';
import 'package:chat/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const String screenRoute ='registration_screen';
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth=FirebaseAuth.instance;
  late String email ;
  late String password;
  bool showSpinner=false ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            Container(
              height: 180,
              child: Image.asset('images/logo.png'),
        
            ),
            SizedBox(height: 50,),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                email=value;
              },
              decoration: InputDecoration(
                hintText: ('Enter you Email'),
                contentPadding: EdgeInsets.symmetric(vertical: 10 ,horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius:BorderRadius.circular(10) ),
                  enabledBorder:  OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 1),
                  borderRadius:BorderRadius.circular(10) ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  borderRadius:BorderRadius.circular(10) ),
              ),
              
            ),
            SizedBox(height: 10,),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                password=value;
              },
              decoration: InputDecoration(
                hintText: ('Enter you Password'),
                contentPadding: EdgeInsets.symmetric(vertical: 10 ,horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius:BorderRadius.circular(10) ),
                  enabledBorder:  OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 1),
                  borderRadius:BorderRadius.circular(10) ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  borderRadius:BorderRadius.circular(10) ),
              ),
              
            ),
            SizedBox(height: 10,),
            myButton(color: Color.fromARGB(255, 28, 77, 238),
            title: 'Registration',
            onPressed: () async {
      setState(() {
        showSpinner=true ;
      });
             
                try {
                  final newUser=await _auth.createUserWithEmailAndPassword(
                email: email, password: password);
                Navigator.pushNamed(context, ChatScreen.screenRoute);
                showSpinner=false ;
                } catch (e) {
                  print(e);
                }
            },
            )
      
          ]),
          
        ),
      ),
    );
  }
}