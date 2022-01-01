// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_collection_literals

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodhouse/model/general_type.dart';
import 'package:goodhouse/pages/home/tab_search/filter_bar/data.dart';
import 'package:goodhouse/pages/home/tab_search/filter_bar/item.dart';
import 'package:goodhouse/scoped_model/room_filter.dart';
import 'package:goodhouse/utils/common_picker/index.dart';
import 'package:goodhouse/utils/dio_http.dart';
import 'package:goodhouse/utils/scoped_model_helper.dart';

var lastCityId;

class FilterBar extends StatefulWidget {
  final ValueChanged<FilterBarResult>? onChange;
  FilterBar({Key? key, this.onChange}) : super(key: key);

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  List<GeneralType> areaList = []; //区域
  List<GeneralType> priceList = []; // 租金
  List<GeneralType> rentTypeList = []; // 方式
  List<GeneralType> roomTypeList = []; // 户型
  List<GeneralType> orientedList = []; // 朝向
  List<GeneralType> floorList = []; // 楼层

  bool isAreaActive = false;
  bool isRentTypeActive = false;
  bool isPriceActive = false;
  bool isFilterActive = false;

  String areaId = '';
  String rentTypeId = '';
  String priceId = '';
  List<String> moreIds = [];

  _onAreaChange(context) {
    setState(() {
      isAreaActive = true;
    });

    var result = CommonPicker.showPicker(
        context: context,
        value: 0,
        options: areaList.map((item) => item.name).toList());

    // 拿到picker选到的结果
    result?.then((index) {
      if (index == null) return;
      setState(() {
        areaId = areaList[index].id;
      });
      _onChange();
    }).whenComplete(() => {
          setState(() {
            isAreaActive = false;
          })
        });
  }

  _onRentTypeChange(context) {
    setState(() {
      isRentTypeActive = true;
    });

    var result = CommonPicker.showPicker(
        context: context,
        value: 0,
        options: rentTypeList.map((item) => item.name).toList());

    // 拿到picker选到的结果
    result?.then((index) {
      if (index == null) return;
      setState(() {
        rentTypeId = rentTypeList[index].id;
      });
      _onChange();
    }).whenComplete(() => {
          setState(() {
            isRentTypeActive = false;
          })
        });
  }

  _onPriceChange(context) {
    setState(() {
      isPriceActive = true;
    });

    var result = CommonPicker.showPicker(
        context: context,
        value: 0,
        options: priceList.map((item) => item.name).toList());

    // 拿到picker选到的结果
    result?.then((index) {
      if (index == null) return;
      setState(() {
        priceId = priceList[index].id;
      });
      _onChange();
    }).whenComplete(() => {
          setState(() {
            isPriceActive = false;
          })
        });
  }

  _onFilterChange(context) {
    // endDrawer 布局在后面的drawer
    Scaffold.of(context).openEndDrawer();
  }

  // 通知父级
  _onChange() {
    // 获取筛选 选中的id
    var selectedList =
        ScopedModelHelper.getModel<FilterBarModel>(context).selectedList;
    if (widget.onChange != null) {
      // 给父级传参
      widget.onChange!(FilterBarResult(
        areaId: areaId,
        rentTypeId: rentTypeId,
        priceId: priceId,
        moreIds: selectedList.toList(),
      ));
    }
  }

  /// 存在问题：
  /// 1. 刚进入搜索页请求数据的时候，立即切换其他菜单，来回点击会报错
  ///  Unhandled Exception: setState() called after dispose(): 组件已经卸载了 才调用setState
  /// 请求还没返回，就点了其他的菜单，导致当前页面已经卸载了
  /// 2. 切换城市的时候，区域数据没有变
  /// 用一个状态存当前的cityId, 在生命周期中判断 改变了就重新getData
  // 获取数据
  _getData() async {
    var cityId = ScopedModelHelper.getAreaId(context);
    lastCityId = cityId;
    final url = '/houses/condition?id=$cityId';

    var res = await DioHttp.of(context).get(url);
    // json to Map 要先toString才可以decode
    var data = json.decode(res.toString())['body'];

    // 解决问题1：在请求回来之后 判断页面是否还存在
    if (!mounted) {
      return;
    }
    // 数据转成数组
    List<GeneralType> areaList = List<GeneralType>.from(data['area']['children']
        .map((item) => GeneralType.fromJson(item))
        .toList());
    List<GeneralType> priceList = List<GeneralType>.from(
        data['price'].map((item) => GeneralType.fromJson(item)).toList());
    List<GeneralType> rentTypeList = List<GeneralType>.from(
        data['rentType'].map((item) => GeneralType.fromJson(item)).toList());
    List<GeneralType> roomTypeList = List<GeneralType>.from(
        data['roomType'].map((item) => GeneralType.fromJson(item)).toList());
    List<GeneralType> orientedList = List<GeneralType>.from(
        data['oriented'].map((item) => GeneralType.fromJson(item)).toList());
    List<GeneralType> floorList = List<GeneralType>.from(
        data['floor'].map((item) => GeneralType.fromJson(item)).toList());

    // 赋值触发更新
    setState(() {
      this.areaList = areaList;
      this.priceList = priceList;
      this.rentTypeList = rentTypeList;
      this.orientedList = orientedList;
      this.floorList = floorList;
      this.roomTypeList = roomTypeList;
    });

    // 数据共享存储
    Map<String, List<GeneralType>> dataList = Map<String, List<GeneralType>>();
    dataList['roomTypeList'] = roomTypeList;
    dataList['orientedList'] = orientedList;
    dataList['floorList'] = floorList;
    ScopedModelHelper.getModel<FilterBarModel>(context).dataList = dataList;
  }

  @override
  void initState() {
    // 延迟执行这个方法 确保获取到 context
    Timer.run(_getData);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _onChange();
    if (lastCityId != null &&
        ScopedModelHelper.getAreaId(context) != lastCityId) {
      _getData();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 41,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12, width: 1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Item(
            title: '区域',
            isActive: isAreaActive,
            onTap: _onAreaChange,
          ),
          Item(
            title: '方式',
            isActive: isRentTypeActive,
            onTap: _onRentTypeChange,
          ),
          Item(
            title: '租金',
            isActive: isPriceActive,
            onTap: _onPriceChange,
          ),
          Item(
            title: '筛选',
            isActive: isFilterActive,
            onTap: _onFilterChange,
          )
        ],
      ),
    );
  }
}
