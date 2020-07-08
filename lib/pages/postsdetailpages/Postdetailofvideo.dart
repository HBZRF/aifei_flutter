import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_app99/http/httputil.dart';
import 'package:flutter_app99/http/posthandelutil.dart';

import 'package:flutter_app99/http/posthandelutil.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';


class Postofvideopage extends StatefulWidget {
  final arguments;
  Postofvideopage({Key key, this.arguments}) : super(key: key);
  @override
  _Postofvideopage createState() => _Postofvideopage();
}
class _Postofvideopage extends State<Postofvideopage> {
  bool _isPlaying = false;


  Map data = {};
  List postslist = [];
  List tmp_post = new List();
  List is_followed_color = [
    Colors.red,
    Colors.grey,
  ];
  List is_followed_bt_state = [Colors.grey, Colors.red];
  List is_liked_bt_state = [Colors.grey, Colors.red];
  List is_liked_bt_str = ['Follow', 'Followed'];
  List is_collected_bt_state = [Colors.grey, Colors.red];
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  @override
  void initState() {
    var url = widget.arguments['videolink'];
    super.initState();
    this._getdata(widget.arguments);
    _controller = VideoPlayerController.network(url)
    // 播放状态
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() { _isPlaying = isPlaying; });
        }
      })
    // 在初始化完成后必须更新界面
      ..initialize().then((_) {

        setState(() {});
      });

  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  _getdata(formData) async {
    var url = "http://m.nokia-nsb.com/post/video/detail/" + formData['postuid'] + '/';
    print('开始发送get请求了');
    Response response = await httprequest.get(url);
    var xmlDoc = xml.parse(response.data.toString());
    var _xmlList = xmlDoc.findAllElements("post").toList();
    for (var xml_item in _xmlList) {
      List postinfo = new List();
      var postcontent = xml_item.findElements('postcontent').first.text;
      var headpicico = xml_item.findElements('headpicico').first.text;
      var number_likes =
      int.parse(xml_item.findElements('number_likes').first.text);
      var number_collect =
      int.parse(xml_item.findElements('number_collect').first.text);
      var authoruid = xml_item.findElements('authoruid').first.text;
      var coverpicture = xml_item.findElements('coverpicture').first.text;
      var isliked = xml_item.findElements('isliked').first.text;
      var iscollected = xml_item.findElements('iscollected').first.text;
      var isfollowed = xml_item.findElements('isfollowed').first.text;
      var videolink = xml_item.findElements('videolink').first.text;
      postinfo.add(postcontent);
      postinfo.add(headpicico);
      postinfo.add(number_likes);
      postinfo.add(number_collect);
      postinfo.add(authoruid);
      postinfo.add(coverpicture);
      postinfo.add(isliked);
      postinfo.add(iscollected);
      postinfo.add(isfollowed);
      postinfo.add(videolink);
      this.tmp_post = postinfo;
    }
    setState(() {
      this.postslist = this.tmp_post;
      if (this.postslist == 1) {}
    });
  }
  _follow(usertofollow, state) async {
    FormData formData =
    new FormData.fromMap({"usertofollow": usertofollow, "state": state});
    var a = HttpUtil();
    var url = "http://m.nokia-nsb.com/post/follow/";
    print('开始发送follow请求了');
    print(url);
    Response response = await a.post(url,data: formData);
  }
  _like(postuid, state) async {
    FormData formData =
    new FormData.fromMap({"postuid": postuid, "state": state});
    var a = HttpUtil();
    print('开始发送post请求了');
    var url = "http://m.nokia-nsb.com/post/thumbsup/";
    Response response = await a.post(url,data: formData);
  }
  _collect(postuid, state) async {
    FormData formData =
    new FormData.fromMap({"postuid": postuid, "state": state});
    var a = HttpUtil();
    print('开始发送post请求了');
    var url = "http://m.nokia-nsb.com/post/collect/";
    Response response = await a.post(url,data: formData);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    print(this.postslist.length);
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.redAccent,
      ),
      home: this.postslist.length > 0
          ? Scaffold(


        body: new Center(
          child: ListView(
            children: <Widget>[
              Container(
                height: ScreenUtil().setHeight(120),
                color: Colors.black12,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                        width: ScreenUtil().setWidth(235),
                        height: ScreenUtil().setHeight(85),
                        //bottom: ScreenUtil().setWidth(1),
                        right: ScreenUtil().setWidth(30),
                        //top: ScreenUtil().setWidth(20),
                        child: RaisedButton(
                          color: this.is_followed_color[
                          int.parse(this.postslist[8])],
                          child: Text(this.is_liked_bt_str[int.parse(this.postslist[8])],
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(30)
                          ),),
                          onPressed: () {
                            print('点了follow了！');
                            if (int.parse(this.postslist[8]) == 1) {//进入这个循环，说明目前是喜欢的状态
                              follow(this.postslist[4], 0);
                              setState(() {
                                this.postslist[8] = '0';
                              });
                            } else {
                              follow(this.postslist[4], 1);
                              setState(() {
                                this.postslist[8] = '1';
                              });
                            }
                          },
                        )),
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
                                image: NetworkImage(this.postslist[1]),
                              ),
                            ),
                          ),
                        )),
                    Positioned(
                        bottom: ScreenUtil().setWidth(30),
                        left: ScreenUtil().setWidth(125),
                        //top: ScreenUtil().setWidth(20),
                        child: Text(
                          this.postslist[4],
                          style:
                          TextStyle(fontSize: ScreenUtil().setSp(40)),
                        ))
                  ],
                ),
              ),
              Container(
                height: ScreenUtil().setHeight(1400),
                width: ScreenUtil().setWidth(1080),
                color: Colors.black12,
                child:new Scaffold(
                  body: new Center(
                    child: _controller.value.initialized
                    // 加载成功
                        ? new AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,

                      child: VideoPlayer(_controller),
                    ) : new Container(),
                  ),
                  floatingActionButton: new FloatingActionButton(
                    onPressed: _controller.value.isPlaying
                        ? _controller.pause
                        : _controller.play,
                    child: new Icon(
                      _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                  ),
                ),
              ),

              Container(
                color: Colors.black38,
                child: Text(
                  postslist[0],
                  style: TextStyle(fontSize: ScreenUtil().setSp(50)),
                ),
                constraints: BoxConstraints(
                  minHeight: ScreenUtil().setHeight(100),
                  maxHeight: ScreenUtil().setHeight(300),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: ScreenUtil().setHeight(180),
          color: Colors.white,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                  bottom: ScreenUtil().setWidth(62),
                  left: ScreenUtil().setWidth(80),
                  //top: ScreenUtil().setWidth(20),
                  child: GestureDetector(
                    child: Container(
                      width: ScreenUtil().setWidth(95),
                      height: ScreenUtil().setHeight(95),
                      child: Icon(
                        Icons.thumb_up,
                        color: this.is_liked_bt_state[int.parse(this.postslist[6])],
                        size: ScreenUtil().setHeight(95),
                      ),
                    ),
                    onTap: (){
                      print('点了like了！');
                      if (int.parse(this.postslist[6]) == 1) {
                        like(widget.arguments['postuid'], 0);
                        setState(() {
                          this.postslist[2] = this.postslist[2] - 1;
                          this.postslist[6] = '0';
                        });
                      } else {
                        like(widget.arguments['postuid'], 1);
                        setState(() {
                          this.postslist[2] = this.postslist[2] + 1;
                          this.postslist[6] = '1';
                        });
                      }
                    },
                  )),
              Positioned(
                  bottom: ScreenUtil().setWidth(12),
                  left: ScreenUtil().setWidth(30),
                  //top: ScreenUtil().setWidth(20),
                  child: Text(
                    'Like ' + this.postslist[2].toString(),
                    style: TextStyle(fontSize: ScreenUtil().setSp(45)),
                  )),
              Positioned(
                  bottom: ScreenUtil().setWidth(62),
                  left: ScreenUtil().setWidth(400),
                  //top: ScreenUtil().setWidth(20),
                  child: GestureDetector(
                    child: Container(
                      width: ScreenUtil().setWidth(95),
                      height: ScreenUtil().setHeight(95),
                      child: Icon(
                        Icons.star,
                        color: this.is_collected_bt_state[int.parse(this.postslist[7])],
                        size: ScreenUtil().setHeight(95),
                      ),
                    ),
                    onTap: (){
                      print('点了收藏了！');
                      if (int.parse(this.postslist[7]) == 1) {
                        collect(widget.arguments['postuid'], 0);
                        setState(() {
                          this.postslist[3] = this.postslist[3] - 1;
                          this.postslist[7] = '0';
                        });
                      } else {
                        collect(widget.arguments['postuid'], 1);
                        setState(() {
                          this.postslist[3] = this.postslist[3] + 1;
                          this.postslist[7] = '1';
                        });
                      }
                    },
                  )),
              Positioned(
                  bottom: ScreenUtil().setWidth(12),
                  left: ScreenUtil().setWidth(330),
                  //top: ScreenUtil().setWidth(20),
                  child: Text(
                    'Collect ' + this.postslist[3].toString(),
                    style: TextStyle(fontSize: ScreenUtil().setSp(45)),
                  )),
            ],
          ),
        ),
      )
          : Text("加载中。。。。。。"),
    );
  }
}
