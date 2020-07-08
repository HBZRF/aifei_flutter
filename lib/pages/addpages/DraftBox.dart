import 'dart:io';
import 'package:flutter/material.dart';
import './ImageVideoUpload.dart';


class DraftBox extends StatefulWidget {
  final arguments;
  DraftBox({Key key, this.arguments}) : super(key: key);
  @override
  _DraftBoxState createState() => _DraftBoxState();
}



class _DraftBoxState extends State<DraftBox> {

  File fileImage;

  @override
  Widget build(BuildContext context) {
    fileImage = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed:() => Navigator.of(context).pop()),
        title: Text("Draft Box"),
        centerTitle: true,
      ),
      body: Card(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15,0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text("the date"),
                        Text("the comment"),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text("Edit"),
                          IconButton(
                              onPressed:(){
                                Navigator.pushReplacementNamed(context,'/imagevideoupload',arguments: {
                                  '/imageFile' : fileImage,
                                });
                              },
                              icon:Icon(Icons.arrow_forward_ios),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("image"),
                  Container(
                   
                  ),
                ],
                  ),
                ],
              ),
          ),
        ),
    );
  }
}
