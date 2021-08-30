class MBeans {
  bool success;
  int code;
  String msg;
  List<MBeansDataList> dataList;
  int pageCount;
  int pageSize;
  int pageTotalCount;
  bool pageHasMoreData;

  MBeans(
      {this.success,
      this.code,
      this.msg,
      this.dataList,
      this.pageCount,
      this.pageSize,
      this.pageTotalCount,
      this.pageHasMoreData});

  MBeans.fromJson(Map<String, dynamic> json) {
    print('fromJson : ' + json.toString());
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    if (json['dataList'] != null) {
      dataList = new List<MBeansDataList>();
      json['dataList'].forEach((v) {
        dataList.add(new MBeansDataList.fromJson(v));
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

class MBeansDataList {
  int sumCounts;
  int usedCounts;
  int unusedCounts;

  MBeansDataList({
    this.sumCounts,
    this.usedCounts,
    this.unusedCounts,
  });

  MBeansDataList.fromJson(Map<String, dynamic> json) {
    sumCounts = json['sumCounts'];
    usedCounts = json['usedCounts'];
    unusedCounts = json['unusedCounts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sumCounts'] = this.sumCounts;
    data['usedCounts'] = this.usedCounts;
    data['unusedCounts'] = this.unusedCounts;
    return data;
  }
}
