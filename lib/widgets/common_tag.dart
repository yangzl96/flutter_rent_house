// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CommonTag extends StatelessWidget {
  final String title;
  final Color color;
  final Color backgroundColor;

  const CommonTag.origin(this.title,
      {Key? key, this.color = Colors.black, this.backgroundColor = Colors.grey})
      : super(key: key);

  factory CommonTag(String title) {
    switch (title) {
      case '近地铁':
        return CommonTag.origin(
          title,
          color: Colors.red,
          backgroundColor: Colors.red.shade50,
        );
      case '集中供暖':
        return CommonTag.origin(
          title,
          color: Colors.blue,
          backgroundColor: Colors.blue.shade50,
        );
      case '随时看房':
        return CommonTag.origin(
          title,
          color: Colors.teal,
          backgroundColor: Colors.teal.shade50,
        );
      case '新上':
        return CommonTag.origin(
          title,
          color: Colors.yellow.shade800,
          backgroundColor: Colors.yellow.shade50
        );
      default:
        return CommonTag.origin(title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 4),
      padding: EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(6)),
      child: Text(title,
          style: TextStyle(
            color: color,
            fontSize: 10,
          )),
    );
  }
}
