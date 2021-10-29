import 'package:mstimes/model/good_details.dart';
import 'dart:convert';

class LocalOrderInfo {
  static LocalOrderInfo _instance = null;

  var orderNumber;
  var totalFee;
  DataList goodInfo;
  Map orderInfoMap = new Map();

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
    // print('LocalOrderInfo clear : ' + goodInfo.goodId.toString());
    goodInfo = null;
    this.orderInfoMap.clear();
  }
}
