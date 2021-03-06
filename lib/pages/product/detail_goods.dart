
import 'package:flutter/material.dart';
import 'package:mstimes/common/constant.dart';
import 'package:mstimes/common/valid.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/good_details.dart';
import 'package:mstimes/model/local_share/account_info.dart';
import 'package:mstimes/model/local_share/order_info.dart';
import 'package:mstimes/pages/order/product_select.dart';
import 'package:mstimes/provide/good_select_type.dart';
import 'package:mstimes/provide/order_info_add.dart';
import 'package:mstimes/provide/reveiver_address_provide.dart';
import 'package:mstimes/provide/select_good_provider.dart';
import 'package:mstimes/tools/common_container.dart';
import 'package:mstimes/pages/product/detail_goods/details_info.dart';
import 'package:mstimes/pages/product/detail_goods/details_top.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';

class DetailGoods extends StatefulWidget {
  final int goodId;
  final String showPay;
  DetailGoods(this.goodId, this.showPay);

  @override
  _DetailGoodsState createState() => _DetailGoodsState();
}

class _DetailGoodsState extends State<DetailGoods> {
  double rpx;

  @override
  void initState() {
    super.initState();
    _getGoodInfosById(widget.goodId);
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back_ios_outlined, size: 45 * rpx),
          onPressed: () {
            LocalOrderInfo.getLocalOrderInfo().clear();
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 70 * rpx,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: _getGoodInfosById(widget.goodId),
        builder: _buildFuture,
      ),
    );
  }

  Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        print('snapshot.error : ${snapshot.error}');
        return Container(
          alignment: Alignment.center,
          child: Text('?????????????????????...'),
        );
      } else {
        return Stack(
          children: <Widget>[
            // Positioned(top: 0, left: 0, child: DetailsGoodTop()),
            ListView(
              children: <Widget>[
                DetailsGoodTop(),
                DetailsGoodInfo(),
              ],
            ),
            Positioned(
              bottom: Platform.isIOS ? 30 * rpx : 3 * rpx,
              left: 70 * rpx,
              child: _buildOrderingContainer(),
            )
          ],
        );
      }
    } else {
      return Container(
        alignment: Alignment.center,
        child: Text('?????????????????????...'),
      );
    }
  }

  Widget _buildOrderingContainer() {
    if (this.widget.showPay == 'false') {
      return Container();
    }

    DataList goodInfo = LocalOrderInfo.getLocalOrderInfo().goodInfo;
    if (goodInfo != null) {
      return InkWell(
        onTap: () {
          if(!checkIsLogin(context)){
            print('4');
            return;
          }
          LocalOrderInfo.getLocalOrderInfo().getUsualAddressInfo();

          context.read<GoodSelectBottomProvide>().clear();
          context.read<OrderInfoAddReciverProvide>().clear();
          context.read<ReceiverAddressProvide>().clear();

          showBottomItems(goodInfo, context, rpx);
        },
        child: buildSingleSummitButton('????????????', 600, 80, 10, rpx),
      );
    } else {
      return Text("??????????????????????????????");
    }
  }

  Future _getGoodInfosById(int goodId) async {
    FormData formData = new FormData.fromMap({
      "goodId": goodId,
    });
    print("getGoodInfosById : " + goodId.toString());
    await requestDataByUrl('queryGoodById', formData: formData).then((val) {
      var data = json.decode(val.toString());
      print('queryGoodById ' + data.toString());
      GoodDetailModel goodDetailModel = GoodDetailModel.fromJson(data);
      LocalOrderInfo.getLocalOrderInfo().setGoodInfo(goodDetailModel.dataList[0]);
      return data;
    });
  }

}
