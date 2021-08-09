import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/local_share/account_info.dart';

class DrawingRecordProvide with ChangeNotifier {
  List<Map> drawingRecordInfo;
  Map newDrawingInfo;

  setNewDrawingInfos(newDrawingInfo) {
    this.newDrawingInfo = newDrawingInfo;
  }

  Map getNewDrawingInfos() {
    return this.newDrawingInfo;
  }

  Future getLastByAgentId() async {
    FormData formData = new FormData.fromMap({
      "agentId": UserInfo.getUserInfo().userId,
    });

    await requestDataByUrl('getLastDrawingRecord', formData: formData)
        .then((val) {
      var data = json.decode(val.toString());
      print('drawingRecordInfo ' + data.toString());
      drawingRecordInfo = (data['dataList'] as List).cast();
      notifyListeners();
      return data;
    });
  }
}
