import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flutter_app99/http/httputil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Myinfopage extends StatefulWidget {
  @override
  _Myinfopage createState() {
    return new _Myinfopage();
  }
}

//根据屏幕宽度适配：width:ScreenUtil().setWidth(540);
//根据屏幕高度适配：height:ScreenUtil().setHeight(200);
//适配字体大小：fontSize：ScreenUtil().setSp(28,false);
//自定义mybuttonpage的widget 继承自stfulwidget状态的widget
class _Myinfopage extends State<Myinfopage> {
  final briefintroduction = TextEditingController();
  List<bool> _breifstate = [false, true];
  List is_brief_changed = [Icons.edit,Icons.check_circle];
  int _breifstateindex = 1;
  List myinfoli = new List();

  void initState() {
    super.initState();

    briefintroduction.addListener((){
      //通过controller获取输入框内容
      print("content="+briefintroduction.text);
    });
    this._getmyinfossummary();
    //briefintroduction.text = 'dafdafda ';
  }

  _getmyinfossummary() async {
    print('请求 个人信息');
    var url = "http://m.nokia-nsb.com/myinfopage/summary/";
    Response response = await httprequest.get(url);
    var xmlDoc = xml.parse(response.data.toString());
    print('获取response');
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
    print('遍历myinfo list完成');
    setState(() {
      print('强制页面刷新');
    });
  }

  _number_render(int nbr) {
    if (nbr > 999) {
      return '999+';
    } else {
      return nbr.toString();
    }
  }

var statecode;
  var statedesc;

  _updateuserinfo(formData) async{
    var url = 'http://m.nokia-nsb.com/user/update/';
    try {
      Response response = await httprequest.post(url,data:formData );
      var xmlDoc = xml.parse(response.data.toString());
      print('获取response');
      var _xmlList = xmlDoc.findAllElements("head").toList();
      for (var xml_item in _xmlList){
        statecode = xml_item.findElements('statecode').first.text;
        statedesc = xml_item.findElements('statedesc').first.text;
      }

      if (statecode == 'OK'){
        Fluttertoast.showToast(
          msg: '个人简介更新完成!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          fontSize:ScreenUtil().setSp(40),
          textColor: Colors.red,
        );
        setState(() {
          this._getmyinfossummary();

        });

      }
      else{
        Fluttertoast.showToast(
          msg: '个人简介更新失败！！',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          fontSize:ScreenUtil().setSp(40),
          textColor: Colors.red,
        );
      }





      print('post上传结束，跳转到首页：');
    }  on Exception catch (e) { // 所有的 Exception
      print('所有exception');
    } catch (e) { // 不指定错误类型，匹配所有
      print('发送post报错，错误是：');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    this.myinfoli.length > 0? briefintroduction.text = this.myinfoli[2]:briefintroduction.text = '';
    FocusNode nodeTwo = FocusNode();
    print(_breifstateindex);
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    return this.myinfoli.length > 0
        ? Scaffold(body: ListView(
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
                child: Stack(
                  children: <Widget>[
                    ClipOval(
                      child: Image.network(
                        this.myinfoli[0],
                        fit: BoxFit.cover,
                        width: ScreenUtil().setWidth(230),
                        height: ScreenUtil().setHeight(250),
                      ),
                    ),

                  ],
                ),
              ),
              Positioned(

                top: ScreenUtil().setWidth(0),
                right: ScreenUtil().setWidth(0),
                child: FlatButton(child: IconButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/settingpage');

                  },
                  color: Colors.red,
                  icon: Icon(Icons.settings),
                iconSize: ScreenUtil().setHeight(80) ,),),
              ),
              Container(
                //color:Colors.blue,
                margin: EdgeInsets.fromLTRB(
                    0, ScreenUtil().setHeight(330), 0, 0),
                child: Text(
                  this.myinfoli[1],
                  style: TextStyle(fontSize: ScreenUtil().setSp(43)),
                ),
              ),
              Container(
                //alignment: Alignment.topCenter,
                //width: ScreenUtil().setWidth(840),
                  margin: EdgeInsets.fromLTRB(
                      0, ScreenUtil().setHeight(400), 0, 0),
                  child: Container(
                    width: ScreenUtil().setWidth(840),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 9,
                          child: TextField(
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              controller: briefintroduction,
                              enableInteractiveSelection: true,
                              enabled: true,
                              textAlign: TextAlign.center,
                              maxLines:2,
                              maxLengthEnforced: true,
                              focusNode: nodeTwo,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(43)),
                              decoration: const InputDecoration(
                                contentPadding:
                                EdgeInsets.only(bottom: 6.0),
                                //contentPadding: const EdgeInsets.all(10.0),
                              ),
                              // 当 value 改变的时候，触发


                              ),
                        ),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            child: Icon(this.is_brief_changed[this._breifstateindex]),
                            onTap: () {
                              setState(() {
                                if (this.myinfoli[2] == briefintroduction.text.toString()){
                                  print('我被点解了哦,内容没变');
                                }
                                else{
                                  FormData formData = new FormData.fromMap({
                                    "BriefIntroduction": briefintroduction.text.toString(),
                                  });
                                  this._updateuserinfo(formData);
                                  print('我被点解了哦,内容变了！！！');
                                }

                              });
                            },
                          ),
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
        Container(
          height: ScreenUtil().setHeight(30),
          color: Color.fromRGBO(233, 233, 233, 0.9),
        ),
        Container(
          color: Colors.red,
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
                      child: Text(this._number_render(this.myinfoli[3]),
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(100))),
                    ),
                    Text('follower',
                        style:
                        TextStyle(fontSize: ScreenUtil().setSp(50)))
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Text(this._number_render(this.myinfoli[4]),
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(100))),
                    ),
                    Text('follow',
                        style:
                        TextStyle(fontSize: ScreenUtil().setSp(50)))
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Text(this._number_render(this.myinfoli[5]),
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(100))),
                    ),
                    Text('likes',
                        style:
                        TextStyle(fontSize: ScreenUtil().setSp(50)))
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
            height: ScreenUtil().setHeight(30),
            color: Color.fromRGBO(233, 233, 233, 0.9)),
        Container(
          child: Column(
            children: <Widget>[
              Container(
                child: ListTile(
                  leading: Icon(
                    Icons.video_library,
                    size: ScreenUtil().setHeight(70),
                  ),
                  title: Text(
                    "Myhomepage",
                    style: TextStyle(fontSize: ScreenUtil().setSp(53)),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: ScreenUtil().setHeight(70),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/personalhomepage',arguments: {'useruid': this.myinfoli[1]});
                  },
                ),
              ),
            ],
          ),
        ),
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
      ],
    ),)
        : Text(
            '内容加载中。。。',
          );
  }
}
