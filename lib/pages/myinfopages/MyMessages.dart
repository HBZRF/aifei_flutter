import 'package:flutter/material.dart';

class MyMessages extends StatefulWidget {
  @override
  _MyMessagesState createState() => _MyMessagesState();
}

class _MyMessagesState extends State<MyMessages> {

  List message = [
    "message1","message2", " message2"
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop()),
        title: Text("Message"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: message.length,
          itemBuilder: (context, index){
            return InkWell(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                color: Colors.grey[200],
                padding: EdgeInsets.all(5),
                child: Card(
                  margin: EdgeInsets.fromLTRB(5, 5, 5,0),
                  child: ListTile(
                    onTap: (){
                      print("display message");
                    },
                    leading: Icon(Icons.message),
                    title: Text(message[index]),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios
                      ),
                    ),
                  ),
                ),
              ),
            );
          })

    );
  }
}
