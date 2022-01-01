// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodhouse/config.dart';
import 'package:goodhouse/model/room_detail_data.dart';
import 'package:goodhouse/pages/home/info/index.dart';
import 'package:goodhouse/utils/dio_http.dart';
import 'package:goodhouse/widgets/common_swiper.dart';
import 'package:goodhouse/widgets/common_tag.dart';
import 'package:goodhouse/widgets/common_title.dart';
import 'package:goodhouse/widgets/room_appliance.dart';
import 'package:share/share.dart';

class RoomDetailPage extends StatefulWidget {
  final String? roomId;

  const RoomDetailPage({Key? key, this.roomId}) : super(key: key);

  @override
  State<RoomDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  RoomDetailData data = RoomDetailData(tags: []);
  bool isLike = false; //收藏
  bool showAllText = false; // 是否展示所有文字

  @override
  void initState() {
    // 模拟拿到数据
    _getData();
    super.initState();
  }

  _getData() async {
    final url = '/houses/${widget.roomId}';
    var res = await DioHttp.of(context).get(url);
    var resMap = json.decode(res.toString());
    var resData = resMap['body'];
    // 将 map 转换成 RoomDetailData data
    // 不是数组 直接转换 不需要map遍历了
    var roomDetailData = RoomDetailData.fromJson(resData);
    // 轮播图图片 要加上地址前缀
    roomDetailData.houseImgs =
        roomDetailData.houseImgs!.map((item) => Config.BaseUrl + item).toList();
    setState(() {
      data = roomDetailData;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) return Container();
    // 是否显示展开
    bool showTextTool = false;
    if (data.subTitle != null) {
      if (data.subTitle!.length > 100) {
        showTextTool = true;
      } else {
        showTextTool = false;
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(data.title ?? ''),
          actions: [
            IconButton(
                onPressed: () {
                  Share.share('http://www.baidu.com');
                },
                icon: Icon(Icons.share))
          ],
        ),
        body: Stack(
          children: [
            ListView(children: [
              CommonSwiper(
                images: data.houseImgs ?? [],
              ),
              CommonTitle(data.title ?? ''),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      data.price.toString(),
                      style: TextStyle(fontSize: 20, color: Colors.pink),
                    ),
                    Text('元/月(押一付三)',
                        style: TextStyle(fontSize: 14, color: Colors.pink))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, top: 6, bottom: 6),
                child: Wrap(
                  spacing: 4,
                  children: data.tags!.map((item) => CommonTag(item)).toList(),
                ),
              ),
              Divider(
                color: Colors.grey,
                indent: 10,
                endIndent: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 10, top: 6, bottom: 6),
                child: Wrap(
                  runSpacing: 20,
                  children: [
                    BaseInfoItem('面积：${data.size}平米'),
                    BaseInfoItem('楼层：${data.floor}'),
                    BaseInfoItem('房形：${data.roomType}'),
                    BaseInfoItem('装修：精装'),
                  ],
                ),
              ),
              CommonTitle('房屋配置'),
              RoomApplicanceList(list: data.applicances ?? []),
              CommonTitle('房屋概况'),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.subTitle ?? '暂无房屋概况',
                      maxLines: showAllText ? null : 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        showTextTool
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showAllText = !showAllText;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      showAllText ? '收起' : '展开',
                                      style: TextStyle(color: Colors.teal),
                                    ),
                                    Icon(
                                        showAllText
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        color: Colors.teal)
                                  ],
                                ),
                              )
                            : Container(),
                        Text(
                          '举报',
                          style: TextStyle(color: Colors.red.shade300),
                        )
                      ],
                    )
                  ],
                ),
              ),
              CommonTitle('猜你喜欢'),
              Info(),
              Container(
                height: 100,
              )
            ]),
            Positioned(
                width: MediaQuery.of(context).size.width,
                height: 100,
                bottom: 0,
                child: Container(
                  color: Colors.grey.shade200,
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isLike = !isLike;
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 40,
                          margin: EdgeInsets.only(right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(isLike ? Icons.star : Icons.star_border,
                                  size: 24,
                                  color: isLike ? Colors.teal : Colors.black),
                              Text(isLike ? '已收藏' : '收藏',
                                  style: TextStyle(fontSize: 12))
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                              margin: EdgeInsets.only(right: 5),
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.cyan,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Center(
                                  child: Text(
                                '联系房东',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ))),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Center(
                                  child: Text('预约看房',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18)))),
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ));
  }
}

class BaseInfoItem extends StatelessWidget {
  final String content;
  const BaseInfoItem(this.content, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(content, style: TextStyle(fontSize: 16)),
        width: (MediaQuery.of(context).size.width - 3 * 10) / 2);
  }
}
