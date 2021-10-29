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
import 'package:mstimes/tools/number_container.dart';
import 'package:mstimes/utils/color_util.dart';
import 'package:mstimes/model/good_details.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

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
  int specValue = 1;
  double rpx;
  int groupPrice = 0;
  int oriPrice = 0;

  @override
  void initState() {
    super.initState();
    DataList goodInfo = LocalOrderInfo.getLocalOrderInfo().goodInfo;
    this.groupPrice = goodInfo.groupPrice;
    this.oriPrice = goodInfo.oriPrice;
    LocalOrderInfo.getLocalOrderInfo().setOrderInfoKV('groupPrice', this.groupPrice);
    LocalOrderInfo.getLocalOrderInfo().setOrderInfoKV('oriPrice', this.oriPrice);

    LocalOrderInfo.getLocalOrderInfo().setOrderInfoKV('classifyId', typeValue);
    List<dynamic> categories = jsonDecode(goodInfo.categories);
    LocalOrderInfo.getLocalOrderInfo().setOrderInfoKV('selectedClassify', categories[0]);

    LocalOrderInfo.getLocalOrderInfo().setOrderInfoKV('specificId', specValue);
    List<dynamic> specifics = jsonDecode(goodInfo.specifics);
    LocalOrderInfo.getLocalOrderInfo().setOrderInfoKV('selectedSpecific', specifics[0]);

    LocalOrderInfo.getLocalOrderInfo().setOrderInfoKV('num', 1);
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return _createItems(context);
  }

  Widget _createItems(BuildContext context) {
    DataList goodInfo = LocalOrderInfo.getLocalOrderInfo().goodInfo;
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          controller: controller,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              _buildTopRow(goodInfo, context),
              _showTypeTitle(),
              _buildGoodTypes(goodInfo),
              _showSpecificationTitle(),
              _buildSpecifics(goodInfo),
              _buildBuyNumber(rpx),
              _buildBottom(rpx),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
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
        DataList goodInfo = LocalOrderInfo.getLocalOrderInfo().goodInfo;
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

                LocalOrderInfo.getLocalOrderInfo().setOrderInfoKV('classifyId', index);
                LocalOrderInfo.getLocalOrderInfo().setOrderInfoKV('selectedClassify', value);
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
                LocalOrderInfo.getLocalOrderInfo().setOrderInfoKV('classifyId', index);
                LocalOrderInfo.getLocalOrderInfo().setOrderInfoKV('selectedClassify', value);

                if(goodInfo.diffType == 1){
                  _refreshDiffPrice(goodInfo, index.toString());
                }else if(goodInfo.diffType == 3){
                  String bothKey = index.toString() + specValue.toString();
                  _refreshDiffPrice(goodInfo, bothKey);
                }
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
      // height: 50 * rpx,
      margin: EdgeInsets.only(left: 20 * rpx, top: 20 * rpx, bottom: 10 * rpx),
      child: Text(
        specification,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 30 * rpx, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildSpecifics(goodInfo) {
    List<dynamic> specifics = jsonDecode(goodInfo.specifics);
    List<Widget> _listWidgets = [];
    if (specifics.length > 0) {
      int index = 1;
      specifics.forEach((val) {
        _listWidgets.add(_listSpecButtons(index++, val));
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

  Widget _listSpecButtons(index, value) {
    bool select = specValue == index;
    return _buildSpecButton(select, index, value);
  }

  void updateSpecValue(int v) {
    setState(() {
      specValue = v;
    });
  }

  Widget _buildSpecButton(bool select, int index, String value) {
    DataList goodInfo = LocalOrderInfo.getLocalOrderInfo().goodInfo;
    if (select) {
      return InkWell(
          onTap: () {
            updateSpecValue(index);
            // context.read<GoodSelectBottomProvide>().updateTypeIndex(index);
            LocalOrderInfo.getLocalOrderInfo().setOrderInfoKV('specificId', index);
            LocalOrderInfo.getLocalOrderInfo().setOrderInfoKV('selectedSpecific', value);
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
        );
    } else {
      return InkWell(
          onTap: () {
            // context.read<GoodSelectBottomProvide>().updateTypeIndex(index);
            updateSpecValue(index);
            LocalOrderInfo.getLocalOrderInfo().setOrderInfoKV('specificId', index);
            LocalOrderInfo.getLocalOrderInfo().setOrderInfoKV('selectedSpecific', value);

            if(goodInfo.diffType == 2){
              _refreshDiffPrice(goodInfo, index.toString());
            }else if(goodInfo.diffType == 3){
              String bothKey = typeValue.toString() + index.toString();
              _refreshDiffPrice(goodInfo, bothKey);
            }
          },
          child: Container(
            padding: EdgeInsets.only(left: 50 * rpx, right: 50 * rpx, top: 10 * rpx, bottom: 10 * rpx),
            margin: EdgeInsets.only(left: 12 * rpx, right: 3 * rpx, top: 5 * rpx),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10 * rpx)),
              border: new Border.all(width: 1 * rpx, color: Colors.black),
            ),
            child: Text(
              value,
              style: TextStyle(fontSize: 26 * rpx),
            ),
          ),
        );
    }
  }

  void _refreshDiffPrice(goodInfo, key){
    if(goodInfo.diffPriceInfoMap[key] != null){
      var newGroupPrice = goodInfo.diffPriceInfoMap[key]['groupPrice'];
      var newOriPrice = goodInfo.diffPriceInfoMap[key]['oriPrice'];
      LocalOrderInfo.getLocalOrderInfo().setOrderInfoKV('groupPrice', newGroupPrice);
      LocalOrderInfo.getLocalOrderInfo().setOrderInfoKV('oriPrice', newOriPrice);

      setState(() {
        this.groupPrice = newGroupPrice;
        this.oriPrice = newOriPrice;
      });
    }else {
      LocalOrderInfo.getLocalOrderInfo().setOrderInfoKV('groupPrice', goodInfo.groupPrice);
      LocalOrderInfo.getLocalOrderInfo().setOrderInfoKV('oriPrice', goodInfo.oriPrice);

      setState(() {
        this.groupPrice = goodInfo.groupPrice;
        this.oriPrice = goodInfo.oriPrice;
      });
    }
  }

  Widget _buildSpecification(goodInfo, ScrollController controller) {
    List<dynamic> specfications = jsonDecode(goodInfo.specifics);
    return SingleChildScrollView(
      controller: controller,
      child: Container(
        margin: EdgeInsets.only(bottom: 180 * rpx),
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
      padding: EdgeInsets.only(left: 20 * rpx, top: 15 * rpx),
      controller: controller,
      itemCount: specs.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.only(bottom: 20 * rpx),
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
                    // '¥${goodInfo.oriPrice}',
                    '¥' + this.oriPrice.toString(),
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
                        '蜜糖价 ¥',
                        style: TextStyle(
                            fontSize: 25.0 * rpx, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      child: Text(
                        // '${goodInfo.groupPrice}',
                        this.groupPrice.toString(),
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

Widget _buildBuyNumber(rpx){
  return Row(
    children: [
      Container(
        margin: EdgeInsets.only(left: 30 * rpx, top: 50 * rpx),
        child: Text('购买数量', style: TextStyle(fontSize: 28 * rpx, fontWeight: FontWeight.w500),),
      ),
      Expanded(
        child: Container(),
      ),
      NumberChangeWidget()
    ],
  );
}

Widget _buildBottom(rpx){
  return Container(
    margin: EdgeInsets.only(bottom: 180 * rpx),
  );
}

Widget _showNumChangeContainer(context, index) {
    final goodSelectBottomProvide = Provider.of<GoodSelectBottomProvide>(context, listen: false);
    return NumChangeWidget(
        currentReceiverNum: goodSelectBottomProvide.currentReceiverIndex,
        typeIndex: goodSelectBottomProvide.typeIndex,
        specIndex: index);
}

showBottomItems(goodInfo, context, rpx) {
  if(goodInfo == null){
    goodInfo = LocalOrderInfo.getLocalOrderInfo().goodInfo;
  }
  List<dynamic> categories = jsonDecode(goodInfo.categories);
  List<dynamic> specfications = jsonDecode(goodInfo.specifics);
  var listLength = categories.length + specfications.length;
  print("showBottomItems h : " + listLength.toString());
  var h_ratio = 0.5;
  if(listLength > 4){
    h_ratio = 0.7;
  }else if(listLength > 6){
    h_ratio = 0.8;
  }else if(listLength > 10){
    h_ratio = 0.9;
  }

  double maxShowHeight = MediaQuery.of(context).size.height * h_ratio;
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(15)),
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,
      builder: (_) {
        return AnimatedPadding(
            // height: Platform.isIOS ? 1100 * rpx : 950 * rpx,
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            child: Container(
                constraints: BoxConstraints(
                  minHeight: 90, //设置最小高度（必要）
                  maxHeight: maxShowHeight
                  // maxHeight: MediaQuery.of(context).size.height / 1.5, //设置最大高度（必要）
                ),
                padding: EdgeInsets.only(top: 5 * rpx, bottom: 5 * rpx),
                child: GestureDetector(
                    onTap: () {
                      return false;
                    },
                    child: ProductSelectItemPage(
                      goodId: goodInfo.goodId,
                    )),
            ),
        );
      });
}
