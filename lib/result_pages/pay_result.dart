import 'package:flutter/material.dart';
import 'package:mstimes/model/local_share/order_info.dart';

import '../routers/router_config.dart';

class PayResultPage extends StatelessWidget {
  int payResult = 1;
  PayResultPage(this.payResult);

  double rpx;

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        primary: true,
        elevation: 0,
        toolbarHeight: 80 * rpx,
        title: Text(
          '支付结果',
          style: TextStyle(
              fontSize: 30 * rpx,
              fontWeight: FontWeight.w400,
              color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Column(
            children: [
              this.payResult == 1
                  ? Container(
                      margin: EdgeInsets.only(top: 70 * rpx),
                      child: ClipOval(
                        child: Image.asset(
                          "lib/images/success.png",
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ))
                  : Container(
                      margin: EdgeInsets.only(top: 70 * rpx),
                      child: ClipOval(
                        child: Image.asset(
                          "lib/images/failed.png",
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              Container(
                margin: EdgeInsets.only(top: 20 * rpx, bottom: 30 * rpx),
                child: Text(
                  this.payResult == 1 ? '支付成功' : '支付失败',
                  style: TextStyle(
                      fontSize: 40 * rpx, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          Divider(
            color: Colors.grey[400],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 40 * rpx, top: 30 * rpx),
                child: Text(
                  '订单号：',
                  style: TextStyle(
                      fontSize: 30 * rpx, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(child: Container()),
              Container(
                margin: EdgeInsets.only(right: 40 * rpx, top: 30 * rpx),
                child: Text(
                  LocalOrderInfo.getLocalOrderInfo().orderNumber,
                  style: TextStyle(
                      fontSize: 30 * rpx, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 40 * rpx, top: 20 * rpx),
                child: Text(
                  '支付方式：',
                  style: TextStyle(
                      fontSize: 30 * rpx, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(child: Container()),
              Container(
                margin: EdgeInsets.only(right: 40 * rpx),
                child: Text(
                  '微信支付',
                  style: TextStyle(
                      fontSize: 30 * rpx, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 40 * rpx, top: 20 * rpx),
                child: Text(
                  '支付金额：',
                  style: TextStyle(
                      fontSize: 30 * rpx, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(child: Container()),
              Container(
                margin: EdgeInsets.only(right: 40 * rpx),
                child: Text(
                  '¥' + LocalOrderInfo.getLocalOrderInfo().totalFee + '.00',
                  style: TextStyle(
                      fontSize: 30 * rpx, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container(
              //   margin: EdgeInsets.only(
              //       left: 20 * rpx, right: 50 * rpx, top: 70 * rpx),
              //   height: 60 * rpx,
              //   width: 260 * rpx,
              //   color: Colors.red[900],
              //   child: OutlineButton(
              //       onPressed: () {
              //         RouterHome.flutoRouter
              //             .navigateTo(context, RouterConfig.groupGoodsPath);
              //       },
              //       child: Text('查看订单',
              //           style: TextStyle(
              //               fontSize: 25 * rpx, color: Colors.white))),
              // ),
              Container(
                margin: EdgeInsets.only(top: 70 * rpx),
                height: 60 * rpx,
                width: 260 * rpx,
                child: OutlineButton(
                    onPressed: () {
                      RouterHome.flutoRouter
                          .navigateTo(context, RouterConfig.groupGoodsPath);
                    },
                    child: Text('回到首页', style: TextStyle(fontSize: 25 * rpx))),
              ),
            ],
          )
        ],
      ),
    );
  }
}
