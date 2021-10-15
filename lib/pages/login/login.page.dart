import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mstimes/common/wechat.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/agent.dart';
import 'package:mstimes/model/local_share/account_info.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:mstimes/utils/color_util.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:sign_in_apple/sign_in_apple.dart';

import '../../common/valid.dart';
import '../../utils/color_util.dart';
import 'dart:io';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //焦点
  FocusNode _focusNodeUserName = new FocusNode();
  FocusNode _focusNodePassWord = new FocusNode();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _userNameController = new TextEditingController();

  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double rpx;

  var _password = ''; //用户名
  var _username = ''; //密码
  var _isShowPwd = false; //是否显示密码
  var _isShowClear = false; //是否显示输入框尾部的清除按钮

  var readServiceText = false;
  var wechatErrCode = -1;
  var _result = '';

  @override
  void initState() {
    fluwx.weChatResponseEventHandler.listen((data) {
      if (data is fluwx.WeChatAuthResponse) {
        if (data.errCode == 0) {
          getWeChatAccessToken(data.code, context);
        } else {
          print('login wechat fail.');
          showAlertDialog(context, '微信一键登陆失败，请重新登陆', 80, rpx);
        }
      }
    });

    //设置焦点监听
    _focusNodeUserName.addListener(_focusNodeListener);
    _focusNodePassWord.addListener(_focusNodeListener);
    //监听用户名框的输入改变
    _userNameController.addListener(() {
      print(_userNameController.text);

      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (_userNameController.text.length > 0) {
        _isShowClear = true;
      } else {
        _isShowClear = false;
      }
      setState(() {});
    });
    super.initState();
  }



  @override
  void dispose() {
    // 移除焦点监听
    _focusNodeUserName.removeListener(_focusNodeListener);
    _focusNodePassWord.removeListener(_focusNodeListener);
    _userNameController.dispose();
    super.dispose();
  }

  // 监听焦点
  Future<Null> _focusNodeListener() async {
    if (_focusNodeUserName.hasFocus) {
      print("用户名框获取焦点");
      // 取消密码框的焦点状态
      _focusNodePassWord.unfocus();
    }
    if (_focusNodePassWord.hasFocus) {
      print("密码框获取焦点");
      // 取消用户名框焦点状态
      _focusNodeUserName.unfocus();
    }
  }

  /**
   * 验证用户名
   */
  String validateUserName(value) {
    // 正则匹配手机号
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    if (value.isEmpty) {
      return '用户名不能为空!';
    } else if (!exp.hasMatch(value)) {
      return '请输入正确手机号';
    }
    return null;
  }

  /**
   * 验证密码
   */
  String validatePassWord(value) {
    if (value.isEmpty) {
      return '密码不能为空';
    } else if (value.trim().length < 6 || value.trim().length > 18) {
      return '密码长度不正确';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;

    // logo 图片区域
    Widget logoImageArea = new Container(
      alignment: Alignment.topCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          "lib/images/mstimes-logo.png",
          height: 130 * rpx,
          width: 130 * rpx,
          fit: BoxFit.cover,
        ),
      ),
    );

    Widget readServiceText = new Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '登陆即同意',
          style: TextStyle(fontSize: 23 * rpx),
        ),
        InkWell(
          onTap: () {
            RouterHome.flutoRouter.navigateTo(
              context,
              RouterConfig.serviceTextPagePath,
            );
          },
          child: Text(
            '用户协议',
            style: TextStyle(color: Colors.red[600], fontSize: 23 * rpx),
          ),
        ),
        Text(
          '和',
          style: TextStyle(fontSize: 23 * rpx),
        ),
        InkWell(
          onTap: () {
            RouterHome.flutoRouter.navigateTo(
              context,
              RouterConfig.privateTextPagePath,
            );
          },
          child: Text(
            '隐私政策',
            style: TextStyle(color: Colors.red[600], fontSize: 23 * rpx),
          ),
        )
      ],
    ));

    // 登录按钮区域
    Widget wxLoginArea = new Container(
      margin: EdgeInsets.only(left: 80 * rpx, right: 80 * rpx),
      height: 83 * rpx,
      width: 260 * rpx,
      child: new RaisedButton(
        color: mainColor,
        child: Text(
          "微信一键登录",
          style: TextStyle(
              color: Colors.white,
              fontSize: 28 * rpx,
              fontWeight: FontWeight.normal),
        ),
        onPressed: () {
          //点击登录按钮，解除焦点，回收键盘
          _focusNodePassWord.unfocus();
          _focusNodeUserName.unfocus();
          wxLogin(context, rpx);
        },
      ),
    );

    Widget appleLoginArea = new GestureDetector(
      onTap: () {
        SignInApple.clickAppleSignIn();
      },
      child: Container(
        margin: EdgeInsets.only(left: 60 * rpx, right: 60 * rpx, top: 30 * rpx),
        height: 80 * rpx,
        width: 300 * rpx,
        child: Image.asset(
          "lib/images/apple_login.jpg",
          width: 56,
          height: 56,
        ),
      ),
    );

    //第三方登录区域
    Widget thirdLoginArea = new Container(
      margin: EdgeInsets.only(left: 20 * rpx, right: 20 * rpx),
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 80 * rpx,
                height: 1.0,
                color: Colors.grey,
              ),
              Text('第三方登录'),
              Container(
                width: 80 * rpx,
                height: 1.0,
                color: Colors.grey,
              ),
            ],
          ),
          new SizedBox(
            height: 18,
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                color: Colors.green[200],
                // 第三方库icon图标
                icon: Icon(FontAwesomeIcons.weixin),
                iconSize: 40.0 * rpx,
                onPressed: () {},
              ),
              IconButton(
                color: Colors.green[200],
                icon: Icon(FontAwesomeIcons.facebook),
                iconSize: 40.0 * rpx,
                onPressed: () {},
              ),
              IconButton(
                color: Colors.green[200],
                icon: Icon(FontAwesomeIcons.qq),
                iconSize: 40.0 * rpx,
                onPressed: () {},
              )
            ],
          )
        ],
      ),
    );

    //忘记密码  立即注册
    Widget bottomArea = new Container(
      margin: EdgeInsets.only(right: 5),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            child: Text(
              "忘记密码?",
              style: TextStyle(
                  color: buttonColor,
                  fontSize: 26.0 * rpx,
                  fontWeight: FontWeight.w500),
            ),
            //忘记密码按钮，点击执行事件
            onPressed: () {},
          ),
          FlatButton(
            child: Text(
              "新用户注册",
              style: TextStyle(
                  color: buttonColor,
                  fontSize: 26.0 * rpx,
                  fontWeight: FontWeight.w500),
            ),
            //点击快速注册、执行事件
            onPressed: () {
              RouterHome.flutoRouter
                  .navigateTo(context, RouterConfig.  bindPhoneNumberPagePath);
            },
          )
        ],
      ),
    );

    Widget closeLoginPage = Row(
      children: [
        IconButton(
          padding: EdgeInsets.only(left: 50 * rpx, top: 10 * rpx),
          alignment: Alignment.topLeft,
          color: Colors.black,
          focusColor: Colors.amber,
          icon: Icon(Icons.close),
          iconSize: 55.0 * rpx,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Expanded(child: Container())
      ],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      // 外层添加一个手势，用于点击空白部分，回收键盘
      body: new GestureDetector(
        onTap: () {
          _focusNodePassWord.unfocus();
          _focusNodeUserName.unfocus();
        },
        child: new ListView(
          children: <Widget>[
            closeLoginPage,
            new SizedBox(
              height: Platform.isIOS ? 400 * rpx : 300 * rpx,
            ),
            logoImageArea,
            new SizedBox(
              height: 150 * rpx,
            ),
            Platform.isIOS ? (isInstalledWx == true ? wxLoginArea : Container()) : wxLoginArea,
            Platform.isIOS ? appleLoginArea : Container(),
            new SizedBox(
              height: Platform.isIOS ? 500 * rpx : 650 * rpx,
            ),
            readServiceText,
          ],
        ),
      ),
    );
  }
}

void postUserLogin(loginType, loginId, accessToken, context) {
  UserInfo userInfo = UserInfo.getUserInfo();
  FormData formData = new FormData.fromMap({
    "loginType": loginType,
    "loginId": loginId,
  });

  requestDataByUrl('login', formData: formData).then((val) {
    var data = json.decode(val.toString());
    print('data ' + data.toString());

    var userModel = UserModel.fromJson(data);
    userInfo.setUnionId(loginId);
    userInfo.setLevel(0);
    userInfo.setLoginType(loginType);
    userInfo.setPhone("0");

    if (userModel.success) {
      print('login success.');
      userInfo.setUserId(userModel.dataList[0].id);
      userInfo.setModel(userModel);
      userInfo.setPhone(userModel.dataList[0].phone);
      userInfo.setImageUrl(userModel.dataList[0].imageUrl);
      userInfo.setUserName(userModel.dataList[0].name);
      userInfo.setLevel(userModel.dataList[0].level);
      userInfo.setInviteCode(userModel.dataList[0].inviteCode);
      userInfo.setUserType(userModel.dataList[0].userType);
      userInfo.setUserNumber(userModel.dataList[0].userNumber);
      userInfo.setParentAgentName(userModel.dataList[0].parentAgentName);
    }

    if(userInfo.phone != null && userInfo.phone != "0"){
      RouterHome.flutoRouter.navigateTo(context, RouterConfig.groupGoodsPath);
    } else {
      if(loginType == 1){
        getWeChatUserInfo(accessToken, loginId);
      }

      RouterHome.flutoRouter
          .navigateTo(context, RouterConfig.bindPhoneNumberPagePath);
    }
  });
}
