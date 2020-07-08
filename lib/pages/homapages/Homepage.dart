import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Myhomepage_body.dart';
import 'package:flutter_app99/pages/myinfopages/Myinfo.dart';
import 'package:flutter_app99/pages/addpages/ImageVideoUpload.dart';
import 'package:flutter_app99/pages/livetelecastpages/livetelecastpage.dart';



class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  List _homepagebody = [
    MediaPage(),
    Myhomepagebody(),
    ImageVideoUpload(),
    Myinfopage(),
  ];
  List _homepageappbar = [
    TextFileWidget(),
    Text("myinfo"),
    Text("myinfo"),
  ];
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    //这时候我们使用的尺寸是px.
    //根据屏幕宽度适配：width:ScreenUtil().setWidth(540);
    //根据屏幕高度适配：height:ScreenUtil().setHeight(200);
    //适配字体大小：fontSize：ScreenUtil().setSp(28,false);
    return Scaffold(
      body: this._homepagebody[this._currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: ScreenUtil().setHeight(80),
        selectedFontSize: ScreenUtil().setSp(45),
        unselectedFontSize: ScreenUtil().setSp(45),
        backgroundColor: Colors.white,
        unselectedIconTheme: IconThemeData(color: Colors.black),
        selectedIconTheme: IconThemeData(color: Colors.pink),
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.black,
        currentIndex: this._currentIndex,
        //unselectedLabelStyle: TextStyle(color: Colors.pink),
        onTap: (int index) {
          print('当前index id是');
          print(index);
          if (index == 2) {
            Navigator.pushNamed(context, '/imagevideoupload',);
          }
          else {
            setState(() {
              this._currentIndex = index;
            });
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            title: Text(
              'live',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(
              'Home',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
            ),
            title: Text('Open'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            title: Text('Me'),
          ),
        ],
      ),
    );
  }
}

