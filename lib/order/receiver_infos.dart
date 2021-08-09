import 'package:flutter/material.dart';
import 'package:mstimes/common/valid.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/identify_address.dart';
import 'package:mstimes/provide/detail_good_infos.dart';
import 'package:mstimes/provide/reveiver_address_provide.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:mstimes/tools/common_container.dart';
import 'package:provide/provide.dart';
import 'package:mstimes/order/receiver_widgets/receiver_address.dart';
import 'package:mstimes/order/receiver_widgets/receiver_select.dart';
import 'package:mstimes/provide/good_select_type.dart';
import 'package:mstimes/provide/order_info_add.dart';
import 'package:mstimes/utils/color_util.dart';

class OrderInfos extends StatefulWidget {
  int deleteIndex = -1;
  ScrollController controller;
  OrderInfos({Key key, this.deleteIndex, this.controller}) : super(key: key);

  @override
  OrderInfosState createState() => OrderInfosState();
}

class OrderInfosState extends State<OrderInfos> {
  ScrollController _controller = new ScrollController();
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
  double alertLeftPadding;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    final orderInfoAddReciverProvide =
        Provide.value<OrderInfoAddReciverProvide>(context);

    // print('_ReceiverInfosState build allReceivers.length : ' +
    //     allReceivers.length.toString());
    if (allReceivers.length < 1) {
      allReceivers.add(buildOrderInfoTop());
      // print('_ReceiverInfosState build orderInfoAddReciverProvide:' +
      //     orderInfoAddReciverProvide.receiverOrderInfos[currentReceiverNum - 1]
      // .toString());
      allReceivers.add(ReceiverAddress(index: currentReceiverNum));
      allReceivers.add(ReceiverSelectInfo(
        index: currentReceiverNum,
      ));
      allReceivers.add(_buildReceiverButton());
    }

    // print('ReceiverInfos build : ' +
    //     ", widget.deleteIndex : " +
    //     widget.deleteIndex.toString());
    if (allReceivers.length > 0 && widget.deleteIndex > 0) {
      // print('_ReceiverInfosState _deleteIndex : ' +
      //     widget.deleteIndex.toString());
      _deleteReceiverRefresh(widget.deleteIndex);
    } else {
      if (needAddReceiver) {
        // print('ReceiverInfos needAddReceiver : ' +
        //     needAddReceiver.toString() +
        //     ", allReceivers : " +
        //     allReceivers.toString());
        orderInfoAddReciverProvide.initAddReceiverOrderSelectInfo();

        final goodTypeBadgerProvide =
            Provide.value<GoodSelectBottomProvide>(context);
        goodTypeBadgerProvide.initValueByIndex(currentReceiverNum);

        allReceivers.add(ReceiverAddress(index: currentReceiverNum));
        allReceivers.add(ReceiverSelectInfo(index: currentReceiverNum));
        allReceivers.add(_buildReceiverButton());
        needAddReceiver = false;
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          backgroundColor: mainColor,
          primary: true,
          elevation: 0,
          leading: Container(
            child: IconButton(
                onPressed: () {
                  final goodTypeBadgerProvide =
                      Provide.value<GoodSelectBottomProvide>(context);
                  goodTypeBadgerProvide.setFromOrderInfo(false);
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
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          )),
      body: Stack(
        children: [
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding:
                  EdgeInsets.only(left: 5 * rpx, right: 5 * rpx, top: 10 * rpx),
              itemCount: currentReceiverNum * 2 + 2,
              itemBuilder: _itemBuilder),
          Expanded(child: Container()),
          Positioned(
            bottom: 0,
            left: 0,
            child: _buildOrderInfoBottom(),
          )
        ],
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return allReceivers[index];
  }

  void _deleteReceiverRefresh(int deleteIndex) {
    final orderInfoAddReciverProvide =
        Provide.value<OrderInfoAddReciverProvide>(context);
    // print('_deleteReceiverRefresh allReceivers : ' + allReceivers.toString());
    // print('_deleteReceiverRefresh deleteIndex : ' + deleteIndex.toString());
    setState(() {
      deleteIndexSet.add(deleteIndex);
      for (int i = 0; i < deleteIndex; i++) {
        // 兼容ReceiverAddress和ReceiverSelectInfo中收件人编号不变的情况
        if (deleteIndexSet.contains(i)) {
          deleteIndex--;
        }
      }
      allReceivers.removeAt(2 * deleteIndex - 1);
      allReceivers.removeAt(2 * deleteIndex - 2);
      widget.deleteIndex = -1;
      orderInfoAddReciverProvide.resetDeleteIndex(-1);
      currentReceiverNum--;
    });
  }

  Widget _buildReceiverButton() {
    return Container(
      margin: EdgeInsets.only(top: 10.0 * rpx, bottom: 180 * rpx),
      width: 130 * rpx,
      height: 60 * rpx,
      color: Colors.white,
      child: Container(
        child: OutlineButton(
            borderSide: new BorderSide(color: buttonColor),
            onPressed: () {
              setState(() {
                this.needAddReceiver = true;
                currentReceiverNum++;
                print('_buildReceiverButton , allReceivers : ' +
                    allReceivers.toString() +
                    ", length : " +
                    allReceivers.length.toString());
                allReceivers.removeLast();
              });
            },
            child: Text(
              '添加新收件人',
              style: TextStyle(color: buttonColor, fontSize: 14.0),
            )),
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
    var goodInfo = Provide.value<DetailGoodInfoProvide>(context)
        .goodDetailModel
        .dataList[0];
    return Container(
        child: Container(
      width: 730 * rpx,
      height: 220 * rpx,
      margin: EdgeInsets.only(
          left: 0 * rpx, top: 0 * rpx, right: 0 * rpx, bottom: 10 * rpx),
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
