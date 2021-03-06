import 'package:mstimes/model/agent.dart';

class UserInfo {
  static UserInfo _instance = null;

  var userType;
  var userId;
  var unionId;
  UserModel loginUserModel;
  bool success;
  var phone;
  var inviteCode;
  var myInviteCode;
  var imageUrl;
  var userName;
  var userNumber;
  var level;
  var parentAgentName;
  var loginType;

  // 登陆成功后索引页面
  String indexPage;

  _UserInfo() {}

  bool isAgent() {
    return userType == 1;
  }

  bool isOrdinaryAccount(){
    return (userType == 2 && level == 1) || level == null;
  }

  bool isLogin(){
    return userNumber != null;
  }

  static UserInfo getUserInfo() {
    if (_instance == null) {
      _instance = new UserInfo();
    }
    return _instance;
  }

  void setLoginType(loginType){
    this.loginType = loginType;
  }

  void setParentAgentName(parentAgentName) {
    this.parentAgentName = parentAgentName;
  }

  void setUserNumber(userNumber) {
    this.userNumber = userNumber;
  }

  void setUserType(userType) {
    this.userType = userType;
  }

  void setUserId(id) {
    this.userId = id;
  }

  void setUnionId(unionId) {
    this.unionId = unionId;
  }

  void setPhone(phoneNum) {
    print('phoneNum ' + phoneNum.toString());
    this.phone = phoneNum;
  }

  void setInviteCode(inviteCode) {
    this.inviteCode = inviteCode;
  }

  void setModel(var model) {
    this.loginUserModel = model;
  }

  void setMyInviteCode(code) {
    this.myInviteCode = code;
  }

  void setImageUrl(imageUrl) {
    this.imageUrl = imageUrl;
  }

  void setUserName(userName) {
    this.userName = userName;
  }

  void setLevel(level) {
    this.level = level;
  }

  void setIndexPage(indexPage){
    this.indexPage = indexPage;
  }
}
