class UserModel {
  bool success;
  int code;
  String msg;
  List<DataList> dataList;
  int pageCount;
  int pageSize;
  int pageTotalCount;
  bool pageHasMoreData;

  UserModel(
      {this.success,
      this.code,
      this.msg,
      this.dataList,
      this.pageCount,
      this.pageSize,
      this.pageTotalCount,
      this.pageHasMoreData});

  UserModel.fromJson(Map<String, dynamic> json) {
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
  int userType;
  int id;
  int level;
  String phone;
  String wxUnionId;
  String inviteCode;
  String name;
  String imageUrl;
  int parentAgentId;
  String gmtCreated;
  String gmtModified;
  String parentAgentName;
  String userNumber;

  DataList(
      {this.id,
      this.userType,
      this.userNumber,
      this.level,
      this.phone,
      this.name,
      this.wxUnionId,
      this.imageUrl,
      this.inviteCode,
      this.parentAgentId,
      this.parentAgentName,
      this.gmtCreated,
      this.gmtModified});

  DataList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userType = json['userType'];
    userNumber = json['userNumber'];
    level = json['level'];
    phone = json['phone'];
    wxUnionId = json['wxUnionId'];
    name = json['name'];
    imageUrl = json['imageUrl'];
    inviteCode = json['inviteCode'];
    parentAgentId = json['parentAgentId'];
    gmtCreated = json['gmtCreated'];
    gmtModified = json['gmtModified'];
    parentAgentName = json['parentAgentName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userType'] = this.userType;
    data['userNumber'] = this.userNumber;
    data['level'] = this.level;
    data['phone'] = this.phone;
    data['wxUnionId'] = this.wxUnionId;
    data['name'] = this.name;
    data['imageUrl'] = this.imageUrl;
    data['inviteCode'] = this.inviteCode;
    data['parentAgentName'] = this.parentAgentName;
    data['parentAgentId'] = this.parentAgentId;
    data['gmtCreated'] = this.gmtCreated;
    data['gmtModified'] = this.gmtModified;
    return data;
  }
}
