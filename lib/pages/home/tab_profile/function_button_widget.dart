// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:goodhouse/pages/home/tab_profile/function_button.data.dart';

class FunctionButtonWidget extends StatelessWidget {
  final FunctionButtonItem data;
  const FunctionButtonWidget(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        data.onTapHandle!(context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.33,
        margin: EdgeInsets.only(top: 30),
        child: Column(
          children: [Image.asset(data.imageUrl), Text(data.title)],
        ),
      ),
    );
  }
}
