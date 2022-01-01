// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:goodhouse/model/general_type.dart';
import 'package:goodhouse/pages/home/tab_search/filter_bar/data.dart';
import 'package:goodhouse/scoped_model/room_filter.dart';
import 'package:goodhouse/utils/scoped_model_helper.dart';
import 'package:goodhouse/widgets/common_title.dart';

class FilterDrawer extends StatelessWidget {
  const FilterDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 初始化数据
    var dataList = ScopedModelHelper.getModel<FilterBarModel>(context).dataList;
    var selectedIds = ScopedModelHelper.getModel<FilterBarModel>(context)
        .selectedList
        .toList();
    roomTypeList = dataList['roomTypeList'] ?? [];
    orientedList = dataList['orientedList'] ?? [];
    floorList = dataList['floorList'] ?? [];

    _onChange(String val) {
      ScopedModelHelper.getModel<FilterBarModel>(context)
          .selectedListToggleItem(val);
    }

    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            CommonTitle('户型'),
            FilterDrawerItem(
              list: roomTypeList,
              selectedIds: selectedIds,
              onChange: _onChange,
            ),
            CommonTitle('朝向'),
            FilterDrawerItem(
              list: orientedList,
              selectedIds: selectedIds,
              onChange: _onChange,
            ),
            CommonTitle('楼层'),
            FilterDrawerItem(
              list: floorList,
              selectedIds: selectedIds,
              onChange: _onChange,
            ),
          ],
        ),
      ),
    );
  }
}

class FilterDrawerItem extends StatelessWidget {
  final List<GeneralType>? list;
  final List<String>? selectedIds;
  final ValueChanged<String>? onChange;

  const FilterDrawerItem({
    Key? key,
    this.list,
    this.selectedIds,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: list!.map((item) {
            // 筛选选中的
            var isActive = selectedIds!.contains(item.id);
            return GestureDetector(
              onTap: () {
                if (onChange != null) {
                  onChange!(item.id);
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    color: isActive ? Colors.teal : Colors.white,
                    border: Border.all(width: 1, color: Colors.teal)),
                child: Center(
                    child: Text(
                  item.name,
                  style:
                      TextStyle(color: isActive ? Colors.white : Colors.teal),
                )),
              ),
            );
          }).toList()),
    );
  }
}
