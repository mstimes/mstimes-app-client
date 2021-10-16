import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mstimes/common/apple.dart';
import 'package:mstimes/common/wechat.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/good_details.dart';
import 'package:mstimes/model/local_share/order_info.dart';
import 'package:mstimes/pages/order/product_select.dart';
import 'package:mstimes/pages/product/group/group_hot_swiper.dart';
import 'package:mstimes/provide/good_select_type.dart';
import 'package:mstimes/provide/order_info_add.dart';
import 'package:mstimes/provide/reveiver_address_provide.dart';
import 'package:mstimes/provide/select_good_provider.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:mstimes/tools/common_container.dart';
import 'package:mstimes/utils/color_util.dart';
import 'package:mstimes/utils/date_utils.dart';
import 'package:provider/provider.dart';
import '../../../common/valid.dart';

class GroupGoods extends StatefulWidget {
  @override
  _GroupGoodsState createState() => _GroupGoodsState();
}

class GroupChoiceTab {
  final String title;
  const GroupChoiceTab({this.title});
}

const List<GroupChoiceTab> groupChoiceTabs = const <GroupChoiceTab>[
  const GroupChoiceTab(title: "今日好物"),
  // const GroupChoiceTab(title: "明日预告"),
];

class _GroupGoodsState extends State<GroupGoods> {
  int pageCount = 1;
  List<Map> _tommorrowGoodList = [];
  List<Map> _todayGoodList = [];
  List<Map> _yesterdayGoodList = [];
  double rpx;
  List<Widget> todayTotalWrapList = new List();
  List<Widget> tommorrowWrapList = new List();
  List<String> hotImages = new List();
  List<String> hotGoodIds = new List();
  GlobalKey _repaintLongImageKey = GlobalKey();
  GlobalKey _repaintSingleImageKey = GlobalKey();
  bool saveLongPatternA = false;
  bool saveLongPatternB = false;
  bool saveLongPatternC = false;
  bool enableSingleImageDownloadA = false;
  bool enableSingleImageDownloadB = false;
  // bool isToday = true;
  String downloadStartDate = formatDate(DateTime.now(), mdFormat);
  String downloadEndDate =
      formatDate(DateTime.now().add(Duration(days: 1)), mdFormat);

  @override
  void initState() {
    super.initState();

    // init wechat register
    print('init ...fluxwx');
    initFluwx();
    isInstallFluwx();

    // init apple register
    initApplePlatformState(context);

    getTodayGroupGoods();
    getYesterdayGroupGoods();

    LocalOrderInfo.getLocalOrderInfo().clear();
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return DefaultTabController(
      length: groupChoiceTabs.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: _showLeadingButton(),
          backgroundColor: Colors.white,
          toolbarHeight: 80 * rpx,
          elevation: 0,
          centerTitle: true,
          title: Text(
            '甄选天下好物 · 尽在Ms时代',
            style: TextStyle(
                fontSize: 30 * rpx,
                fontWeight: FontWeight.w400,
                color: Colors.black),
          ),
        ),
        body: _buildBody(),
        floatingActionButton: _buildFloatButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }

  Widget _showLeadingButton() {
    if (_needSaveLongImage() || _needSaveSingeImage()) {
      return IconButton(
        color: Colors.black,
        icon: Icon(Icons.arrow_back_ios_outlined),
        onPressed: () {
          RouterHome.flutoRouter
              .navigateTo(context, RouterConfig.groupGoodsPath);
        },
      );
    }
    return Container();
  }

  Widget _buildBody() {
    if (_needSaveSingeImage()) {
      return Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: RepaintBoundary(
                key: _repaintSingleImageKey,
                child: Container(
                  width: double.infinity,
                  color: Colors.black,
                  child: _buildDownloadContainers(),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: RepaintBoundary(
                key: _repaintLongImageKey,
                child: Container(
                  width: double.infinity,
                  color: _needSaveLongImageForBlack()
                      ? Colors.black
                      : homeBackgroundColor,
                  child: GestureDetector(
                    onLongPress: _showLongImage,
                    child: Column(children: _getTodayWrapList()),
                  ),
                ),
              )),
        ),
      ],
    );
  }

  Widget _buildFloatButton() {
    if (_needSaveSingeImage() || _needSaveLongImage()) {
      return SpeedDial(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.download_sharp,
            color: Colors.black,
          ),
          onPress: () => {
                if (_needSaveLongImage())
                  {_saveLongImage()}
                else
                  {_saveSingleImage()}
              });
    }

    return SpeedDial(
        backgroundColor: Colors.black26,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        children: [
          SpeedDialChild(
              child: Image.asset(
                'lib/images/my.png',
                height: 20 * rpx,
                width: 20 * rpx,
              ),
              backgroundColor: Colors.black26,
              labelStyle: TextStyle(fontSize: 20 * rpx),
              onTap: () => {
                      RouterHome.flutoRouter
                          .navigateTo(context, RouterConfig.myPagePath)
                  }),
          SpeedDialChild(
            child: Image.asset(
              'lib/images/new.png',
              height: 20 * rpx,
              width: 20 * rpx,
            ),
            backgroundColor: Colors.black26,
            labelStyle: TextStyle(fontSize: 20 * rpx),
            onTap: () => {
                RouterHome.flutoRouter
                    .navigateTo(context, RouterConfig.newGoodsPath)
            },
          ),
        ]);
  }

  bool _needSaveLongImageForBlack() {
    return saveLongPatternA || saveLongPatternB;
  }

  bool _needSaveLongImage() {
    return saveLongPatternA || saveLongPatternB || saveLongPatternC;
  }

  bool _needSaveSingeImage() {
    return enableSingleImageDownloadA || enableSingleImageDownloadB;
  }

  void _showLongImage() {
    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(500, 75, 10, 0),
        items: <PopupMenuEntry>[
          PopupMenuItem(
            child: Card(
              child: Column(children: [
                Container(
                  child: Padding(
                    child: Text(
                      "预览长图素材模版",
                      style: TextStyle(color: Colors.black, fontSize: 13),
                    ),
                    padding: EdgeInsets.only(left: 5, bottom: 5),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            saveLongPatternA = true;
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 25 * rpx),
                          child: Image.asset(
                            "lib/images/A.png",
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.only(right: 5),
                    ),
                    Padding(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            saveLongPatternB = true;
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 25 * rpx),
                          child: Image.asset(
                            "lib/images/B.png",
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.only(right: 5),
                    ),
                    Padding(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            saveLongPatternC = true;
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 25 * rpx),
                          child: Image.asset(
                            "lib/images/C.png",
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.only(right: 5),
                    ),
                  ],
                )
              ]),
            ),
          ),
        ]);
  }

  _saveLongImage() async {
    RenderRepaintBoundary boundary =
        _repaintLongImageKey.currentContext.findRenderObject();
    var image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();

    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(pngBytes + pngBytes),
        quality: 60,
        name: "hello");
    print(result);

    _returnGroupGoodsPageConfirm();
  }

  Widget showFloatingActionButton() {
    return new FloatingActionButton.extended(
      onPressed: () {
        print('button click');
      },
      foregroundColor: Colors.white,
      backgroundColor: Colors.amber,
      //如果不手动设置icon和text颜色,则默认使用foregroundColor颜色
      icon: new CircleAvatar(
        backgroundImage: new AssetImage('images/zhubo01.jpg'),
      ),
      label: new Text('FloatingActionButton', maxLines: 1),
    );
  }

  Widget _buildImageSwiperBottom(colorForBlack) {
    return Container(
      margin: EdgeInsets.only(top: 30 * rpx),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 10 * rpx,
            ),
            child: Image.asset(
              colorForBlack
                  ? "lib/images/zp_white.png"
                  : "lib/images/zp_yellow.png",
              height: 35 * rpx,
              width: 35 * rpx,
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 10 * rpx, right: 10 * rpx),
              child: Text(
                '正品授权',
                style: TextStyle(
                    fontSize: 23 * rpx,
                    color: colorForBlack ? Colors.white : backgroundFontColor,
                    fontWeight: FontWeight.bold),
              )),
          SizedBox(
            height: 50 * rpx,
            child: VerticalDivider(
              color: backgroundFontColor,
              width: 20 * rpx,
              thickness: 2 * rpx,
              indent: 10 * rpx,
              endIndent: 5 * rpx,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: 20 * rpx,
            ),
            child: Image.asset(
              colorForBlack
                  ? "lib/images/sale_white.png"
                  : "lib/images/sale_yellow.png",
              height: 35 * rpx,
              width: 35 * rpx,
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 10 * rpx, right: 10 * rpx),
              child: Text(
                '限时特卖',
                style: TextStyle(
                    fontSize: 23 * rpx,
                    color: colorForBlack ? Colors.white : backgroundFontColor,
                    fontWeight: FontWeight.bold),
              )),
          SizedBox(
            height: 50 * rpx,
            child: VerticalDivider(
              color: backgroundFontColor,
              width: 20 * rpx,
              thickness: 2 * rpx,
              indent: 10 * rpx,
              endIndent: 5 * rpx,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: 20 * rpx,
            ),
            child: Image.asset(
              colorForBlack
                  ? "lib/images/discount_white.png"
                  : "lib/images/discount_yellow.png",
              height: 35 * rpx,
              width: 35 * rpx,
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 10 * rpx, right: 10 * rpx),
              child: Text(
                '全网低价',
                style: TextStyle(
                    fontSize: 23 * rpx,
                    color: colorForBlack ? Colors.white : backgroundFontColor,
                    fontWeight: FontWeight.bold),
              )),
          SizedBox(
            height: 50 * rpx,
            child: VerticalDivider(
              color: backgroundFontColor,
              width: 20 * rpx,
              thickness: 2 * rpx,
              indent: 10 * rpx,
              endIndent: 5 * rpx,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: 20 * rpx,
            ),
            child: Image.asset(
              colorForBlack
                  ? "lib/images/trace_white.png"
                  : "lib/images/trace_yellow.png",
              height: 45 * rpx,
              width: 45 * rpx,
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 10 * rpx, right: 10 * rpx),
              child: Text(
                '品牌溯源',
                style: TextStyle(
                    fontSize: 23 * rpx,
                    color: colorForBlack ? Colors.white : backgroundFontColor,
                    fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  List<Widget> _getTodayWrapList() {
    if (_todayGoodList.length != 0) {
      todayTotalWrapList.clear();
      if (!_needSaveLongImage()) {
        todayTotalWrapList.add(GroupGoodsImageSwiper(
          swiperImageUrls: hotImages,
          goodIds: hotGoodIds,
        ));
      } else {
        todayTotalWrapList.add(Container(
          margin: EdgeInsets.only(top: 30 * rpx),
        ));
        if (saveLongPatternA) {
          todayTotalWrapList.add(
              _buildDownloadHeaderContainerB("lib/images/TOP_HEADER_1.JPG"));
        } else if (saveLongPatternB) {
          todayTotalWrapList.add(
              _buildDownloadHeaderContainerB("lib/images/TOP_HEADER_2.JPG"));
        } else {
          todayTotalWrapList.add(
              _buildDownloadHeaderContainerB("lib/images/TOP_HEADER_3.JPG"));
        }
      }

      todayTotalWrapList
          .add(_buildImageSwiperBottom(_needSaveLongImageForBlack()));

      todayTotalWrapList.add(
        _buildProductListHeaderContainer('PICK SUPER LIST', '甄选超榜',
            '#今日上新# 每日20:00准时更新甄选榜单', _needSaveLongImageForBlack()),
      );

      List<Widget> listWidget = _todayGoodList.map((val) {
        return InkWell(
            onTap: () {
              // if(!checkIsLogin(context)){
              //   // 腾讯应用上架前置登陆
              //   return;
              // }

              context.read<SelectedGoodInfoProvide>().getGoodInfosById(val['goodId']);

              RouterHome.flutoRouter.navigateTo(
                context,
                RouterConfig.detailsPath +
                    "?id=${val['goodId']}&showPay=true",
              );
            },
            child: _buildSingleProductContainer(val, true));
      }).toList();
      todayTotalWrapList.addAll(listWidget);

      if (_yesterdayGoodList.length != 0) {
        todayTotalWrapList.add(_buildProductListHeaderContainer(
            'TIMEKEEPING LIST',
            '计时榜单',
            '#即将下架# 明日20:00即将下架产品',
            _needSaveLongImageForBlack()));

        List<Widget> yesterdayListWidget = _yesterdayGoodList.map((val) {
          return InkWell(
              onTap: () {
                RouterHome.flutoRouter.navigateTo(
                  context,
                  RouterConfig.detailsPath +
                      "?id=${val['goodId']}&showPay=true",
                );
              },
              child: _buildSingleProductContainer(val, false));
        }).toList();

        todayTotalWrapList.addAll(yesterdayListWidget);
      }

      todayTotalWrapList.add(buildCommonBottom(
        _needSaveLongImageForBlack() ? Colors.white : backgroundFontColor,
        rpx,
      ));
      
      return todayTotalWrapList;
    } else {
      return List();
    }
  }

  Widget _buildProductListHeader(top, title, bottom, needForBlack) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 15 * rpx),
          child: Text(
            top,
            style: TextStyle(
                color: needForBlack ? Colors.white : backgroundFontColor,
                fontSize: 28 * rpx,
                fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          title,
          style: TextStyle(
              color: needForBlack ? Colors.white : backgroundFontColor,
              fontSize: 38 * rpx,
              fontWeight: FontWeight.w700),
        ),
        Container(
          margin: EdgeInsets.only(top: 15 * rpx),
          child: Text(
            bottom,
            style: TextStyle(
              color: needForBlack ? Colors.white : backgroundFontColor,
              fontSize: 23 * rpx,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSingleProductContainer(val, today) {
    return Container(
      width: 700 * rpx,
      height: 360 * rpx,
      margin: EdgeInsets.only(
          left: 15 * rpx, top: 15 * rpx, right: 15 * rpx, bottom: 20 * rpx),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15.0 * rpx)),
        border: new Border.all(width: 1 * rpx, color: Colors.white),
      ),
      child: GestureDetector(
        onLongPress: _showSingleImage,
        onLongPressStart: (details) {
          print('group_goods ... ' + val['goodId'].toString());
          context.read<SelectedGoodInfoProvide>().getGoodInfosById(val['goodId']);
          if (!today) {
            downloadStartDate =
                formatDate(DateTime.now().add(Duration(days: -1)), mdFormat);
            downloadEndDate = formatDate(DateTime.now(), mdFormat);
          }

          downloadStartDate += ' 20:00';
          downloadEndDate += ' 20:00';
        },
        child: Row(
          children: <Widget>[
            makeImageArea(val, 360),
            buildTitleAndPrice(val, true),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadContainers() {
    var goodInfo = context.read<SelectedGoodInfoProvide>().goodInfo;
    print('_buildDownloadContainers ' + goodInfo.toString());
    return Column(
      children: [
        enableSingleImageDownloadA
            ? _buildDownloadHeaderContainerA(goodInfo)
            : _buildDownloadHeaderContainerB("lib/images/TOP_HEADER_1.JPG"),
        enableSingleImageDownloadA
            ? Container()
            : _buildImageSwiperBottom(true),
        enableSingleImageDownloadA
            ? _buildDownloadProductDetailInfo(goodInfo)
            : Container(
                margin: EdgeInsets.only(top: 60 * rpx),
                child: Text(
                  'a',
                ),
              ),
        // : isToday
        //     ? _buildProductListHeaderContainer(
        //         'PICK SUPER LIST', '甄选超榜', '#今日上新# 每日20:00准时更新甄选榜单', true)
        //     : _buildProductListHeaderContainer(
        //         'TIMEKEEPING LIST', '即将下架', '#限时低价# 今日20:00下架产品', true),
        _downloadSingleProductContainer(goodInfo),
        buildCommonBottom(
          Colors.white,
          rpx,
        )
      ],
    );
  }

  Widget _buildDownloadProductDetailInfo(goodInfo) {
    int len = goodInfo.description.toString().length;
    int substractCounts = 0;
    int modShift = 0;
    for (int i = 0; i < len; i++) {
      if (isAlphabetOrNumber(goodInfo.description.toString()[i])) {
        substractCounts++;
      }
    }
    len -= substractCounts;

    int mod = len ~/ 3;
    for (int i = 0; i < mod; i++) {
      if (isAlphabetOrNumber(goodInfo.description.toString()[i])) {
        modShift++;
      }
    }
    mod += modShift ~/ 2;
    for (int i = mod; i < len; i++) {
      if (isAlphabetOrNumber(goodInfo.description.toString()[i])) {
        mod++;
      } else {
        break;
      }
    }

    String firstLine = goodInfo.description.toString().substring(0, mod);
    String secordLine = goodInfo.description.toString().substring(mod, len);

    return Container(
      margin: EdgeInsets.only(
          left: 100 * rpx, right: 100 * rpx, top: 50 * rpx, bottom: 30 * rpx),
      width: 700 * rpx,
      alignment: Alignment.center,
      child: Column(children: [
        Text(firstLine,
            style: TextStyle(
              fontSize: 30 * rpx,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            )),
        Container(
          margin: EdgeInsets.only(top: 20 * rpx),
          child: Text(secordLine,
              style: TextStyle(
                fontSize: 30 * rpx,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              )),
        ),
        _buildDownloadImagePrice(goodInfo)
      ]),
    );
  }

  Widget _buildDownloadImagePrice(goodInfo) {
    return Container(
      margin: EdgeInsets.only(top: 20 * rpx, left: 70 * rpx),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('￥',
              style: TextStyle(
                fontSize: 26 * rpx,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          Text('${goodInfo.groupPrice}',
              style: TextStyle(
                fontSize: 40 * rpx,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          Container(
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              '￥${goodInfo.oriPrice} ',
              style: TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                  fontSize: 28 * rpx,
                  fontWeight: FontWeight.w300),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadHeaderContainerA(goodInfo) {
    return Container(
      width: 750 * rpx,
      margin: EdgeInsets.only(top: 100 * rpx, bottom: 30 * rpx),
      child: Row(
          children: [
        Container(
          width: 200 * rpx,
          height: 160 * rpx,
          margin: EdgeInsets.only(
              left: 30 * rpx, top: 10 * rpx, right: 50 * rpx, bottom: 0 * rpx),
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50.0 * rpx),
                bottomRight: Radius.circular(50.0 * rpx)),
            border: new Border.all(width: 1 * rpx, color: Colors.white),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10 * rpx),
                child: Text('限时特卖',
                    style: TextStyle(
                        fontSize: 30 * rpx,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: EdgeInsets.only(top: 20 * rpx),
                child: Text(downloadStartDate,
                    style: TextStyle(
                        fontSize: 20 * rpx,
                        color: Colors.black,
                        fontWeight: FontWeight.w500)),
              ),
              Container(
                child: Text('~',
                    style: TextStyle(
                        fontSize: 20 * rpx,
                        color: Colors.black,
                        fontWeight: FontWeight.w500)),
              ),
              Container(
                child: Text(downloadEndDate,
                    style: TextStyle(
                        fontSize: 20 * rpx,
                        color: Colors.black,
                        fontWeight: FontWeight.w500)),
              )
            ],
          ),
        ),
        Container(
          width: 400 * rpx,
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // margin:
                // EdgeInsets.only(top: 30 * rpx, bottom: 30 * rpx, left: 10 * rpx),
                child: Text(
                  'Ms时代 x ',
                  style: TextStyle(
                      fontSize: 40 * rpx,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                // margin: EdgeInsets.only(top: 30 * rpx, bottom: 30 * rpx),
                child: Text(
                  goodInfo.brand.toString(),
                  style: TextStyle(
                      fontSize: 40 * rpx,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }

  Widget _buildDownloadHeaderContainerB(imagePath) {
    return Container(
      margin: EdgeInsets.only(top: 20 * rpx),
      child: ClipRRect(
        child: Image.asset(imagePath),
      ),
    );
  }

  Widget _buildProductListHeaderContainer(top, title, bottom, needForBlack) {
    return Container(
        height: 180 * rpx,
        width: 450 * rpx,
        margin: EdgeInsets.only(top: 80 * rpx, bottom: 30 * rpx),
        child: _buildProductListHeader(top, title, bottom, needForBlack));
  }

  Widget _downloadSingleProductContainer(goodInfo) {
    return Container(
      width: 700 * rpx,
      height: enableSingleImageDownloadA ? 400 * rpx : 420 * rpx,
      margin: EdgeInsets.only(
          left: 15 * rpx, top: 15 * rpx, right: 15 * rpx, bottom: 20 * rpx),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15.0 * rpx)),
        border: new Border.all(width: 1 * rpx, color: Colors.white),
      ),
      child: GestureDetector(
        onLongPress: _showSingleImage,
        child: Row(
          children: <Widget>[
            buildDownloadImageInfo(goodInfo),
            makeDownloadImageArea(
              goodInfo,
              enableSingleImageDownloadA ? 400 : 420,
            ),
          ],
        ),
      ),
    );
  }

  void _showSingleImage() {
    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(500, 75, 10, 0),
        items: <PopupMenuEntry>[
          PopupMenuItem(
            child: Card(
              child: Row(children: [
                Container(
                  margin: EdgeInsets.only(left: 10 * rpx),
                  child: Padding(
                    child: Text(
                      "预览单品素材",
                      style: TextStyle(color: Colors.black, fontSize: 13),
                    ),
                    padding: EdgeInsets.only(left: 5, bottom: 5),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            enableSingleImageDownloadA = true;
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 20 * rpx),
                          child: Row(
                            children: [
                              Image.asset(
                                "lib/images/A.png",
                                height: 30,
                                width: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                      padding: EdgeInsets.only(right: 5),
                    ),
                    Padding(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            enableSingleImageDownloadB = true;
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 10 * rpx),
                          child: Row(
                            children: [
                              Image.asset(
                                "lib/images/B.png",
                                height: 30,
                                width: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                      padding: EdgeInsets.only(right: 5),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ]);
  }

  _saveSingleImage() async {
    RenderRepaintBoundary boundary =
        _repaintSingleImageKey.currentContext.findRenderObject();
    var image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();

    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(pngBytes + pngBytes),
        quality: 60,
        name: "save single image.");
    _returnGroupGoodsPageConfirm();
    print(result);
  }

  _returnGroupGoodsPageConfirm() {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          backgroundColor: Colors.black45,
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10 * rpx),
                  child: Text('素材保存成功，是否返回首页？',
                      style:
                          TextStyle(fontSize: 25 * rpx, color: Colors.white)),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('否',
                  style: TextStyle(fontSize: 23 * rpx, color: Colors.white)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text('是',
                  style: TextStyle(fontSize: 25 * rpx, color: Colors.white)),
              onPressed: () {
                RouterHome.flutoRouter
                    .navigateTo(context, RouterConfig.groupGoodsPath);
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildTitleAndPrice(val, today) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  top: 60 * rpx, left: 50 * rpx, right: 50 * rpx),
              child: Text(
                val['title'],
                maxLines: 3,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 28 * rpx,
                    color: goodsFontColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          _buildPrice(val),
          today == true
              ? _buildOrderingContainer(val)
              : _buildWillOrderContainer(val)
        ],
      ),
    );
  }

  Widget buildDownloadImageInfo(goodInfo) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  top: enableSingleImageDownloadA ? 60 * rpx : 50 * rpx,
                  left: 50 * rpx,
                  right: 50 * rpx),
              child: Text(
                goodInfo.title.toString(),
                maxLines: 3,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 28 * rpx,
                    color: goodsFontColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Container(
            width: enableSingleImageDownloadA ? 280 * rpx : 300 * rpx,
            height: enableSingleImageDownloadA ? 70 * rpx : 100 * rpx,
            margin:
                EdgeInsets.only(left: 20 * rpx, bottom: 0 * rpx, top: 60 * rpx),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: enableSingleImageDownloadA ? 280 * rpx : 300 * rpx,
                  height: enableSingleImageDownloadA ? 70 * rpx : 100 * rpx,
                  child: Column(
                    children: [
                      enableSingleImageDownloadA
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text('(市场价)',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15.0 * rpx,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontWeight: FontWeight.w300)),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10 * rpx),
                                  child: Text(
                                    '￥${goodInfo.oriPrice}',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 23.0 * rpx,
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ],
                            ),
                      Container(
                        margin: EdgeInsets.only(bottom: 15 * rpx),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('(特卖价)',
                                style: TextStyle(
                                    color: goodsFontColor,
                                    fontSize: 15.0 * rpx,
                                    fontWeight: FontWeight.w600)),
                            Text(
                              '￥${goodInfo.groupPrice}',
                              style: TextStyle(
                                  color: goodsFontColor,
                                  fontSize: 35.0 * rpx,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
          _buildDownloadButtonContainer()
        ],
      ),
    );
  }

  Widget buildOrderingContainer(val) {
    return Container(
      margin: EdgeInsets.only(right: 10 * rpx, bottom: 10 * rpx),
      padding: EdgeInsets.only(right: 20 * rpx, left: 20 * rpx),
      width: 150 * rpx,
      height: 80 * rpx,
      decoration: new BoxDecoration(
        //背景
        color: Colors.black,
        //设置四周圆角 角度
        borderRadius: BorderRadius.all(Radius.circular(30.0 * rpx)),
        //设置四周边框
        border: new Border.all(width: 1 * rpx, color: Colors.white),
      ),
      child: Row(
        children: [
          Text(
            '￥ ',
            style: TextStyle(
                color: priceColor,
                fontSize: 20.0 * rpx,
                fontWeight: FontWeight.bold),
          ),
          Text(
            '${val['groupPrice']}',
            style: TextStyle(
                color: priceColor,
                fontSize: 35.0 * rpx,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPrice(val) {
    return Container(
      width: 400 * rpx,
      height: 40 * rpx,
      margin: EdgeInsets.only(left: 40 * rpx, bottom: 20 * rpx),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 200 * rpx,
            height: 40 * rpx,
            child: Row(
              children: [
                Row(
                  children: [
                    Text('￥',
                        style: TextStyle(
                            color: goodsFontColor,
                            fontSize: 24.0 * rpx,
                            fontWeight: FontWeight.w600)),
                    Text(
                      '${val['groupPrice']}',
                      style: TextStyle(
                          color: goodsFontColor,
                          fontSize: 35.0 * rpx,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 10 * rpx),
                  child: Text(
                    '￥${val['oriPrice']}',
                    style: TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                        fontSize: 25 * rpx,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  Widget _buildDownloadButtonContainer() {
    return Container(
      margin: EdgeInsets.only(left: 20 * rpx, bottom: 50 * rpx),
      width: 260 * rpx,
      height: 40 * rpx,
      color: Colors.black,
      child: FlatButton(
        child: Text(
          '即刻选购',
          style: TextStyle(
              fontSize: 20 * rpx,
              color: Colors.white,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Widget _buildOrderingContainer(val) {
    return Container(
      margin: EdgeInsets.only(left: 40 * rpx, bottom: 30 * rpx),
      width: 220 * rpx,
      height: 50 * rpx,
      //边框设置
      decoration: new BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20 * rpx),
            topRight: Radius.circular(20 * rpx)),
      ),
      child: Container(
        alignment: Alignment.center,
        width: 200 * rpx,
        child: Text(
          '立即下单',
          style: TextStyle(
              fontSize: 23 * rpx,
              color: Colors.white,
              fontWeight: FontWeight.w400),
        ),
      ),
      // child: FlatButton(
      //     child: Text(
      //       '立即下单',
      //       style: TextStyle(
      //           fontSize: 23 * rpx,
      //           color: Colors.white,
      //           fontWeight: FontWeight.w400),
      //     ),
      //     onPressed: () {
      //         // context.read<SelectedGoodInfoProvide>().getGoodInfosById(val['goodId']);
      //         // Provider.of<GoodSelectBottomProvide>(context, listen: false).clear();
      //         // Provider.of<OrderInfoAddReciverProvide>(context, listen: false).clear();
      //         // Provider.of<ReceiverAddressProvide>(context, listen: false).clear();
      //         //
      //         // DataList goodInfo = context.read<SelectedGoodInfoProvide>().goodInfo;
      //         // showBottomItems(goodInfo, context, rpx);
      //     }),
    );
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

  // Future _getGoodInfos(BuildContext context, int goodId) async {
  //   return Provide.value<OrderingInfosProvide>(context)
  //       .getGoodInfosById(goodId);
  // }

  Widget _buildWillOrderContainer(val) {
    return Container(
      margin: EdgeInsets.only(left: 40 * rpx, bottom: 30 * rpx),
      width: 220 * rpx,
      height: 50 * rpx,
      //边框设置
      decoration: new BoxDecoration(
        color: goodsFontColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20 * rpx),
            topRight: Radius.circular(20 * rpx)),
      ),
      child: Container(
        alignment: Alignment.center,
        child: Text(
          '即将开启',
          style: TextStyle(
              fontSize: 23 * rpx,
              color: Colors.white,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Widget createGroupPriceContainer(val) {
    return Container(
      width: 200 * rpx,
      height: 80 * rpx,
      //边框设置
      decoration: new BoxDecoration(
        color: priceContainerColor,
      ),
      child: Center(
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 45 * rpx),
              child: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '￥ ${val['groupPrice']} ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 38.0 * rpx,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget makeDownloadImageArea(goodInfo, size) {
    String imageUrl = QINIU_OBJECT_STORAGE_URL + goodInfo.mainImage;
    return Container(
      margin: EdgeInsets.only(left: 10 * rpx, right: 10 * rpx),
      width: size * rpx,
      height: size * rpx,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20 * rpx),
        child: goodInfo.mainImage == null ? '' : Image.network(imageUrl),
      ),
    );
  }

  Widget makeImageArea(val, size) {
    String imageUrl = QINIU_OBJECT_STORAGE_URL + val['mainImage'];
    return Container(
      margin: EdgeInsets.only(left: 10 * rpx, right: 10 * rpx),
      width: size * rpx,
      height: size * rpx,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20 * rpx),
        child: val['mainImage'] == null ? '' : Image.network(imageUrl),
      ),
    );
  }

  void getTommorrowGroupGoods() {
    FormData formData = new FormData.fromMap({
      "groupStartDate":
          formatDate(DateTime.now().add(Duration(days: 1)), ymdFormat)
    });

    requestDataByUrl('queryGoodsList', formData: formData).then((val) {
      var data = json.decode(val.toString());
      List<Map> newGoodList = (data['dataList'] as List).cast();
      setState(() {
        _tommorrowGoodList.addAll(newGoodList);
      });
    });
  }

  void getTodayGroupGoods() {
    FormData formData = new FormData.fromMap(
        {"groupStartDate": formatDate(DateTime.now(), ymdFormat)});

    requestDataByUrl('queryGoodsList', formData: formData).then((val) {
      var data = json.decode(val.toString());
      List<Map> newGoodList = (data['dataList'] as List).cast();
      print('newGoodList data ' + newGoodList.toString());

      newGoodList
          .map((val) => {
                if (val['hotSale'].toString() == '1')
                  {
                    hotImages.add(val['hotSaleImage'].toString()),
                    hotGoodIds.add(val['goodId'].toString())
                  }
              })
          .toList();

      print('hotImages ' + hotImages.toString());
      print('hotGoodIds ' + hotGoodIds.toString());

      setState(() {
        _todayGoodList.addAll(newGoodList);
      });
    });
  }

  void getYesterdayGroupGoods() {
    FormData formData = new FormData.fromMap({
      "groupStartDate":
          formatDate(DateTime.now().add(Duration(days: -1)), ymdFormat)
    });

    requestDataByUrl('queryGoodsList', formData: formData).then((val) {
      var data = json.decode(val.toString());

      List<Map> newGoodList = (data['dataList'] as List).cast();

      newGoodList
          .map((val) => {
                if (val['hotSale'].toString() == '1')
                  {
                    hotImages.add(val['hotSaleImage'].toString()),
                    hotGoodIds.add(val['goodId'].toString())
                  }
              })
          .toList();

      setState(() {
        _yesterdayGoodList.addAll(newGoodList);
      });
    });
  }
}
