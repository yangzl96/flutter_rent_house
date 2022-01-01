// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:goodhouse/pages/home/tab_index/index_recommedn_data.dart';
import 'package:goodhouse/pages/home/tab_index/index_recommend_item_widget.dart';

class IndexRecommend extends StatelessWidget {
  final List<IndexRecommendItem> dataList;

  const IndexRecommend({Key? key, this.dataList = indexRecommendData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0x08000000),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('房屋推荐',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              Text(
                '更多',
                style: TextStyle(color: Colors.black54),
              )
            ],
          ),
          Padding(padding: EdgeInsets.all(5)),
          Wrap(
              runSpacing: 10,
              spacing: 10,
              children: dataList
                  .map((item) => IndexRecommendItemWidget(item))
                  .toList())
        ],
      ),
    );
  }
}
