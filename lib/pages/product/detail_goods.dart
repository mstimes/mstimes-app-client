
import 'package:flutter/material.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/good_details.dart';
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
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {
            LocalOrderInfo.getLocalOrderInfo().clear();
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 30.0,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      // body: Stack(
      //   children: <Widget>[
      //     ListView(
      //       children: <Widget>[
      //         DetailsGoodTop(),
      //         DetailsGoodInfo(),
      //       ],
      //     ),
      //     Positioned(
      //       bottom: Platform.isIOS ? 30 * rpx : 3 * rpx,
      //       left: 70 * rpx,
      //       child: _buildOrderingContainer(),
      //     )
      //     // Positioned(bottom: 0, left: 0, child: DetailsGoodBottom())
      //   ],
      // )
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
          child: Text('商品详情加载中...'),
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
            // Positioned(bottom: 0, left: 0, child: DetailsGoodBottom())
          ],
        );
      }
    } else {
      return Container(
        alignment: Alignment.center,
        child: Text('商品详情加载中...'),
      );
    }
  }

  Widget _buildOrderingContainer() {
    if (this.widget.showPay == 'false') {
      return Container();
    }

    // DataList goodInfo = context.watch<SelectedGoodInfoProvide>().goodInfo;
    DataList goodInfo = LocalOrderInfo.getLocalOrderInfo().goodInfo;
    if (goodInfo != null) {
      return InkWell(
        onTap: () {
          // final goodTypeBadgerProvide =
          //     Provide.value<GoodSelectBottomProvide>(context);
          // final orderInfoAddReciverProvide =
          //     Provide.value<OrderInfoAddReciverProvide>(context);
          // final receiverAddressProvide =
          //     Provide.value<ReceiverAddressProvide>(context);
          //

          context.read<GoodSelectBottomProvide>().clear();
          context.read<OrderInfoAddReciverProvide>().clear();
          context.read<ReceiverAddressProvide>().clear();

          showBottomItems(widget.goodId, context, rpx);
        },
        child: buildSingleSummitButton('立即下单', 600, 80, 10, rpx),
      );
    } else {
      return Text("商品详情信息不存在！");
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
