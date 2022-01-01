// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  final String? title;
  final bool? isActive;
  final Function(BuildContext)? onTap;

  const Item({Key? key, this.title, this.isActive, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = isActive! ? Colors.teal : Colors.black;
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          // 传context是因为 commonPicker 需要
          onTap!(context);
        }
      },
      child: Container(
        child: Container(
          child: Row(
            children: [
              Text(title!, style: TextStyle(color: color)),
              Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
      ),
    );
  }
}
