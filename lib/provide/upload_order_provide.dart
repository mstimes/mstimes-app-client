import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mstimes/common/valid.dart';
import 'package:mstimes/common/wechat.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/local_share/order_info.dart';

class UploadOrderProvide with ChangeNotifier {
  void postUploadGoodInfos(formData, goodName, totalFee, context, rpx) async {
    await requestDataByUrl('uploadOrder', formData: jsonEncode(formData)).then((val) {
      var data = json.decode(val.toString());
      print('data' + data.toString());

      if (data['success']) {
        LocalOrderInfo.getLocalOrderInfo()
            .setOrderNumber(data['dataList'][0]);
        LocalOrderInfo.getLocalOrderInfo().setTotalFee(totalFee);
        doWechatRepay(data['dataList'][0], goodName, totalFee);
      } else {
        showAlertDialog(context, data['msg'], 210, rpx);
      }
    });
  }
}
