import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelpService extends StatefulWidget {
  @override
  _HelpServiceState createState() => _HelpServiceState();
}

class _HelpServiceState extends State<HelpService> {

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    //ScreenUtil().setWidth(35)
    //ScreenUtil().setSp(30)
    //ScreenUtil().setHeight(10)

    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop()),
        title: Text("Help service",style: TextStyle(fontSize: ScreenUtil().setSp(60)),),
        centerTitle: true,
        ),
      body: Container(
        margin: EdgeInsets.fromLTRB(0, ScreenUtil().setWidth(75), 0,0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                "How to reach us ?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(60),
                  color: Colors.black
                ),
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(60),),
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(55)),
              child: Text(
                  "E-mail address :  xxxxx.com ",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: ScreenUtil().setSp(40),
                    color: Colors.black54
                ),
              ),
            ),
            SizedBox(height: ScreenUtil().setWidth(60),),
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(55)),
              child: Text(
                  "Wechat : xxxxxxxxxxx ",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: ScreenUtil().setSp(40),
                    color: Colors.black54
                ),
              ),
            ),
            SizedBox(height: 40,),
          ],
        ),
      ),
      );
  }
}

