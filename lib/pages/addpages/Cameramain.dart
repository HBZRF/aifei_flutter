import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';




class Cameramain extends StatefulWidget {
  @override
  _Cameramain createState() => _Cameramain();
}

class _Cameramain extends State<Cameramain> {
  CameraController camerascontroller;
  List<CameraDescription> cameras;
  Future initcamera() async {
    cameras = await availableCameras();
    camerascontroller = CameraController(cameras[0], ResolutionPreset.medium);
    camerascontroller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }


//
  @override
  void initState() {
    super.initState();
    initcamera();
  }

  @override
  void dispose() {
    camerascontroller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!camerascontroller.value.isInitialized) {
      print('dddffffggggg');
      return Container(
        child: Text("ddddddfa"),
      );
    }
    return AspectRatio(
        aspectRatio:
        camerascontroller.value.aspectRatio,
        child: CameraPreview(camerascontroller));
  }
}