import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/identify_address.dart';

class AddReceiverAddressProvide with ChangeNotifier {
  IdentifyAddressModel identifyAddress;

  void getIndentifyResult(requestMap) async {
    Map<String, dynamic> queryParameters = Map();
    queryParameters['access_token'] = requestMap['access_token'];
    await requestDataForJson('identifyReceiverAddress',
            queryParameters: queryParameters, bodyParameters: requestMap)
        .then((val) {
      var data = json.decode(val.toString());
      identifyAddress = IdentifyAddressModel.fromJson(data);
      print('getIndentifyResult ......');
      notifyListeners();
    });
  }

  void clear() {
    identifyAddress = null;
  }
}
