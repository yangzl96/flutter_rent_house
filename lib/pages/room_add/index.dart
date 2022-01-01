// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodhouse/model/community.dart';
import 'package:goodhouse/model/general_type.dart';
import 'package:goodhouse/scoped_model/auth.dart';
import 'package:goodhouse/utils/common_toast.dart';
import 'package:goodhouse/utils/dio_http.dart';
import 'package:goodhouse/utils/scoped_model_helper.dart';
import 'package:goodhouse/utils/string_isnull_or_empty.dart';
import 'package:goodhouse/utils/upload_images.dart';
import 'package:goodhouse/widgets/common_floating_action_button.dart';
import 'package:goodhouse/widgets/common_form_item.dart';
import 'package:goodhouse/widgets/common_form_radio_item.dart';
import 'package:goodhouse/widgets/common_form_select_item.dart';
import 'package:goodhouse/widgets/common_image_picker.dart';
import 'package:goodhouse/widgets/common_title.dart';
import 'package:goodhouse/widgets/room_appliance.dart';
import 'package:image_picker/image_picker.dart';

class RoomAddPage extends StatefulWidget {
  const RoomAddPage({Key? key}) : super(key: key);

  @override
  State<RoomAddPage> createState() => _RoomAddPageState();
}

class _RoomAddPageState extends State<RoomAddPage> {
  List<GeneralType> floorList = [];
  List<GeneralType> orientedList = [];
  List<GeneralType> roomTypeList = [];

  int rentType = 0; //租赁方式
  int decorationType = 0; // 装修
  int roomType = 0; //户型
  int floor = 0; //楼层
  int oriented = 0; // 朝向

  List<XFile> images = []; //图片

  Community? community; // 小区

  List<RoomApplianceItem> applianceList = []; //家具

  var titleController = TextEditingController();
  var descController = TextEditingController();
  var sizeController = TextEditingController();
  var priceController = TextEditingController();

  @override
  void initState() {
    Timer.run(_getParams);
    super.initState();
  }

  // 获取基础选择数据
  _getParams() async {
    String url = '/houses/params';
    var res = await DioHttp.of(context).get(url);
    var data = json.decode(res.toString())['body'];
    // 赋值  map =>  List<GeneralType>
    List<GeneralType> floorList = List<GeneralType>.from(
        data['floor'].map((item) => GeneralType.fromJson(item)));
    List<GeneralType> orientedList = List<GeneralType>.from(
        data['oriented'].map((item) => GeneralType.fromJson(item)));
    List<GeneralType> roomTypeList = List<GeneralType>.from(
        data['roomType'].map((item) => GeneralType.fromJson(item)));

    setState(() {
      this.floorList = floorList;
      this.orientedList = orientedList;
      this.roomTypeList = roomTypeList;
    });
  }

  // 提交
  _submit(BuildContext context) async {
    var size = sizeController.text;
    var price = priceController.text;

    if (stringIsNullOrEmpty(size)) {
      CommonToast.showToast('【大小】不能为空');
      return;
    }
    if (stringIsNullOrEmpty(price)) {
      CommonToast.showToast('【价格】不能为空');
      return;
    }
    if (community == null) {
      CommonToast.showToast('【小区】不能为空');
      return;
    }
    var imageString = await uploadImages(images, context);
    var token = ScopedModelHelper.getModel<AuthModel>(context).token;
    Map<String, dynamic> params = {
      "title": titleController.text,
      "description": descController.text,
      "price": price,
      "size": size,
      "oriented": orientedList[oriented].id,
      "roomType": roomTypeList[roomType].id,
      "floor": floorList[floor].id,
      "community": community!.id,
      "houseImg": imageString,
      "supporting": applianceList
          .map((item) {
            if (item.isChecked) {
              return item.title;
            }
          })
          .toList()
          .join('|'), //家具 字符串 以 | 分割
    };
    String url = '/user/houses';
    var res = await DioHttp.of(context).post(url, params, token);
    var status = json.decode(res.toString())['status'];
    if (status.toString().startsWith('2')) {
      CommonToast.showToast('房源发布成功');
      bool isSubmitted = true;
      // 给房屋管理业传参
      Navigator.of(context).pop(isSubmitted);
    }
    // else {
    //   var description = json.decode(res.toString())['description'];
    //   CommonToast.showToast(description);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('房源发布'),
      ),
      body: ListView(
        children: [
          CommonTitle('房源信息'),
          CommonFormItem(
            label: '小区',
            contentBuilder: (context) {
              return Container(
                  child: GestureDetector(
                      // 默认点击的时候 只有有文字的地方才会触发
                      // 这个属性可以让整体触发，包括空白处
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        // 接受这个页面的返回值
                        var result =
                            Navigator.of(context).pushNamed('communityPicker');
                        result.then((value) {
                          if (value != null) {
                            setState(() {
                              community = value as Community;
                            });
                          }
                        });
                      },
                      child: Container(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              community?.name ?? '请选择小区',
                              style: TextStyle(fontSize: 16),
                            ),
                            Icon(Icons.keyboard_arrow_right)
                          ],
                        ),
                      )));
            },
          ),
          CommonFormItem(
            label: '租金',
            hintText: '请输入租金',
            suffixText: '元/月',
            controller: priceController,
          ),
          CommonFormItem(
            label: '大小',
            hintText: '请输入大小',
            suffixText: '平方米',
            controller: sizeController,
          ),
          CommonFormRadioitem(
            label: '租赁方式',
            options: ['合租', '整租'],
            value: rentType,
            onChange: (index) {
              setState(() {
                rentType = index!;
              });
            },
          ),
          if (roomTypeList.isNotEmpty)
            CommonFormSelectItem(
                label: '户型',
                value: roomType,
                onChange: (val) {
                  setState(() {
                    roomType = val;
                  });
                },
                options: roomTypeList.map((json) => json.name).toList()),
          // 数组空判断 避免初始值为 0 然后匹配不到value 报错
          if (floorList.isNotEmpty)
            CommonFormSelectItem(
                label: '楼层',
                value: floor,
                onChange: (val) {
                  setState(() {
                    floor = val;
                  });
                },
                options: floorList.map((json) => json.name).toList()),
          if (orientedList.isNotEmpty)
            CommonFormSelectItem(
                label: '朝向',
                value: oriented,
                onChange: (val) {
                  setState(() {
                    oriented = val;
                  });
                },
                options: orientedList.map((json) => json.name).toList()),
          CommonFormRadioitem(
            label: '装修',
            options: ['精装', '简装'],
            value: decorationType,
            onChange: (index) {
              setState(() {
                decorationType = index!;
              });
            },
          ),
          CommonTitle('房源图像'),
          CommonImagePicker(
            onChange: (List<XFile> files) {
              setState(() {
                images = files;
              });
            },
          ),
          CommonTitle('房源标题'),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '请输入标题（例如：整租，小区名 2室 2008）'),
            ),
          ),
          CommonTitle('房源配置'),
          RoomAppliance(onChange: (data) {
            // 拿到子级的更新数据
            applianceList = data;
          }),
          CommonTitle('房源描述'),
          Container(
            margin: EdgeInsets.only(bottom: 100),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: descController,
              maxLines: 10,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: '请输入房屋描述信息'),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: commonFloatingActionButton('提交', _submit),
    );
  }
}
