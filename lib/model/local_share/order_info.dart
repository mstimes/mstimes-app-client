import 'package:mstimes/model/good_details.dart';
import 'dart:convert';

import '../identify_address.dart';

class LocalOrderInfo {
  static LocalOrderInfo _instance = null;

  var orderNumber;
  var totalFee;
  DataList goodInfo;
  Map orderInfoMap = new Map();
  IdentifyAddressModel identifyAddressResult;

  _LocalOrderInfo() {}

  static LocalOrderInfo getLocalOrderInfo() {
    if (_instance == null) {
      _instance = new LocalOrderInfo();
    }
    return _instance;
  }

  void setOrderNumber(orderNumber) {
    this.orderNumber = orderNumber;
  }

  void setTotalFee(totalFee) {
    this.totalFee = totalFee;
  }

  void setGoodInfo(currentGoodInfo){
    if(this.goodInfo != null){
      return;
    }
    print('LocalOrderInfo set goodInfo : ' + currentGoodInfo.goodId.toString());
    this.goodInfo = currentGoodInfo;
    this.goodInfo.diffPriceInfoMap = json.decode(this.goodInfo.diffPriceInfo);
  }

  void setOrderInfoKV(key, value){
    this.orderInfoMap[key] = value;
  }

  void clear(){
    goodInfo = null;
    this.orderInfoMap.clear();
  }

  // void getIndentifyResult(requestMap) async {
  //   Map<String, dynamic> queryParameters = Map();
  //   queryParameters['access_token'] = requestMap['access_token'];
  //   await requestDataForJson('identifyReceiverAddress',
  //       queryParameters: queryParameters, bodyParameters: requestMap)
  //       .then((val) {
  //     var data = json.decode(val.toString());
  //     print('identifyReceiverAddress get ...');
  //     identifyAddressResult = IdentifyAddressModel.fromJson(data);
  //   });
  // }

  // void identifyAddressClear(){
  //   identifyAddressResult = null;
  // }
}
