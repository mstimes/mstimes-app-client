import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mstimes/common/valid.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/agent.dart';
import 'package:mstimes/model/local_share/account_info.dart';
import 'package:mstimes/pages/login/verify_code.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:dio/dio.dart';

class VerifyPage extends StatefulWidget {
  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  double rpx;
  var fillCode;

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return Scaffold(
        // backgroundColor: Colors.grey[200],
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
                '填写验证码',
                style: TextStyle(
                    fontSize: 30 * rpx,
                    color: Colors.black,
                    fontWeight: FontWeight.w300),
              ),
            )),
        body: Column(
          children: <Widget>[
            Container(
              height: 120 * rpx,
              width: 430 * rpx,
              child: TextFormField(
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 60 * rpx),
                cursorColor: Colors.grey,
                cursorHeight: 60 * rpx,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hoverColor: Colors.grey,
                    hintText: "请输入四位验证码",
                    hintStyle:
                        TextStyle(fontSize: 50 * rpx, color: Colors.grey[300])),
                onChanged: (String value) {
                  setState(() {
                    fillCode = value;
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20 * rpx),
              child: VercodeTimerWidget(),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: 20 * rpx, right: 20 * rpx, top: 20 * rpx),
              height: 85.0 * rpx,
              width: 700 * rpx,
              child: new RaisedButton(
                color: Colors.black,
                child: Text(
                  "下一步",
                  // style: Theme.of(context).primaryTextTheme.headline,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30 * rpx,
                      fontWeight: FontWeight.normal),
                ),
                // 设置按钮圆角
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                onPressed: () {
                  checkPhoneVerify(fillCode);
                },
              ),
            )
          ],
        ));


  }

  void checkPhoneVerify(fillCode) {
    FormData formData = new FormData.fromMap({
      "phoneNumber": UserInfo.getUserInfo().phone,
      "fillCode": fillCode
    });

    requestDataByUrl('checkPhoneVerify', formData: formData).then((val) {
      var data = json.decode(val.toString());
      print('data ' + data.toString());
      print('data result ' + data['success'].toString());
      if(data['success'] == true){
        print('fillCode ' + fillCode);
        loginByPhoneNo(fillCode);
      }else{
        showAlertDialog(context, '请检查手机号或验证码是否正确！', 100, rpx);
      }
    });
  }

  void loginByPhoneNo(fillCode) {
    FormData formData = new FormData.fromMap({
      "loginType": UserInfo.getUserInfo().loginType,
      "loginId": UserInfo.getUserInfo().unionId,
      "phoneNo" : UserInfo.getUserInfo().phone,
      "name" : UserInfo.getUserInfo().userName,
      "imageUrl": UserInfo.getUserInfo().imageUrl
    });

    requestDataByUrl('loginByPhoneNo', formData: formData).then((val) {
      var data = json.decode(val.toString());
      print('data ' + data.toString());

      var userModel = UserModel.fromJson(data);
      if(data['success'] == true){
        UserInfo.getUserInfo().setUserId(userModel.dataList[0].id);
        UserInfo.getUserInfo().setModel(userModel);
        UserInfo.getUserInfo().setPhone(userModel.dataList[0].phone);
        UserInfo.getUserInfo().setImageUrl(userModel.dataList[0].imageUrl);
        UserInfo.getUserInfo().setUserName(userModel.dataList[0].name);
        UserInfo.getUserInfo().setLevel(userModel.dataList[0].level);
        UserInfo.getUserInfo().setInviteCode(userModel.dataList[0].inviteCode);
        UserInfo.getUserInfo().setUserType(userModel.dataList[0].userType);
        UserInfo.getUserInfo().setUserNumber(userModel.dataList[0].userNumber);
        UserInfo.getUserInfo().setParentAgentName(userModel.dataList[0].parentAgentName);

        RouterHome.flutoRouter.navigateTo(context, RouterConfig.groupGoodsPath);
      }else{
        RouterHome.flutoRouter
            .navigateTo(context, RouterConfig.selectAccTypePagePath);
      }
    });
  }
}
