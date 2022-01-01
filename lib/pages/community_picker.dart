// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodhouse/model/community.dart';
import 'package:goodhouse/utils/dio_http.dart';
import 'package:goodhouse/utils/scoped_model_helper.dart';
import 'package:goodhouse/widgets/search_bar/index.dart';

class CommunityPickerPage extends StatefulWidget {
  const CommunityPickerPage({Key? key}) : super(key: key);

  @override
  State<CommunityPickerPage> createState() => _CommunityPickerPageState();
}

class _CommunityPickerPageState extends State<CommunityPickerPage> {
  List<Community> dataList = [];
  // 点击键盘搜索的时候触发
  _searchHandle(String value) async {
    var areaId = ScopedModelHelper.getAreaId(context);
    final url = '/area/community?name=$value&id=$areaId';
    var res = await DioHttp.of(context).get(url);
    // json => map
    var data = json.decode(res.toString())['body'];
    // map =>  List<Community>
    List<Community> resList = List<Community>.from(
        data.map((item) => Community.fromJson(item)).toList());
    setState(() {
      dataList = resList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false, //去掉appbar左侧的回退按钮
          title: SearchBar(
            onSearchSubmit: _searchHandle,
            onCancel: () {
              Navigator.of(context).pop();
            },
            goBackCallback: () {
              Navigator.of(context).pop();
            },
          ),
          elevation: 0,
          backgroundColor: Colors.white),
      body: SafeArea(
          minimum: EdgeInsets.all(10),
          child: ListView.separated(
              itemBuilder: (context, index) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    // 给上个页面传参 上个页面可通过 .then 拿到值
                    Navigator.of(context).pop(dataList[index]);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Text(dataList[index].name),
                  ),
                );
              },
              separatorBuilder: (_context, _) => Divider(),
              itemCount: dataList.length)),
    );
  }
}
