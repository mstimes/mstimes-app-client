import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mstimes/model/local_share/order_info.dart';
import 'package:mstimes/provide/reveiver_address_provide.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/pages/order/product_select_bottom.dart';
import 'package:mstimes/provide/good_select_type.dart';
import 'package:mstimes/provide/order_info_add.dart';
import 'package:mstimes/tools/number_change.dart';
import 'package:mstimes/utils/color_util.dart';
import 'package:mstimes/model/good_details.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
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
    return FutureBuilder(
        future: getGoodInfos(widget.goodId, context),
        builder: _buildFuture);
  }

  Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot) {
    // return _createItems(context, snapshot);
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        // return Text('Not beginning to connect network.');
        return Container();
      case ConnectionState.active:
        // return Text('ConnectionState is active.');
        return Container();
      case ConnectionState.waiting:
        return Container();
      case ConnectionState.done:
        // if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        return _createItems(context, snapshot);
      default:
        return Container();
    }
  }

  Widget _createItems(BuildContext context, AsyncSnapshot snapshot) {
    DataList goodInfo = LocalOrderInfo.getLocalOrderInfo().goodInfo;
    // DataList goodInfo = context.read<SelectedGoodInfoProvide>().goodInfo;
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          controller: controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
        style: TextStyle(fontSize: 30 * rpx, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildGoodTypes(goodInfo) {
    List<dynamic> categories = jsonDecode(goodInfo.categories);
    List<Widget> _listWidgets = List<Widget>();
    if (categories.length != 0) {
      int index = 1;
      categories.forEach((val) {
        _listWidgets.add(_listItem(index++, val));
      });
    }

    return Container(
      margin: EdgeInsets.only(left: 20 * rpx, right: 10 * rpx),
      child: Wrap(
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.end,
        runSpacing: 6 * rpx,
        spacing: 6 * rpx,
        children: _listWidgets,
      ),
    );
  }

  Widget _buildTypeButton(bool select, int index, String value) {
        Map typeValueMap = context.watch<GoodSelectBottomProvide>().queryTypeValueMap();
        if (select) {
          return Badge(
            badgeColor: Colors.black,
            showBadge: '${typeValueMap[index]}' != 'null',
            badgeContent: Container(
              child: Text(
                '${typeValueMap[index]}',
                style: TextStyle(color: Colors.white, fontSize: 15 * rpx),
              ),
            ),
            child: InkWell(
              onTap: () {
                updateTypeValue(index);
                context.read<GoodSelectBottomProvide>().updateTypeIndex(index);
              },
              child: Container(
                padding: EdgeInsets.only(left: 50 * rpx, right: 50 * rpx, top: 10 * rpx, bottom: 10 * rpx),
                margin: EdgeInsets.only(left: 12 * rpx, right: 3 * rpx, top: 5 * rpx),
                decoration: new BoxDecoration(
                  color: homeBackgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(10 * rpx)),
                  border: new Border.all(width: 1 * rpx, color: homeBackgroundColor),
                ),
                child: Text(value, style: TextStyle(color: Colors.white, fontSize: 26 * rpx)),
              ),
            ),
          );
        } else {
          return Badge(
            badgeColor: Colors.black,
            showBadge: '${typeValueMap[index]}' != 'null',
            badgeContent: Container(
                child: Text(
              '${typeValueMap[index]}',
              style: TextStyle(color: Colors.white, fontSize: 15 * rpx),
            )),
            child: InkWell(
              onTap: () {
                context.read<GoodSelectBottomProvide>().updateTypeIndex(index);
                updateTypeValue(index);
              },
              child: Container(
                padding: EdgeInsets.only(left: 50 * rpx, right: 50 * rpx, top: 10 * rpx, bottom: 10 * rpx),
                margin: EdgeInsets.only(left: 12 * rpx, right: 3 * rpx, top: 5 * rpx),
                decoration: new BoxDecoration(
                  // color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(10 * rpx)),
                  border: new Border.all(width: 1 * rpx, color: Colors.black),
                ),
                child: Text(
                  value,
                  style: TextStyle(fontSize: 26 * rpx),
                ),
              ),
            ),
          );
        };
      // },
    // );
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
        style: TextStyle(fontSize: 30 * rpx, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildSpecification(goodInfo, ScrollController controller) {
    List<dynamic> specfications = jsonDecode(goodInfo.specifics);
    return SingleChildScrollView(
      controller: controller,
      child: Container(
        margin: EdgeInsets.only(bottom: 100 * rpx),
        child: _genSpecificationList(specfications, controller),
      ),
    );
  }

  Future getGoodInfos(int goodId, context) async {
    FormData formData = new FormData.fromMap({
      "goodId": goodId,
    });
    await requestDataByUrl('queryGoodById', formData: formData).then((val) {
      var data = json.decode(val.toString());
      // print('queryGoodById ' + data.toString());
      GoodDetailModel goodDetailModel = GoodDetailModel.fromJson(data);
      // Provider.of<SelectedGoodInfoProvide>(context, listen: false).setGoodInfo(goodDetailModel.dataList[0]);
      LocalOrderInfo.getLocalOrderInfo().setGoodInfo(goodDetailModel.dataList[0]);
      return data;
    });
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
                  padding: EdgeInsets.only(left: 50 * rpx, right: 50 * rpx, top: 10 * rpx, bottom: 10 * rpx),
                  margin: EdgeInsets.only(left: 10 * rpx, right: 10 * rpx, top: 5 * rpx),
                  decoration: new BoxDecoration(
                    // color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(10 * rpx)),
                    border: new Border.all(width: 1 * rpx, color: Colors.black),
                  ),
                  child: Container(
                      child: Center(
                    child: Text(
                      specs[index].toString(),
                      style: TextStyle(fontSize: 26 * rpx),
                    ),
                  ))),
              Expanded(
                child: Container(),
              ),
              _showNumChangeContainer(context, index)
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopRow(goodInfo, context) {
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
                  LocalOrderInfo.getLocalOrderInfo().clear();

                  if (!Provider.of<GoodSelectBottomProvide>(context, listen: false).fromOrderInfo) {
                    Navigator.pop(context);
                    Provider.of<GoodSelectBottomProvide>(context, listen: false).clear();
                    Provider.of<OrderInfoAddReciverProvide>(context, listen: false).clear();
                    Provider.of<ReceiverAddressProvide>(context, listen: false).clear();
                  } else {
                    Navigator.pop(context);
                  }
                })),
      ],
    );
  }
}

Widget _showNumChangeContainer(context, index) {
    final goodSelectBottomProvide = Provider.of<GoodSelectBottomProvide>(context, listen: false);
    return NumChangeWidget(
        currentReceiverNum: goodSelectBottomProvide.currentReceiverIndex,
        typeIndex: goodSelectBottomProvide.typeIndex,
        specIndex: index);
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
            // height: Platform.isIOS ? 1100 * rpx : 950 * rpx,
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
