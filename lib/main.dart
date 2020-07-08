import 'pages/addpages/DraftBox.dart';
import 'package:flutter/material.dart';
import 'pages/homapages/Homepage.dart';
import 'pages/addpages/ImageVideoUpload.dart';
import 'pages/postsdetailpages/Postdetailofvideo.dart';
import 'pages/postsdetailpages/Postdetailoftext.dart';
import 'pages/myinfopages/MyMessages.dart';
import 'pages/myinfopages/HelpServices.dart';
import 'pages/myinfopages/Collections.dart';
import 'pages/myinfopages/PersonalHomepage.dart';
import 'pages/settingpages/Settingpage.dart';
import 'pages/settingpages/loginpage.dart';
import 'pages/settingpages/registerpage.dart';
import 'package:get/get.dart';
import 'package:flutter_app99/pages/homapages/Myhomepage_body.dart';





void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  void initState() {
    print('wo是首页');
    // TODO: implement initState
    print('haluo ow laile !!!');
    //super.initState();
  }
  // This widget is the root of your application.
  final routes = <String, WidgetBuilder>{
    '/Myhomepagebody': (context) => Myhomepagebody(),
    '/imagevideoupload': (context) => ImageVideoUpload(),
    '/draftbox': (context,{arguments}) => DraftBox(arguments: arguments),
    '/posttext': (context, {arguments}) => Postoftextpage(arguments: arguments),
    '/postvideo': (context,{arguments}) => Postofvideopage(arguments: arguments),
    '/helpservice' : (context) => HelpService(),
    '/message' : (context) => MyMessages (),
    '/collection' : (context) => Collection(),
    '/personalhomepage' : (context,{arguments}) => PersonalHomepage(arguments: arguments),
    '/settingpage' : (context,{arguments}) => Settingpage(arguments: arguments),
    '/login' : (context) => Loginpage(),
    '/registerpage' : (context) => Registerpage(),
    '/MyHomePage' : (context) => MyHomePage(),

   //'/homepage':(context) => MyApp(),
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: Get.key,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: MyHomePage(
          title: 'Aifei',
        ),
        onGenerateRoute: (RouteSettings settings) {
          final String name = settings.name;
          final Function pageContentBuilder = this.routes[name];
          if (pageContentBuilder != null) {
            if (settings.arguments != null) {
              final Route route = MaterialPageRoute(
                  builder: (context) =>
                      pageContentBuilder(
                          context, arguments: settings.arguments));
              return route;
            } else {
              final Route route = MaterialPageRoute(
                  builder: (context) =>
                      pageContentBuilder(context));
              return route;
            }
          }
        }
    );
  }
}

class Router {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
}
