import 'package:flutter/material.dart';
import 'package:mstimes/model/local_share/account_info.dart';
import 'package:mstimes/routers/router_config.dart';

class RegistryPage extends StatefulWidget {
  @override
  _RegistryPageState createState() => _RegistryPageState();
}

class _RegistryPageState extends State<RegistryPage> {
  double rpx;

  //焦点
  FocusNode _focusNodeUserName = new FocusNode();
  FocusNode _focusNodePassWord = new FocusNode();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _userNameController = new TextEditingController();

  var _isShowClear = false; //是否显示输入框尾部的清除按钮

  @override
  void initState() {
    //设置焦点监听
    _focusNodeUserName.addListener(_focusNodeListener);
    _focusNodePassWord.addListener(_focusNodeListener);
    //监听用户名框的输入改变
    _userNameController.addListener(() {

    // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
    if (_userNameController.text.length > 0) {
      _isShowClear = true;
    } else {
      _isShowClear = false;
    }});

    super.initState();
  }

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
                    color: Colors.black,
                    size: 25,
                  )),
            ),
            title: Container(
             // margin: EdgeInsets.only(left: 50 * rpx),
              child: Text(
                '手机注册',
                style: TextStyle(
                    fontSize: 30 * rpx,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            )),
        body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 30 * rpx, right: 30 * rpx),
              child: TextFormField(
                controller: _userNameController,
                focusNode: _focusNodeUserName,
                //设置键盘类型
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: " 请输入手机号",
                  // prefixIcon: Icon(Icons.person),
                  //尾部添加清除按钮
                  suffixIcon: (_isShowClear)
                      ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      // 清空输入框内容
                      _userNameController.clear();
                    },
                  )
                      : null,
                ),
                validator: validateUserName,
                onChanged: (value) {
                  UserInfo.getUserInfo().setPhone(value);
                },
              ),
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
                  //点击登录按钮，解除焦点，回收键盘
                  _focusNodePassWord.unfocus();
                  _focusNodeUserName.unfocus();
                  RouterHome.flutoRouter
                      .navigateTo(context, RouterConfig.verifyPagePath);
                },
              ),
            )
          ],
        ));
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
}
