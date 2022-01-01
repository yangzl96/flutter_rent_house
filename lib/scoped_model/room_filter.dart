// ignore_for_file: prefer_collection_literals, prefer_final_fields

import 'package:goodhouse/model/general_type.dart';
import 'package:scoped_model/scoped_model.dart';

class FilterBarModel extends Model {
  // 可选列表
  List<GeneralType> _roomTypeList = [];
  List<GeneralType> _orientedList = [];
  List<GeneralType> _floorList = [];

  // 已选项目
  Set<String> _selectedList = Set<String>();

  Map<String, List<GeneralType>> get dataList {
    var result = Map<String, List<GeneralType>>();
    result['roomTypeList'] = _roomTypeList;
    result['orientedList'] = _orientedList;
    result['floorList'] = _floorList;

    return result;
  }

  set dataList(Map<String, List<GeneralType>> data) {
    _roomTypeList = data['roomTypeList'] ?? [];
    _orientedList = data['orientedList'] ?? [];
    _floorList = data['floorList'] ?? [];
    // 数据更新
    notifyListeners();
  }

  Set<String> get selectedList {
    return _selectedList;
  }

  selectedListToggleItem(String data) {
    if (_selectedList.contains(data)) {
      _selectedList.remove(data);
    } else {
      _selectedList.add(data);
    }
    // 数据更新
    notifyListeners();
  }
}
