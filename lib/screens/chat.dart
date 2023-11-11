import 'package:flutter/material.dart' ;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ChatScreen extends StatefulWidget {
  static const String screenRoute ='chat_screen';
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void initState(){
    super.initState();
    getCurrentUser();
  }
  final _firestore=FirebaseFirestore.instance;
  final _auth= FirebaseAuth.instance;
  late User signedInUser;
  String? messageText ;
  void getCurrentUser(){
    try {
      final user=_auth.currentUser;
    if (user!= null) {
      signedInUser=user;
    }
    } catch (e) {
      
    }

  }
  //void getmessages() async{
   // final messages = await _firestore.collection('messages').get();
   // for (var message in messages.docs){
    //  print(message.data());
  //  }
  //}

void messageStreams()async {
  await for (var snapshot in _firestore.collection('messages').snapshots() )
  {
    for (var message in snapshot.docs){
     print(message.data());
    
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange ,
        title: Row(children: [
          Image.asset('images/logo.png',
          height: 26,
          ),
          SizedBox(width: 5,),
          Text('ChatApp')
        ]),
        actions: [
          IconButton(onPressed: (){
            _auth.signOut();
            Navigator.pop(context);
          }, icon: Icon(Icons.close))
        ],
        
      ),
      body: SafeArea(child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        StreamBuilder<QuerySnapshot>(
          stream:  _firestore.collection('messages').snapshots() ,
          builder:(context,snapshot)
          {
            List<MessageLine> messageWidgets =[];
             if(!snapshot.hasData){
              //fh/d
             }

           final messages =snapshot.data!.docs;
           for(var message in messages)
           {
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            final messageWidget = MessageLine(sender: messageSender , text: messageText,);
            messageWidgets.add(messageWidget);
           }
          return Expanded(
            child: ListView(
              children: messageWidgets,
            ),
          );

          }),
        Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(
              color: Colors.orange,
              width: 2,
            ))
          ),
          child: Row(
            crossAxisAlignment:CrossAxisAlignment.center,
            children: [
            Expanded(child: 
            TextField(
              onChanged: (value) {
                messageText=value;
              },
              decoration: InputDecoration(
                contentPadding:EdgeInsets.symmetric(
                  vertical: 10,horizontal: 20,
                ),
                hintText:'Write your message here ...', 
                border: InputBorder.none,
                ),
                
              ),),
              TextButton(onPressed: (){
                _firestore.collection('messages').add(
                  {
                  'text' :messageText,
                  'sender': signedInUser.email ,
                  }
                );
              }, child: const Text(
                'send',
                style: TextStyle(color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 18),
              ),)
          ]),
        )
      ],)
      ),
    );
  }
}


}

class MessageLine extends StatelessWidget {
  const MessageLine({ this.sender ,this.text, super.key});

 final  String? text ;
 final  String? sender ;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.red,
      child: Text('$text - $sender')); 
  }
}