import 'package:chat/screens/chat.dart';
import 'package:chat/screens/registration_screen.dart';
import 'package:chat/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

final _auth=FirebaseAuth.instance;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: ChatScreen(),
      initialRoute: _auth.currentUser != null ?ChatScreen.screenRoute : WelcomeScreen.screenRoute,
      routes: {
        WelcomeScreen.screenRoute :(context) => WelcomeScreen(),
        SignIn.screenRoute:(context) => SignIn(),
        RegistrationScreen.screenRoute:(context) => RegistrationScreen(),
        ChatScreen.screenRoute:(context) => ChatScreen(),
      },
    );
  }
}
