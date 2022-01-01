// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodhouse/scoped_model/auth.dart';
import 'package:goodhouse/utils/common_toast.dart';
import 'package:goodhouse/utils/dio_http.dart';
import 'package:goodhouse/utils/scoped_model_helper.dart';
import 'package:goodhouse/utils/store.dart';
import 'package:goodhouse/utils/string_isnull_or_empty.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showPassword = false;
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  _loginHandle() async {
    var username = usernameController.text;
    var password = passwordController.text;
    if (stringIsNullOrEmpty(username) || stringIsNullOrEmpty(password)) {
      CommonToast.showToast('用户名或密码不能为空');
      return;
    }

    const url = '/user/login';
    var params = {
      'username': username,
      'password': password,
    };

    var res = await DioHttp.of(context).post(url, params);
    // decode 变成map结构
    var resMap = json.decode(res.toString());

    int status = resMap['status'];
    // String description = resMap['description'] ?? '内部错误';
    // CommonToast.showToast(description);

    if (status.toString().startsWith('2')) {
      // 存token
      String token = resMap['body']['token'];
      Store store = await Store.getInstance();
      await store.setString(StoreKeys.token, token);

      // 共享token
      ScopedModelHelper.getModel<AuthModel>(context).login(token, context);

      // 一秒后返回上一个页面
      Timer(Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('登录')),
      body: SafeArea(
        minimum: EdgeInsets.all(30),
        child: ListView(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: '用户名', hintText: '请输入用户名'),
            ),
            Padding(padding: EdgeInsets.all(10)),
            TextField(
                controller: passwordController,
                obscureText: !showPassword,
                decoration: InputDecoration(
                    labelText: '密码',
                    hintText: '请输入密码',
                    suffixIcon: IconButton(
                      icon: Icon(showPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                    ))),
            Padding(padding: EdgeInsets.all(10)),
            ElevatedButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 80))),
              child: Text('登录'),
              onPressed: _loginHandle,
            ),
            Padding(padding: EdgeInsets.all(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('还没有账号，'),
                TextButton(
                    child: Text('去注册 ~'),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, 'register');
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
