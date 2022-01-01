// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodhouse/model/room_list_item_data.dart';
import 'package:goodhouse/pages/home/tab_search/dataList.dart';
import 'package:goodhouse/pages/home/tab_search/filter_bar/data.dart';
import 'package:goodhouse/pages/home/tab_search/filter_bar/filter_drawer.dart';
import 'package:goodhouse/pages/home/tab_search/filter_bar/index.dart';
import 'package:goodhouse/utils/dio_http.dart';
import 'package:goodhouse/utils/scoped_model_helper.dart';
import 'package:goodhouse/widgets/room_list_item_widget.dart';
import 'package:goodhouse/widgets/search_bar/index.dart';

class TabSearch extends StatefulWidget {
  const TabSearch({Key? key}) : super(key: key);

  @override
  State<TabSearch> createState() => _TabSearchState();
}

// 思考：为什么刚进来这个页面就会获取数据？明明没有调用过 _onFilterBarChange
/// 1: 这个页面用到了 filterBar 组件
/// 2: filterBar 在initState中初始化执行 _getData
/// 3: filterBar用到了scopeModel，全局变量发生变化后，会通知刷新页面，刷新的时候这个 _onFilterBarChange 就执行了

class _TabSearchState extends State<TabSearch> {
  List<RoomListItemData> list = [];
  // 通过回调函数 拿到filter的参数
  _onFilterBarChange(FilterBarResult data) async {
    // 拼接到url上的参数要转义下 使用 encodeQueryComponent
    var cityId = Uri.encodeQueryComponent(ScopedModelHelper.getAreaId(context));
    var area = Uri.encodeQueryComponent(data.areaId ?? '');
    var mode = Uri.encodeQueryComponent(data.rentTypeId ?? '');
    var price = Uri.encodeQueryComponent(data.priceId ?? '');
    var more = Uri.encodeQueryComponent(data.moreIds!.join(','));

    String url = '/houses?cityId=' +
        '$cityId&area=$area&rentType=$mode&price=$price&more=$more&start=1&end=20';
    print('URL: $url');
    var res = await DioHttp.of(context).get(url);
    // json => Map
    var resMap = json.decode(res.toString());
    List dataMap = resMap['body']['list'];

    // 将 map转化 => List<RoomListItemData>
    List<RoomListItemData> resList =
        dataMap.map((json) => RoomListItemData.fromJson(json)).toList();

    if (!mounted) return;
    // 类型转换完后 给上面的list赋值
    setState(() {
      list = resList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: FilterDrawer(),
      appBar: AppBar(
        elevation: 0,
        actions: [Container()], // 隐藏Drawer按钮 这样只能左滑出现了
        title: SearchBar(
          showLocation: true,
          showMap: true,
          onSearch: () {
            Navigator.of(context).pushNamed('search');
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            height: 40,
            child: FilterBar(onChange: _onFilterBarChange),
          ),
          Expanded(
              child: ListView(
            children: list.map((item) => RoomListItemWidget(item)).toList(),
          ))
        ],
      ),
    );
  }
}
