// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:goodhouse/utils/common_picker/index.dart';
import 'package:goodhouse/widgets/common_form_item.dart';

class CommonFormSelectItem extends StatelessWidget {
  final String? label;
  final int value;
  final List<String>? options;
  final Function(int)? onChange;

  const CommonFormSelectItem(
      {Key? key, this.label, required this.value, this.options, this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonFormItem(
      label: label,
      contentBuilder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          // 点击中间的时候 显示 picker
          onTap: () {
            // 打开选择器 可以理解是一个页面 所以可以通过navigator去传参回来
            var result = CommonPicker.showPicker(
                context: context, options: options, value: value);

            // 接受 navigator.of(context).pop(参数) 过来的值
            // 返回的是一个 furture
            result!.then((selectedValue) {
              // print('valuesss:  $selectedValue');
              if (value != selectedValue &&
                  selectedValue != null &&
                  onChange != null) {
                // 拿到值触发 onChange事件
                onChange!(selectedValue);
              }
            });
          },
          child: Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(options![value]),
                const Icon(Icons.keyboard_arrow_right)
              ],
            ),
          ),
        );
      },
    );
  }
}
