// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodhouse/model/user_info.dart';
import 'package:goodhouse/utils/dio_http.dart';
import 'package:goodhouse/utils/store.dart';
import 'package:goodhouse/utils/string_isnull_or_empty.dart';
import 'package:scoped_model/scoped_model.dart';

// 共享数据
class AuthModel extends Model {
  String _token = ''; // token
  UserInfo? _userInfo; // 用户信息

  UserInfo? get userInfo => _userInfo;
  String get token => _token;
  bool get isLogin => _token is String && _token != '';

  // 初始化
  void initApp(BuildContext context) async {
    print('init app -----');
    Store store = await Store.getInstance();
    String token = await store.getString(StoreKeys.token);
    print('token: $token');
    print(stringIsNullOrEmpty(token));
    if (!stringIsNullOrEmpty(token)) {
      login(token, context);
    }
  }

  // 获取用户信息
  _getUserInfo(BuildContext context) async {
    const url = '/user';
    var res = await DioHttp.of(context).get(url, null, _token);
    var resMap = json.decode(res.toString());
    var data = resMap['body'];
    var userInfo = UserInfo.fromJson(data);
    _userInfo = userInfo;
    notifyListeners();
  }

  // 登录
  void login(String token, BuildContext context) {
    _token = token;
    // 告诉所有依赖Token的地方更新下
    notifyListeners();
    _getUserInfo(context);
  }

  void logout() async {
    _token = '';
    _userInfo = UserInfo('', '', '', '', 0);
    notifyListeners();
    Store store = await Store.getInstance();
    await store.setString(StoreKeys.token, '');
  }
}
