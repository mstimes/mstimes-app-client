import 'package:flutter/material.dart';
import 'package:mstimes/provide/detail_good_infos.dart';
import 'package:provide/provide.dart';

Future getGoodInfosById(goodId, BuildContext context) async {
  return Provide.value<DetailGoodInfoProvide>(context)
      .getGoodInfosById(goodId);
}