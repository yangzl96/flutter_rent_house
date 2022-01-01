// 第一步引入依赖
import 'package:json_annotation/json_annotation.dart';

// 第二步 ：part 'user_info.g.dart'; 或者给空
part 'user_info.g.dart';

// 第三步 ：@JsonSerializable()
@JsonSerializable()
class UserInfo {
  final String avatar;
  final String gender;
  final String nickname;
  // 如果需要改变后端的字段（phone -> newPhone） 使用：
  // @JsonKey(name: 'newPhone')
  // 再重新生成
  final String phone;
  final int id;

  UserInfo(this.avatar, this.gender, this.nickname, this.phone, this.id);

  // 第四步 注意是 FromJson
  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
  // 第五步 注意是 ToJson
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
  // 第六步：flutter packages pub run build_runner build
}




// -------------------------
// class UserInfo {
//   final String avatar;
//   final String gender;
//   final String nickname;
//   final String phone;
//   final int id;

//   UserInfo(this.avatar, this.gender, this.nickname, this.phone, this.id);

//   factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
//       json['avatar'] as String,
//       json['gender'] as String,
//       json['nickname'] ?? '2222',
//       json['phone'] ?? '1111', //phone 有空值
//       json['id'] as int);
// }
