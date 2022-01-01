import 'package:flutter/material.dart';
import 'package:goodhouse/config.dart';
import 'package:goodhouse/scoped_model/city.dart';
import 'package:scoped_model/scoped_model.dart';

// 封装 scoped_model 获取数据的方法
class ScopedModelHelper {
  static T getModel<T extends Model>(BuildContext context) {
    return ScopedModel.of<T>(context, rebuildOnChange: true);
  }

  // 获取区域id
  static String getAreaId(context) {
    return ScopedModelHelper.getModel<CityModel>(context).city.id;
  }
}
