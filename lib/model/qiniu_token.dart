class QiniuToken {
  bool success;
  int code;
  String msg;
  List<String> dataList;
  int pageCount;
  int pageSize;
  int pageTotalCount;
  bool pageHasMoreData;

  QiniuToken(
      {this.success,
      this.code,
      this.msg,
      this.dataList,
      this.pageCount,
      this.pageSize,
      this.pageTotalCount,
      this.pageHasMoreData});

  QiniuToken.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    dataList = json['dataList'].cast<String>();
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
    data['dataList'] = this.dataList;
    data['pageCount'] = this.pageCount;
    data['pageSize'] = this.pageSize;
    data['pageTotalCount'] = this.pageTotalCount;
    data['pageHasMoreData'] = this.pageHasMoreData;
    return data;
  }
}
