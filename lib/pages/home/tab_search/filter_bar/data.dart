//结果数据类型
import 'package:goodhouse/model/general_type.dart';

class FilterBarResult {
  final String? areaId;
  final String? priceId;
  final String? rentTypeId;
  final List<String>? moreIds;

  FilterBarResult({
    this.areaId,
    this.priceId,
    this.rentTypeId,
    this.moreIds,
  });
}

List<GeneralType> areaList = [
  GeneralType('区域1', 'ASD'),
  GeneralType('区域2', '22sd'),
];
List<GeneralType> priceList = [
  GeneralType('价格1', '11sds'),
  GeneralType('价格2', '22qwq'),
];
List<GeneralType> rentTypeList = [
  GeneralType('出租类型1', '11we'),
  GeneralType('出租类型2', '2wew2'),
];
List<GeneralType> roomTypeList = [
  GeneralType('房屋类型1', '1fg1'),
  GeneralType('房屋类型2', '22tt'),
];
List<GeneralType> orientedList = [
  GeneralType('方向1', '11hg'),
  GeneralType('方向2', '22rtt'),
];
List<GeneralType> floorList = [
  GeneralType('楼层1', '11'),
  GeneralType('楼层2', '22'),
];
