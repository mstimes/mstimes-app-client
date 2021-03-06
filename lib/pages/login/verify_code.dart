import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mstimes/common/valid.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/local_share/account_info.dart';
import 'package:dio/dio.dart';


class VercodeTimerWidget extends StatefulWidget {
  @override
  _VercodeTimerWidgetState createState() => _VercodeTimerWidgetState();
}

class _VercodeTimerWidgetState extends State<VercodeTimerWidget> {
  Timer _timer;
  double rpx;

  //倒计时数值
  var _countdownTime = 0;
  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;

    // return OutlineButton(
    //       borderSide: new BorderSide(color: Colors.grey[600]),
    //       onPressed: _countdownTime == 0 ? btnPress() : null,
    //       child: Text(
    //           handleCodeAutoSizeText(),
    //           style: TextStyle(color: Colors.grey[600], fontSize: 20 * rpx),
    //         ),
    //       );
    return InkWell(
      onTap: (){
        if(_countdownTime == 0){
          btnPress();
        }else {
          return null;
        }
      },
      child: Container(
        height: 70 * rpx,
        width: 160 * rpx,
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 20 * rpx, right: 20 * rpx, top: 10 * rpx, bottom: 10 * rpx),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          border: new Border.all(width: 1, color: Colors.grey[600]),
        ),
        child: Text(
          handleCodeAutoSizeText(),
          style: TextStyle(color: Colors.grey[600], fontSize: 22 * rpx, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  btnPress() {
    if (_countdownTime == 0) {
      String validateResult = validatePhoneNumber(UserInfo.getUserInfo().phone);
      if(validateResult != null){
        showAlertDialog(context, validateResult, 150, rpx);
        return;
      }

      sendPhoneVerify();
      startCountdown();
    }
  }



  void sendPhoneVerify() {
    FormData formData = new FormData.fromMap({
      "phoneNumber": UserInfo.getUserInfo().phone,
    });

    requestDataByUrl('sendPhoneVerify', formData: formData).then((val) {
      var data = json.decode(val.toString());
      if(data['success'] == true){
        print('验证码发送成功');
      }else {
        showAlertDialog(context, '验证码发送失败, 请重试！', 100, rpx);
      }

    });
  }

  String handleCodeAutoSizeText() {
    if (_countdownTime > 0) {
      return '$_countdownTime' + 's';
    } else
      return '获取验证码';
  }

  call(timer) {
    if (_countdownTime < 1) {
      _timer.cancel();
      _timer = null;
    } else {
      setState(() {
        _countdownTime -= 1;
      });
    }
    // print(_countdownTime);
  }

  //倒计时方法
  startCountdown() {
    //倒计时时间
    _countdownTime = 30;
    // print({_countdownTime: _countdownTime, _timer: _timer == null});
    // print(_timer);
    if (_timer == null) {
      // /所以第一次循环是_timer是null,再次点击时_timer == null为false
      _timer = Timer.periodic(Duration(seconds: 1), call);
      //原因是_timer被赋值了，所以在清除定时器后我手动赋值null
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }
}
