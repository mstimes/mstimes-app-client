import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;

import 'package:mstimes/config/qiniu_config.dart';

typedef FlutterQiNiuProgress(String key, double percent);

class FlutterQiNiu {
  static const MethodChannel _channel =
      // const MethodChannel('plugins.xiaoenai.com/flutter_qiniu');
      const MethodChannel('flutter_qiniu');

  static String get platformVersion {
    return '0.0.1';
  }

  static FlutterQiNiuProgress _progress;

  static Future<Map> upload(
      FlutterQiNiuConfig config, FlutterQiNiuProgress progress) async {
    try {
      _progress = progress;
      _channel.setMethodCallHandler(_handler);

      print('convert.jsonEncode begin...');
      String args = convert.jsonEncode(config.toJson());
      print('_channel.invokeMethod begin...');
      String result = await _channel.invokeMethod('upload', args);
      print('convert.jsonDecode begin...');
      Map map = convert.jsonDecode(result);
      print('convert.jsonDecode end...');

      return Future.value(map);
    } catch (e) {
      print('FlutterQiNiuProgress upload error : $e');
      return Future.error(e);
    }
  }

  static Future<dynamic> _handler(MethodCall call) async {
    if (call.method == 'progress') {
      Map args = convert.jsonDecode(call.arguments);
      if (_progress != null) {
        _progress(args['key'], args['percent']);
      }
      return '';
    }
  }
}
