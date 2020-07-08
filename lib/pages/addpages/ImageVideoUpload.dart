import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app99/http/httputil.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app99/pages/homapages/Homepage.dart';
import 'package:video_player/video_player.dart';

class ImageVideoUpload extends StatefulWidget {
  @override
  _ImageVideoUploadState createState() => _ImageVideoUploadState();
}

class _ImageVideoUploadState extends State<ImageVideoUpload> {
  bool _isPlaying = false;
  Map data = {};
  File _videoFile;
  VideoPlayerController _videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;

// This funcion will helps you to pick a Video File

  File imageFile;
  String description;
  String title;
  final descriptionControl = TextEditingController();
  final titleControl = TextEditingController();

  DateTime date = DateTime.now();
  String todayDate;

  @override
  void dispose() {
    descriptionControl.dispose();
    titleControl.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    titleControl.addListener(() {
      //通过controller获取输入框内容
      print("title=" + titleControl.text);
    });
    descriptionControl.addListener(() {
      //通过controller获取输入框内容
      print("content=" + descriptionControl.text);
    });
  }

  // To to get the photos from local storage
  _pickimage() async {
    print('挑选图片来了');
    File selectedImage =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        imageFile = selectedImage;
      });
    }
  }

  _pickVideo() async {
    print('挑选视频来了');
    //var image = await ImagePicker.pickVideo(source: ImageSource.gallery);
    File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    _videoFile = video;
    _videoPlayerController = VideoPlayerController.file(_videoFile)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    //根据屏幕宽度适配：width:ScreenUtil().setWidth(540);
//根据屏幕高度适配：height:ScreenUtil().setHeight(200);
//适配字体大小：fontSize：ScreenUtil().setSp(28);
    data = ModalRoute.of(context).settings.arguments;

    _upload(path, name) async {
      //Dio dio = new Dio();
      print('待上传的文件名称及路径');
      //new UploadFileInfo(new File(path), name,contentType: ContentType.parse("image/$suffix")),
      var image_file = await MultipartFile.fromFile(path, filename: name);
      //var video_file = await MultipartFile.fromFile(path1, filename: name1);
      FormData formData = new FormData.fromMap({
        "file": image_file,
        //"file2": image_file,
        //"videofile": file,
        "title": titleControl.text.toString(),
        "textcontent": ' ' + ' ' + descriptionControl.text.toString(),
        "createtime": DateTime.now().millisecondsSinceEpoch,
      });

      //formData = new Map<String, dynamic>.from(formData);
      var url = 'http://m.nokia-nsb.com/post/upload/';
      try {
        Response response = await httprequest.post(url, data: formData);
        //Response response = await dio.post(url, data: formData);
        print('上传结果是：');
        print(response.data);
        Fluttertoast.showToast(
          msg: 'POST 发布成功！',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          fontSize: ScreenUtil().setSp(40),
          textColor: Colors.red,
        );
        print('post上传结束，跳转到首页：');
        //Navigator.pushNamed(context, '/MyHomePage');
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => new MyHomePage()),
            (route) => route == null);
        //return true;
      } on Exception catch (e) {
        // 所有的 Exception
        print('所有exception');
      } catch (e) {
        // 不指定错误类型，匹配所有
        print('发送post报错，错误是：');
        print(e);
      }
    }

    title = titleControl.text.toString();
    description = descriptionControl.text.toString();
    todayDate = DateFormat('yyyy-MM-dd').format(date);
    data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.grey[300],
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(0),
            child: ListView(
              children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(
                            0,
                            ScreenUtil().setHeight(5),
                            0,
                            ScreenUtil().setHeight(5)),
                        child: Column(
                          children: <Widget>[
                            // Cancel Icon
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: ScreenUtil().setHeight(30),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          color: Colors.black,
                                        ),
                                        iconSize: ScreenUtil().setHeight(90),
                                        color: Colors.white,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(height: ScreenUtil().setHeight(20)),
                            // Add photos Icons + text
                            InkWell(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    ScreenUtil().setHeight(20),
                                    ScreenUtil().setHeight(20),
                                    0,
                                    0),
                                child: Container(
                                  height: ScreenUtil().setHeight(200),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child:IconButton(
                                          //child: RaisedButton.icon(
                                          onPressed: () {
                                            //_gallery();
                                            _pickimage();
                                          },
                                          icon: Icon(
                                            Icons.add_to_photos,
                                            color: Colors.black,
                                            size: ScreenUtil().setSp(140),
                                          ),
                                        )
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child:GestureDetector(
                                            onTap: () {
                                              _pickimage();
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  ScreenUtil().setHeight(50),
                                                  ScreenUtil().setHeight(50),
                                                  0,
                                                  0),
                                              child: Text(
                                                "Add photos",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: ScreenUtil().setSp(65),
                                                    fontWeight: FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                      ),
                                      /*
                                      Expanded(
                                          flex: 1,
                                          child:IconButton(
                                            //child: RaisedButton.icon(
                                            onPressed: () {
                                              //_gallery();

                                              //_pickVideo();目前不做video的功能
                                            },
                                            icon: Icon(
                                              Icons.video_library,
                                              color: Colors.black,
                                              size: ScreenUtil().setSp(140),
                                            ),
                                          )
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child:GestureDetector(
                                          onTap: () {
                                            _pickVideo();
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                ScreenUtil().setHeight(50),
                                                ScreenUtil().setHeight(50),
                                                0,
                                                0),
                                            child: Text(
                                              "Add videos",

                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: ScreenUtil().setSp(65),
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                      ),
                                  */
                                      //SizedBox(width:100,),
                                      //SizedBox(width:100,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(height: ScreenUtil().setHeight(7)),
                      Container(
                        //height: ScreenUtil().setHeight(800),
                        margin: EdgeInsets.fromLTRB(ScreenUtil().setHeight(20),
                            0, ScreenUtil().setHeight(20), 0),
                        color: Colors.grey,
                        child: imageFile == null
                            ? Center(
                                child: Container(
                                  child: data == null
                                      ? Container()
                                      : Image.file(
                                          data['imageFile'],
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              )
                            : Center(
                                child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    ScreenUtil().setHeight(5),
                                    ScreenUtil().setHeight(5),
                                    ScreenUtil().setHeight(5),
                                    ScreenUtil().setHeight(5)),
                                child: Image.file(
                                  imageFile,
                                  fit: BoxFit.fill,
                                ),
                              )),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            if (_videoFile != null)
                              _videoPlayerController.value.initialized
                                  ? Center(
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            ScreenUtil().setHeight(20),
                                            0,
                                            ScreenUtil().setHeight(20),
                                            0),
                                        child: AspectRatio(
                                          aspectRatio: _videoPlayerController
                                              .value.aspectRatio,
                                          child: VideoPlayer(
                                              _videoPlayerController),
                                        ),
                                      ),
                                    )
                                  : Container()
                          ],
                        ),
                      ),
                      //Container(height: ScreenUtil().setHeight(7)),
                      // Title + say something
                      Container(
                        margin: EdgeInsets.fromLTRB(ScreenUtil().setHeight(20),
                            0, ScreenUtil().setHeight(20), 0),
                        height: ScreenUtil().setHeight(600),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  ScreenUtil().setHeight(30),
                                  ScreenUtil().setHeight(0),
                                  ScreenUtil().setHeight(400),
                                  ScreenUtil().setHeight(0)),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                      controller: titleControl,
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(40)),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          hintText: "Title",
                                          hintStyle: TextStyle(
                                              fontSize:
                                                  ScreenUtil().setSp(40))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  ScreenUtil().setHeight(80),
                                  ScreenUtil().setHeight(20),
                                  0,
                                  0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                      controller: descriptionControl,
                                      keyboardType: TextInputType.text,
                                      maxLines: null,
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(40)),
                                      decoration: InputDecoration(
                                          focusedBorder: InputBorder.none,
                                          border: InputBorder.none,
                                          hintText: "Say something",
                                          hintStyle: TextStyle(
                                              fontSize:
                                                  ScreenUtil().setSp(40))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: ScreenUtil().setHeight(30)),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            ScreenUtil().setHeight(30), 0, 0, 0),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: ScreenUtil().setHeight(74),
                              child: Column(
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, '/draftbox',
                                          arguments: {
                                            'imageFile': imageFile,
                                            'date': todayDate,
                                            'title': title,
                                            'description': description,
                                          });
                                    },
                                    icon: Icon(Icons.drafts),
                                  ),
                                  
                                ],
                              ),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(130)),
                            Container(
                              //color: Colors.white,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setHeight(10)),
                              ),
                              child: FlatButton(
                                onPressed: () {
                                  print(todayDate.toString());
                                  print(DateTime.now().millisecondsSinceEpoch);
                                  print(description);
                                  print(title);
                                  if (imageFile == null ){
                                    Fluttertoast.showToast(
                                      msg: '请至少选择一张图片！！',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIos: 2,
                                      fontSize: ScreenUtil().setSp(40),
                                      textColor: Colors.red,
                                    );
                                  }
                                  else {
                                    String image_path = imageFile.path;
                                    //String video_path = _videoFile.path;
                                    var image_name = image_path.substring(image_path.lastIndexOf("/") + 1, image_path.length);
                                    //var video_name = video_path.substring(video_path.lastIndexOf("/") + 1, video_path.length);
                                    String image_suffix = image_name.substring(image_name.lastIndexOf(".") + 1, image_name.length);

                                    _upload(image_path, image_name);

                                  }

                                },
                                child: Text(
                                  "Upload",
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(35),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UploadFileInfo {
  UploadFileInfo(this.file, this.fileName, {ContentType contentType})
      : bytes = null,
        this.contentType = contentType ?? ContentType.binary;

  UploadFileInfo.fromBytes(this.bytes, this.fileName, {ContentType contentType})
      : file = null,
        this.contentType = contentType ?? ContentType.binary;

  /// The file to upload.
  final File file;

  /// The file content
  final List<int> bytes;

  /// The file name which the server will receive.
  final String fileName;

  /// The content-type of the upload file. Default value is `ContentType.binary`
  ContentType contentType;
}
