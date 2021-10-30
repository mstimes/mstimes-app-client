import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mstimes/common/router.dart';
import 'package:mstimes/common/valid.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/local_share/account_info.dart';
import 'package:mstimes/pages/login/verify_code.dart';
import 'package:mstimes/provide/login_provide.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:dio/dio.dart';
import 'package:mstimes/model/agent.dart';
import 'package:mstimes/tools/common_container.dart';
import 'dart:io';

import 'package:provider/src/provider.dart';


class RegistryPage extends StatefulWidget {
  @override
  _RegistryPageState createState() => _RegistryPageState();
}

class _RegistryPageState extends State<RegistryPage> {
  double rpx;
  var fillCode;

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
                '绑定手机',
                style: TextStyle(
                    fontSize: 30 * rpx,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            )),
        body: Stack(
          children: [
            ListView(
              children: <Widget>[
                _buildSkipButton(),
                _buildMainLogoContainer(),
                _buildInputPhoneNumberContainer(),
                _buildInputVerifyCodeContainer(),
              ],
            ),
            Positioned(
              bottom: 10,
              left: 0,
              child: _buildNextBottom(),
            )
          ],
        ),
    );
  }

  Widget _buildSkipButton(){
    return Container(
      margin: EdgeInsets.only(top: 20 * rpx, right: 30 * rpx),
      child: Row(
        children: [
          Expanded(child: Container()),
          InkWell(
            onTap: (){
              _confirmNoPhoneNumber();

            },
            child: Container(
              child: Text('跳过', style: TextStyle(color: Colors.grey[500], fontSize: 26 * rpx),),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMainLogoContainer(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 70 * rpx, bottom: 20 * rpx),
          // alignment: Alignment.topCenter,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              "lib/images/mstimes-logo.png",
              height: 160 * rpx,
              width: 160 * rpx,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          // alignment: Alignment.center,
          margin: EdgeInsets.only(top: 20 * rpx, bottom: 120 * rpx),
          child: Text('手机绑定，账号安全无忧购', style: TextStyle(color: Colors.grey[500], fontSize: 25 * rpx, fontWeight: FontWeight.w400),),
        )
      ],
    );
  }

  Widget _buildInputPhoneNumberContainer(){
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 50 * rpx),
          child: Image.asset(
            "lib/images/phone.png",
            height: 30 * rpx,
            width: 30 * rpx,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20 * rpx, right: 30 * rpx),
          width: 530 * rpx,
          child: TextFormField(
            controller: _userNameController,
            focusNode: _focusNodeUserName,
            //设置键盘类型
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "请输入手机号",
              // prefixIcon: Icon(Icons.person),
              //尾部添加清除按钮
              // suffixIcon: (_isShowClear)
              //     ? IconButton(
              //   icon: Icon(Icons.clear),
              //   onPressed: () {
              //     // 清空输入框内容
              //     _userNameController.clear();
              //   },
              // )
              //     : null,
            ),
            onChanged: (value) {
              UserInfo.getUserInfo().setPhone(value);
            },
          ),
        )
      ],
    );
  }

  Widget _buildInputVerifyCodeContainer(){
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 50 * rpx),
          child: Image.asset(
            "lib/images/verify_code.png",
            height: 25 * rpx,
            width: 25 * rpx,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20 * rpx, right: 30 * rpx),
          width: 400 * rpx,
          child: TextFormField(
            cursorColor: Colors.grey,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                hoverColor: Colors.grey[300],
                hintText: "请输入四位验证码",
                border: InputBorder.none),
            onChanged: (String value) {
              setState(() {
                fillCode = value;
              });
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20 * rpx, bottom: 20 * rpx, right: 30 * rpx),
          child: VercodeTimerWidget(),
        ),
      ],
    );
  }

  Widget _buildNextBottom(){
    return InkWell(
      onTap: (){
        _focusNodePassWord.unfocus();
        _focusNodeUserName.unfocus();

        String validateResult = validatePhoneNumber(UserInfo.getUserInfo().phone);
        if(validateResult != null){
          showAlertDialog(context, validateResult, 150, rpx);
          return;
        }

        if(fillCode == null || fillCode.toString().length != 4){
          showAlertDialog(context, '请输入正确验证码', 150, rpx);
          return;
        }

        checkPhoneVerify(fillCode);
      },
      child: Container(
        padding: EdgeInsets.only(
            left: 40 * rpx, right: 40 * rpx, top: 15 * rpx, bottom: Platform.isIOS ? 30 * rpx * rpx : 10 * rpx),
        width: 750 * rpx,
        child: buildSingleSummitButton('下一步', 280, 90, 10, rpx),
      ),
    );
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
        if(UserInfo.getUserInfo().userNumber != null){
          // 注册过，但未绑定手机号
          updatePhoneNumber();
          // RouterHome.flutoRouter.navigateTo(context, RouterConfig.groupGoodsPath);
          // 路由登陆前最后一个页面
          // indexPageAfterLogin(context);
          Navigator.pop(context);
          context.read<LoginProvide>().refreshLoginStatus();
        }else {
          loginByPhoneNo();
        }
      }else{
        showAlertDialog(context, '请检查手机号或验证码是否正确！', 100, rpx);
      }
    });
  }

  void updatePhoneNumber(){
    FormData formData = new FormData.fromMap({
      "userNumber": UserInfo.getUserInfo().userNumber,
      "phone": UserInfo.getUserInfo().phone
    });

    requestDataByUrl('updatePhoneNumber', formData: formData).then((val) {
      var data = json.decode(val.toString());
      print('data ' + data.toString());
      RouterHome.flutoRouter.navigateTo(context, RouterConfig.groupGoodsPath);
    });
  }

  void loginByPhoneNo() {
    print('UserInfo.getUserInfo().unionId ' + UserInfo.getUserInfo().unionId.toString());
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

        // RouterHome.flutoRouter.navigateTo(context, RouterConfig.groupGoodsPath);
        // 路由登陆前最后一个页面
        // indexPageAfterLogin(context);
        Navigator.pop(context);
        context.read<LoginProvide>().refreshLoginStatus();
      }else{
        // RouterHome.flutoRouter
        //     .navigateTo(context, RouterConfig.selectAccTypePagePath);
        UserInfo.getUserInfo().setUserType(1);
        Navigator.pop(context);
        RouterHome.flutoRouter
            .navigateTo(context, RouterConfig.invitePagePath);
      }
    });
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

  _confirmNoPhoneNumber() {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          backgroundColor: Colors.black54,
          title: Container(
            alignment: Alignment.center,
            child: new Text(
              '提示信息',
              style: TextStyle(fontSize: 30 * rpx, color: Colors.white),
            ),
          ),
          content: new SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 10 * rpx),
              child: Text('为了更好的统计您的下单信息，建议您绑定手机号，以便为您提供更好的购物体验。',
                  style:
                  TextStyle(fontSize: 25 * rpx, color: Colors.white)),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('仍然跳过',
                  style: TextStyle(fontSize: 23 * rpx, color: Colors.white)),
              onPressed: () {
                // phone number 设置默认值
                UserInfo.getUserInfo().phone = '0';
                if(UserInfo.getUserInfo().userType == null){
                  UserInfo.getUserInfo().setUserType(1);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  RouterHome.flutoRouter
                      .navigateTo(context, RouterConfig.invitePagePath);
                }else{
                  Navigator.pop(context);
                  Navigator.pop(context);
                  RouterHome.flutoRouter
                      .navigateTo(context, RouterConfig.groupGoodsPath);
                  context.read<LoginProvide>().refreshLoginStatus();
                }
              },
            ),
            new FlatButton(
              child: new Text('继续绑定',
                  style: TextStyle(fontSize: 23 * rpx, color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
