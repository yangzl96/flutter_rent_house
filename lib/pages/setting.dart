// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:goodhouse/scoped_model/auth.dart';
import 'package:goodhouse/utils/common_toast.dart';
import 'package:goodhouse/utils/scoped_model_helper.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
      ),
      body: ListView(
        children: [
          Container(
            width: 100,
            child: ElevatedButton(
                onPressed: () {
                  ScopedModelHelper.getModel<AuthModel>(context).logout();
                  CommonToast.showToast('已退出');
                  Navigator.of(context).pop();
                },
                child: Text('退出登录')),
          )
        ],
      ),
    );
  }
}
