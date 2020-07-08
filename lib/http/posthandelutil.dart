import 'package:dio/dio.dart';
import 'package:flutter_app99/http/httputil.dart';



follow(usertofollow, state) async {
  FormData formData =
  new FormData.fromMap({"usertofollow": usertofollow, "state": state});
  var url = "http://m.nokia-nsb.com/post/follow/";
  print('开始发送follow请求了');
  print(url);
  Response response = await httprequest.post(url,data: formData);
}
like(postuid, state) async {
  FormData formData =
  new FormData.fromMap({"postuid": postuid, "state": state});
  print('开始发送post请求了');
  var url = "http://m.nokia-nsb.com/post/thumbsup/";
  Response response = await httprequest.post(url,data: formData);
}
collect(postuid, state) async {
  FormData formData =
  new FormData.fromMap({"postuid": postuid, "state": state});
  print('开始发送post请求了');
  var url = "http://m.nokia-nsb.com/post/collect/";
  Response response = await httprequest.post(url,data: formData);
}
