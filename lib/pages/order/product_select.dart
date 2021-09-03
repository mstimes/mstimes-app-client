import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mstimes/common/provider_call.dart';
import 'package:mstimes/model/local_share/order_info.dart';
import 'package:mstimes/provide/reveiver_address_provide.dart';
import 'package:provide/provide.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/pages/order/product_select_bottom.dart';
import 'package:mstimes/provide/good_select_type.dart';
import 'package:mstimes/provide/order_info_add.dart';
import 'package:mstimes/tools/number_change.dart';
import 'package:mstimes/utils/color_util.dart';
import 'package:mstimes/model/good_details.dart';
import 'dart:io';

class ProductSelectItemPage extends StatefulWidget {
  final int goodId;
  const ProductSelectItemPage({Key key, this.pCtx, @required this.goodId})
      : super(key: key);
  final BuildContext pCtx;

  @override
  _ProductSelectItemPageState createState() => _ProductSelectItemPageState();
}

class _ProductSelectItemPageState extends State<ProductSelectItemPage> {
  ScrollController controller = ScrollController();
  String typeName = '种类';
  String specification = '规格';
  int typeValue = 1;
  double rpx;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;

    print('product_select ... ' + widget.goodId.toString());
    return FutureBuilder(
        future: getGoodInfosById(widget.goodId, context),
        builder: _buildFuture);
  }

  Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('Not beginning to connect network.');
      case ConnectionState.active:
        return Text('ConnectionState is active.');
      case ConnectionState.waiting:
        return Center(
            child: Positioned(
                left: 150.0,
                top: 170.0,
                child: CircularProgressIndicator(
                  value: 0.3,
                  valueColor: new AlwaysStoppedAnimation<Color>(buttonColor),
                )));
      case ConnectionState.done:
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        return _createItems(context, snapshot);
      default:
        return null;
    }
  }

  Widget _createItems(BuildContext context, AsyncSnapshot snapshot) {
    DataList goodInfo = LocalOrderInfo.getLocalOrderInfo().goodInfo;
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          controller: controller,
          child: Column(
            children: <Widget>[
              _buildTopRow(goodInfo, context),
              _showTypeTitle(),
              _buildGoodTypes(goodInfo),
              _showSpecificationTitle(),
              _buildSpecification(goodInfo, controller),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: GoodSelectBottom(goodId: widget.goodId),
        )
      ],
    );
  }

  Widget _showTypeTitle() {
    return Container(
      width: 730 * rpx,
      height: 60 * rpx,
      margin: EdgeInsets.only(left: 10.0, top: 10.0),
      child: Text(
        typeName,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 35 * rpx, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildGoodTypes(goodInfo) {
    // var goodInfo = Provide.value<DetailGoodInfoProvide>(context)
    //     .goodDetailModel
    //     .dataList[0];
    List<dynamic> categories = jsonDecode(goodInfo.categories);
    List<Widget> _listWidgets = List<Widget>();
    if (categories.length != 0) {
      int index = 1;
      categories.forEach((val) {
        _listWidgets.add(_listItem(index++, val));
      });
    }

    return Wrap(
      runSpacing: 20,
      children: _listWidgets,
    );
  }

  Widget _buildTypeButton(bool select, int index, String value) {
    return Provide<GoodSelectBottomProvide>(
      builder: (context, child, counter) {
        // print(
        //     'counter.queryTypeValueMap().toString() : ${counter.queryTypeValueMap().toString()}');
        // print('${counter.queryTypeNumChangeMap().toString()}');

        Map typeValueMap = counter.queryTypeValueMap();
        if (select) {
          return Badge(
            badgeColor: Colors.black,
            showBadge: '${typeValueMap[index]}' != 'null',
            badgeContent: Container(
              child: Text(
                '${typeValueMap[index]}',
                style: TextStyle(color: Colors.white, fontSize: 11.0),
              ),
            ),
            child: OutlineButton(
              borderSide: new BorderSide(color: Colors.black),
              onPressed: () {
                updateTypeValue(index);
                counter.updateTypeIndex(index);
              },
              child: Text(value, style: TextStyle(color: Colors.black)),
            ),
          );
        } else {
          return Badge(
            badgeColor: Colors.black,
            showBadge: '${typeValueMap[index]}' != 'null',
            badgeContent: Container(
                child: Text(
              '${typeValueMap[index]}',
              style: TextStyle(color: Colors.white, fontSize: 11.0),
            )),
            child: OutlineButton(
              onPressed: () {
                counter.updateTypeIndex(index);
                updateTypeValue(index);
              },
              child: Text(
                value,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _listItem(index, value) {
    bool select = typeValue == index;
    return _buildTypeButton(select, index, value);
  }

  void updateTypeValue(int v) {
    setState(() {
      typeValue = v;
    });
  }

  Widget _showSpecificationTitle() {
    return Container(
      width: 730 * rpx,
      height: 60 * rpx,
      margin: EdgeInsets.only(left: 10.0, top: 20.0),
      child: Text(
        specification,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 35 * rpx, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSpecification(goodInfo, ScrollController controller) {
    // var goodInfo = Provide.value<DetailGoodInfoProvide>(context)
    //     .goodDetailModel
    //     .dataList[0];
    List<dynamic> specfications = jsonDecode(goodInfo.specifics);
    return SingleChildScrollView(
      controller: controller,
      child: Container(
        child: _genSpecificationList(specfications, controller),
      ),
    );
  }

  Widget _genSpecificationList(
      List<dynamic> specs, ScrollController controller) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(left: 10.0, top: 15.0),
      controller: controller,
      itemCount: specs.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Row(
            children: <Widget>[
              Container(
                  width: 200 * rpx,
                  height: 50 * rpx,
                  decoration: new BoxDecoration(
                    //背景
                    color: Colors.white,
                    //设置四周圆角 角度
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    //设置四周边框
                    border: new Border.all(width: 1, color: Colors.grey),
                  ),
                  child: Container(
                      child: Center(
                    child: Text(
                      specs[index].toString(),
                      style: TextStyle(fontSize: 28 * rpx),
                    ),
                  ))),
              Expanded(
                child: Container(),
              ),
              _showNumChangeContainer(index)
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopRow(goodInfo, context) {
    // var goodInfo = Provide.value<DetailGoodInfoProvide>(context)
    //     .goodDetailModel
    //     .dataList[0];
    return Row(
      children: [
        Container(
          height: 200 * rpx,
          width: 200 * rpx,
          margin: EdgeInsets.only(left: 3 * rpx, top: 3 * rpx),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image:
                    NetworkImage(QINIU_OBJECT_STORAGE_URL + goodInfo.mainImage),
                fit: BoxFit.cover,
              )),
        ),
        Container(
            height: 200 * rpx,
            margin: EdgeInsets.only(left: 20 * rpx),
            padding: EdgeInsets.only(top: 110.0 * rpx),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 5 * rpx),
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '¥${goodInfo.oriPrice}',
                    style: TextStyle(
                        color: Colors.black26,
                        fontSize: 30 * rpx,
                        decoration: TextDecoration.lineThrough),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      child: Text(
                        '特卖价 ¥',
                        style: TextStyle(
                            fontSize: 25.0 * rpx, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      child: Text(
                        '${goodInfo.groupPrice}',
                        style: TextStyle(
                            fontSize: 35.0 * rpx, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            )),
        Expanded(
          child: Container(),
        ),
        Container(
            width: 100 * rpx,
            height: 200 * rpx,
            child: IconButton(
                alignment: Alignment.topCenter,
                icon: Icon(
                  Icons.close,
                  color: Color(0xff666666),
                  size: 65 * rpx,
                ),
                onPressed: () {
                  final goodTypeBadgerProvide =
                      Provide.value<GoodSelectBottomProvide>(context);
                  final orderInfoAddReciverProvide =
                      Provide.value<OrderInfoAddReciverProvide>(context);
                  final receiverAddressProvide =
                      Provide.value<ReceiverAddressProvide>(context);

                  LocalOrderInfo.getLocalOrderInfo().clear();
                  if (!goodTypeBadgerProvide.fromOrderInfo) {
                    Navigator.pop(context);
                    goodTypeBadgerProvide.clear();
                    orderInfoAddReciverProvide.clear();
                    receiverAddressProvide.clear();
                  } else {
                    Navigator.pop(context);
                  }
                })),
      ],
    );
  }
}

Widget _showNumChangeContainer(index) {
  return Provide<GoodSelectBottomProvide>(builder: (context, child, counter) {
    return NumChangeWidget(
        currentReceiverNum: counter.currentReceiverIndex,
        typeIndex: counter.typeIndex,
        specIndex: index);
  });
}

showBottomItems(goodId, context, rpx) {
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(15)),
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      builder: (_) {
        return SizedBox(
            height: Platform.isIOS ? 1100 * rpx : 950 * rpx,
            child: Container(
                child: GestureDetector(
                    onTap: () {
                      return false;
                    },
                    child: ProductSelectItemPage(
                      goodId: goodId,
                    ))),
          );
      });
}
