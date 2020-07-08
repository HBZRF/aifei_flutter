import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Collection extends StatefulWidget {
  @override
  _CollectionState createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {

  List myCollection = [
    'item1',
    'item2',
    '',
    '',
    'item1',
    'item2',
    '',
    '',
    'item1',
    'item2',
    '',
    '',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text("Collection"),
        centerTitle: true,
        backgroundColor: Colors.grey[500],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(myCollection.length, (index) {
          return Container(
            color: Colors.grey[400],
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 90,
                  margin: EdgeInsets.fromLTRB(5,0,5,0),
                  child: FittedBox(
                    child: Image.asset('asset/afb4.jpg'),
                    fit: BoxFit.fill,
                  ),

                ),
                Container(
                  color: Colors.white,
                 margin: EdgeInsets.fromLTRB(5,0,5,0),
                  padding: EdgeInsets.fromLTRB(5, 0, 2,0),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          "Here is the comment of the picture or products"
                              "Beautiful ladies",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage('asset/afb4.jpg'),
                        radius: 15,
                      ),
                      SizedBox(width: 5,),
                      Text("Lily", style: TextStyle( color: Colors.black),),
                      SizedBox(width: 30,),
                      IconButton(
                        icon: Icon(Icons.check_circle_outline),
                        iconSize: 25,
                      ),
                      Text(
                          "9999",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        ),
      ),
    );
  }
}
