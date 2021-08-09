import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/identify_address.dart';

class ReceiverAddressProvide with ChangeNotifier {
  Map<String, IdentifyAddressModel> identifyAddressMap = Map();

  void getIndentifyResult(receiverIndex, requestMap) async {
    // print("requestDataByUrl receiverIndex : " +
    //     receiverIndex +
    //     ",requestMap : " +
    //     requestMap.toString());
    Map<String, dynamic> queryParameters = Map();
    queryParameters['access_token'] = requestMap['access_token'];
    await requestDataForJson('identifyReceiverAddress',
            queryParameters: queryParameters, bodyParameters: requestMap)
        .then((val) {
      var data = json.decode(val.toString());
      // print('getIndentifyResult ' + data.toString());
      identifyAddressMap[receiverIndex] = IdentifyAddressModel.fromJson(data);
      notifyListeners();
    });
  }

  void clear() {
    identifyAddressMap.clear();
  }
}
