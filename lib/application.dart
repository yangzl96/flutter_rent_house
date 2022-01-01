// ignore_for_file: prefer_const_constructors

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:goodhouse/routes.dart';
import 'package:goodhouse/scoped_model/auth.dart';
import 'package:goodhouse/scoped_model/city.dart';
import 'package:goodhouse/scoped_model/room_filter.dart';
import 'package:scoped_model/scoped_model.dart';

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 声明路由
    final router = FluroRouter();
    Routes.configureRoutes(router);

    return ScopedModel<CityModel>(
      // 城市
      model: CityModel(),
      child: ScopedModel<AuthModel>(
          //token 权限
          model: AuthModel(),
          child: ScopedModel<FilterBarModel>(
              // 搜索过滤
              model: FilterBarModel(),
              child: MaterialApp(
                theme: ThemeData(primarySwatch: Colors.teal),
                // 关联路由
                onGenerateRoute: router.generator,
                // 初始页面
                initialRoute: Routes.loading,
              ))),
    );
  }
}
