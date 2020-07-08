import 'package:flutter/material.dart';
import 'package:flutter_app99/http/posthandelutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flutter_app99/http/httputil.dart';

class PersonalHomepage extends StatefulWidget {
  final arguments;

  PersonalHomepage({Key key, this.arguments}) : super(key: key);

  @override
  _PersonalHomepage createState() => _PersonalHomepage();
}

class _PersonalHomepage extends State<PersonalHomepage> {
  List isliked_color = [Colors.grey,Colors.red];
  List myinfoli = new List();
  List tmppostsli = new List();
  List postslist = new List();
  _number_render(int nbr) {
    if (nbr > 999) {
      return '999+';
    } else {
      return nbr.toString();
    }
  }
  void initState() {
    super.initState();
    this._getpersonalhomepagesummary();
  }

  _getpersonalhomepagesummary() async {
    FormData formData =
        new FormData.fromMap({"useruid": widget.arguments['useruid']});
    print('开始发送post请求了');
    var url = "http://m.nokia-nsb.com/personalhomepagesummary/";
    Response response = await httprequest.post(url, data: formData);
    print('请求 个人信息');
    var xmlDoc = xml.parse(response.data.toString());
    print('获取response');
    print(xmlDoc);
    var _xmlList = xmlDoc.findAllElements("data");
    print('获取myinfo');
    for (var xml_item in _xmlList) {
      List tmpli = new List();
      print('遍历myinfo list');
      var headpicico = xml_item.findElements('headpicico').first.text;
      var briefintroduction =
          xml_item.findElements('briefintroduction').first.text;
      var userruid = xml_item.findElements('userruid').first.text;
      var number_followers =
          int.parse(xml_item.findElements('number_followers').first.text);
      var number_likes =
          int.parse(xml_item.findElements('number_likes').first.text);
      var number_followe =
          int.parse(xml_item.findElements('number_followe').first.text);
      tmpli.add(headpicico);
      tmpli.add(userruid);
      tmpli.add(briefintroduction);
      tmpli.add(number_followers);
      tmpli.add(number_followe);
      tmpli.add(number_likes);

      this.myinfoli = tmpli;
    }
    var _xmlList_postdata = xmlDoc.findAllElements("post").toList();
    print('获取post list');

    for (var xml_item in _xmlList_postdata) {
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
    return this.myinfoli.length > 0
        ? MaterialApp(
            home: Scaffold(
              body: Center(
                child: ListView(
                  children: <Widget>[
                    Container(
                      //color: Colors.red,
                      height: ScreenUtil().setHeight(580),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          Container(
                            //color:Colors.red,
                            margin: EdgeInsets.fromLTRB(
                                0, ScreenUtil().setHeight(50), 0, 0),
                            child: ClipOval(
                              child: Image.network(
                                this.myinfoli[0],
                                fit: BoxFit.cover,
                                width: ScreenUtil().setWidth(230),
                                height: ScreenUtil().setHeight(250),
                              ),
                            ),
                          ),
                          Container(
                            //color:Colors.blue,
                            margin: EdgeInsets.fromLTRB(
                                0, ScreenUtil().setHeight(330), 0, 0),
                            child: Text(
                              this.myinfoli[1],
                              style:
                                  TextStyle(fontSize: ScreenUtil().setSp(43)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: ScreenUtil().setHeight(30),
                      color: Color.fromRGBO(233, 233, 233, 0.9),
                    ),
                    Container(
                      //color: Colors.red,
                      height: ScreenUtil().setHeight(250),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                  child: Text(
                                      this._number_render(this.myinfoli[3]),
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(100))),
                                ),
                                Text('follower',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(50)))
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                  child: Text(
                                      this._number_render(this.myinfoli[4]),
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(100))),
                                ),
                                Text('follow',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(50)))
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                  child: Text(
                                      this._number_render(this.myinfoli[5]),
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(100))),
                                ),
                                Text('likes',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(50)))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        height: ScreenUtil().setHeight(30),
                        color: Color.fromRGBO(233, 233, 233, 0.9)),
                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      //padding: EdgeInsets.all(10.0),
                      childAspectRatio: 0.6,
                      crossAxisSpacing: ScreenUtil().setHeight(10),
                      mainAxisSpacing: ScreenUtil().setHeight(10),
                      children: this.postslist.map((value) {
                        return Container(
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
                                          fit: BoxFit.cover)
                                  ),
                                  onTap: () {
                                    var posttype = value[8];
                                    if (posttype == 'text') {
                                      Navigator.pushNamed(context, '/posttext',
                                          arguments: {'postuid': value[1]});
                                    } else {
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
                                          Navigator.pushNamed(
                                              context, '/posttext',
                                              arguments: {'postuid': value[1]});
                                        } else {
                                          Navigator.pushNamed(
                                              context, '/postvideo',
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
                                                Icon(Icons.thumb_up,size: ScreenUtil().setWidth(65),color: this.isliked_color[value[9]],),
                                                Padding(padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(15), 0, 0, 0),
                                                  child: Text(value[4].toString(),style: TextStyle(
                                                      fontSize: ScreenUtil().setSp(30)
                                                  ),),),
                                              ],
                                            ),
                                          ),
                                          onTap: (){
                                            if(value[9] == 1){
                                              like(value[1], 0);
                                              setState(() {
                                                value[4] = value[4] - 1;
                                                value[9] = 0;
                                              });
                                            }
                                            else{
                                              like(value[1], 1);
                                              setState(() {
                                                value[9] = 1;
                                                value[4] = value[4] + 1;
                                              });
                                            }





                                          },
                                        ),),
                                      Positioned(
                                          bottom: ScreenUtil().setWidth(20),
                                          left: ScreenUtil().setWidth(10),
                                          //top: ScreenUtil().setWidth(20),
                                          child: GestureDetector(
                                            child: Container(
                                              width: ScreenUtil().setWidth(75),
                                              height:
                                              ScreenUtil().setHeight(75),
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(value[3]),
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, '/personalhomepage',
                                                  arguments: {
                                                    'useruid': value[5]
                                                  });
                                            },
                                          )),
                                      Positioned(
                                          bottom: ScreenUtil().setWidth(25),
                                          left: ScreenUtil().setWidth(95),
                                          //top: ScreenUtil().setWidth(20),
                                          child: Text(
                                            value[5],
                                            style: TextStyle(
                                                fontSize:
                                                ScreenUtil().setSp(40)),
                                          )),

                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
            ),
          )
        : Text(
            '内容加载中。。。',
          );
  }
}
