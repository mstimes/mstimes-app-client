import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/good_details.dart';

class DetailGoodInfoProvide with ChangeNotifier {
  GoodDetailModel goodDetailModel;

  Future getGoodInfosById(int goodId) async {
    FormData formData = new FormData.fromMap({
      "goodId": goodId,
    });
    print("getGoodInfosById : " + goodId.toString());
    await requestDataByUrl('queryGoodById', formData: formData).then((val) {
      var data = json.decode(val.toString());
      print('queryGoodById ' + data.toString());
      goodDetailModel = GoodDetailModel.fromJson(data);
      // notifyListeners();
      return data;
    });
  }
}
