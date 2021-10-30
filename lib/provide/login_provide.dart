import 'package:flutter/material.dart';

class LoginProvide with ChangeNotifier {
  bool isLogin = false;
  Map aab = {};

  void refreshLoginStatus(){
    this.isLogin = true;
    notifyListeners();
  }

  bool getLoginStatus(){
    return isLogin;
  }
}
