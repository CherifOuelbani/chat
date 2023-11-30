import 'package:flutter/material.dart' ;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
late User signedInUser;
 final _firestore=FirebaseFirestore.instance;
class ChatScreen extends StatefulWidget {
  static const String screenRoute ='chat_screen';
  const ChatScreen({Key? key}):super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
} 

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
 final _firestore=FirebaseFirestore.instance;
  final _auth= FirebaseAuth.instance;
  
  String? messageText ;

  @override 
  void initState(){
    super.initState();
    getCurrentUser();
  }
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
        MessageStream(),
        
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
              controller: messageTextController ,
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
                messageTextController.clear();
                _firestore.collection('messages').add(
                  {
                  'text' :messageText,
                  'sender': signedInUser.email ,
                  'time': FieldValue.serverTimestamp()
                  }
                );
              }, child: const Text(
                'send',
                style: TextStyle(color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 18),
              ),)
          ],),
        )
      ],)
      ),
    );
  }
}




class MessageStream extends StatelessWidget {
  const MessageStream({super.key});
 
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
          stream:  _firestore.collection('messages').orderBy('time').snapshots() ,
          builder:(context,snapshot)
          {
            List<MessageLine> messageWidgets =[];
             if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(
                backgroundColor: Colors.blue ,
              ),);
             }

           final messages =snapshot.data!.docs.reversed;
           for(var message in messages)
           {
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            final currentUser = signedInUser.email;
            final messageWidget = MessageLine(sender: messageSender , text: messageText, IsME: currentUser==messageSender,);
            messageWidgets.add(messageWidget);
           }
          return Expanded(
            child: ListView(
              reverse: true,
              children: messageWidgets,
            ),
          );

          });
  }
}
class MessageLine extends StatelessWidget {
  const MessageLine({ this.sender ,this.text,required this.IsME , super.key});

 final  String? text ;
 final  String? sender ;
 final bool IsME ;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: IsME? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text('$sender' , style: TextStyle(color: Colors.yellow[900]),),
          Material(
            elevation: 5,
            borderRadius: IsME? BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ) :
            BorderRadius.only(
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ) ,
            color: IsME ? Color.fromARGB(255, 33, 115, 182) : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text('$text' , style: TextStyle( fontSize:15 ,color: Colors.white),),
            )),
        ],
      ),
    ); 
  }
}