import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/local_share/account_info.dart';
import 'package:mstimes/provide/detail_good_infos.dart';
import 'package:mstimes/provide/order_info_add.dart';
import 'package:mstimes/provide/reveiver_address_provide.dart';
import 'package:mstimes/provide/upload_order_provide.dart';
import 'package:mstimes/tools/common_container.dart';
import 'package:mstimes/utils/color_util.dart';
import 'package:provide/provide.dart';

class ConfirmOrderPage extends StatefulWidget {
  const ConfirmOrderPage({Key key}) : super(key: key);

  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  int totalOrderPrice = 0;
  Map receiverSelectDataTmp = Map();
  double rpx;

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: mainColor,
          leading: Container(
            child: IconButton(
                onPressed: () {
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
                  '确认订单',
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
          ListView(
            children: showOrderInfos(),
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

  List<Widget> showOrderInfos() {
    List<Widget> orderInfoTotalList = List();
    // 商品信息头
    orderInfoTotalList.add(buildOrderInfoTop());

    final receiverAddressProvide =
        Provide.value<ReceiverAddressProvide>(context);
    final orderInfoAddReciverProvide =
        Provide.value<OrderInfoAddReciverProvide>(context);

    receiverAddressProvide.identifyAddressMap.forEach((key, value) {
      receiverSelectDataTmp['receiverPrice'] = 0;
      receiverSelectDataTmp['selectNums'] = 0;

      List<Widget> receiverOrderInfoList = List();
      int receiverIndex = int.parse(key.toString());
      Map selectTypeNums =
          orderInfoAddReciverProvide.receiverOrderInfos[receiverIndex - 1];

      getReceiverAddressColumn(receiverOrderInfoList, value);

      receiverSelectDataTmp = getSelectTypesColumn(
          receiverOrderInfoList, selectTypeNums, receiverSelectDataTmp);

      // receiverSelectDataTmp =
      //     getBonusRow(receiverOrderInfoList, receiverSelectDataTmp);

      int receiverPrice = receiverSelectDataTmp['receiverPrice'];
      getReceiverSumPriceContainer(receiverOrderInfoList, receiverPrice);

      orderInfoTotalList.add(Container(
        margin: EdgeInsets.only(left: 10 * rpx, right: 10 * rpx),
        decoration: new BoxDecoration(
          color: Colors.white,
          border: new Border.all(width: 1, color: Colors.white),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: receiverOrderInfoList,
        ),
      ));
    });
    return orderInfoTotalList;
  }

  Map getBonusRow(list, receiverSelectDataTmp) {
    var goodInfo = Provide.value<DetailGoodInfoProvide>(context)
        .goodDetailModel
        .dataList[0];

    int receiverPrice = receiverSelectDataTmp['receiverPrice'];
    int selectNums = receiverSelectDataTmp['selectNums'];

    // list.add(Container(
    //   decoration: new BoxDecoration(
    //     color: Colors.white,
    //     border: new Border.all(width: 1, color: Colors.white),
    //   ),
    //   margin:
    //       EdgeInsets.only(left: 20 * rpx, right: 20 * rpx, bottom: 10 * rpx),
    //   child: Row(
    //     children: [
    //       Container(
    //           child: Text(
    //         '优惠减免',
    //         style: TextStyle(fontSize: 23 * rpx, fontWeight: FontWeight.w700),
    //       )),
    //       Expanded(child: Container()),
    //       Container(
    //         child: Text('-' + (goodInfo.bonus * selectNums).toString() + '.00',
    //             style: TextStyle(fontSize: 23 * rpx)),
    //       )
    //     ],
    //   ),
    // ));

    // receiverPrice -= goodInfo.bonus * selectNums;
    receiverSelectDataTmp['receiverPrice'] = receiverPrice;

    // totalOrderPrice -= goodInfo.bonus * selectNums;
    return receiverSelectDataTmp;
  }

  List<Widget> getReceiverAddressColumn(list, value) {
    list.add(Divider(thickness: 8 * rpx, color: Colors.black));
    list.add(Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        border: new Border.all(width: 1, color: Colors.white),
      ),
      margin: EdgeInsets.only(left: 20 * rpx, right: 20 * rpx),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  child: Text(
                value.person,
                style: TextStyle(fontSize: 30 * rpx),
              )),
              Expanded(child: Container()),
              Container(
                  child: Text(value.phonenum,
                      style: TextStyle(fontSize: 30 * rpx))),
            ],
          ),
        ],
      ),
    ));
    list.add(
      Container(
        margin: EdgeInsets.only(top: 20 * rpx, left: 10 * rpx),
        child: Container(
          child: Text(value.province +
              " " +
              value.city +
              " " +
              value.town +
              " " +
              value.detail),
        ),
      ),
    );
    list.add(Divider(
      color: Colors.grey[300],
    ));

    return list;
  }

  Map getSelectTypesColumn(list, infos, receiverSelectDataTmp) {
    var goodInfo = Provide.value<DetailGoodInfoProvide>(context)
        .goodDetailModel
        .dataList[0];
    List<dynamic> categories = jsonDecode(goodInfo.categories);
    List<dynamic> specifics = jsonDecode(goodInfo.specifics);

    int receiverPrice = receiverSelectDataTmp['receiverPrice'];
    int selectNums = receiverSelectDataTmp['selectNums'];

    print('getSelectTypesColumn infos ' + infos.toString());
    infos.keys.forEach((typeIndex) {
      infos[typeIndex].keys.forEach((specIndex) {
        print('typeIndex , specIndex' +
            typeIndex.toString() +
            "  " +
            specIndex.toString());

        int sumPrice = goodInfo.groupPrice * infos[typeIndex][specIndex];

        totalOrderPrice += sumPrice;
        receiverPrice += sumPrice;
        selectNums += infos[typeIndex][specIndex];

        list.add(Container(
            decoration: new BoxDecoration(
              color: Colors.white,
              border: new Border.all(width: 1, color: Colors.white),
            ),
            margin: EdgeInsets.only(left: 20 * rpx, right: 20 * rpx),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Container(
                      child: Text(
                        categories[typeIndex - 1] + ' ' + specifics[specIndex],
                        style: TextStyle(fontSize: 26 * rpx),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      child: Text(
                        '￥' + sumPrice.toString() + '.00',
                        style: TextStyle(fontSize: 23 * rpx),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 8 * rpx),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Text(
                          '￥' +
                              goodInfo.groupPrice.toString() +
                              '.00' +
                              '/件 包邮',
                          style: TextStyle(fontSize: 23 * rpx),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        child:
                            Text('x' + infos[typeIndex][specIndex].toString()),
                      )
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey[200],
                )
              ],
            )));
      });
    });

    receiverSelectDataTmp['receiverPrice'] = receiverPrice;
    receiverSelectDataTmp['selectNums'] = selectNums;
    return receiverSelectDataTmp;
  }

  getReceiverSumPriceContainer(list, receiverPrice) {
    list.add(Container(
      decoration: new BoxDecoration(
        color: Colors.grey[200],
        border: new Border.all(width: 1, color: Colors.white),
      ),
      padding: EdgeInsets.only(
          left: 10 * rpx, right: 10 * rpx, top: 5 * rpx, bottom: 5 * rpx),
      child: Row(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10 * rpx),
                  child: Text(
                    '小计：￥' + receiverPrice.toString() + '.00',
                    style: TextStyle(fontSize: 23 * rpx),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10 * rpx, left: 10 * rpx),
                  child: Text(
                    '运费：￥0.00',
                    style: TextStyle(fontSize: 23 * rpx),
                  ),
                )
              ],
            ),
          ),
          Expanded(child: Container()),
          Container(
            margin: EdgeInsets.only(right: 15 * rpx),
            child: Text('￥' + receiverPrice.toString() + '.00'),
          )
        ],
      ),
    ));
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
    final orderInfoAddReciverProvide =
        Provide.value<OrderInfoAddReciverProvide>(context);
    final receiverAddressProvide =
        Provide.value<ReceiverAddressProvide>(context);
    final uploadOrderProvide = Provide.value<UploadOrderProvide>(context);
    var goodInfo = Provide.value<DetailGoodInfoProvide>(context)
        .goodDetailModel
        .dataList[0];
    return Container(
        padding: EdgeInsets.only(
            left: 50 * rpx, right: 40 * rpx, top: 15 * rpx, bottom: 40 * rpx),
        width: 750 * rpx,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Row(
                    children: [
                      Text(
                        '总计金额：￥',
                        style: TextStyle(
                            fontSize: 26 * rpx, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        totalOrderPrice.toString(),
                        style: TextStyle(
                            fontSize: 36 * rpx, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '.00',
                        style: TextStyle(
                            fontSize: 26 * rpx, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                Expanded(child: Container()),
                InkWell(
                    onTap: () {
                      UserInfo acc = UserInfo.getUserInfo();
                      FormData formData = FormData.fromMap({
                        "userNumber": acc.userNumber,
                        "goodId": goodInfo.goodId,
                        "classifyAndSpecifics": orderInfoAddReciverProvide
                            .receiverOrderInfos
                            .toString(),
                        "receiverAddress": jsonEncode(
                            receiverAddressProvide.identifyAddressMap)
                      });
                      uploadOrderProvide.postUploadGoodInfos(
                          formData,
                          goodInfo.title,
                          totalOrderPrice.toString(),
                          context,
                          rpx);

                      orderInfoAddReciverProvide.clear();
                      receiverAddressProvide.clear();
                    },
                    child: buildSingleSummitButton('立即支付', 280, 90, 10, rpx))
              ],
            ),
          ],
        ));
  }
}
