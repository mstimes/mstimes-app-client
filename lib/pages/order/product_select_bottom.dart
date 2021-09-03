import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:mstimes/common/valid.dart';
import 'package:mstimes/provide/good_select_type.dart';
import 'package:mstimes/provide/order_info_add.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:mstimes/tools/common_container.dart';
import 'dart:io';

class GoodSelectBottom extends StatefulWidget {
  final int goodId;

  const GoodSelectBottom({Key key, @required this.goodId})
      : super(key: key);

  @override
  _GoodSelectBottomState createState() => _GoodSelectBottomState();
}

class _GoodSelectBottomState extends State<GoodSelectBottom> {
  double rpx;
  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return Container(
      padding: EdgeInsets.only(
          left: 0 * rpx, right: 0, top: 15 * rpx, bottom: Platform.isIOS ? 30 * rpx : 3 * rpx),
      width: 750 * rpx,
      color: Colors.white,
      alignment: Alignment.center,
      child: createOrderingButton(),
    );
  }

  Widget createOrderingButton() {
    final goodTypeBadgerProvide =
        Provide.value<GoodSelectBottomProvide>(context);
    final orderInfoAddReciverProvide =
        Provide.value<OrderInfoAddReciverProvide>(context);
    return InkWell(
        onTap: () {
          if(!checkIsLogin(context)){
            return;
          }

          if (goodTypeBadgerProvide.queryTypeValueMap().isEmpty ||
              goodTypeBadgerProvide.typeSpecNums <= 0) {
            showAlertDialog(context, '请选择后下单', 180.00, rpx);
            return;
          }

          orderInfoAddReciverProvide.addReceiverOrderSelectInfo(
              goodTypeBadgerProvide.queryTypeNumChangeMap(),
              goodTypeBadgerProvide.queryTypeValueMap());

          if (!goodTypeBadgerProvide.fromOrderInfo) {
            RouterHome.flutoRouter.navigateTo(
              context,
              RouterConfig.setOrderInfosPath + "?goodId=${widget.goodId}",
            );
          } else {
            Navigator.pop(context);
          }
        },
        child: buildSingleSummitButton('开始下单', 600, 80, 10, rpx));
  }
}