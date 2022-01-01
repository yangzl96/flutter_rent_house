// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodhouse/model/room_list_item_data.dart';
import 'package:goodhouse/pages/home/tab_search/dataList.dart';
import 'package:goodhouse/scoped_model/auth.dart';
import 'package:goodhouse/utils/dio_http.dart';
import 'package:goodhouse/utils/scoped_model_helper.dart';
import 'package:goodhouse/widgets/common_floating_action_button.dart';
import 'package:goodhouse/widgets/room_list_item_widget.dart';

class RoomManagePage extends StatefulWidget {
  const RoomManagePage({Key? key}) : super(key: key);

  @override
  State<RoomManagePage> createState() => _RoomManagePageState();
}

class _RoomManagePageState extends State<RoomManagePage> {
  List<RoomListItemData> availableDataList = [];

  _getData() async {
    var auth = ScopedModelHelper.getModel<AuthModel>(context);
    if (!auth.isLogin) return;
    var token = auth.token;
    String url = '/user/houses';
    var res = await DioHttp.of(context).get(url, null, token);
    var resMap = json.decode(res.toString());
    List listMap = resMap['body'];

    var dataList =
        listMap.map((json) => RoomListItemData.fromJson(json)).toList();
    print(dataList);
    setState(() {
      availableDataList = dataList;
    });
  }

  @override
  void initState() {
    Timer.run(_getData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('房屋管理'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: '空置',
              ),
              Tab(
                text: '已租',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              children: availableDataList.isNotEmpty
                  ? (availableDataList
                      .map((item) => RoomListItemWidget(item))
                      .toList())
                  : [
                      Container(
                        height: MediaQuery.of(context).size.height - 300,
                        child: Center(
                          child: Text('暂无房源'),
                        ),
                      )
                    ],
            ),
            ListView(
              children:
                  dataList.map((item) => RoomListItemWidget(item)).toList(),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: commonFloatingActionButton('发布房源', (context) {
          // 在这里跳转到发布房源页面的，发布房源页面成功后调用了.pop 并传参了
          // 所以在这里接受返回的值 但是注意是异步的需要.then
          var result = Navigator.of(context).pushNamed('roomAdd');
          result.then((value) {
            if (value == true) {
              // 重新拉取数据
              _getData();
            }
          });
        }),
      ),
    );
  }
}
