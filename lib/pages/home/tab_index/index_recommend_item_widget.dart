// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:goodhouse/pages/home/tab_index/index_recommedn_data.dart';

var textStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);

class IndexRecommendItemWidget extends StatelessWidget {
  final IndexRecommendItem data;
  const IndexRecommendItemWidget(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        width: (MediaQuery.of(context).size.width - 10 * 3) / 2,
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [Text(data.title, style: textStyle), Text(data.subTitle, style:textStyle)],
            ),
            Image.asset(
              data.imageUrl,
              width: 55,
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(data.navigateUrl);
      },
    );
  }
}
