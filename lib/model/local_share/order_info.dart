import 'package:mstimes/model/good_details.dart';

class LocalOrderInfo {
  static LocalOrderInfo _instance = null;

  var orderNumber;
  var totalFee;
  DataList goodInfo;

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
  }

  void clear(){
    // print('LocalOrderInfo clear : ' + goodInfo.goodId.toString());
    goodInfo = null;
  }
}
