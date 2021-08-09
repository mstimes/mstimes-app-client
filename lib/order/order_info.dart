import 'package:flutter/material.dart';
import 'package:mstimes/order/receiver_infos.dart';
import 'package:provide/provide.dart';
import 'package:mstimes/common/valid.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/identify_address.dart';
import 'package:mstimes/provide/detail_good_infos.dart';
import 'package:mstimes/provide/order_info_add.dart';
import 'package:mstimes/provide/reveiver_address_provide.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:mstimes/tools/common_container.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class SetOrderInfos extends StatefulWidget {
  @override
  _SetOrderInfosState createState() => _SetOrderInfosState();
}

class _SetOrderInfosState extends State<SetOrderInfos> {
  ScrollController controller = ScrollController();
  List<Widget> orderInfoWidgets = List<Widget>();
  bool enableAddReciver = false;
  double rpx;
  bool validReceiverInfo = true;
  String remindContent;

  Iterable receiversIterable;
  String receiverRegionInfo;
  double alertLeftPadding;

  @override
  void initState() {
    super.initState();

    fluwx.responseFromPayment.listen((data) {
      print(data.errCode);

      if (data.errCode == 0) {
        print("微信支付成功");
        print('responseFromPayment : ' + data.toString());

        RouterHome.flutoRouter
            .navigateTo(context, RouterConfig.paySuccessPagePath);
      } else {
        print("微信支付失败");
        RouterHome.flutoRouter
            .navigateTo(context, RouterConfig.payFailedPagePath);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Provide<OrderInfoAddReciverProvide>(
            builder: (context, child, receiver) {
          return Container(
            child: OrderInfos(
              deleteIndex: receiver.deleteIndex,
              controller: controller,
            ),
          );
        }));
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  Widget buildOrderInfoTop() {
    var goodInfo = Provide.value<DetailGoodInfoProvide>(context)
        .goodDetailModel
        .dataList[0];
    return Container(
        child: Container(
      width: 730 * rpx,
      height: 220 * rpx,
      margin: EdgeInsets.only(left: 0, top: 5 * rpx, right: 0, bottom: 0),
      //设置 child 居中
      alignment: Alignment(0, 0),
      //边框设置
      decoration: new BoxDecoration(
        //背景
        color: Colors.white,
        //设置四周圆角 角度
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        //设置四周边框
        border: new Border.all(width: 1, color: Colors.white),
      ),
      child: Container(
        margin:
            EdgeInsets.only(top: 5 * rpx, bottom: 5 * rpx, left: 0, right: 0),
        child: Row(
          children: <Widget>[
            Container(
              height: 200 * rpx,
              width: 200 * rpx,
              margin: EdgeInsets.only(left: 12.0 * rpx, top: 0),
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
                Text(
                  '${goodInfo.title}',
                  style: TextStyle(
                      color: Color.fromRGBO(77, 99, 104, 1), fontSize: 16),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }

  Widget _buildOrderInfoBottom() {
    // final orderInfoAddReciverProvide =
    //     Provide.value<OrderInfoAddReciverProvide>(context);
    final receiverAddressProvide =
        Provide.value<ReceiverAddressProvide>(context);
    // final uploadOrderProvide = Provide.value<UploadOrderProvide>(context);
    // var goodInfo = Provide.value<DetailGoodInfoProvide>(context)
    //     .goodDetailModel
    //     .dataList[0];
    return Container(
        padding: EdgeInsets.only(
            left: 80 * rpx, right: 0, top: 15 * rpx, bottom: 40 * rpx),
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
                      _checkReceiverInfos(receiverAddressProvide);

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

  _checkReceiverInfos(receiverAddressProvide) {
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
        remindContent = '请填写第' + receiver + "收件人省份区域信息";
        alertLeftPadding = 100.00;
        break;
      }
      if (identifyAddressModel.phonenum.isEmpty) {
        validReceiverInfo = false;
        remindContent = '请填写第' + receiver + "收件人联系方式";
        alertLeftPadding = 120.00;
        break;
      }
      if (identifyAddressModel.person.isEmpty) {
        validReceiverInfo = false;
        remindContent = '请填写第' + receiver + "收件人信息";
        alertLeftPadding = 140.00;
        break;
      }
      if (identifyAddressModel.detail.isEmpty) {
        validReceiverInfo = false;
        remindContent = '请填写第' + receiver + "收件人详细地址";
        alertLeftPadding = 120.00;
        break;
      }
    }
  }
}
