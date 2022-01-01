// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, unused_element, unused_field, unrelated_type_equality_checks, unnecessary_null_comparison

import 'dart:convert';

import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:goodhouse/config.dart';
import 'package:goodhouse/model/general_type.dart';
import 'package:goodhouse/scoped_model/city.dart';
import 'package:goodhouse/utils/common_toast.dart';
import 'package:goodhouse/utils/scoped_model_helper.dart';
import 'package:goodhouse/utils/store.dart';

class SearchBar extends StatefulWidget {
  final bool? showLocation; // 展示位置按钮
  final bool? showMap; //展示地图按钮
  final void Function()? goBackCallback; //回退按钮
  final String inputValue; // 搜索值
  final String defaultInputValue; //默认值
  final void Function()? onCancel; //取消按钮
  final void Function()? onSearch; //点击搜索框触发
  final ValueChanged<String>? onSearchSubmit; //用户输入搜索词后，点击搜索

  SearchBar(
      {Key? key,
      this.showLocation,
      this.goBackCallback,
      this.inputValue = '',
      this.defaultInputValue = '请输入搜索词',
      this.onCancel,
      this.onSearch,
      this.onSearchSubmit,
      this.showMap})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String _searchWord = '';
  late TextEditingController _controller;
  late FocusNode _focus;
  // 清空
  Function? _onClean() {
    _controller.clear();
    setState(() {
      _searchWord = '';
    });
  }

  @override
  void initState() {
    _controller = TextEditingController(text: widget.inputValue);
    _focus = FocusNode();
    super.initState();
  }

  // 城市点击
  _onChangeLocation() async {
    var result = await CityPickers.showCitiesSelector(
        context: context,
        theme: ThemeData(
            primarySwatch: Colors.teal,
            textTheme: TextTheme(
                bodyText1: TextStyle(fontSize: 16, color: Colors.red))));

    String cityName = result!.cityName ?? '未知城市';
    if (cityName == null) return;

    // 找城市是否存在
    var city = Config.availableCitys
        .firstWhere((city) => cityName.startsWith(city.name), orElse: () {
      CommonToast.showToast('该城市暂未开通!');
      return GeneralType('', '-1');
    });

    if (city.id == -1) return;
    // 保存
    _saveCity(city);
  }

  // 保存数据
  _saveCity(GeneralType city) async {
    // 全局存储
    ScopedModelHelper.getModel<CityModel>(context).city = city;
    // 本地缓存
    var store = await Store.getInstance();
    // value 应该是字符串
    // Map<GeneralType> 转成 json字符串
    var cityString = json.encode(city.toJson());
    store.setString(StoreKeys.city, cityString);
  }

  // 初始化从本地存储获取城市
  _getCity() async {
    var store = await Store.getInstance();
    var cityString = await store.getString(StoreKeys.city);
    if (cityString == null) return;
    // 存在缓存city
    var city = GeneralType.fromJson(json.decode(cityString));
    // 存到公共存储 又会触发更新重构build方法 就可以直接拿到city了
    ScopedModelHelper.getModel<CityModel>(context).city = city;
  }

  @override
  Widget build(BuildContext context) {
    // 初始化
    // print('开始获取 -------');
    // 先去公共存储获取
    var city = ScopedModelHelper.getModel<CityModel>(context).city;
    // map => json字符串
    // print(json.encode(city.toJson()));

    // 不存在的话 去获取默认的初始值（写死的）
    if (city.name == '') {
      city = Config.availableCitys.first;
      // print(json.encode(city.toJson()));
      // （强刷新的时候city.name会为''）那么就取缓存
      _getCity();
    }

    return Container(
      child: Row(
        children: [
          // 定位
          if (widget.showLocation != null)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                  child: Row(
                    children: [
                      Icon(
                        Icons.room,
                        color: Colors.teal,
                        size: 16,
                      ),
                      Text(
                        city.name,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      )
                    ],
                  ),
                  onTap: () {
                    _onChangeLocation();
                  }),
            ),
          // 返回按钮
          if (widget.goBackCallback != null)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                child: Icon(
                  Icons.chevron_left,
                  color: Colors.black87,
                ),
                onTap: widget.goBackCallback,
              ),
            ),
          // 输入框
          Expanded(
              child: Container(
            height: 34,
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(17)),
            margin: EdgeInsets.only(right: 10),
            child: TextField(
              controller: _controller,
              // 需要自己控制focus状态
              focusNode: _focus,
              style: TextStyle(fontSize: 14),
              textInputAction: TextInputAction.search, //键盘search按钮文字
              // 点击输入框的时候
              onTap: () {
                // 手动失焦 避免点击搜索后再次返回时 input还是聚焦状态
                if (widget.onSearchSubmit == null) {
                  _focus.unfocus();
                }
                // 执行跳转方法
                if (widget.onSearch != null) {
                  widget.onSearch!();
                }
              },
              // onTap: widget.onSearch, 点击键盘搜索按钮的时候
              onSubmitted: widget.onSearchSubmit,
              // 输入框改变
              onChanged: (String value) {
                setState(() {
                  _searchWord = value;
                });
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '请输入搜索词',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  contentPadding: EdgeInsets.only(top: 1, left: -10),
                  suffixIcon: GestureDetector(
                      child: Icon(
                        Icons.clear,
                        size: 18,
                        color: _searchWord == ''
                            ? Colors.grey.shade200
                            : Colors.grey,
                      ),
                      onTap: () {
                        _onClean();
                      }),
                  icon: Padding(
                    padding: EdgeInsets.only(top: 4, left: 8),
                    child: Icon(
                      Icons.search,
                      size: 18,
                      color: Colors.grey,
                    ),
                  )),
            ),
          )),
          // 取消按钮
          if (widget.onCancel != null)
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                    child: Text(
                      '取消',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    onTap: widget.onCancel)),
          // 地图
          if (widget.showMap != null)
            Image.asset('static/icons/widget_search_bar_map.png')
        ],
      ),
    );
  }
}
