// ignore_for_file: unused_element, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:goodhouse/config.dart';
import 'package:goodhouse/widgets/common_check_button.dart';

class RoomApplianceItem {
  final String title;
  final int iconPoint;
  final bool isChecked;

  const RoomApplianceItem(this.title, this.iconPoint, this.isChecked);
}

const List<RoomApplianceItem> _dataList = [
  RoomApplianceItem('衣柜', 0xe918, false),
  RoomApplianceItem('洗衣机', 0xe917, false),
  RoomApplianceItem('空调', 0xe90d, false),
  RoomApplianceItem('天然气', 0xe90f, false),
  RoomApplianceItem('冰箱', 0xe907, false),
  RoomApplianceItem('暖气', 0xe910, false),
  RoomApplianceItem('电视', 0xe908, false),
  RoomApplianceItem('热水器', 0xe912, false),
  RoomApplianceItem('宽带', 0xe90e, false),
  RoomApplianceItem('沙发', 0xe913, false),
];

class RoomAppliance extends StatefulWidget {
  final ValueChanged<List<RoomApplianceItem>>? onChange;
  const RoomAppliance({Key? key, this.onChange}) : super(key: key);

  @override
  State<RoomAppliance> createState() => _RoomApplianceState();
}

class _RoomApplianceState extends State<RoomAppliance> {
  // 本来没有定义这里的_dateList直接用的外面的_dataList也是可以的
  // 但是这里有状态的变化也就是选中与否 所以需要管理 那就单独再定义
  List<RoomApplianceItem> list = _dataList;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        runSpacing: 30,
        children: list
            .map((item) => GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      // 找到相同的item项 isChecked 取反 新建一个RoomApplianceItem
                      list = list
                          .map((innerItem) => innerItem == item
                              ? RoomApplianceItem(
                                  item.title, item.iconPoint, !item.isChecked)
                              : innerItem)
                          .toList();
                    });

                    // 通知父级
                    if (null != widget.onChange) {
                      widget.onChange!(list);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 5,
                    child: Column(
                      children: [
                        // 使用 iconfont.tff 图标
                        Icon(
                            IconData(item.iconPoint,
                                fontFamily: Config.CommonIcon),
                            size: 40),
                        // 文字描述
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(item.title),
                        ),
                        // 是否勾选
                        CommonCheckButton(item.isChecked)
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class RoomApplicanceList extends StatelessWidget {
  final List<String>? list;
  const RoomApplicanceList({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 找到该显示的
    var showList =
        _dataList.where((item) => list!.contains(item.title)).toList();
    if (showList.isEmpty) {
      return Container(
          padding: EdgeInsets.only(left: 10), child: Text('暂无房屋配置信息'));
    }

    return Container(
      child: Wrap(
        runSpacing: 30,
        children: showList
            .map((item) => Container(
                  width: MediaQuery.of(context).size.width / 5,
                  child: Column(
                    children: [
                      // 使用 iconfont.tff 图标
                      Icon(
                          IconData(item.iconPoint,
                              fontFamily: Config.CommonIcon),
                          size: 40),
                      // 文字描述
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(item.title),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}
