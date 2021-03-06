import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mstimes/model/local_share/release_images.dart';
import 'package:provider/provider.dart';
import 'package:mstimes/provide/upload_release_provide.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:mstimes/utils/color_util.dart';

class ReleaseGoodDetails extends StatefulWidget {
  @override
  _ReleaseGoodDetailsState createState() => _ReleaseGoodDetailsState();
}

class _ReleaseGoodDetailsState extends State<ReleaseGoodDetails> {
  ScrollController controller = ScrollController();
  DateTime groupStartDate;
  int categoryContainterNum = 1;
  int specificsContainerNum = 1;
  String categoryType = 'categorys';
  String specificType = 'specifics';
  double rpx;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [
              _buildBrandInfo(),
              _buildMaterialInfo(),
              _buildComponentInfo(),
              _buildProductionDateInfo(),
              _buildExpirationDateInfo(),
              _buildProductionPlaceInfo(),
              _buildShippingInfo(),
              _buildUnshippingInfo(),
              _buildGuaranteePeriodInfo(),
              _buildShippingTimeLimitInfo(),
              _buildAfterSalesInfo()
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: _buildUploadImageBottom(context),
        )
      ],
    );
  }

  Widget _buildBrandInfo() {
    // final uploadGoodInfosProvide =
    //     Provide.value<UploadGoodInfosProvide>(context);
    final uploadGoodInfosProvide = context.read<UploadGoodInfosProvide>();
    // FocusNode _focusNode = FocusNode();
    return Container(
      margin: EdgeInsets.only(left: 6 * rpx, top: 10 * rpx),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
                left: 5 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 0),
            child: Text(
              '?????????',
              style: TextStyle(fontSize: 30 * rpx, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
              width: 600 * rpx,
              height: 75 * rpx,
              margin: EdgeInsets.only(
                  left: 5 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 5 * rpx),
              alignment: Alignment(0, 0),
              decoration: new BoxDecoration(
                //??????
                color: Colors.white,
                //??????????????????
                border: new Border.all(width: 1, color: Colors.grey),
              ),
              child: TextField(
                // focusNode: _focusNode,
                maxLines: 1,
                enabled: true,
                onChanged: (value) {
                  uploadGoodInfosProvide.setUploadInfo('brand', value);
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration.collapsed(
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.grey[400]),
                    hintText: "??????????????????10?????????(??????)"),
              ))
        ],
      ),
    );
  }

  Widget _buildMaterialInfo() {
    // final uploadGoodInfosProvide =
    //     Provide.value<UploadGoodInfosProvide>(context);
    final uploadGoodInfosProvide = context.read<UploadGoodInfosProvide>();
    // FocusNode _focusNode = FocusNode();
    return Container(
      margin: EdgeInsets.only(left: 6 * rpx, top: 6 * rpx),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 5, top: 5, right: 3, bottom: 0),
            child: Text(
              '??????',
              style: TextStyle(fontSize: 30 * rpx, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
              width: 600 * rpx,
              height: 120 * rpx,
              margin: EdgeInsets.only(
                  left: 5 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 5 * rpx),
              alignment: Alignment(0, 0),
              decoration: new BoxDecoration(
                //??????
                color: Colors.white,
                //??????????????????
                border: new Border.all(width: 1, color: Colors.grey),
              ),
              child: TextField(
                // focusNode: _focusNode,
                maxLines: 10,
                enabled: true,
                onChanged: (value) {
                  uploadGoodInfosProvide.setUploadInfo('material', value);
                },
                textAlign: TextAlign.justify,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration.collapsed(
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.grey[400]),
                    hintText: "??????????????????????????????????????????(??????)"),
              ))
        ],
      ),
    );
  }

  Widget _buildComponentInfo() {
    final uploadGoodInfosProvide = context.read<UploadGoodInfosProvide>();
    // FocusNode _focusNode = FocusNode();
    return Container(
      margin: EdgeInsets.only(left: 6 * rpx, top: 6 * rpx),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
                left: 5 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 0),
            child: Text(
              '??????',
              style: TextStyle(fontSize: 30 * rpx, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
              width: 600 * rpx,
              height: 120 * rpx,
              margin: EdgeInsets.only(
                  left: 5 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 5 * rpx),
              alignment: Alignment(0, 0),
              decoration: new BoxDecoration(
                //??????
                color: Colors.white,
                //??????????????????
                border: new Border.all(width: 1, color: Colors.grey),
              ),
              child: TextField(
                // focusNode: _focusNode,
                maxLines: 10,
                enabled: true,
                onChanged: (value) {
                  uploadGoodInfosProvide.setUploadInfo('component', value);
                },
                textAlign: TextAlign.justify,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration.collapsed(
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.grey[400]),
                    hintText: "????????????????????????????????????(??????)"),
              ))
        ],
      ),
    );
  }

  Widget _buildProductionDateInfo() {
    final uploadGoodInfosProvide = context.read<UploadGoodInfosProvide>();
    // FocusNode _focusNode = FocusNode();
    return Container(
      margin: EdgeInsets.only(left: 6 * rpx, top: 6 * rpx),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
                left: 5 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 0),
            child: Text(
              '????????????',
              style: TextStyle(fontSize: 30 * rpx, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
              width: 600 * rpx,
              height: 75 * rpx,
              margin: EdgeInsets.only(
                  left: 5 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 5 * rpx),
              alignment: Alignment(0, 0),
              decoration: new BoxDecoration(
                //??????
                color: Colors.white,
                //??????????????????
                border: new Border.all(width: 1, color: Colors.grey),
              ),
              child: TextField(
                // focusNode: _focusNode,
                minLines: 1,
                maxLines: 5,
                enabled: true,
                onChanged: (value) {
                  uploadGoodInfosProvide.setUploadInfo('productionDate', value);
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration.collapsed(
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.grey[400]),
                    hintText: "????????????????????????(??????)"),
              ))
        ],
      ),
    );
  }

  Widget _buildExpirationDateInfo() {
    final uploadGoodInfosProvide = context.read<UploadGoodInfosProvide>();
    // FocusNode _focusNode = FocusNode();
    return Container(
      margin: EdgeInsets.only(left: 6 * rpx, top: 6 * rpx),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
                left: 5 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 0),
            child: Text(
              '????????????/?????????',
              style: TextStyle(fontSize: 30 * rpx, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
              width: 400 * rpx,
              height: 75 * rpx,
              margin: EdgeInsets.only(
                  left: 5 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 5 * rpx),
              alignment: Alignment(0, 0),
              decoration: new BoxDecoration(
                //??????
                color: Colors.white,
                //??????????????????
                border: new Border.all(width: 1, color: Colors.grey),
              ),
              child: TextField(
                // focusNode: _focusNode,
                minLines: 1,
                maxLines: 5,
                enabled: true,
                onChanged: (value) {
                  uploadGoodInfosProvide.setUploadInfo('expirationDate', value);
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration.collapsed(
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.grey[400]),
                    hintText: "??????????????????????????????(??????)"),
              ))
        ],
      ),
    );
  }

  Widget _buildGuaranteePeriodInfo() {
    final uploadGoodInfosProvide = context.read<UploadGoodInfosProvide>();
    // FocusNode _focusNode = FocusNode();
    return Container(
      margin: EdgeInsets.only(left: 6 * rpx, top: 6 * rpx),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
                left: 5 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 0),
            child: Text(
              '?????????',
              style: TextStyle(fontSize: 30 * rpx, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
              width: 600 * rpx,
              height: 75 * rpx,
              margin: EdgeInsets.only(
                  left: 5 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 5 * rpx),
              alignment: Alignment(0, 0),
              decoration: new BoxDecoration(
                //??????
                color: Colors.white,
                //??????????????????
                border: new Border.all(width: 1, color: Colors.grey),
              ),
              child: TextField(
                // focusNode: _focusNode,
                minLines: 1,
                maxLines: 5,
                enabled: true,
                onChanged: (value) {
                  uploadGoodInfosProvide.setUploadInfo('expirationDate', value);
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration.collapsed(
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.grey[400]),
                    hintText: "?????????????????????????????????(??????)"),
              ))
        ],
      ),
    );
  }

  Widget _buildProductionPlaceInfo() {
    final uploadGoodInfosProvide = context.read<UploadGoodInfosProvide>();
    // FocusNode _focusNode = FocusNode();
    return Container(
      margin: EdgeInsets.only(left: 6 * rpx, top: 6 * rpx),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
                left: 5 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 0),
            child: Text(
              '??????',
              style: TextStyle(fontSize: 30 * rpx, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
              width: 600 * rpx,
              height: 75 * rpx,
              margin: EdgeInsets.only(
                  left: 5 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 5 * rpx),
              alignment: Alignment(0, 0),
              decoration: new BoxDecoration(
                //??????
                color: Colors.white,
                //??????????????????
                border: new Border.all(width: 1, color: Colors.grey),
              ),
              child: TextField(
                // focusNode: _focusNode,
                minLines: 1,
                maxLines: 5,
                enabled: true,
                onChanged: (value) {
                  uploadGoodInfosProvide.setUploadInfo(
                      'productionPlace', value);
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration.collapsed(
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.grey[400]),
                    hintText: "??????????????????(??????)"),
              ))
        ],
      ),
    );
  }

  Widget _buildShippingInfo() {
    final uploadGoodInfosProvide = context.read<UploadGoodInfosProvide>();
    // FocusNode _focusNode = FocusNode();
    return Container(
      margin: EdgeInsets.only(left: 6 * rpx, top: 6 * rpx),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
                left: 5 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 0),
            child: Text(
              '?????????/??????',
              style: TextStyle(fontSize: 30 * rpx, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
              width: 500 * rpx,
              height: 75 * rpx,
              margin: EdgeInsets.only(
                  left: 5 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 5 * rpx),
              alignment: Alignment(0, 0),
              decoration: new BoxDecoration(
                //??????
                color: Colors.white,
                //??????????????????
                border: new Border.all(width: 1, color: Colors.grey),
              ),
              child: TextField(
                // focusNode: _focusNode,
                minLines: 1,
                maxLines: 5,
                enabled: true,
                onChanged: (value) {
                  uploadGoodInfosProvide.setUploadInfo('shippingInfo', value);
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration.collapsed(
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.grey[400]),
                    hintText: "???????????????????????????????????????(??????)"),
              ))
        ],
      ),
    );
  }

  Widget _buildUnshippingInfo() {
    final uploadGoodInfosProvide = context.read<UploadGoodInfosProvide>();
    // FocusNode _focusNode = FocusNode();
    return Container(
      margin: EdgeInsets.only(left: 6 * rpx, top: 6 * rpx),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
                left: 5 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 0),
            child: Text(
              '?????????',
              style: TextStyle(fontSize: 30 * rpx, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
              width: 600 * rpx,
              height: 75 * rpx,
              margin: EdgeInsets.only(
                  left: 5 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 5 * rpx),
              alignment: Alignment(0, 0),
              decoration: new BoxDecoration(
                //??????
                color: Colors.white,
                //??????????????????
                border: new Border.all(width: 1, color: Colors.grey),
              ),
              child: TextField(
                // focusNode: _focusNode,
                minLines: 1,
                maxLines: 5,
                enabled: true,
                onChanged: (value) {
                  uploadGoodInfosProvide.setUploadInfo('unshippingInfo', value);
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration.collapsed(
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.grey[400]),
                    hintText: "??????????????????????????????(??????)"),
              ))
        ],
      ),
    );
  }

  Widget _buildShippingTimeLimitInfo() {
    final uploadGoodInfosProvide = context.read<UploadGoodInfosProvide>();
    // FocusNode _focusNode = FocusNode();
    return Container(
      margin: EdgeInsets.only(left: 6 * rpx, top: 6 * rpx),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
                left: 5 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 0),
            child: Text(
              '????????????',
              style: TextStyle(fontSize: 30 * rpx, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
              width: 600 * rpx,
              height: 120 * rpx,
              margin: EdgeInsets.only(
                  left: 5 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 5 * rpx),
              alignment: Alignment(0, 0),
              decoration: new BoxDecoration(
                //??????
                color: Colors.white,
                //??????????????????
                border: new Border.all(width: 1, color: Colors.grey),
              ),
              child: TextField(
                // focusNode: _focusNode,
                maxLines: 10,
                enabled: true,
                onChanged: (value) {
                  uploadGoodInfosProvide.setUploadInfo(
                      'shippingTimeLimit', value);
                },
                textInputAction: TextInputAction.done,
                textAlign: TextAlign.justify,
                decoration: InputDecoration.collapsed(
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.grey[400]),
                    hintText: "?????????????????????????????????????????????????????????(??????)"),
              ))
        ],
      ),
    );
  }

  Widget _buildAfterSalesInfo() {
    final uploadGoodInfosProvide = context.read<UploadGoodInfosProvide>();
    // FocusNode _focusNode = FocusNode();
    return Container(
      margin: EdgeInsets.only(left: 6 * rpx, top: 6 * rpx),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
                left: 5 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 0),
            child: Text(
              '??????',
              style: TextStyle(fontSize: 30 * rpx, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
              width: 600 * rpx,
              height: 150 * rpx,
              margin: EdgeInsets.only(
                  left: 5 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 5 * rpx),
              alignment: Alignment(0, 0),
              decoration: new BoxDecoration(
                //??????
                color: Colors.white,
                //??????????????????
                border: new Border.all(width: 1, color: Colors.grey),
              ),
              child: TextField(
                // focusNode: _focusNode,
                maxLines: 12,
                enabled: true,
                onChanged: (value) {
                  uploadGoodInfosProvide.setUploadInfo('afterSales', value);
                },
                textInputAction: TextInputAction.done,
                textAlign: TextAlign.justify,
                decoration: InputDecoration.collapsed(
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.grey[400]),
                    hintText: "???????????????????????????????????????????????????(??????)"),
              ))
        ],
      ),
    );
  }

  Widget _buildUploadImageBottom(context) {
    final uploadGoodInfosProvide = context.read<UploadGoodInfosProvide>();
    return Container(
        padding: EdgeInsets.only(left: 0, right: 0, top: 6, bottom: 26),
        width: 750 * rpx,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                InkWell(
                    onTap: () {
                      uploadGoodInfosProvide.postUploadGoodInfos();
                      uploadGoodInfosProvide.clear();
                      LocalReleaseImages.getImagesMap().localImagesMap.clear();
                      RouterHome.flutoRouter
                          .navigateTo(context, RouterConfig.myPagePath);
                    },
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                              width: 600 * rpx,
                              height: 75 * rpx,
                              margin: EdgeInsets.only(left: 75 * rpx),
                              alignment: Alignment(0, 0),
                              //????????????
                              decoration: new BoxDecoration(
                                //??????
                                color: buttonColor,
                                //?????????????????? ??????
                                // borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Container(
                                child: Text(
                                  '??????',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30 * rpx,
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                        ],
                      ),
                    ))
              ],
            ),
          ],
        ));
  }
}
