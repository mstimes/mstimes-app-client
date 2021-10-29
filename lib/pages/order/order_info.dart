import 'package:flutter/material.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/local_share/account_info.dart';
import 'package:mstimes/model/local_share/order_info.dart';
import 'package:mstimes/tools/common_container.dart';
import 'package:mstimes/utils/color_util.dart';
import 'package:mstimes/model/good_details.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class OrderInfoPage extends StatefulWidget {
  const OrderInfoPage({Key key}) : super(key: key);

  @override
  _OrderInfoPageState createState() => _OrderInfoPageState();
}

class _OrderInfoPageState extends State<OrderInfoPage> {
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
            children: <Widget>[
              _buildUserAddressContainer(),
              _buildOrderInfoContainer(),
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

  Widget _buildUserAddressContainer(){
    return Container(
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        border: new Border.all(width: 1, color: Colors.white),
      ),
      padding: EdgeInsets.all(30 * rpx),
      margin: EdgeInsets.only(left: 20 * rpx, right: 20 * rpx, top: 50 * rpx, bottom: 10 * rpx),
      child: Row(
        children: [
          Text(' + 请填写收获地址', style: TextStyle(fontSize: 28 * rpx, fontWeight: FontWeight.w500),)
        ],
      ),
    );
  }

  Widget  _buildOrderInfoContainer(){
    return Container(
      margin: EdgeInsets.all(15 * rpx),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        border: new Border.all(width: 1, color: Colors.white),
      ),
      child: Column(
        children: [
          _showOrderInfo(),
          _buildDispatchWay(),
          _buildCouponDiscountRow(),
          _buildBriefSummary(),
        ],
      ),
    );
  }

  Widget _showOrderInfo(){
    Map orderInfoMap = LocalOrderInfo.getLocalOrderInfo().orderInfoMap;
    DataList goodInfo = LocalOrderInfo.getLocalOrderInfo().goodInfo;
    return Container(
      margin: EdgeInsets.only(top: 30 * rpx),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        border: new Border.all(width: 1, color: Colors.white),
      ),
      child: Row(
        children: [
          Container(
            height: 200 * rpx,
            width: 200 * rpx,
            margin: EdgeInsets.only(left: 12.0 * rpx, top: 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(
                      QINIU_OBJECT_STORAGE_URL + goodInfo.mainImage),
                  // fit: BoxFit.cover,
                )),
          ),
          Container(
              margin: EdgeInsets.only(left: 30 * rpx),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(goodInfo.title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 28 * rpx),),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5 * rpx),
                    child: Text('分类：' + orderInfoMap['selectedClassify'].toString(), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 23 * rpx),),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5 * rpx, bottom: 30 * rpx),
                    child: Text('规格：' + orderInfoMap['selectedSpecific'].toString(), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 23 * rpx)),
                  ),
                  Row(
                      children: [
                        Container(
                          child: Text('¥', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 23 * rpx)),
                        ),
                        Container(
                          child: Text(orderInfoMap['groupPrice'].toString(), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30 * rpx)),
                        ),
                        Container(
                          child: Text('/件', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 23 * rpx)),
                        ),
                        Container(
                            width: 60 * rpx,
                            margin: EdgeInsets.only(left: 260 * rpx),
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: 5 * rpx, bottom: 5 * rpx),
                            decoration: new BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              border: new Border.all(width: 1, color: Colors.white),
                            ),
                            child: Text('x ' + orderInfoMap['num'].toString(), style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20 * rpx))
                        )
                      ]
                  )
                ],
              )
          )
        ],
      ),
    );
  }

  Widget _buildDispatchWay(){
    return Container(
      margin: EdgeInsets.only(left: 40 * rpx, top: 40 * rpx, right: 40 * rpx),
      child: Row(
        children: [
          Container(
            child: Text('配送方式', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 23 * rpx)),
          ),
          Expanded(
            child: Container(),
          ),
          Container(
            child: Text('快递 免邮', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 23 * rpx)),
          )
        ],
      ),
    );
  }

  Widget _buildCouponDiscountRow(){
    return Container(
      margin: EdgeInsets.only(left: 40 * rpx, top: 20 * rpx, right: 10 * rpx),
      decoration: new BoxDecoration(
        color: Colors.white,
        border: new Border.all(width: 1, color: Colors.white),
      ),
      child: Row(
        children: [
          Container(
            child: Text('优惠券', style: TextStyle(fontSize: 23 * rpx, fontWeight: FontWeight.w500),),
          ),
          Expanded(child: Container()),
          getCouponList(),
        ],
      ),
    );
  }

  Widget getCouponList(){
    return InkWell(
      onTap: (){
        // if(_userCouponList.length > 0){
        //   _showCouponItems(context);
        // }
      },
      child: Row(
        children: [
          Container(
            child: Text('0张优惠券可用',
              style: TextStyle(fontSize: 23 * rpx, color: Colors.grey[500], fontWeight: FontWeight.w400),),
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
  }

  Widget _buildBriefSummary(){
    Map orderInfoMap = LocalOrderInfo.getLocalOrderInfo().orderInfoMap;
    int sumPrice = orderInfoMap['groupPrice'] * orderInfoMap['num'];

    return Container(
      alignment: Alignment.center,
      color: Colors.grey[200],
      margin: EdgeInsets.only(bottom: 30 * rpx, top: 30 * rpx, left: 10 * rpx, right: 10 * rpx),
      child: Container(
        padding: EdgeInsets.only(left: 30 * rpx, top: 30 * rpx, bottom: 30 * rpx, right: 30 * rpx),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20 * rpx),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text('小计 ¥ ' + sumPrice.toString() + ".00", style: TextStyle(fontSize: 23 * rpx, fontWeight: FontWeight.w400)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10 * rpx),
                    child: Text('邮费 ¥ 0.00', style: TextStyle(fontSize: 23 * rpx, fontWeight: FontWeight.w400)),
                  )
                ],
              ),
            ),
            Expanded(child: Container()),
            Container(
              margin: EdgeInsets.only(right: 20 * rpx),
              child: Text('¥ ' + sumPrice.toString() + '.00', style: TextStyle(fontSize: 28 * rpx, fontWeight: FontWeight.w400)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfoBottom() {
    DataList goodInfo = LocalOrderInfo.getLocalOrderInfo().goodInfo;
    Map orderInfoMap = LocalOrderInfo.getLocalOrderInfo().orderInfoMap;

    int sumPrice = orderInfoMap['groupPrice'] * orderInfoMap['num'];

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
                        sumPrice.toString(),
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
                        "couponCode": '',
                        "mbeanCounts": 0,
                      });
                      // context.read<UploadOrderProvide>().postUploadGoodInfos(
                      //     formData,
                      //     goodInfo.title,
                      //     (totalOrderPrice - totalCouponDiscount - totalBeansToMoneyAmount).toString(),
                      //     context,
                      //     rpx);

                      LocalOrderInfo.getLocalOrderInfo().clear();
                    },
                    child: buildSingleSummitButton('立即支付', 280, 90, 10, rpx))
              ],
            ),
          ],
        ));
    // });
  }
}
