import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class MediaPage extends StatefulWidget {
  MediaPage({Key key}) : super(key: key);

  @override
  _MediaPageState createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  IjkMediaController controller = IjkMediaController();

  @override
  void initState() {
    super.initState();
    this.initMedia();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  //初始化视频
  initMedia() async {
    await controller.setNetworkDataSource(
        'http://49.234.35.246:8000/live/stream.flv',
        autoPlay: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("好货清仓，每天遇见更美好的自己"),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              height: 200, //指定视频的高度
              child: IjkPlayer(
                mediaController: controller,
              ),
            ),
            SizedBox(height: 40),
            Text('welcom to my live telecast !')
          ],
        ));
  }
}
