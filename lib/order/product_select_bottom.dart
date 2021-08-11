import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:mstimes/common/valid.dart';
import 'package:mstimes/provide/good_select_type.dart';
import 'package:mstimes/provide/order_info_add.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:mstimes/tools/common_container.dart';

class GoodSelectBottom extends StatefulWidget {
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
          left: 0 * rpx, right: 0, top: 15 * rpx, bottom: 40 * rpx),
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
          if(checkIsLogin(context)){
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
              RouterConfig.setOrderInfosPath,
            );
          } else {
            Navigator.pop(context);
          }
        },
        child: buildSingleSummitButton('开始下单', 600, 80, 10, rpx));
  }
}
