// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:goodhouse/pages/home/tab_index/index_navigator_item.dart';
import 'package:goodhouse/widgets/common_image.dart';

class IndexNavigator extends StatelessWidget {
  const IndexNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 6, bottom: 6),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: indexNavigatorItemList
              .map((item) => InkWell(
                  child: Column(
                    children: [
                      CommonImage(
                        item.imageUri,
                        width: 47,
                      ),
                      // Image.asset(
                      //   item.imageUri,
                      //   width: 47,
                      // ),
                      Text(
                        item.title,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  onTap: () {
                    item.onTap!(context);
                  }))
              .toList()),
    );
  }
}
