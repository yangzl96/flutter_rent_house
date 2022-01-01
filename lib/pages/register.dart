// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodhouse/utils/common_toast.dart';
import 'package:goodhouse/utils/dio_http.dart';
import 'package:goodhouse/utils/string_isnull_or_empty.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var repeatPasswordController = TextEditingController();

  _registerHandler() async {
    var username = usernameController.text;
    var password = passwordController.text;
    var repeatPassword = repeatPasswordController.text;
    if (stringIsNullOrEmpty(username) || stringIsNullOrEmpty(password)) {
      CommonToast.showToast('用户名或密码不能为空');
      return;
    }
    if (password != repeatPassword) {
      CommonToast.showToast('两次密码输入不一致');
      return;
    }
    const url = '/user/registered';
    var params = {'username': username, 'password': password};
    
    var res = await DioHttp.of(context).post(url, params);
    // 解码
    var resString = json.decode(res.toString());

    int status = resString['status'];
    // String description = resString['description'] ?? '内部错误';
    // CommonToast.showToast(description);
    if (status.toString().startsWith('2')) {
      Navigator.of(context).pushReplacementNamed('login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('注册')),
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
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '密码',
                  hintText: '请输入密码',
                )),
            Padding(padding: EdgeInsets.all(10)),
            TextField(
                controller: repeatPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '确认密码',
                  hintText: '请输入确认密码',
                )),
            Padding(padding: EdgeInsets.all(10)),
            ElevatedButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 80))),
              child: Text('注册'),
              onPressed: _registerHandler,
            ),
            Padding(padding: EdgeInsets.all(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('已有账号，'),
                TextButton(
                    child: Text('去登录 ~'),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, 'login');
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
