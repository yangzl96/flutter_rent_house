// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// 正则
final networkUriReg = RegExp('^http');
final localUriReg = RegExp('^static');

class CommonImage extends StatelessWidget {
  final String src;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const CommonImage(this.src, {Key? key, this.width, this.height, this.fit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (networkUriReg.hasMatch(src)) {
      return SizedBox(
        width: width,
        height: height,
        child: CachedNetworkImage(
          imageUrl: src,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      );
    }

    if (localUriReg.hasMatch(src)) {
      return Image.asset(src, width: width, height: height, fit: fit);
    }

    assert(false, '图片加载失败');
    return Container(
      color: Colors.grey.shade200,
    );
  }
}
