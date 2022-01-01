// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, sized_box_for_whitespace

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const List<String> defautImages = [
  'http://ww3.sinaimg.cn/large/006y8mN6ly1g6e2tdgve1j30ku0bsn75.jpg',
  'http://ww3.sinaimg.cn/large/006y8mN6ly1g6e2whp87sj30ku0bstec.jpg',
  'http://ww3.sinaimg.cn/large/006y8mN6ly1g6e2tl1v3bj30ku0bs77z.jpg',
];

// 设置图片宽高
var imageWidth = 750.0;
var imageHeight = 424.0;
var imageWidgetHeightRatio = imageWidth / imageHeight; //宽高比

// 图片选择器 要在ios Runner/info.plist 中添加额外的配置项
class CommonImagePicker extends StatefulWidget {
  final ValueChanged<List<XFile>>? onChange;
  CommonImagePicker({Key? key, this.onChange}) : super(key: key);

  @override
  _CommonImagePickerState createState() => _CommonImagePickerState();
}

class _CommonImagePickerState extends State<CommonImagePicker> {
  List<XFile>? files = [];
  final ImagePicker _picker = ImagePicker();
  _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (null == image) return;
    setState(() {
      // 添加选择的图片
      files = files!..add(image);
    });
    // 通知父级更新
    if (widget.onChange != null) {
      widget.onChange!(files!);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = (MediaQuery.of(context).size.width - 10 * 4.0) / 3;
    var height = width / imageWidgetHeightRatio;

    //加号
    Widget addButton = GestureDetector(
        onTap: () {
          _pickImage();
        },
        behavior: HitTestBehavior.translucent,
        child: Container(
          width: width,
          height: height,
          color: Colors.grey,
          child: Center(
            child: Text('+',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w100)),
          ),
        ));

    // 图片
    Widget wrapper(XFile? file) {
      return Stack(
          // 溢出显示 避免卡在角落的被影藏
          clipBehavior: Clip.none,
          children: [
            Image.file(
              File(file!.path),
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
            Positioned(
                right: -20,
                top: -20,
                child: IconButton(
                  icon: Icon(Icons.delete_forever, color: Colors.red.shade400),
                  onPressed: () {
                    setState(() {
                      // 返回删除图片后的 files 用到 ..
                      files = files!..remove(file);
                      // 通支父级
                      if (null != widget.onChange) {
                        widget.onChange!(files!);
                      }
                    });
                  },
                ))
          ]);
    }

    // 列表 拼接上 一个加号部件 ..add()
    List<Widget> list = files!.map((item) => wrapper(item)).toList()
      ..add(addButton);

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: list,
        ));
  }
}
