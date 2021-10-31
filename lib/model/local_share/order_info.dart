import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/good_details.dart';
import 'package:mstimes/model/local_share/account_info.dart';
import 'dart:convert';

import '../identify_address.dart';
import 'package:dio/dio.dart';

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

  String getFullAddress(){
    return identifyAddressResult.province + identifyAddressResult.city + identifyAddressResult.town + identifyAddressResult.detail;
  }

  Future getUsualAddressInfo() async {
    print('getUsualAddressInfo ' + UserInfo.getUserInfo().userNumber.toString());
    FormData formData = new FormData.fromMap({
      "userNumber": UserInfo.getUserInfo().userNumber,
    });
    await requestDataByUrl('queryLastUsualAddress', formData: formData).then((val) {
      var data = json.decode(val.toString());
      print('queryLastUsualAddress ' + data.toString());
      if(data['success']){
        Map<String, dynamic> map = {
          'person' : data['dataList'][0]['name'],
          'phonenum': data['dataList'][0]['phoneNo'],
          'province': data['dataList'][0]['address'],
          'city': '',
          'town': '',
          'detail': '',
        };
        identifyAddressResult = IdentifyAddressModel.fromJson(map);
        print('get person : ' + identifyAddressResult.person.toString());
      }else {
        print('no address.');
      }

      return data;
    });
  }
}
