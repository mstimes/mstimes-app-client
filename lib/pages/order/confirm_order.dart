import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mstimes/common/constant.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/local_share/account_info.dart';
import 'package:mstimes/model/local_share/order_info.dart';
import 'package:mstimes/model/m_beans.dart';
import 'package:mstimes/provide/order_info_add.dart';
import 'package:mstimes/provide/reveiver_address_provide.dart';
import 'package:mstimes/provide/select_discount.dart';
import 'package:mstimes/provide/upload_order_provide.dart';
import 'package:mstimes/tools/common_container.dart';
import 'package:mstimes/utils/color_util.dart';
import 'package:provider/provider.dart';
import 'coupon_select.dart';
import 'package:mstimes/model/good_details.dart';
import 'dart:io';


class ConfirmOrderPage extends StatefulWidget {
  const ConfirmOrderPage({Key key}) : super(key: key);

  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  ScrollController controller = ScrollController();
  int totalOrderPrice = 0;
  Map receiverSelectDataTmp = Map();
  List<Map> _userCouponList = new List();
  int enableCheckBoxIndex = 0;
  MBeans mbeansSummary = new MBeans();
  int canUseBeanCounts = 0;
  int beanToMoneyAmount = 0;
  bool selectUseBeans = false;
  double rpx;

  @override
  void initState() {
    super.initState();

    // getGoodInfosById(widget.goodId, context);
    _getUserCouponRecords();
    _getMBeansSummary(UserInfo.getUserInfo().userNumber);
  }

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
          title: Text(
            '确认订单',
            style: TextStyle(
                fontSize: 30 * rpx,
                color: Colors.white,
                fontWeight: FontWeight.w400),
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

  void _getUserCouponRecords() {
    FormData formData = new FormData.fromMap({
      "userNumber": UserInfo.getUserInfo().userNumber,
      "status": 1,
      "pageNum": 0,
      "pageSize": 50
    });

    requestDataByUrl('queryUserCoupons', formData: formData).then((val) {
      var data = json.decode(val.toString());
      print("queryUserCoupons list : " + data.toString());

      List<Map> userCouponList = (data['dataList'] as List).cast();
      setState(() {
        _userCouponList.addAll(userCouponList);
      });
    });
  }

  List<Widget> showOrderInfos() {
    DataList goodInfo = LocalOrderInfo.getLocalOrderInfo().goodInfo;
    // DataList goodInfo = context.read<SelectedGoodInfoProvide>().goodInfo;
    List<Widget> orderInfoTotalList = List();
    // 商品信息头
    orderInfoTotalList.add(buildOrderInfoTop(goodInfo));

    // final receiverAddressProvide =
    //     Provide.value<ReceiverAddressProvide>(context);
    // final orderInfoAddReciverProvide =
    //     Provide.value<OrderInfoAddReciverProvide>(context);

    final receiverAddressProvide = context.read<ReceiverAddressProvide>();
    final orderInfoAddReciverProvide = context.read<OrderInfoAddReciverProvide>();

    receiverAddressProvide.identifyAddressMap.forEach((key, value) {
      receiverSelectDataTmp['receiverPrice'] = 0;
      receiverSelectDataTmp['selectNums'] = 0;

      List<Widget> receiverOrderInfoList = List();
      int receiverIndex = int.parse(key.toString());
      Map selectTypeNums =
          orderInfoAddReciverProvide.receiverOrderInfos[receiverIndex - 1];

      getReceiverAddressColumn(receiverOrderInfoList, value);

      receiverSelectDataTmp = getSelectTypesColumn(
          goodInfo, receiverOrderInfoList, selectTypeNums, receiverSelectDataTmp);

      receiverSelectDataTmp =
          getCouponDiscountRow(receiverOrderInfoList, receiverSelectDataTmp);

      receiverSelectDataTmp =
          getBeansDiscountRow(receiverOrderInfoList, receiverSelectDataTmp);

      int receiverPrice = receiverSelectDataTmp['receiverPrice'];
      getReceiverSumPriceContainer(receiverOrderInfoList, receiverPrice);
      totalOrderPrice = receiverPrice;

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

  Map getCouponDiscountRow(list, receiverSelectDataTmp){
    // int receiverPrice = receiverSelectDataTmp['receiverPrice'];

      list.add(Container(
        margin: EdgeInsets.only(left: 20 * rpx, top: 10 * rpx),
        decoration: new BoxDecoration(
          color: Colors.white,
          border: new Border.all(width: 1, color: Colors.white),
        ),
        child: Row(
          children: [
            Container(
              child: Text('优惠券', style: TextStyle(fontSize: 25 * rpx, fontWeight: FontWeight.w500),),
            ),
            Expanded(child: Container()),
            getCouponList(),
          ],
        ),
      ));


    return receiverSelectDataTmp;
  }

  Widget getCouponList(){
    // return Provide<SelectDiscountProvide>(builder: (context, child, counter) {
    var counter = context.watch<SelectDiscountProvide>();
      return InkWell(
        onTap: (){
          if(_userCouponList.length > 0){
            _showCouponItems(context);
          }
        },
        child: Row(
          children: [
            Container(
              child: Text(counter.selectedCoupon == null ? _userCouponList.length.toString() + '张优惠券可用' : '优惠券抵扣 ' + counter.selectedCoupon['discountCoupon'].toString() + ' 元',
                style: TextStyle(fontSize: 25 * rpx, color: Colors.grey[500], fontWeight: FontWeight.w400),),
            ),
            Container(
              child: Icon(
                Icons.arrow_right_sharp,
                color: Colors.grey[500],
              ),
            )
          ],
        ),
      );
    // });
  }

  Map getBeansDiscountRow(list, receiverSelectDataTmp) {
    int receiverPrice = receiverSelectDataTmp['receiverPrice'];
    int halfTotalPrice = (receiverPrice / 2).toInt();
    if(beanToMoneyAmount > halfTotalPrice){
      beanToMoneyAmount = halfTotalPrice;
      canUseBeanCounts = beanToMoneyAmount * moneyToMBeansRatio;
    }

    list.add(Container(
      margin: EdgeInsets.only(left: 20 * rpx, top: 20 * rpx),
      decoration: new BoxDecoration(
        color: Colors.white,
        border: new Border.all(width: 1, color: Colors.white),
      ),
      child: InkWell(
        onTap: (){
          if(canUseBeanCounts < moneyToMBeansRatio){
            return;
          }
          setState(() {
            if(selectUseBeans){
              selectUseBeans = false;
            }else{
              selectUseBeans = true;
            }

          });
        },
        child: Row(
          children: [
            Container(
              child: Text('蜜豆抵现', style: TextStyle(fontSize: 25 * rpx, fontWeight: FontWeight.w500)),
            ),
            Expanded(child: Container()),
            Container(
              child: Text(
                  canUseBeanCounts < moneyToMBeansRatio ?
                  '共' + canUseBeanCounts.toString() + ' , 满' + moneyToMBeansRatio.toString() + '个可用'
                      : '最多可用' + canUseBeanCounts.toString() + '个蜜豆抵扣' + beanToMoneyAmount.toString() + '元',
                  style: TextStyle(fontSize: 25 * rpx, color: Colors.grey[500], fontWeight: FontWeight.w400)),
            ),
            _buildSelectBeans()
          ],
        ),
      ),
    ));

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

  Map getSelectTypesColumn(goodInfo, list, infos, receiverSelectDataTmp) {
    // var goodInfo = Provide.value<DetailGoodInfoProvide>(context)
    //     .goodDetailModel
    //     .dataList[0];
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

        // totalOrderPrice += sumPrice;
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
      margin: EdgeInsets.only(
          left: 10 * rpx, right: 10 * rpx, top: 30 * rpx, bottom: 10 * rpx),
      child: calculateTotalPrice(receiverPrice),
    ));
  }

  Widget calculateTotalPrice(receiverPrice){
    // return Provide<SelectDiscountProvide>(builder: (context, child, counter) {
    var counter = context.watch<SelectDiscountProvide>();
      int totalCouponDiscount = 0;
      if(counter.selectedCoupon != null){
        totalCouponDiscount =  int.parse(counter.selectedCoupon['discountCoupon']);
      }

      int totalBeansDiscount = 0;
      int totalBeansToMoneyAmount = 0;
      if(selectUseBeans){
        totalBeansDiscount = canUseBeanCounts;
        totalBeansToMoneyAmount = beanToMoneyAmount;
      }

      return Row(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10 * rpx, top: 10 * rpx),
                  child: Text(
                    '小计：￥' + (receiverPrice - totalCouponDiscount - totalBeansToMoneyAmount).toString() + '.00',
                    style: TextStyle(fontSize: 23 * rpx),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10 * rpx, left: 10 * rpx, bottom: 10 * rpx),
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
            child: Text('￥' + (receiverPrice - totalCouponDiscount - totalBeansToMoneyAmount).toString() + '.00'),
          )
        ],
      );
    // });
  }

  Widget buildOrderInfoTop(goodInfo) {
    // var goodInfo = Provide.value<DetailGoodInfoProvide>(context)
    //     .goodDetailModel
    //     .dataList[0];
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
    // final receiverAddressProvide =
    //     Provide.value<ReceiverAddressProvide>(context);

    final orderInfoAddReciverProvide = context.read<OrderInfoAddReciverProvide>();
    final receiverAddressProvide = context.read<ReceiverAddressProvide>();

    // final uploadOrderProvide = Provide.value<UploadOrderProvide>(context);
    // var goodInfo = Provide.value<DetailGoodInfoProvide>(context)
    //     .goodDetailModel
    //     .dataList[0];
    DataList goodInfo = LocalOrderInfo.getLocalOrderInfo().goodInfo;
    // DataList goodInfo = context.read<SelectedGoodInfoProvide>().goodInfo;
    var counter = context.watch<SelectDiscountProvide>();
    // return Provide<SelectDiscountProvide>(builder: (context, child, counter) {
      int totalCouponDiscount = 0;
      if(counter.selectedCoupon != null){
        totalCouponDiscount = int.parse(counter.selectedCoupon['discountCoupon']);
      }

      int totalBeansDiscount = 0;
      int totalBeansToMoneyAmount = 0;
      if(selectUseBeans){
        totalBeansDiscount = canUseBeanCounts;
        totalBeansToMoneyAmount = beanToMoneyAmount;
      }

      return Container(
          padding: EdgeInsets.only(
              left: 50 * rpx, right: 40 * rpx, top: 15 * rpx, bottom: Platform.isIOS ? 30 * rpx * rpx : 3 * rpx),
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
                            (totalOrderPrice - totalCouponDiscount - totalBeansToMoneyAmount).toString(),
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
                        int totalBeansDiscount = 0;
                        if(selectUseBeans){
                          totalBeansDiscount = canUseBeanCounts;
                        }

                        // final selectDiscountProvide =
                        // Provide.value<SelectDiscountProvide>(context);

                        final selectDiscountProvide = context.read<SelectDiscountProvide>();

                        var couponCode = '';
                        if(selectDiscountProvide.selectedCoupon != null){
                          couponCode = selectDiscountProvide.selectedCoupon['couponCode'].toString();
                        }

                        UserInfo acc = UserInfo.getUserInfo();
                        FormData formData = FormData.fromMap({
                          "userNumber": acc.userNumber,
                          "goodId": goodInfo.goodId,
                          "couponCode": couponCode,
                          "mbeanCounts": totalBeansDiscount,
                          "classifyAndSpecifics": orderInfoAddReciverProvide
                              .receiverOrderInfos
                              .toString(),
                          "receiverAddress": jsonEncode(
                              receiverAddressProvide.identifyAddressMap)
                        });
                        context.read<UploadOrderProvide>().postUploadGoodInfos(
                            formData,
                            goodInfo.title,
                            (totalOrderPrice - totalCouponDiscount - totalBeansToMoneyAmount).toString(),
                            context,
                            rpx);

                        orderInfoAddReciverProvide.clear();
                        receiverAddressProvide.clear();
                        LocalOrderInfo.getLocalOrderInfo().clear();
                      },
                      child: buildSingleSummitButton('立即支付', 280, 90, 10, rpx))
                ],
              ),
            ],
          ));
    // });
  }

  _buildSelectBeans(){
    if(selectUseBeans){
      return Container(
        margin: EdgeInsets.only(left: 10 * rpx, right: 10 * rpx),
        child: ClipOval(
            child: Image.asset(
              "lib/images/circle_right.png",
              height: 25 * rpx,
              width: 25 * rpx,
            )
        ),
      );
    }else {
      return Container(
        margin: EdgeInsets.only(left: 10 * rpx, right: 10 * rpx),
        child: ClipOval(
            child: Image.asset(
              "lib/images/circle.png",
              height: 25 * rpx,
              width: 25 * rpx,
            )
        ),
      );
    }
  }

  _showCouponItems(context) {
    // final selectDiscountProvide =
    // Provide.value<SelectDiscountProvide>(context);

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(15)),
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return SizedBox(
            height: 600,
            child: Container(
                child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  child: CouponSelectItemPage(
                    couponList: _userCouponList,
                    selectedIndex: context.read<SelectDiscountProvide>().selectedIndex,
                  ),
                )),
          );
        });
  }

  void _getMBeansSummary(userNumber) {
    FormData formData = new FormData.fromMap({"userNumber": userNumber});

    requestDataByUrl('queryMBeans', formData: formData).then((val) {
      var data = json.decode(val.toString());

      setState(() {
        mbeansSummary = MBeans.fromJson(data);
        beanToMoneyAmount = (mbeansSummary.dataList[0].unusedCounts / moneyToMBeansRatio).toInt();
        canUseBeanCounts = beanToMoneyAmount * moneyToMBeansRatio;
        if(canUseBeanCounts >= moneyToMBeansRatio){
          selectUseBeans = true;
        }
      });
    });
  }

}
