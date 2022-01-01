// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:goodhouse/config.dart';
import 'package:goodhouse/model/room_list_item_data.dart';
import 'package:goodhouse/widgets/common_image.dart';
import 'package:goodhouse/widgets/common_tag.dart';

class RoomListItemWidget extends StatelessWidget {
  final RoomListItemData? data;
  const RoomListItemWidget(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var imageUrl = data!.imageUri!.startsWith('http')
        ? data!.imageUri
        : Config.BaseUrl + data!.imageUri!;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('roomDetail/${data!.id}');
      },
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Row(
          children: [
            // Image.network(
            //   data.imageUri ?? '',
            //   width: 132.5,
            //   height: 100,
            // ),
            CommonImage(
              imageUrl!,
              width: 132.5,
              height: 100,
            ),
            Padding(padding: EdgeInsets.only(left: 10)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data!.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(data!.subTitle ?? '',
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  Wrap(
                    children:
                        data!.tags!.map((item) => CommonTag(item)).toList(),
                  ),
                  Text('${data!.price}元/月',
                      style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                          fontSize: 16))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
