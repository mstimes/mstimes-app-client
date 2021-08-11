import 'package:flutter/material.dart';
import 'package:mstimes/common/valid.dart';
import 'package:mstimes/model/good_details.dart';
import 'package:mstimes/order/product_select.dart';
import 'package:mstimes/provide/good_select_type.dart';
import 'package:mstimes/provide/order_info_add.dart';
import 'package:mstimes/provide/reveiver_address_provide.dart';
import 'package:mstimes/tools/common_container.dart';
import 'package:provide/provide.dart';
import 'package:mstimes/product/detail_goods/details_info.dart';
import 'package:mstimes/product/detail_goods/details_top.dart';
import 'package:mstimes/provide/detail_good_infos.dart';

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
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 30.0,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: _getGoodInfos(context),
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
              bottom: 30 * rpx,
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

    return Provide<DetailGoodInfoProvide>(builder: (context, child, val) {
      DataList goodInfo = Provide.value<DetailGoodInfoProvide>(context)
          .goodDetailModel
          .dataList[0];
      if (goodInfo != null) {
        return InkWell(
          onTap: () {
            final goodTypeBadgerProvide =
                Provide.value<GoodSelectBottomProvide>(context);
            final orderInfoAddReciverProvide =
                Provide.value<OrderInfoAddReciverProvide>(context);
            final receiverAddressProvide =
                Provide.value<ReceiverAddressProvide>(context);

            goodTypeBadgerProvide.clear();
            orderInfoAddReciverProvide.clear();
            receiverAddressProvide.clear();

            showBottomItems(goodInfo.goodId, context);
          },
          child: buildSingleSummitButton('立即下单', 600, 80, 10, rpx),
        );
      } else {
        return Text("商品详情信息不存在！");
      }
    });
  }

  Future _getGoodInfos(BuildContext context) async {
    return Provide.value<DetailGoodInfoProvide>(context)
        .getGoodInfosById(this.widget.goodId);
  }
}
