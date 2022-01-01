// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:goodhouse/pages/home/tab_profile/function_button.data.dart';
import 'package:goodhouse/pages/home/tab_profile/function_button_widget.dart';

class FunctionButton extends StatelessWidget {
  const FunctionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        spacing: 1,
        runSpacing: 1,
        children: list.map((item) => FunctionButtonWidget(item)).toList(),
      ),
    );
  }
}
