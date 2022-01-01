// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:goodhouse/scoped_model/auth.dart';
import 'package:goodhouse/utils/dio_http.dart';
import 'package:goodhouse/utils/scoped_model_helper.dart';
import 'package:image_picker/image_picker.dart';

Future<String> uploadImages(List<XFile> files, BuildContext context) async {
  if (files == null) return Future.value('');
  if (files.isEmpty) return Future.value('');

  // 使用map的方式 报错500
  // List<Future<MultipartFile>> filesList = files.map((file) async {
  //   return await MultipartFile.fromFile(file as String,
  //       filename: 'picture.jpg');
  // }).toList();
  // FormData formData = FormData.fromMap({"file": filesList});

  List<MultipartFile> filesList = [];
  for (var file in files) {
    MultipartFile multipartFile = await MultipartFile.fromFile(
      file.path,
      filename: 'picture.jpg',
    );
    filesList.add(multipartFile);
  }
  FormData formData = FormData.fromMap({"file": filesList});

  String url = 'http://api-hookuprent-web.itheima.net/houses/image';
  var token = ScopedModelHelper.getModel<AuthModel>(context).token;

  // 报错：The argument type 'FormData' can't be assigned to the parameter type 'Map<String, dynamic>?'
  // var res = await DioHttp.of(context).postFormData(url, formData, token);

  var res = await Dio().post(url,
      data: formData,
      options: Options(
          contentType: 'multipart/form-data',
          headers: {'Authorization': token}));

  var data = json.decode(res.toString())['body'];
  String images = List<String>.from(data).join('|');
  return Future.value(images);
}
