class AccountOrderSummary {
  bool success;
  int code;
  String msg;
  List<ResultDataList> dataList;
  int pageCount;
  int pageSize;
  int pageTotalCount;
  bool pageHasMoreData;

  AccountOrderSummary(
      {this.success,
      this.code,
      this.msg,
      this.dataList,
      this.pageCount,
      this.pageSize,
      this.pageTotalCount,
      this.pageHasMoreData});

  AccountOrderSummary.fromJson(Map<String, dynamic> json) {
    print('fromJson : ' + json.toString());
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    if (json['dataList'] != null) {
      dataList = new List<ResultDataList>();
      json['dataList'].forEach((v) {
        dataList.add(new ResultDataList.fromJson(v));
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

class ResultDataList {
  String sumCount;
  String sumPrice;

  ResultDataList({this.sumCount, this.sumPrice});

  ResultDataList.fromJson(Map<String, dynamic> json) {
    sumCount = json['sumCount'];
    sumPrice = json['sumPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sumCount'] = this.sumCount;
    data['sumPrice'] = this.sumPrice;
    return data;
  }
}
