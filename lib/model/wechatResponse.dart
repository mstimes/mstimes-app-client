class WechatPrepayResponse {
  bool success;
  int code;
  String msg;
  List<DataList> dataList;
  int pageCount;
  int pageSize;
  int pageTotalCount;
  bool pageHasMoreData;

  WechatPrepayResponse(
      {this.success,
      this.code,
      this.msg,
      this.dataList,
      this.pageCount,
      this.pageSize,
      this.pageTotalCount,
      this.pageHasMoreData});

  WechatPrepayResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    if (json['dataList'] != null) {
      dataList = new List<DataList>();
      json['dataList'].forEach((v) {
        dataList.add(new DataList.fromJson(v));
      });
    }
    pageCount = json['pageCount'];
    pageSize = json['pageSize'];
    pageTotalCount = json['pageTotalCount'];
    pageHasMoreData = json['pageHasMoreData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.dataList != null) {
      data['dataList'] = this.dataList.map((v) => v.toJson()).toList();
    }
    data['pageCount'] = this.pageCount;
    data['pageSize'] = this.pageSize;
    data['pageTotalCount'] = this.pageTotalCount;
    data['pageHasMoreData'] = this.pageHasMoreData;
    return data;
  }
}

class DataList {
  String appId;
  String partnerId;
  String prepayId;
  String nonceStr;
  String timestamp;
  String pack;
  String sign;

  DataList(
      {this.appId,
      this.partnerId,
      this.prepayId,
      this.nonceStr,
      this.timestamp,
      this.pack,
      this.sign});

  DataList.fromJson(Map<String, dynamic> json) {
    appId = json['appId'];
    partnerId = json['partnerId'];
    prepayId = json['prepayId'];
    nonceStr = json['nonceStr'];
    timestamp = json['timestamp'];
    pack = json['pack'];
    sign = json['sign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appId'] = this.appId;
    data['partnerId'] = this.partnerId;
    data['prepayId'] = this.prepayId;
    data['nonceStr'] = this.nonceStr;
    data['timestamp'] = this.timestamp;
    data['pack'] = this.pack;
    data['sign'] = this.sign;
    return data;
  }
}
