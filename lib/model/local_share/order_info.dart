class LocalOrderInfo {
  static LocalOrderInfo _instance = null;

  var orderNumber;
  var totalFee;

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
}
