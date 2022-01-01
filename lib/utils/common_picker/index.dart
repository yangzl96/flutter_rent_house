// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonPicker {
  static Future<int?>? showPicker(
      {required BuildContext context,
      List<String>? options,
      int? value,
      double height = 300}) {
    return showCupertinoModalPopup<int>(
        context: context,
        builder: (BuildContext context) {
          var buttonTextStyle = TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600);
          // 初始化controller value 初始化值
          var controller = FixedExtentScrollController(initialItem: value ?? 0);

          return Container(
            color: Colors.grey,
            height: height,
            child: Column(
              children: [
                Container(
                  color: Colors.grey.shade200,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            // 返回上一个页面
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            '取消',
                            style: buttonTextStyle,
                          )),
                      TextButton( 
                          onPressed: () {
                            // 返回上一个页面
                            // 点击选中的时候传值
                            Navigator.of(context).pop(controller.selectedItem);
                          },
                          child: Text('确定', style: buttonTextStyle)),
                    ],
                  ),
                ),
                Expanded(
                    child: CupertinoPicker(
                  // 绑定controller 存 选中的item
                  scrollController: controller,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  itemExtent: 32,
                  onSelectedItemChanged: (val) {},
                  children: options!.map((item) => Text(item)).toList(),
                ))
              ],
            ),
          );
        });
  }
}
