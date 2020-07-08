import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart' as xml;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app99/http/httputil.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_app99/main.dart';
import 'package:get/get.dart';

class Loginpage extends StatefulWidget {
  @override
  _Loginpage createState() => new _Loginpage();
}

class _Loginpage extends State<Loginpage> {
  //static GlobalKey<NavigatorState> navigatorKey=GlobalKey();
  //获取Key用来获取Form表单组件

  GlobalKey<FormState> loginKey = new GlobalKey<FormState>();

  String username;
  int retry_time_remains = 5;
  int is_countdown_ongoing = 0;

  String password;

  bool isShowPassWord = false;

  void login() {
    //读取当前的Form状态
    var loginForm = loginKey.currentState;
    //验证Form表单
    if (loginForm.validate()) {
      loginForm.save();
      print('userName: ' + username + ' password: ' + password);
      FormData formData =
          new FormData.fromMap({'username': username, 'password': password});
      _login(formData);
    }
  }

  Timer _countdownTimer;
  String _codeCountdownStr = 'log in';
  int _countdownNum = 59;

  void reGetCountdown() {
    setState(() {
      if (_countdownTimer != null) {
        this.is_countdown_ongoing = 1;
        return;
      }
      // Timer的第一秒倒计时是有一点延迟的，为了立刻显示效果可以添加下一行。
      _codeCountdownStr = 'Please retry after ${_countdownNum--} s';
      _countdownTimer = new Timer.periodic(new Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdownNum > 0) {
            _codeCountdownStr = 'Please retry after ${_countdownNum--} s ';
          } else {
            _codeCountdownStr = 'log in';
            _countdownNum = 59;
            _countdownTimer.cancel();
            this.is_countdown_ongoing = 0;
            this.retry_time_remains = 5;
            _countdownTimer = null;
          }
        });
      });
    });
  }

  _login(formData) async {
    var url = "http://m.nokia-nsb.com/login/";
    print('开始发送post请求了');
    Response response = await httprequest.post(url, data: formData);
    print('得到的反馈结果是：');
    //Response response = await dio.post(url, data: formData);
    var xmlDoc = xml.parse(response.data.toString());
    print('获取response');
    var _xmlhead = xmlDoc.findAllElements("head").toList()[0];
    var statecode = _xmlhead.findElements('statecode').first.text;
    var desc = _xmlhead.findElements('statedesc').first.text;
    print('打印获取的信息');
    print('after');

    print(statecode);
    print(desc);
    if (statecode == 'NOK') {
      if (this.retry_time_remains > 0) {
        Fluttertoast.showToast(
          msg: desc + 'Left times of retry ：' + this.retry_time_remains.toString() ,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          textColor: Colors.red,
        );
        this.retry_time_remains = this.retry_time_remains - 1;
      } else {
        reGetCountdown();
        this.retry_time_remains = 3;

      }
    }
    else{
        Fluttertoast.showToast(
          msg: 'Log in successfully！',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          textColor: Colors.red,
          fontSize:ScreenUtil().setSp(40),
        );
        //Navigator.pushNamed(context, '/MyHomePage',arguments: {'useruid': username });
          Navigator.pushNamed(context, '/MyHomePage');
        //Get.toNamed("/login");



    }
  }

  void showPassWord() {
    setState(() {
      isShowPassWord = !isShowPassWord;
    });
  }

  final GlobalKey<NavigatorState> navigatorKeylonin = new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    //根据屏幕宽度适配：width:ScreenUtil().setWidth(540);
//根据屏幕高度适配：height:ScreenUtil().setHeight(200);
//适配字体大小：fontSize：ScreenUtil().setSp(28);
    return new MaterialApp(
      navigatorKey: navigatorKeylonin,
      title: 'Form表单示例',
      home: new Scaffold(
        body: SingleChildScrollView (child:Column(
          children: <Widget>[
            new Container(
                padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(200),
                    bottom: ScreenUtil().setHeight(20)),
                child: new Text(
                  'Aifei',
                  style: TextStyle(
                      color: Color.fromARGB(255, 53, 53, 53),
                      fontSize: ScreenUtil().setSp(100)),
                )),
            SizedBox(height:
            ScreenUtil().setHeight(80)
              ,),
            new Container(
              padding: EdgeInsets.all(ScreenUtil().setHeight(32)),
              child: new Form(
                key: loginKey,
                autovalidate: true,
                child: new Column(
                  children: <Widget>[
                    new Container(
                      decoration: new BoxDecoration(
                          border: new Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(255, 240, 240, 240),
                                  width: ScreenUtil().setHeight(2)))),
                      child: new TextFormField(
                        decoration: new InputDecoration(
                          labelText: 'Please input your username',

                          labelStyle: new TextStyle(
                              fontSize: ScreenUtil().setSp(40),
                              color: Color.fromARGB(255, 93, 93, 93)),

                          border: InputBorder.none,

                          // suffixIcon: new IconButton(

                          //  icon: new Icon(

                          //    Icons.close,

                          //    color: Color.fromARGB(255, 126, 126, 126),

                          //  ),

                          //  onPressed: () {

                          //  },

                          // ),
                        ),
                        keyboardType: TextInputType.phone,
                        onSaved: (value) {
                          username = value;
                        },
                        validator: (username) =>
                            (username.length < 1) ? "Please input your username！！" : null,
                        onFieldSubmitted: (value) {},
                      ),
                    ),
                    SizedBox(height:
                    ScreenUtil().setHeight(20)
                      ,),
                    new Container(
                      decoration: new BoxDecoration(
                          border: new Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(255, 240, 240, 240),
                                  width: 1.0))),
                      child: new TextFormField(
                        decoration: new InputDecoration(
                            labelText: 'Please input your password',
                            labelStyle: new TextStyle(
                                fontSize: ScreenUtil().setSp(40),
                                color: Color.fromARGB(255, 93, 93, 93)),
                            border: InputBorder.none,
                            suffixIcon: new IconButton(
                              icon: new Icon(
                                isShowPassWord
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Color.fromARGB(255, 126, 126, 126),
                              ),
                              onPressed: showPassWord,
                            )),
                        obscureText: !isShowPassWord,
                        onSaved: (value) {
                          password = value;
                        },
                        validator: (phone) =>
                            (phone.length < 1) ? "Please input your password！！" : null,
                      ),
                    ),
                    SizedBox(height:
                    ScreenUtil().setHeight(20)
                      ,),
                    new Container(
                      height: ScreenUtil().setHeight(90),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(80)),
                      child: new SizedBox.expand(
                        child: new RaisedButton(
                          onPressed:
                              this.is_countdown_ongoing < 1 ? login : null,
                          color: Color.fromARGB(255, 61, 203, 128),
                          child: new Text(
                            _codeCountdownStr,
                            style: TextStyle(
                                fontSize: ScreenUtil().setHeight(55),
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(
                                  ScreenUtil().setHeight(90))),
                        ),
                      ),
                    ),
                    SizedBox(height:
                    ScreenUtil().setHeight(20)
                      ,),
                    new Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
                      padding: EdgeInsets.only(
                          left: ScreenUtil().setHeight(16),
                          right: ScreenUtil().setHeight(16)),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            child: new Container(
                              child: Text(
                                'Register your account',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(30),
                                    color: Color.fromARGB(255, 53, 53, 53)),
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, '/registerpage');
                            },
                          ),
                          Text(
                            'Forget your password？',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(30),
                                color: Color.fromARGB(255, 53, 53, 53)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
