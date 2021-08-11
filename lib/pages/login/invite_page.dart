import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/agent.dart';
import 'package:mstimes/model/local_share/account_info.dart';
import 'package:mstimes/routers/router_config.dart';

import '../../common/control.dart';

class InvitePage extends StatefulWidget {
  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  UserModel userModel;
  double rpx;
  String _result = 'nothing';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserInfo agentInfo = UserInfo.getUserInfo();
    ;
    rpx = MediaQuery.of(context).size.width / 750;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            primary: true,
            elevation: 0,
            leading: Container(
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.grey,
                    size: 25,
                  )),
            ),
            title: Container(
              child: Text(
                '填写邀请码',
                style: TextStyle(
                    fontSize: 36 * rpx,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            )),
        body: ListView(
          children: <Widget>[
            _showRegisterResult(),
            Container(
              height: 120 * rpx,
              width: 430 * rpx,
              margin: EdgeInsets.only(
                  left: 40 * rpx, right: 40 * rpx, top: 20 * rpx),
              child: TextFormField(
                textAlign: TextAlign.center,
                cursorColor: Colors.grey,
                cursorHeight: 60 * rpx,
                style: TextStyle(fontSize: 60 * rpx),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hoverColor: Colors.grey,
                    hintText: "请输入六位邀请码",
                    hintStyle:
                        TextStyle(fontSize: 50 * rpx, color: Colors.grey[300])),
                onChanged: (value) {
                  agentInfo.setInviteCode(value);
                  setState(() {
                    userModel = null;
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: 40 * rpx, right: 40 * rpx, top: 20 * rpx),
              height: 85.0 * rpx,
              width: 600 * rpx,
              child: new RaisedButton(
                color: Colors.black,
                child: Text(
                  "注册",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30 * rpx,
                      fontWeight: FontWeight.normal),
                ),
                // 设置按钮圆角
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                onPressed: () {
                  postRegisterUser();
                },
              ),
            )
          ],
        ));
  }

  Widget _showRegisterResult() {
    if (userModel != null && !userModel.success) {
      return Container(
          margin: EdgeInsets.only(left: 300 * rpx, top: 20 * rpx),
          child: Text(
            userModel.msg,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w300),
          ));
    }
    return Container();
  }

  void postRegisterUser() {
    UserInfo userInfo = UserInfo.getUserInfo();
    FormData formData = new FormData.fromMap({
      "userType": userInfo.userType,
      "loginType": userInfo.loginType,
      "loginId": userInfo.unionId,
      "phoneNo": userInfo.phone,
      "inviteCode": userInfo.inviteCode,
      "name": userInfo.userName,
      "imageUrl": userInfo.imageUrl
    });

    requestDataByUrl('registerUser', formData: formData).then((val) {
      var data = json.decode(val.toString());
      if (debug) {
        print('registerUser return data' + data.toString());
      }
      print('registerUser return data' + data.toString());

      userModel = UserModel.fromJson(data);
      print('userModel ' + userModel.toString());
      if (userModel.success) {
        userInfo.setUserId(userModel.dataList[0].id);
        userInfo.setModel(userModel);
        userInfo.setPhone(userModel.dataList[0].phone);
        userInfo.setLevel(userModel.dataList[0].level);
        userInfo.setUserNumber(userModel.dataList[0].userNumber);
        userInfo.setInviteCode(userModel.dataList[0].inviteCode);
        userInfo.setParentAgentName(userModel.dataList[0].parentAgentName);
        print('userModel.success ....');
        RouterHome.flutoRouter.navigateTo(context, RouterConfig.groupGoodsPath);
      } else {
        setState(() {
          userModel = UserModel.fromJson(data);
        });
        userInfo.setMyInviteCode(userModel.dataList[0].inviteCode);
        userInfo.setModel(userModel);
        print('userModel return false.');
      }

      print('userModel' + userModel.toJson().toString());
    });
  }
}
