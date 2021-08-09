import 'package:flutter/material.dart';
import 'package:mstimes/pages/login/verify_code.dart';
import 'package:mstimes/routers/router_config.dart';

class VerifyPage extends StatefulWidget {
  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  double rpx;
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
                    fontSize: 36 * rpx,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
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
                // controller: _userNameController,
                // focusNode: _focusNodeUserName,
                //设置键盘类型
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    // enabledBorder: InputBorder.none,
                    // focusedBorder: InputBorder.none,
                    hoverColor: Colors.grey,
                    hintText: "请输入四位验证码",
                    hintStyle:
                        TextStyle(fontSize: 50 * rpx, color: Colors.grey[300])),
                //保存数据
                onSaved: (String value) {
                  // _username = value;
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
                color: Colors.yellow[800],
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
                  RouterHome.flutoRouter
                      .navigateTo(context, RouterConfig.invitePagePath);
                  //点击登录按钮，解除焦点，回收键盘
                  // _focusNodePassWord.unfocus();
                  // _focusNodeUserName.unfocus();

                  // if (_formKey.currentState.validate()) {
                  //   //只有输入通过验证，才会执行这里
                  //   _formKey.currentState.save();
                  //   //todo 登录操作
                  //   print("$_username + $_password");
                  // }
                },
              ),
            )
          ],
        ));
  }
}
