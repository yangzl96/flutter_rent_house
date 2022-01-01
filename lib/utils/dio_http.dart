// // ignore_for_file: unnecessary_this, unnecessary_null_comparison
// ignore_for_file: import_of_legacy_library_into_null_safe, unnecessary_null_comparison, void_checks, unnecessary_this, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:goodhouse/scoped_model/auth.dart';
import 'package:goodhouse/utils/common_toast.dart';
import 'package:goodhouse/utils/scoped_model_helper.dart';

import '../config.dart';
import '../routes.dart';

class DioHttp {
  Dio? _client;
  BuildContext? context;

  static DioHttp of(BuildContext context) {
    return DioHttp._internal(context);
  }

  DioHttp._internal(BuildContext context) {
    if (_client == null || context != this.context) {
      this.context = context;
      var options = BaseOptions(
          baseUrl: Config.BaseUrl,
          connectTimeout: 1000 * 10,
          receiveTimeout: 1000 * 5,
          extra: {'context': context},
          responseType: ResponseType.plain);
      Interceptor interceptor =
          InterceptorsWrapper(onResponse: (Response res, handler) {
        // print(res);
        if (null == res) handler.next(res);
        // 拦截提示信息
        if (res.data['status'] != 200) {
          CommonToast.showToast(res.data['description']);
        }
        return handler.next(res);
      }, onError: (DioError e, handler) {
        //错误处理
        var status = e.response!.statusCode;
        if (404 == status) {
          CommonToast.showToast('接口地址错误！当前接口：${e.requestOptions.path}');
          return handler.next(e);
        }
        if (status.toString().startsWith('4')) {
          ScopedModelHelper.getModel<AuthModel>(context).logout();

          // token 存在 但是token过期了，可能会出现：
          // 从loading页面跳转到登录页，然后登录页登陆成功pop回到loading页面
          // 处理在loading页面的时候不要调到登录页面

          if (ModalRoute.of(context)!.settings.name == Routes.loading) {
            return handler.next(e);
          }

          // 当前请求为登录请求则不处理
          // if (!res.requestOptions.path.startsWith('/user/login')) {
          //   CommonToast.showToast('登录过期');
          //   Navigator.of(context).pushNamed(Routes.login);
          // }

          return handler.next(e);
        }
        return handler.next(e);
      });

      var client = Dio(options);
      client.interceptors.add(interceptor);
      this._client = client;
    }
  }
  Future<Response<Map<String, dynamic>>> get(String path,
      [Map<String, dynamic>? params, String? token]) async {
    var options = Options(headers: {'Authorization': token});
    return await _client!.get(path, queryParameters: params, options: options);
  }

  Future<Response<Map<String, dynamic>>> post(String path,
      [Map<String, dynamic>? params, String? token]) async {
    var options = Options(headers: {'Authorization': token});
    return await _client!.post(path, data: params, options: options);
  }

  Future<Response<Map<String, dynamic>>> postFormData(String path,
      [Map<String, dynamic>? params, String? token]) async {
    var options = Options(
        contentType: 'multipart/form-data',
        responseType: ResponseType.plain,
        headers: {'Authorization': token});
    return await _client!.post(path, data: params, options: options);
  }
}

// --------------------------
// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:goodhouse/config.dart';
// import 'package:goodhouse/routes.dart';
// import 'package:goodhouse/scoped_model/auth.dart';
// import 'package:goodhouse/utils/common_toast.dart';
// import 'package:goodhouse/utils/scoped_model_helper.dart';

// class DioHttp {
//   static final BaseOptions baseOptions = BaseOptions(
//     baseUrl: Config.BaseUrl,
//     connectTimeout: 1000 * 10,
//     receiveTimeout: 1000 * 3,
//   );

//   static Dio dio = Dio(baseOptions);

//   Interceptor interceptor =
//       InterceptorsWrapper(onResponse: (response, handler) {
//     if (response == null) return response;
//     var status = json.decode(response.toString());
//     if (status == 404) {
//       CommonToast.showToast('请求地址不存在');
//       return response;
//     }
//     if (status.toString().startsWith('4')) {
//       ScopedModelHelper.getModel<AuthModel>(context).logout();
//       CommonToast.showToast('登陆过期');
//       Navigator.of(context).pushNamed(Routes.login);
//       return response;
//     }
//     return response;
//   });

//   // 封装get
//   static Future<Response<Map<String, dynamic>>> get(String path,
//       [Map<String, dynamic>? params, String? token]) async {
//     var options = Options(headers: {'Authorization': token});
//     return await dio.get(path, queryParameters: params, options: options);
//   }

//   // post
//   static Future<Response<Map<String, dynamic>>> post(String path,
//       [Map<String, dynamic>? params, String? token]) async {
//     var options = Options(headers: {'Authorization': token});
//     return await dio.post(path, data: params, options: options);
//   }

//   // post form-data
//   static Future<Response<Map<String, dynamic>>> postFormData(String path,
//       [Map<String, dynamic>? params, String? token]) async {
//     var options = Options(
//         contentType: 'multipart/form-data', headers: {'Authorization': token});
//     return await dio.post(path, data: params, options: options);
//   }
// }


// -------------------------
//   static Future<T> request<T>(String url,
//       {String method = "get",
//       Map<String, dynamic>? params,
//       Interceptor? inter}) async {
//     // 1.创建单独配置
//     final options = Options(method: method);

//     //全局拦截器
//     //创建默认的全局拦截器
//     Interceptor dInter = InterceptorsWrapper(onRequest: (options, handler) {
//       // Do something before request is sent
//       return handler.next(options); //continue
//     }, onResponse: (response, handler) {
//       // Do something with response data
//       return handler.next(response); // continue
//     }, onError: (DioError e, handler) {
//       // Do something with response error
//       return handler.next(e); //continue
//     });
//     List<Interceptor> inters = [dInter];

//     // 请求单独拦截器
//     if (inter != null) {
//       inters.add(inter);
//     }

//     // 统一添加到拦截器中
//     dio.interceptors.addAll(inters);

//     // 2.发送网络请求
//     try {
//       Response response =
//           await dio.request(url, queryParameters: params, options: options);
//       return response.data;
//     } on DioError catch (e) {
//       return Future.error(e);
//     }
//   }
// }
// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:goodhouse/config.dart';

// class DioHttp {
//   Dio _client = Dio();
//   late BuildContext context;

//   static DioHttp of(BuildContext context) {
//     return DioHttp._internal(context);
//   }

//   DioHttp._internal(BuildContext context) {

//     if (_client == null || context != this.context) {
//       this.context = context;
//       var options = BaseOptions(
//           baseUrl: Config.BaseUrl,
//           connectTimeout: 1000 * 10,
//           receiveTimeout: 1000 * 3,
//           extra: {'context': context});

//       var client = Dio(options);
//       this._client = client;
//     }
//   }

//   // 封装get
//   Future<Response<Map<String, dynamic>>> get(String path,
//       [Map<String, dynamic>? params, String? token]) async {
//     var options = Options(headers: {'Authorization': token});
//     return await _client.get(path, queryParameters: params, options: options);
//   }

//   // post
//   Future<Response<Map<String, dynamic>>> post(String path,
//       [Map<String, dynamic>? params, String? token]) async {
//     var options = Options(headers: {'Authorization': token});
//     return await _client.post(path, data: params, options: options);
//   }

//   // post form-data
//   Future<Response<Map<String, dynamic>>> postFormData(String path,
//       [Map<String, dynamic>? params, String? token]) async {
//     var options = Options(
//         contentType: 'multipart/form-data', headers: {'Authorization': token});
//     return await _client.post(path, data: params, options: options);
//   }
// }
