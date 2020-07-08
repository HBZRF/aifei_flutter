import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_app99/http/httputil.dart';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart' as xml;
import 'package:fluttertoast/fluttertoast.dart';

class Settingpage extends StatefulWidget {
  final arguments;

  Settingpage({Key key, this.arguments}) : super(key: key);

  @override
  _Settingpage createState() {
    return new _Settingpage();
  }
}

//根据屏幕宽度适配：width:ScreenUtil().setWidth(540);
//根据屏幕高度适配：height:ScreenUtil().setHeight(200);
//适配字体大小：fontSize：ScreenUtil().setSp(28,false);
//自定义mybuttonpage的widget 继承自stfulwidget状态的widget
class _Settingpage extends State<Settingpage> {
  var loging_bt_str = '退出登录';
  var isalive = 'NOK';
  var statecode;
  void initState() {
    super.initState();
    this._isalive();
  }

  _isalive() async {
    var url = "http://m.nokia-nsb.com/isalive/";
    print('开始发送get请求了');
    Response response = await httprequest.get(url);
    var xmlDoc = xml.parse(response.data.toString());
    var _xmlList = xmlDoc.findAllElements("head").toList();
    for (var xml_item in _xmlList) {
      this.isalive = xml_item.findElements('statecode').first.text;
      print('当前是否登录');
      print(this.isalive);
    }
    if (this.isalive == 'NOK'){
      setState(() {
        this.loging_bt_str = '登录';
      });

    }


  }
  _logout() async {
    var url = "http://m.nokia-nsb.com/logout/";
    print('开始发送get请求了');
    Response response = await httprequest.get(url);
    var xmlDoc = xml.parse(response.data.toString());
    var _xmlList = xmlDoc.findAllElements("head").toList();
    for (var xml_item in _xmlList) {
      this.statecode = xml_item.findElements('statecode').first.text;
      print('当前是否登录');
      print(this.statecode);
    }
    if (this.statecode == 'OK'){
      Fluttertoast.showToast(
        msg: '成功退出！',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 2,
        textColor: Colors.red,
        fontSize:ScreenUtil().setSp(40),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/MyHomePage', (route) => route == null);
    }


  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home:
    Scaffold(

      appBar: AppBar(
        //backgroundColor: Colors.white,
        title: Text('设置',style: TextStyle(fontSize: ScreenUtil().setSp(60))),
        centerTitle: true,

      ),
      body: ListView(
      children: <Widget>[
        Container(
            height: ScreenUtil().setHeight(30),
            color: Color.fromRGBO(233, 233, 233, 0.9)),
        Container(
          //height: ScreenUtil().setHeight(30),
          //color:Color.fromRGBO(233, 233, 233, 0.9)
          child: ListTile(
            leading: Icon(
              Icons.collections,
              size: ScreenUtil().setHeight(70),
            ),
            title: Text(
              "Collection",
              style: TextStyle(fontSize: ScreenUtil().setSp(53)),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: ScreenUtil().setHeight(70),
            ),
            onTap: () {
              print('wo shi collectinog!!');
              Navigator.pushNamed(context, '/collection');
            },
          ),
        ),
        Container(
          height: ScreenUtil().setHeight(30),
          color: Color.fromRGBO(233, 233, 233, 0.9),
        ),
        Container(
          //height: ScreenUtil().setHeight(30),
          //color:Color.fromRGBO(233, 233, 233, 0.9)
          child: ListTile(
            leading: Icon(
              Icons.chat,
              size: ScreenUtil().setHeight(70),
            ),
            title: Text(
              "My message",
              style: TextStyle(fontSize: ScreenUtil().setSp(53)),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: ScreenUtil().setHeight(70),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/message');
            },
          ),
        ),
        Container(
          height: ScreenUtil().setHeight(30),
          color: Color.fromRGBO(233, 233, 233, 0.9),
        ),
        Container(
          //height: ScreenUtil().setHeight(30),
          //color:Color.fromRGBO(233, 233, 233, 0.9)
          child: ListTile(
            leading: Icon(
              Icons.group_work,
              size: ScreenUtil().setHeight(70),
            ),
            title: Text(
              "Draft box",
              style: TextStyle(fontSize: ScreenUtil().setSp(53)),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: ScreenUtil().setHeight(70),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/draftbox');
            },
          ),
        ),
        Container(
          height: ScreenUtil().setHeight(30),
          color: Color.fromRGBO(233, 233, 233, 0.9),
        ),
        Container(
          //height: ScreenUtil().setHeight(30),
          //color:Color.fromRGBO(233, 233, 233, 0.9)
          child: ListTile(
            leading: Icon(
              Icons.account_box,
              size: ScreenUtil().setHeight(70),
            ),
            title: Text(
              "Help services",
              style: TextStyle(fontSize: ScreenUtil().setSp(53)),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: ScreenUtil().setHeight(70),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/helpservice');
            },
          ),
        ),
        Container(
          height: ScreenUtil().setHeight(100),
          color: Color.fromRGBO(233, 233, 233, 0.9),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(15, 0, 15, 0) ,
          //height: ScreenUtil().setHeight(30),
          //color:Color.fromRGBO(233, 233, 233, 0.9)
          child: ListTile(

            contentPadding: EdgeInsets.symmetric(horizontal: ScreenUtil().setHeight(400)),
            title: Text(
              this.loging_bt_str,
              style: TextStyle(fontSize: ScreenUtil().setSp(53)),
            ),
            onTap: () {
              if (this.loging_bt_str == '登录'){
                Navigator.pushNamed(context, '/login');
              }
              else{
                this._logout();
              }





            },
          ),
        ),
        Container(
          height: ScreenUtil().setHeight(30),
          color: Color.fromRGBO(233, 233, 233, 0.9),
        ),
      ],
    ),),);
  }
}
