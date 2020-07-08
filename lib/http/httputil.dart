import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter_app99/pages/settingpages/loginpage.dart';
import 'package:flutter_app99/main.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'package:flutter/material.dart';



class HttpUtil {
  var cookiespath;
  static HttpUtil instance;
  Dio dio;
  BaseOptions options;

  CancelToken cancelToken = new CancelToken();

  static HttpUtil getInstance() {
    if (null == instance) instance = new HttpUtil();
    return instance;
  }

  /*
   * config it and create
   */
  HttpUtil() {
    //BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    options = new BaseOptions(
      //请求基地址,可以包含子路径
      baseUrl: "http://m.nokia-nsb.com",
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: 10000,
      //响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: 5000,
      //Http请求头.
      headers: {
        //do something
        "version": "1.0.0"
      },
      //请求的Content-Type，默认值是[ContentType.json]. 也可以用ContentType.parse("application/x-www-form-urlencoded")
      contentType: ContentType.json.toString(),
      //表示期望以那种格式(方式)接受响应数据。接受4种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      responseType: ResponseType.json,
    );
    dio = new Dio(options);
    print('初始的temp文件路径为：');
    print(cookiespath);
    //CookieJar

    //添加拦截器
    Api.cookieJar.then((cj) {
      dio.interceptors.add(CookieManager(cj));
    });
    dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      print("请求之前");
      // Do something before request is sent
      Api.cookieJar.then((cj) {
        print('当前的cookies是：');
        print(cj.loadForRequest(Uri.parse('http://m.nokia-nsb.com/')));
        //dio.interceptors.add(CookieManager(cj));
      });
      return options; //continue
    }, onResponse: (Response response) {
      print("响应之前,打印response");
      print(response);
      print('请求返回的状态码是:');
      print(response.statusCode);

      //navigatorKeylonin.currentState.pushNamed("/login");
      //Get.toNamed("/login");
      // Do something with response data
      return response; // continue
    }, onError: (DioError e) {
      print("错误响应");
      print('请求返回的状态码是:');
      print(e.type);
      print(e.response);
      if(e.response.statusCode==401){
//Navigator.pushNamed(context,'/login');
        print('tiaozhuanle');
        print('401');
//navigatorKeylonin.currentState.pushNamed("/login");
        Get.toNamed("/login");
        Fluttertoast.showToast(
          msg:'请登录！！！',
          toastLength:Toast.LENGTH_SHORT,
          gravity:ToastGravity.CENTER,
          timeInSecForIos:2,
          textColor:Colors.red,
        );
      }

      return e; //continue
    }));


    //setData() async {
      //cookiespath = await getCookiePath();
     // print('获取的temp文件路径完成');
     // print(cookiespath);
     // print('新建开始新建cj！！');
     // var cj=new PersistCookieJar(
     //   dir:cookiespath,
     //   ignoreExpires:false, //save/load even cookies that have expired.
     // );
     // print('新建cj成功！！');
     // dio.interceptors.add(CookieManager(cj));
     // print('添加cookie设置成功！！');
      //getData()延迟执行后赋值给data
   // };
    //setData();

  }

  /*
   * get请求
   */
  get(url, {data, options, cancelToken,queryParameters}) async {
    Response response;
    try {
      response = await dio.get(url, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
      print('get success---------${response.statusCode}');
      print('get success---------${response.data}');

//      response.data; 响应体
//      response.headers; 响应头
//      response.request; 请求体
//      response.statusCode; 状态码

    } on DioError catch (e) {
      print('get error---------$e');
      formatError(e);
    }
    return response;
  }

  /*
   * post请求
   */
  post(url, {data,queryParameters, options, cancelToken}) async {
    print('请求的url是：');
    print(url);
    print("请求的data是：");
    print(data);
    Response response;
    try {
      response = await dio.post(url, data: data, options: options, cancelToken: cancelToken,queryParameters:queryParameters);
      print('post success---------${response.data}');
    } on DioError catch (e) {
      print('post error---------$e');
      formatError(e);
    }
    return response;
  }

  /*
   * 下载文件
   */
  downloadFile(urlPath, savePath) async {
    Response response;
    try {
      response = await dio.download(urlPath, savePath,onReceiveProgress: (int count, int total){
        //进度
        print("$count $total");
      });
      print('downloadFile success---------${response.data}');
    } on DioError catch (e) {
      print('downloadFile error---------$e');
      formatError(e);
    }
    return response.data;
  }

  /*
   * error统一处理
   */
  void formatError(DioError e) {
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      // It occurs when url is opened timeout.
      print("连接超时");
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      // It occurs when url is sent timeout.
      print("请求超时");
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      //It occurs when receiving timeout
      print("响应超时");
    } else if (e.type == DioErrorType.RESPONSE) {
      // When the server response, but with a incorrect status, such as 404, 503...
      print("出现异常");
    } else if (e.type == DioErrorType.CANCEL) {
      // When the request is cancelled, dio will throw a error with this type.
      print("请求取消");
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      print("未知错误");
    }
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }
}

getCookiePath() async {
  var tempDir = await getTemporaryDirectory();
  print('临时路径是：');
  print(tempDir.path);
  return tempDir.path;
}


class Api {
  //改为使用 PersistCookieJar，在文档中有介绍，PersistCookieJar将cookie保留在文件中，因此，如果应用程序退出，则cookie始终存在，除非显式调用delete
  static PersistCookieJar _cookieJar;
  static Future<PersistCookieJar> get cookieJar async {
    // print(_cookieJar);
    if (_cookieJar == null) {
      print('cookies 是空的，新建一个');
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath  = appDocDir.path;
      print('获取的文件系统目录 appDocPath： ' + appDocPath);
      _cookieJar = new PersistCookieJar(dir: appDocPath);
    }
    return _cookieJar;
  }
}


class Router {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
}

var httprequest = HttpUtil();