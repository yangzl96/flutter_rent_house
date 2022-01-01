// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:goodhouse/config.dart';
import 'package:goodhouse/scoped_model/auth.dart';
import 'package:goodhouse/utils/scoped_model_helper.dart';

var loginRegisterStyle = TextStyle(color: Colors.white, fontSize: 20);

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 获取登录状态
    var isLogin = ScopedModelHelper.getModel<AuthModel>(context).isLogin;
    return isLogin ? _loginBuilder(context) : _notLoginBuilder(context);
  }

  Widget _notLoginBuilder(BuildContext context) {
    return Container(
      height: 95,
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(color: Colors.teal),
      child: Row(
        children: [
          Container(
            height: 65,
            width: 65,
            margin: EdgeInsets.only(right: 15),
            child: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://tva1.sinaimg.cn/large/008i3skNgy1gsuh24kjbnj30do0duaad.jpg')),
          ),
          // height: 50,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                GestureDetector(
                  child: Text(
                    '登录',
                    style: loginRegisterStyle,
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('login');
                  },
                ),
                Text('/', style: loginRegisterStyle),
                GestureDetector(
                  child: Text('注册', style: loginRegisterStyle),
                  onTap: () {
                    Navigator.of(context).pushNamed('register');
                  },
                ),
              ]),
              Text(
                '登录后可体验更多',
                style: TextStyle(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _loginBuilder(BuildContext context) {
    var userInfo = ScopedModelHelper.getModel<AuthModel>(context).userInfo;
    String userImage = userInfo?.avatar ??
        'https://i.picsum.photos/id/1065/3744/5616.jpg?hmac=V64psST3xnjnVwmIogHI8krnL3edsh_sy4HNc3dJ_xY';
    String userName = userInfo?.nickname ?? '已登录的用户名';

    // 处理服务端返回的不带前缀的地址
    if (!userImage.startsWith('http')) {
      userImage = Config.BaseUrl + userImage;
    }
    return Container(
      height: 95,
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(color: Colors.teal),
      child: Row(
        children: [
          Container(
            height: 65,
            width: 65,
            margin: EdgeInsets.only(right: 15),
            child: CircleAvatar(backgroundImage: NetworkImage(userImage)),
          ),
          // height: 50,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                GestureDetector(
                  child: Text(
                    userName,
                    style: loginRegisterStyle,
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('login');
                  },
                ),
              ]),
              Text(
                '查看编辑个人资料',
                style: TextStyle(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}
