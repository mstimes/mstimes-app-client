class FundSummary {
  bool success;
  int code;
  String msg;
  List<DataList> dataList;
  int pageCount;
  int pageSize;
  int pageTotalCount;
  bool pageHasMoreData;

  FundSummary(
      {this.success,
      this.code,
      this.msg,
      this.dataList,
      this.pageCount,
      this.pageSize,
      this.pageTotalCount,
      this.pageHasMoreData});

  FundSummary.fromJson(Map<String, dynamic> json) {
    print('fromJson : ' + json.toString());
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
  String myIncome;
  String mySales;
  String groupIncome;
  String groupSales;
  String totalSales;

  DataList(
      {this.myIncome,
      this.mySales,
      this.groupIncome,
      this.groupSales,
      this.totalSales});

  DataList.fromJson(Map<String, dynamic> json) {
    myIncome = json['myIncome'];
    mySales = json['mySales'];
    groupIncome = json['groupIncome'];
    groupSales = json['groupSales'];
    totalSales = json['totalSales'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['myIncome'] = this.myIncome;
    data['mySales'] = this.mySales;
    data['groupIncome'] = this.groupIncome;
    data['groupSales'] = this.groupSales;
    data['totalSales'] = this.totalSales;
    return data;
  }
}
