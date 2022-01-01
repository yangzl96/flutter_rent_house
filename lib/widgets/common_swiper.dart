// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unnecessary_new, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

// 图片宽 750px 高 424px
const List<String> defaultImages = [
  'http://ww3.sinaimg.cn/large/006y8mN6ly1g6e2tdgve1j30ku0bsn75.jpg',
  'http://ww3.sinaimg.cn/large/006y8mN6ly1g6e2whp87sj30ku0bstec.jpg',
  'http://ww3.sinaimg.cn/large/006y8mN6ly1g6e2tl1v3bj30ku0bs77z.jpg',
];

var imageWidth = 750;
var imageHeight = 424;

class CommonSwiper extends StatelessWidget {
  final List<String> images;
  const CommonSwiper({Key? key, this.images = defaultImages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 换算一个相对高度
    var height = MediaQuery.of(context).size.width / imageWidth * imageHeight;
    return Container(
      height: height,
      child: new Swiper(
        // 解决：ScrollController not attached to any scroll views.
        key: UniqueKey(),
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return new Image.network(
            images[index],
            fit: BoxFit.fill,
          );
        },
        itemCount: images.length,
        pagination: new SwiperPagination(),
      ),
    );
  }
}
