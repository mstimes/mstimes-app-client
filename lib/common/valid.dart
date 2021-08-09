import 'package:flutter/material.dart';
import 'package:mstimes/utils/color_util.dart';

import '../model/local_share/account_info.dart';
import '../routers/router_config.dart';

String needStringCommonValid(String value) {
  if (value == null || value.isEmpty) {
    return "该字段为必填字段，请检查。";
  }
  return null;
}

String priceCommonValid(str) {
  // bool result = new RegExp(
  //         r'/(^[1-9][0-9]{0,7}$)|(^((0\.0[1-9]$)|(^0\.[1-9]\d?)$)|(^[1-9][0-9]{0,7}\.\d{1,2})$)/')
  //     .hasMatch(str);

  bool result = new RegExp(
          r'/(^[1-9][0-9]{0,7}$)|(^((0\.0[1-9]$)|(^0\.[1-9]\d?)$)|(^[1-9][0-9]{0,7})$)/')
      .hasMatch(str);

  if (!result) {
    return "请输入正确金额。";
  }
  return null;
}

bool isAlphabetOrNumber(value) {
  RegExp exp = RegExp(r'[a-zA-Z]|[0-9.]');
  if (exp.hasMatch(value)) {
    return true;
  }
  return false;
}

bool checkIsLogin(context) {
  UserInfo agent = UserInfo.getUserInfo();
  if (agent.userType == null) {
    RouterHome.flutoRouter.navigateTo(context, RouterConfig.loginPagePath);
  } else {
    return true;
  }
}

AlertDialog showAlertDialog(
    BuildContext context, String textContent, leftPadding, rpx) {
  AlertDialog alert = AlertDialog(
    contentPadding: EdgeInsets.only(
        top: 15 * rpx, bottom: 15 * rpx, left: leftPadding * rpx),
    content: Text(textContent),
    contentTextStyle: TextStyle(color: Colors.white),
    backgroundColor: buttonColor,
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
