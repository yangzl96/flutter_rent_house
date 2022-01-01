// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class commonFloatingActionButton extends StatelessWidget {
  final String title;
  final Function onTap;
  const commonFloatingActionButton(
    this.title,
    this.onTap, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(context);
      },
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        height: 40,
        decoration: BoxDecoration(
            color: Colors.teal, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )),
        ),
      ),
    );
  }
}