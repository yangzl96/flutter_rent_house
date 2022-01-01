// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:goodhouse/pages/community_picker.dart';
import 'package:goodhouse/pages/home/index.dart';
import 'package:goodhouse/pages/loading.dart';
import 'package:goodhouse/pages/login.dart';
import 'package:goodhouse/pages/not_found.dart';
import 'package:goodhouse/pages/register.dart';
import 'package:goodhouse/pages/room_add/index.dart';
import 'package:goodhouse/pages/room_detail/index.dart';
import 'package:goodhouse/pages/room_manage/index.dart';
import 'package:goodhouse/pages/setting.dart';

class Routes {
  // 定义路由名称
  static String home = '/';
  static String login = '/login';
  static String register = '/register';
  static String roomDetail = '/roomDetail/:roomId';
  static String setting = '/setting';
  static String roomManage = '/roomManage';
  static String roomAdd = '/roomAdd';
  static String communityPicker = '/communityPicker';
  static String loading = '/loading';

  // 定义路由处理函数
  static Handler _homeHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return HomePage();
  });

  static Handler _loginHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return LoginPage();
  });

  static Handler _registerHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return RegisterPage();
  });

  static Handler _roomDetailHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return RoomDetailPage(
      roomId: params['roomId'][0],
    );
  });

  static Handler _settingHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return Setting();
  });

  static Handler _roomManageHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return RoomManagePage();
  });

  static Handler _roomAddHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return RoomAddPage();
  });

  static Handler _communityPickerHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return CommunityPickerPage();
  });

  static Handler _notFoundHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return NotFoundPage();
  });

  static Handler _loadingHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return LoadingPage();
  });

  // 关联路由名称和处理函数
  static void configureRoutes(FluroRouter router) {
    router.define(home, handler: _homeHandler);
    router.define(login, handler: _loginHandler);
    router.define(register, handler: _registerHandler);
    router.define(roomDetail, handler: _roomDetailHandler);
    router.define(setting, handler: _settingHandler);
    router.define(roomManage, handler: _roomManageHandler);
    router.define(roomAdd, handler: _roomAddHandler);
    router.define(communityPicker, handler: _communityPickerHandler);
    router.define(loading, handler: _loadingHandler);
    router.notFoundHandler = _notFoundHandler;
  }
}
