import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:fluwx/fluwx.dart';
import 'package:mstimes/common/valid.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/wechatResponse.dart';
import 'package:mstimes/pages/login/login.page.dart';
import 'package:mstimes/model/local_share/account_info.dart';

// WeChat Constants
final wechartAppid = "wx8ca4f12e793a8103";
final wechartSecret = "764a75b41db36ce6c32449d4d502356f";
final wechartGrandType = "authorization_code";

bool isInstalledWx = true;

initFluwx() async {
  print('_initFluwx start...');
  await fluwx.registerWxApi(
      appId: wechartAppid,
      doOnAndroid: true,
      doOnIOS: true,
      universalLink: "https://server.ghomelifevvip.com/well/");
  print('_initFluwx end...');
}

doWechatRepay(groupNumber, goodName, totalFee) {
  // UserInfo agent = UserInfo.getUserInfo();
  FormData formData = new FormData.fromMap(
      {"outTradeNo": groupNumber, "goodName": goodName, "totalFee": totalFee});

  requestDataByUrl('doRepay', formData: formData).then((val) {
    var data = json.decode(val.toString());

    var wechatResponse = WechatPrepayResponse.fromJson(data);

    if (wechatResponse.success) {
      print('wechat repay return success');
      fluwx.payWithWeChat(
        appId: wechatResponse.dataList[0].appId,
        partnerId: wechatResponse.dataList[0].partnerId,
        prepayId: wechatResponse.dataList[0].prepayId,
        packageValue: "Sign=WXPay",
        nonceStr: wechatResponse.dataList[0].nonceStr,
        timeStamp: int.parse(wechatResponse.dataList[0].timestamp),
        sign: wechatResponse.dataList[0].sign,
      );

      // _callWechatPay(wechatResponse.dataList[0]);
    } else {
      print('wechat repay return fail. ');
      // RouterHome.flutoRouter.navigateTo(context, RouterConfig.invitePagePath);
    }
  });
}

wxLogin(context, rpx) {
  print('wx login ...');
  fluwx.sendWeChatAuth(scope: "snsapi_userinfo", state: "mstimes").then((data) {
    // print('fluwx data ' + data.toString());
  }).catchError((e){
    // showAlertDialog(context, 'weChatLogin  e  $e', 50, rpx);
    // print('weChatLogin  e  $e');
  });
  print('login finished.');
}

void getWeChatAccessToken(code, context) {
  FormData formData = new FormData.fromMap({
    "appid": wechartAppid,
    "secret": wechartSecret,
    "code": code,
    "grant_type": wechartGrandType
  });

  requestDataByUrl('wechatAccessToken', formData: formData).then((val) {
    var data = json.decode(val.toString());
    print('wechatAccessToken data : ' + data.toString());
    print("access_token: " + data['access_token'].toString());
    print("unionid: " + data['unionid'].toString());

    postUserLogin( 1, data['unionid'], data['access_token'].toString(), context);
  });
}

void getWeChatUserInfo(accessToken, openId) {
  UserInfo agentInfo = UserInfo.getUserInfo();
  FormData formData = new FormData.fromMap({
    "access_token": accessToken,
    "openid": openId,
  });

  requestDataByUrl('wechatUserInfo', formData: formData).then((val) {
    var data = json.decode(val.toString());
    print('wechatUserInfo res : ' + data.toString());

    agentInfo.setImageUrl(data['headimgurl'].toString());
    agentInfo.setUserName(data['nickname'].toString());
  });
}

void callInviteFriends(context, rpx) {
  // showAlertDialog(context, 'call invite friends', 80, rpx);
  var model = new WeChatShareMiniProgramModel(
      webPageUrl: '/pages/discount/discount.wxml',
      path: '/pages/discount/discount?shareUser=' + UserInfo.getUserInfo().userNumber,
      userName: 'gh_6482b034b059',
      title: UserInfo.getUserInfo().userName + '????????????3??????????????????',
      description: '?????????????????? ??????Ms??????',
      thumbnail: WeChatImage.network('/images/invite_logo.jpeg'),
          // thumbnail: WeChatImage.network('https://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83erw66OoBpTLWcNqiahRvskOtfwz72hNwk04BNr4GlCicEqXmsSD13qn7AeWkzOicicjmficMIMBnfSTx4w/132'),
      // hdImagePath: WeChatImage.network('https://ghomelifevvip.com/MSTIMES_PLATFORM_SHARE_2.jpg'),
  );

  fluwx.shareToWeChat(model).then((result){
    showAlertDialog(context, result.toString(), 80, rpx);
  },
  onError: (msg){
    showAlertDialog(context, msg, 80, rpx);
  }
 );
}

isInstallFluwx() async {
  // return await fluwx.isWeChatInstalled().then((value) => {
  //   print('isInstallWx ' + value.toString()),
  //   isInstalledWx = value,
  // });
}