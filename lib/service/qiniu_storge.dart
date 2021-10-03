import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mstimes/common/control.dart';
import 'package:mstimes/common/valid.dart';
import 'package:mstimes/model/local_share/release_images.dart';
import 'package:provider/provider.dart';
import 'package:qiniu_flutter_sdk/qiniu_flutter_sdk.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/qiniu_token.dart';
import 'package:mstimes/provide/upload_release_provide.dart';

Storage storage;
int lastGetTokenTime;
String token;
Timer _timer;

void uploadImage(String keyType, String imageName, int number, String filePath,
    context) async {
  // final uploadGoodInfosProvide = Provide.value<UploadGoodInfosProvide>(context);
  final uploadGoodInfosProvide = Provider.of<UploadGoodInfosProvide>(context, listen: false);

  double rpx = MediaQuery.of(context).size.width / 750;
  storage = Storage();
  File imageFile = File(filePath);

  storage.putFile(imageFile, token)
    ..then((PutResponse response) {
      if (keyType != null) {
        if (debug) {
          print('keyType != null keyType: ' +
              keyType.toString() +
              ' response.rawData ' +
              response.rawData['key'].toString());
        }
        uploadGoodInfosProvide.setUploadMapInfo(
            keyType, number, response.rawData['key'].toString());
      } else {
        if (debug) {
          print('keyType null imageName: ' +
              imageName +
              ' response.rawData ' +
              response.rawData['key'].toString());
        }
        uploadGoodInfosProvide.setUploadInfo(
            imageName, response.rawData['key'].toString());
      }
    }).catchError((e) {
      print('qiniu storage error');
      showAlertDialog(context, '图片云端存储错误，清重新选择图片！', 30, rpx);
    }).whenComplete(() => {
          LocalReleaseImages.getImagesMap().localImagesMap[imageName] =
              imageFile
        });

  print('Qiniu storage upload finished. fileName : ' + imageFile.path);
}

int getIntervalTime() {
  return DateTime.now().microsecond - lastGetTokenTime;
}

void qiniuTokenTimer(context) async {
  if (_timer == null) {
    getQiniuToken();
    _timer = Timer.periodic(Duration(seconds: 60 * 60), (t) {
      print('执行qiniu token timer');
      getQiniuToken();
      // t.cancel();
    });
  }
}

void getQiniuToken() {
  QiniuToken qiniuToken;
  requestDataByUrl('getQiniuToken').then((val) {
    var data = json.decode(val.toString());
    print('data' + data.toString());
    qiniuToken = QiniuToken.fromJson(data);
    token = qiniuToken.dataList[0].toString();
  });
}
