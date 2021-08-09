import 'package:flutter/material.dart';
import 'package:mstimes/provide/drawing_record_provide.dart';
import 'package:provide/provide.dart';

import '../routers/router_config.dart';

class DrawingResultPage extends StatelessWidget {
  DrawingResultPage();

  double rpx;

  @override
  Widget build(BuildContext context) {
    final drawingRecordProvide = Provide.value<DrawingRecordProvide>(context);
    Map drawingRecordInfo = drawingRecordProvide.getNewDrawingInfos();
    rpx = MediaQuery.of(context).size.width / 750;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        primary: true,
        elevation: 0,
        toolbarHeight: 80 * rpx,
        title: Text(
          '提交结果',
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
              Container(
                  margin: EdgeInsets.only(top: 70 * rpx),
                  child: ClipOval(
                    child: Image.asset(
                      "lib/images/success.png",
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  )),
              Container(
                margin: EdgeInsets.only(top: 20 * rpx, bottom: 30 * rpx),
                child: Text(
                  '提款申请已提交',
                  style: TextStyle(
                      fontSize: 35 * rpx, fontWeight: FontWeight.w500),
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
                  '提款金额：',
                  style: TextStyle(
                      fontSize: 30 * rpx, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(child: Container()),
              Container(
                margin: EdgeInsets.only(right: 40 * rpx, top: 30 * rpx),
                child: Text(
                  drawingRecordInfo['amount'] + ' 元',
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
                  '支付类型：',
                  style: TextStyle(
                      fontSize: 30 * rpx, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(child: Container()),
              Container(
                margin: EdgeInsets.only(right: 40 * rpx),
                child: Text(
                  '银行转账',
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
                  '提款人姓名：',
                  style: TextStyle(
                      fontSize: 30 * rpx, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(child: Container()),
              Container(
                margin: EdgeInsets.only(right: 40 * rpx),
                child: Text(
                  drawingRecordInfo['userName'],
                  style: TextStyle(
                      fontSize: 28 * rpx, fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 40 * rpx, top: 20 * rpx),
                child: Text(
                  '身份证：',
                  style: TextStyle(
                      fontSize: 30 * rpx, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(child: Container()),
              Container(
                margin: EdgeInsets.only(right: 40 * rpx),
                child: Text(
                  drawingRecordInfo['identityCard'],
                  style: TextStyle(
                      fontSize: 28 * rpx, fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 40 * rpx, top: 20 * rpx),
                child: Text(
                  '银行卡号：',
                  style: TextStyle(
                      fontSize: 30 * rpx, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(child: Container()),
              Container(
                margin: EdgeInsets.only(right: 40 * rpx),
                child: Text(
                  drawingRecordInfo['bankNumber'],
                  style: TextStyle(
                      fontSize: 28 * rpx, fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 40 * rpx, top: 20 * rpx),
                child: Text(
                  '银行卡类型：',
                  style: TextStyle(
                      fontSize: 30 * rpx, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(child: Container()),
              Container(
                margin: EdgeInsets.only(right: 40 * rpx),
                child: Text(
                  drawingRecordInfo['bankType'],
                  style: TextStyle(
                      fontSize: 28 * rpx, fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 40 * rpx, top: 20 * rpx),
                child: Text(
                  '开户地区：',
                  style: TextStyle(
                      fontSize: 30 * rpx, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(child: Container()),
              Container(
                margin: EdgeInsets.only(right: 40 * rpx),
                child: Text(
                  drawingRecordInfo['depositRegion'],
                  style: TextStyle(
                      fontSize: 28 * rpx, fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 40 * rpx, top: 20 * rpx),
                child: Text(
                  '开户行：',
                  style: TextStyle(
                      fontSize: 30 * rpx, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(child: Container()),
              Container(
                margin: EdgeInsets.only(right: 40 * rpx),
                child: Text(
                  drawingRecordInfo['depositBank'],
                  style: TextStyle(
                      fontSize: 28 * rpx, fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                    left: 20 * rpx, right: 50 * rpx, top: 70 * rpx),
                height: 60 * rpx,
                width: 260 * rpx,
                color: Colors.red[900],
                child: OutlineButton(
                    onPressed: () {
                      RouterHome.flutoRouter
                          .navigateTo(context, RouterConfig.groupGoodsPath);
                    },
                    child: Text('查看已提交记录',
                        style: TextStyle(
                            fontSize: 25 * rpx, color: Colors.white))),
              ),
              Container(
                margin: EdgeInsets.only(top: 70 * rpx),
                height: 60 * rpx,
                width: 260 * rpx,
                child: OutlineButton(
                    onPressed: () {
                      RouterHome.flutoRouter
                          .navigateTo(context, RouterConfig.myPagePath);
                    },
                    child:
                        Text('回到个人中心', style: TextStyle(fontSize: 25 * rpx))),
              ),
            ],
          )
        ],
      ),
    );
  }
}
