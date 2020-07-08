import 'package:flutter/material.dart';
import 'package:flutter_app99/pages/settingpages/listOfCountry.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart' as xml;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app99/http/httputil.dart';

class Registerpage extends StatefulWidget {
  @override
  _Registerpage createState() => new _Registerpage();
}

class _Registerpage extends State<Registerpage> {
  //获取Key用来获取Form表单组件
  ///TextInputType.text（普通完整键盘）
  ///TextInputType.number（数字键盘）
  //TextInputType.emailAddress（带有“@”的普通键盘）
  //TextInputType.datetime（带有“/”和“：”的数字键盘）
  //TextInputType.multiline（带有选项以启用有符号和十进制模式的数字键盘）
  GlobalKey<FormState> registerKey = new GlobalKey<FormState>();
  FocusNode _inputemailFocus = FocusNode();
  String username;
  String phonenumber;
  String password;
  String usercountry;
  String useremail;
  int retry_time_remains = 5;
  int is_countdown_ongoing = 0;
  bool isShowPassWord = false;
  bool isEnterCountry = false;
  bool isCountry = false;
  String hintText = "Please input your country name";

  List<String> newCountriesList = List.from(countries);
  TextEditingController _controller = TextEditingController();


  void register() {
    //读取当前的Form状态
    var registerForm = registerKey.currentState;
    //验证Form表单
    if (registerForm.validate()) {
      registerForm.save();
      print("users country:");
      print(usercountry);
      if(isEmail(useremail)){
        print('是邮箱格式');
        print('userName: ' + username + ' password: ' + password);
        FormData formData =
        new FormData.fromMap({'username': username,
          'phonenumber':phonenumber,
          'useremail':useremail,
          'country':usercountry,
          'password': password});
        _register_to_web(formData);
      }
      else{
        print('不是邮箱格式');
        Fluttertoast.showToast(
          msg: 'please input the correct email format！！',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          textColor: Colors.red,
          fontSize:ScreenUtil().setSp(40),
        );

      }

    }

  }




  ///邮箱验证
  static bool isEmail(String str) {
    return RegExp(
        r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$")
        .hasMatch(str);
  }
  _register_to_web(formData) async {
    var url = "http://m.nokia-nsb.com/register/";
    print('开始发送注册请求了');
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
      Fluttertoast.showToast(
        msg: desc,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 2,
        textColor: Colors.red,
      );

    }
    else{
      Fluttertoast.showToast(
        msg: desc,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 2,
        textColor: Colors.red,
      );
      print('注册成功');
      Navigator.pushNamed(context, '/MyHomePage');

    }
  }

  // countries list change

//  onItemChanged(String value){
//    newCountriesList = countries
//        .where((country) => country.toString().toLowerCase().contains(value.toLowerCase()))
//        .toList();
//    print("vous avez saisi $value");
//  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    //根据屏幕宽度适配：width:ScreenUtil().setWidth(540);
//根据屏幕高度适配：height:ScreenUtil().setHeight(200);
//适配字体大小：fontSize：ScreenUtil().setSp(28);
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: new Scaffold(
        appBar: AppBar(
          title: Text('Aifei Register Page',
              style: TextStyle(fontSize: ScreenUtil().setSp(60))),
          centerTitle: true,
        ),
        body: Container(
          child: ListView(
            //physics: ClampingScrollPhysics(),
            //shrinkWrap: true,
            children: <Widget>[
              new Column(
                children: <Widget>[
                  new Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(
                        ScreenUtil().setHeight(24),
                        ScreenUtil().setHeight(44),
                        ScreenUtil().setHeight(24),
                        ScreenUtil().setHeight(24)),
                    child: new Form(

                      key: registerKey,
                      autovalidate: true,
                      child: new Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Please set your username(By English letters / number/_ )',
                              style: TextStyle(fontSize: ScreenUtil().setSp(48)),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),
                          new Container(
                            decoration: new BoxDecoration(
                                border: new Border(
                                    bottom: BorderSide(
                                        color: Color.fromARGB(255, 240, 240, 240),
                                        width: ScreenUtil().setHeight(2)))),
                            child: Container(
                              child: TextFormField(
                                inputFormatters: [
                                  WhitelistingTextInputFormatter(
                                      RegExp("^(?!_)[a-zA-Z0-9_]*")),
                                  LengthLimitingTextInputFormatter(20),
                                ],
                                decoration: new InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(
                                        ScreenUtil().setHeight(16),
                                        ScreenUtil().setHeight(36),
                                        ScreenUtil().setHeight(16),
                                        ScreenUtil().setHeight(16)),
                                    hintText: 'Please input your Aifei username',
                                    prefixStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(50),
                                    ),
                                    hintStyle: TextStyle(
                                        fontSize: ScreenUtil().setSp(50),
                                        color: Color.fromARGB(255, 93, 93, 93)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().setHeight(16)),
                                        borderSide: BorderSide(color: Colors.grey)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().setHeight(16)),
                                        borderSide: BorderSide(color: Colors.blue)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().setHeight(16)),
                                        borderSide: BorderSide(color: Colors.red))
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
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Please input your phone number',
                              style: TextStyle(fontSize: ScreenUtil().setSp(48)),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),
                          new Container(
                            decoration: new BoxDecoration(
                                border: new Border(
                                    bottom: BorderSide(
                                        color: Color.fromARGB(255, 240, 240, 240),
                                        width: ScreenUtil().setHeight(2)))),
                            child: Container(
                              child: TextFormField(
                                inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(15)
                                ],
                                decoration: new InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(
                                        ScreenUtil().setHeight(16),
                                        ScreenUtil().setHeight(36),
                                        ScreenUtil().setHeight(16),
                                        ScreenUtil().setHeight(16)),
                                    hintText: 'Please input your phone number',
                                    prefixStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(50),
                                    ),
                                    hintStyle: TextStyle(
                                        fontSize: ScreenUtil().setSp(50),
                                        color: Color.fromARGB(255, 93, 93, 93)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().setHeight(16)),
                                        borderSide: BorderSide(color: Colors.grey)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().setHeight(16)),
                                        borderSide: BorderSide(color: Colors.blue)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().setHeight(16)),
                                        borderSide: BorderSide(color: Colors.red))
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
                                  phonenumber = value;
                                },
                                validator: (phonenumber) =>
                                (phonenumber.length < 1) ? "Please input your phone number！！" : null,
                                onFieldSubmitted: (value) {},
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Please input your password',
                              style: TextStyle(fontSize: ScreenUtil().setSp(48)),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),
                          new Container(
                            decoration: new BoxDecoration(
                                border: new Border(
                                    bottom: BorderSide(
                                        color: Color.fromARGB(255, 240, 240, 240),
                                        width: ScreenUtil().setHeight(2)))),
                            child: Container(
                              child: TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(20),
                                ],
                                decoration: new InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(
                                        ScreenUtil().setHeight(16),
                                        ScreenUtil().setHeight(36),
                                        ScreenUtil().setHeight(16),
                                        ScreenUtil().setHeight(16)),
                                    hintText: 'Please input your password',
                                    prefixStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(50),
                                    ),
                                    hintStyle: TextStyle(
                                        fontSize: ScreenUtil().setSp(50),
                                        color: Color.fromARGB(255, 93, 93, 93)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().setHeight(16)),
                                        borderSide: BorderSide(color: Colors.grey)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().setHeight(16)),
                                        borderSide: BorderSide(color: Colors.blue)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().setHeight(16)),
                                        borderSide: BorderSide(color: Colors.red))
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
                                  password = value;
                                },
                                validator: (password) =>
                                (password.length < 6) ? "The length of the password should be at least 7！！" : null,
                                onFieldSubmitted: (value) {},
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Please input the eamil',
                              style: TextStyle(fontSize: ScreenUtil().setSp(48)),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),
                          new Container(
                            decoration: new BoxDecoration(
                                border: new Border(
                                    bottom: BorderSide(
                                        color: Color.fromARGB(255, 240, 240, 240),
                                        width: ScreenUtil().setHeight(2)))),
                            child: Container(
                              child: TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(35)
                                ],
                                decoration: new InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(
                                        ScreenUtil().setHeight(16),
                                        ScreenUtil().setHeight(36),
                                        ScreenUtil().setHeight(16),
                                        ScreenUtil().setHeight(16)),
                                    hintText: 'Please input the email',
                                    prefixStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(50),
                                    ),
                                    hintStyle: TextStyle(
                                        fontSize: ScreenUtil().setSp(50),
                                        color: Color.fromARGB(255, 93, 93, 93)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().setHeight(16)),
                                        borderSide: BorderSide(color: Colors.grey)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().setHeight(16)),
                                        borderSide: BorderSide(color: Colors.blue)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().setHeight(16)),
                                        borderSide: BorderSide(color: Colors.red))
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
                                  useremail = value;
                                },
                                validator: (useremail) => (useremail.length < 1)? "Please input the email！！"
                                    : null,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Please input your coutry name',
                              style: TextStyle(fontSize: ScreenUtil().setSp(48)),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),
                          Column(
                            children: <Widget>[
                              new Container(
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        bottom: BorderSide(
                                            color: Color.fromARGB(255, 240, 240, 240),
                                            width: ScreenUtil().setHeight(2)))),
                                child: Container(

                                  child: !isCountry?TextFormField(
//
//                                    inputFormatters: [
//                                      //WhitelistingTextInputFormatter.digitsOnly,
//                                      LengthLimitingTextInputFormatter(25)
//                                    ],
                                    decoration: new InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(
                                            ScreenUtil().setHeight(16),
                                            ScreenUtil().setHeight(36),
                                            ScreenUtil().setHeight(16),
                                            ScreenUtil().setHeight(16)),
                                        hintText: hintText,
                                        prefixStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(50),
                                        ),
                                        hintStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(50),
                                            color: Color.fromARGB(255, 93, 93, 93)),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                ScreenUtil().setHeight(16)),
                                            borderSide: BorderSide(color: Colors.grey)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                ScreenUtil().setHeight(16)),
                                            borderSide: BorderSide(color: Colors.blue)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                ScreenUtil().setHeight(16)),
                                            borderSide: BorderSide(color: Colors.red))
                                      // suffixIcon: new IconButton(

                                      //  icon: new Icon(

                                      //    Icons.close,

                                      //    color: Color.fromARGB(255, 126, 126, 126),

                                      //  ),

                                      //  onPressed: () {

                                      //  },

                                      // ),
                                    ),
                                    onChanged:(val){
                                      setState(() {
                                        newCountriesList = countries
                                            .where((country) => country.toLowerCase()
                                            .contains(val.toLowerCase()))
                                            .toList();
                                        isEnterCountry = true;
                                      });
                                    },
                                    initialValue: hintText=="Please input your country name"?null:"$hintText",
                                    keyboardType: TextInputType.text,
                                  onSaved: (value) {
                                    usercountry = value;
                                  },
                                    validator: (randomcode) =>
                                    (randomcode.length < 1) ? "Please input your country name！！" : null,
                                    onFieldSubmitted: (value) {
                                      print("$value is your country");
                                      usercountry = value;
                                    },
                                  ):GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        isCountry = false;
                                        hintText = usercountry;
                                      });
                                    },
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                ScreenUtil().setHeight(14)),
                                            borderSide: BorderSide(color: Colors.grey)),),
                                      child: Container(
                                        child: Text(
                                          usercountry, style: TextStyle(
                                          color:  Colors.black
                                        ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              isEnterCountry?Container(
                                child: ListView(
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  children: newCountriesList.map((country){
                                    return ListTile(
                                      title: Text("$country"),
                                      onTap: (){
                                        setState(() {
                                          isEnterCountry = false;
                                          usercountry = country;
                                          isCountry = true;
                                        });
                                      },
                                    );
                                  }).toList()
                                ),
                              ):Container()
                            ],
                          ),
                          SizedBox(height:
                          ScreenUtil().setHeight(10)
                            ,),
                          new Container(
                            height: ScreenUtil().setHeight(90),
                            margin: EdgeInsets.only(top: ScreenUtil().setHeight(80)),
                            child: new SizedBox.expand(
                              child: new RaisedButton(
                                onPressed:(){
                                  register();
                                },

                                color: Color.fromARGB(255, 61, 203, 128),
                                child: new Text(
                                  'Submmit',
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setHeight(55),
                                      color: Color.fromARGB(255, 255, 255, 255)),
                                ),
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(
                                        ScreenUtil().setHeight(400))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



