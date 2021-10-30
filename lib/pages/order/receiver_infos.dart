import 'package:flutter/material.dart';
import 'package:mstimes/common/valid.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/identify_address.dart';

import 'package:mstimes/model/local_share/order_info.dart';
import 'package:mstimes/pages/order/receiver_widgets/receiver_address.dart';
import 'package:mstimes/pages/order/receiver_widgets/receiver_select.dart';
import 'package:mstimes/provide/reveiver_address_provide.dart';
import 'package:mstimes/provide/select_good_provider.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:mstimes/tools/common_container.dart';
import 'package:provider/provider.dart';
import 'package:mstimes/provide/good_select_type.dart';
import 'package:mstimes/utils/color_util.dart';
import 'package:mstimes/model/good_details.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'dart:io';


class OrderInfos extends StatefulWidget {
  ScrollController controller;
  OrderInfos({Key key, this.controller}) : super(key: key);

  @override
  OrderInfosState createState() => OrderInfosState();
}

class OrderInfosState extends State<OrderInfos> {
  List<Widget> showReceiverOrderSelect = List();
  List<Widget> allReceivers = List();
  bool needAddReceiver = false;
  int currentReceiverNum = 1;
  Set<int> deleteIndexSet = Set();
  double rpx;

  List<Widget> orderInfoWidgets = List<Widget>();
  bool enableAddReciver = false;
  bool validReceiverInfo = true;
  String remindContent;

  Iterable receiversIterable;
  String receiverRegionInfo;
  double alertLeftPadding = 10;

  @override
  void initState() {

    // fluwx.weChatResponseEventHandler.listen((data) {
    //   print(data.errCode);
    //
    //   if (data.errCode == 0) {
    //     print("微信支付成功");
    //     print('responseFromPayment : ' + data.toString());
    //
    //     RouterHome.flutoRouter
    //         .navigateTo(context, RouterConfig.paySuccessPagePath);
    //   } else {
    //     print("微信支付失败");
    //     RouterHome.flutoRouter
    //         .navigateTo(context, RouterConfig.payFailedPagePath);
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          backgroundColor: mainColor,
          primary: true,
          elevation: 0,
          leading: Container(
            child: IconButton(
                onPressed: () {
                  context.read<GoodSelectBottomProvide>().setFromOrderInfo(false);
                  OrderInfosState().clear();
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  size: 25,
                )),
          ),
          title: Row(
            children: <Widget>[
              Container(
                child: Text(
                  '订单信息',
                  style: TextStyle(
                      fontSize: 30 * rpx,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          )),
      body: Stack(
        children: [
          Column(
            children: [
              buildOrderInfoTop(),
              ReceiverAddress(index: 1),
              ReceiverSelectInfo(
                index: 1,
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: _buildOrderInfoBottom(),
          )
        ],
      ),
    );
  }

  void clear() {
    deleteIndexSet.clear();
    allReceivers.clear();
    showReceiverOrderSelect.clear();
    needAddReceiver = false;
    currentReceiverNum = 1;
  }

  Widget buildOrderInfoTop() {
    DataList goodInfo = LocalOrderInfo.getLocalOrderInfo().goodInfo;
    // DataList goodInfo = context.read<SelectedGoodInfoProvide>().goodInfo;
    return Container(
          child: Container(
            width: 730 * rpx,
            height: 220 * rpx,
            margin: EdgeInsets.only(
                left: 10 * rpx, top: 10 * rpx, right: 0 * rpx, bottom: 10 * rpx),
            //设置 child 居中
            alignment: Alignment(0, 0),
            //边框设置
            decoration: new BoxDecoration(
              //背景
              color: Colors.white,
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //设置四周边框
              border: new Border.all(width: 1, color: Colors.white),
            ),
            child: Container(
              child: Row(
                children: <Widget>[
                  Container(
                    height: 200 * rpx,
                    width: 200 * rpx,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(
                              QINIU_OBJECT_STORAGE_URL + goodInfo.mainImage),
                          fit: BoxFit.cover,
                        )),
                  ),
                  Column(
                    children: <Widget>[
                      Expanded(child: Container(
                        margin: EdgeInsets.only(top: 20 * rpx),
                        child: Text(
                          '${goodInfo.title}',
                          style: TextStyle(
                              color: Color.fromRGBO(77, 99, 104, 1), fontSize: 16),
                        ),
                      )),
                    ],
                  )
                ],
              ),
            ),
          )
    );
  }

  Widget _buildOrderInfoBottom() {
    return Container(
        padding: EdgeInsets.only(
            left: 80 * rpx, right: 0, top: 15 * rpx, bottom: Platform.isIOS ? 30 * rpx : 3 * rpx),
        width: 750 * rpx,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                InkWell(
                    onTap: () {
                      // 重置校验开关
                      validReceiverInfo = true;
                      // 校验收件人信息
                      _checkReceiverInfos();
                      // _checkReceiver();

                      if (!validReceiverInfo) {
                        showAlertDialog(
                            context, remindContent, alertLeftPadding, rpx);
                        return;
                      }

                      RouterHome.flutoRouter.navigateTo(
                          context, RouterConfig.confirmOrderPagePath);
                    },
                    child: buildSingleSummitButton('确认下单', 600, 80, 10, rpx))
              ],
            ),
          ],
        ));
  }

  _checkReceiver(){
    final receiverAddressProvide = context.read<ReceiverAddressProvide>();
    if(receiverAddressProvide.identifyAddressMap.isEmpty){
      showAlertDialog(
          context, 'b' + receiverAddressProvide.identifyAddressMap.toString(), alertLeftPadding, rpx);
    }else{
      showAlertDialog(
          context, 'a' + receiverAddressProvide.identifyAddressMap.toString(), alertLeftPadding, rpx);
    }

    print('.......abc ' + receiverAddressProvide.identifyAddressMap.toString());
  }

  _checkReceiverInfos() {
    final receiverAddressProvide = context.read<ReceiverAddressProvide>();
    receiversIterable = receiverAddressProvide.identifyAddressMap.keys;
    if (receiversIterable.isEmpty) {
      validReceiverInfo = false;
      remindContent = '请正确填写收件人信息';
      alertLeftPadding = 140.00;
      return;
    }

    for (String receiver in receiversIterable) {
      IdentifyAddressModel identifyAddressModel =
          receiverAddressProvide.identifyAddressMap[receiver];

      receiverRegionInfo = identifyAddressModel.province +
          identifyAddressModel.city +
          identifyAddressModel.town;
      if (receiverRegionInfo.isEmpty) {
        validReceiverInfo = false;
        remindContent = '请填写收件人省份区域信息';
        alertLeftPadding = 120.00;
        break;
      }
      if (identifyAddressModel.phonenum.isEmpty) {
        validReceiverInfo = false;
        remindContent = '请填写收件人联系方式';
        alertLeftPadding = 140.00;
        break;
      }
      if (identifyAddressModel.person.isEmpty) {
        validReceiverInfo = false;
        remindContent = '请填写收件人信息';
        alertLeftPadding = 160.00;
        break;
      }
      if (identifyAddressModel.detail.isEmpty) {
        validReceiverInfo = false;
        remindContent = '请填写收件人详细地址';
        alertLeftPadding = 140.00;
        break;
      }
    }
  }
}
