import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flutter_app99/http/httputil.dart';
import 'package:flutter_app99/http/posthandelutil.dart';
import 'package:flutter_app_upgrade/flutter_app_upgrade.dart';
import 'package:flutter_app99/uri_config.dart';
import 'package:version/version.dart';

class Myhomepagebody extends StatefulWidget {
  @override
  _Myhomepagebody createState() {
    return new _Myhomepagebody();
  }
}

//自定义mybuttonpage的widget 继承自stfulwidget状态的widget
class _Myhomepagebody extends State<Myhomepagebody> {

  List isliked_color = [Colors.grey, Colors.red];
  final filter_str = TextEditingController();

  List postslist = new List();
  var isfirstrender = 1;
  List tmppostsli = new List();


  @override
  void initState() {
    AppUpgrade.appUpgrade(

      context,
      _checkAppInfo(),
      iosAppId: 'id88888888',
      cancelText: 'Not Now',
      titleStyle: TextStyle(fontSize: ScreenUtil().setSp(65)),
      contentStyle: TextStyle(fontSize: ScreenUtil().setSp(50)),
        progressBarColor: Colors.lightBlue.withOpacity(.4),
      cancelTextStyle: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(55)),
      okText: 'Upgrade',
      okTextStyle: TextStyle(color: Colors.red,fontSize: ScreenUtil().setSp(55)),
    );

    FormData formData =
    new FormData.fromMap({'filter_str':"", });
    super.initState();
    this._getpostssummary(formData);
    filter_str.addListener(() {
      //通过controller获取输入框内容
      print("content=" + filter_str.text);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getpostssummary(formData) async {
    print('请求 首页');
    var url = "http://m.nokia-nsb.com/postssummary/";
    Response response = await httprequest.post(url,data:formData);
    //print(response.data);
    var xmlDoc = xml.parse(response.data.toString());
    print('获取response');
    var _xmlList = xmlDoc.findAllElements("post").toList();
    print('获取post list');
    this.tmppostsli = List();
    for (var xml_item in _xmlList) {
      List tmpli = new List();
      print('遍历post list');
      var title = xml_item.findElements('title').first.text;
      var postuid = xml_item.findElements('postuid').first.text;
      var postcontent = xml_item.findElements('postcontent').first.text;
      var headpicico = xml_item.findElements('headpicico').first.text;
      var number_likes =
          int.parse(xml_item.findElements('attitude_like').first.text);
      var authoruid = xml_item.findElements('authoruid').first.text;
      var coverpicture = xml_item.findElements('coverpicture').first.text;
      var videolink = xml_item.findElements('video').first.text;
      var posttype = xml_item.findElements('posttype').first.text;
      var is_liked = int.parse(xml_item.findElements('is_liked').first.text);
      tmpli.add(title);
      tmpli.add(postuid);
      tmpli.add(postcontent);
      tmpli.add(headpicico);
      tmpli.add(number_likes);
      tmpli.add(authoruid);
      tmpli.add(coverpicture);
      tmpli.add(videolink);
      tmpli.add(posttype);
      tmpli.add(is_liked);
      this.tmppostsli.add(tmpli);
    }
    print('遍历post list完成');
    setState(() {
      print('强制页面刷新');
      this.postslist = this.tmppostsli;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    return this.postslist.length > 0
        ? Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: ListView(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).

              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(10),
                ),
                Container(
                  //修饰黑色背景与圆角
                  decoration: new BoxDecoration(
                    border: Border.all(
                        color: Colors.grey, width: ScreenUtil().setWidth(1)),
                    //灰色的一层边框
                    color: Colors.grey,
                    borderRadius: new BorderRadius.all(
                        new Radius.circular(ScreenUtil().setWidth(15))),
                  ),
                  alignment: Alignment.center,
                  height: ScreenUtil().setHeight(120),
                  padding: EdgeInsets.fromLTRB(
                      ScreenUtil().setWidth(15),
                      ScreenUtil().setWidth(0),
                      ScreenUtil().setWidth(0),
                      ScreenUtil().setWidth(0)),
                  child: TextField(
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.done,
                    //设置光标
                    controller: filter_str,
                    onEditingComplete: () {
                      print('我编辑完了');
                    },
                    onSubmitted: (val) {
                      Map paras = {"filter_str":""};
                      print("点击了键盘上的动作按钮，当前输入框的值为：${val}");
                      FormData formData =
                      new FormData.fromMap({'filter_str':val });
                      _getpostssummary(formData);
                    },
                    decoration: InputDecoration(
                        //输入框decoration属性
//            contentPadding: const EdgeInsets.symmetric(vertical: 1.0,horizontal: 1.0),
                        contentPadding: new EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(15),0,0,ScreenUtil().setWidth(15)),
//            fillColor: Colors.white,
                        border: InputBorder.none,
//            icon: Icon(Icons.search),
//            icon: ImageIcon(AssetImage("image/search_meeting_icon.png",),),
                        icon: Icon(Icons.search),
                        //suffixIcon: Icon(Icons.check_box),
                        //suffixStyle: ,
                        hintText: "Video name",
                        hintStyle: new TextStyle(
                          fontSize: ScreenUtil().setSp(55),
                          color: Colors.white,
                        )),
                    style: new TextStyle(
                        fontSize: ScreenUtil().setSp(55), color: Colors.black),
                  ),
                ),
                Container(
                  height: ScreenUtil().setHeight(10),
                ),
                Text(
                  'Finding',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: ScreenUtil().setSp(80)),
                ),
                Container(
                  height: ScreenUtil().setHeight(10),
                ),
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  //padding: EdgeInsets.all(10.0),
                  childAspectRatio: 0.6,
                  crossAxisSpacing: ScreenUtil().setHeight(10),
                  mainAxisSpacing: ScreenUtil().setHeight(10),
                  children: this.postslist.map((value) {
                    return Scaffold(
                      body: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: ScreenUtil().setWidth(20),
                              color: Color.fromRGBO(233, 233, 233, 0.8),
                            ) //
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              flex: 14,
                              child: GestureDetector(
                                child: Container(
                                    child: Image.network(value[6],
                                        fit: BoxFit.cover)),
                                onTap: () {
                                  var posttype = value[8];
                                  if (posttype == 'text') {
                                    print('跳转到 TEXT 了');
                                    Navigator.pushNamed(context, '/posttext',
                                        arguments: {'postuid': value[1]});
                                  } else {
                                    print('跳转到视频了');
                                    Navigator.pushNamed(context, '/postvideo',
                                        arguments: {
                                          'postuid': value[1],
                                          'videolink': value[7]
                                        });
                                  }
                                },
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    child: Text(
                                      value[0],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(45)),
                                    ),
                                    onTap: () {
                                      var posttype = value[8];
                                      if (posttype == 'text') {
                                        Navigator.pushNamed(context, '/posttext',
                                            arguments: {'postuid': value[1]});
                                      } else {
                                        Navigator.pushNamed(context, '/postvideo',
                                            arguments: {'postuid': value[1]});
                                      }
                                    },
                                  )),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                width: double.infinity,
                                //color: Colors.red,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Positioned(
                                      bottom: ScreenUtil().setWidth(25),
                                      right: ScreenUtil().setWidth(40),
                                      //top: ScreenUtil().setWidth(20),
                                      child: GestureDetector(
                                        child: Container(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.thumb_up,
                                                size: ScreenUtil().setWidth(65),
                                                color:
                                                this.isliked_color[value[9]],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    ScreenUtil().setWidth(15),
                                                    0,
                                                    0,
                                                    0),
                                                child: Text(
                                                  value[4].toString(),
                                                  style: TextStyle(
                                                      fontSize:
                                                      ScreenUtil().setSp(30)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          if (value[9] == 1) {
                                            like(value[1], 0);
                                            setState(() {
                                              value[4] = value[4] - 1;
                                              value[9] = 0;
                                            });
                                          } else {
                                            like(value[1], 1);
                                            setState(() {
                                              value[9] = 1;
                                              value[4] = value[4] + 1;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    Positioned(
                                        bottom: ScreenUtil().setWidth(20),
                                        left: ScreenUtil().setWidth(10),
                                        //top: ScreenUtil().setWidth(20),
                                        child: GestureDetector(
                                          child: Container(
                                            width: ScreenUtil().setWidth(75),
                                            height: ScreenUtil().setHeight(75),
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(value[3]),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/personalhomepage',
                                                arguments: {'useruid': value[5]});
                                          },
                                        )),
                                    Positioned(
                                        bottom: ScreenUtil().setWidth(35),
                                        left: ScreenUtil().setWidth(95),
                                        //top: ScreenUtil().setWidth(20),
                                        child: GestureDetector(
                                          child: Text(
                                            value[5],
                                            style: TextStyle(
                                                fontSize: ScreenUtil().setSp(40)),
                                          ),
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/personalhomepage',
                                                arguments: {'useruid': value[5]});
                                          },
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
          )
        : Text(
            '内容加载中。。。',
          );
  }
}

///搜索控件widget
class TextFileWidget extends StatelessWidget {
  Widget buildTextField() {
    //theme设置局部主题
    return TextField(
      cursorColor: Colors.white, //设置光标
      decoration: InputDecoration(
          //输入框decoration属性
//            contentPadding: const EdgeInsets.symmetric(vertical: 1.0,horizontal: 1.0),
          contentPadding: new EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(15), 0, 0, ScreenUtil().setWidth(15)),
//            fillColor: Colors.white,
          border: InputBorder.none,
//            icon: Icon(Icons.search),
//            icon: ImageIcon(AssetImage("image/search_meeting_icon.png",),),
          icon: Icon(Icons.search),
          hintText: "Video name",
          hintStyle: new TextStyle(
            fontSize: ScreenUtil().setSp(55),
            color: Colors.white,
          )),
      style:
          new TextStyle(fontSize: ScreenUtil().setSp(55), color: Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget editView() {
      return Container(
        //修饰黑色背景与圆角
        decoration: new BoxDecoration(
          border: Border.all(
              color: Colors.grey, width: ScreenUtil().setWidth(1)), //灰色的一层边框
          color: Colors.grey,
          borderRadius: new BorderRadius.all(
              new Radius.circular(ScreenUtil().setWidth(15))),
        ),
        alignment: Alignment.center,
        height: ScreenUtil().setHeight(120),
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(15),
            ScreenUtil().setWidth(0),
            ScreenUtil().setWidth(0),
            ScreenUtil().setWidth(0)),
        child: TextField(
          cursorColor: Colors.white, //设置光标
          decoration: InputDecoration(
              //输入框decoration属性
//            contentPadding: const EdgeInsets.symmetric(vertical: 1.0,horizontal: 1.0),
              contentPadding: new EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(15), 0, 0, ScreenUtil().setWidth(15)),
//            fillColor: Colors.white,
              border: InputBorder.none,
//            icon: Icon(Icons.search),
//            icon: ImageIcon(AssetImage("image/search_meeting_icon.png",),),
              icon: Icon(Icons.search),
              hintText: "Video name",
              hintStyle: new TextStyle(
                fontSize: ScreenUtil().setSp(55),
                color: Colors.white,
              )),
          style: new TextStyle(
              fontSize: ScreenUtil().setSp(55), color: Colors.black),
        ),
      );
    }

    return editView();
  }
}
//搜索控件结束

Future<AppUpgradeInfo> _checkAppInfo() async {
  bool is_force;
  List<String> content_li = new List();
  var title;
  var apkDownloadUrl;
  var is_force_update ;
  var sw_version ;


  //这里一般访问网络接口，将返回的数据解析成如下格式
  var current_app_info = await FlutterUpgrade.appInfo;
  print('99999999. woshi banben  xinxi');
  print(current_app_info.versionName);
  var url = url_checkupdate;
  Response response = await httprequest.get(url);
  var xmlDoc = xml.parse(response.data.toString());
  print('获取response');
  var datas = xmlDoc.findAllElements("data").toList();
  var contents = xmlDoc.findAllElements("contents").toList();
  title = xmlDoc.findAllElements("title").toList();
  for ( var t in title){
    title = t.text;
  };
  apkDownloadUrl = xmlDoc.findAllElements("download_url").toList();
  for ( var t in apkDownloadUrl){
    apkDownloadUrl = t.text;
  };
  is_force_update = xmlDoc.findAllElements("is_force_update").toList();
  for ( var t in is_force_update){
    is_force_update = t.text;
  };
  sw_version = xmlDoc.findAllElements("sw_version").toList();
  for ( var t in sw_version){
    sw_version = t.text;
  };
  for (var content in contents) {
    print('遍历content li');
    var cont = content.findElements('p').toList();
    for (var i in cont) {
      content_li.add(i.text.toString());

    };
  }
  print('遍历content li 完成');
   if (is_force_update == 'true'){
    is_force = true;
  }
  else
    {
      is_force = false;
    }
  print('远端版本为：');
  print(sw_version);
  Version latestVersion = Version.parse(sw_version);
  var appInfo = await FlutterUpgrade.appInfo;
  print('本地版本为：');
  print(appInfo.versionName);
  Version localVersion = Version.parse(appInfo.versionName);

  if (latestVersion > localVersion) {
    return Future.delayed(Duration(seconds: 1), () {
      return AppUpgradeInfo(
        title: title,
        contents: content_li,
        force: is_force,
        apkDownloadUrl: apkDownloadUrl,
      );
    });

  }


  //List<String> contents = new List<String>.from(originList);




}