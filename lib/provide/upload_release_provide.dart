import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mstimes/common/control.dart';
import 'package:mstimes/config/service_url.dart';

class UploadGoodInfosProvide with ChangeNotifier {
  Map _uploadInfos = Map();

  Map get uploadInfos => _uploadInfos;

  setUploadInfo(key, value) {
    _uploadInfos[key] = value;
  }

  setUploadMapInfo(keyType, number, value) {
    if (_uploadInfos[keyType] == null) {
      List<String> initList = List();
      initList.add(value);
      _uploadInfos[keyType] = initList;
      if (debug) {
        print('_uploadInfos[keyType] == null, add list.');
      }
      print('_uploadInfos[keyType] == null, add list ' + initList.toString());
    } else {
      if (debug) {
        print('_uploadInfos[keyType].add(value) , keyType : ' +
            keyType.toString() +
            ", value : " +
            value.toString());
      }
      List<String> list = _uploadInfos[keyType.toString()];

      if (list.length < number + 1) {
        _uploadInfos[keyType.toString()].add(value.toString());
      } else {
        List<String> initList = List();
        initList.add(value);
        print('replaceRange number ' + number.toString());
        print('list will replace ' + list.toString());
        list.replaceRange(number, number + 1, initList);
      }
      print('list ' + list.toString());
    }
  }

  String getUploadInfosJson() {
    return jsonEncode(_uploadInfos);
  }

  clear() {
    _uploadInfos.clear();
  }

  clearByKeytype(keyType) {
    _uploadInfos.remove(keyType);
  }

  void postUploadGoodInfos() async {
    await requestDataByUrl('uploadReleaseGoods', formData: getUploadInfosJson())
        .then((val) {
      var data = json.decode(val.toString());
      print('data' + data.toString());
      // notifyListeners();
    });
  }
}
