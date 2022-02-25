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
import 'package:mstimes/model/local_share/account_info.dart';
import 'package:mstimes/model/local_share/order_info.dart';
import 'package:mstimes/pages/product/group/hot_swiper.dart';
import 'package:mstimes/pages/product/group/main_page_widgets.dart';
import 'package:mstimes/provide/select_good_provider.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:mstimes/tools/common_container.dart';
import 'package:mstimes/utils/color_util.dart';
import 'package:mstimes/utils/date_utils.dart';
import 'package:permission_handler/permission_handler.dart';
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
  List<Map> _todayGoodList = [];
  List<Map> _yesterdayGoodList = [];
  List<Map> _mondayGoodList = [];
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
  String downloadStartDate = formatDate(DateTime.now(), mdFormat);
  String downloadEndDate =
      formatDate(DateTime.now().add(Duration(days: 1)), mdFormat);
  String appletCodePath = '';

  @override
  void initState() {
    super.initState();
    // var permission =  PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    PermissionHandler().requestPermissions(<PermissionGroup>[
      PermissionGroup.storage,
    ]);

    // init wechat register
    print('init ...fluxwx');
    initFluwx();
    isInstallFluwx();

    // init apple register
    initApplePlatformState(context);

    getTodayGroupGoods();
    getYesterdayGroupGoods();
    getMondayGroupGoods();

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
                  color: enableSingleImageDownloadA ? Colors.black : Colors.white,
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
      var goodInfo = context.read<SelectedGoodInfoProvide>().goodInfo;
      return SpeedDial(
          backgroundColor: Colors.black26,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          children: [
            SpeedDialChild(
                child: Icon(
                  Icons.download_sharp,
                  color: Colors.black,
                ),
                onTap: () => {
                  if (_needSaveLongImage())
                    {_saveLongImage()}
                  else
                    {_saveSingleImage()}
                }
            ),
            SpeedDialChild(
                child: Icon(
                  Icons.dashboard,
                  color: Colors.black,
                ),
                onTap: () => {
                  if(checkIsLogin(context)){
                    _getAppletCode(UserInfo.getUserInfo().userNumber, goodInfo.goodId)
                  }
                }
            )
          ]
          );
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

    returnGroupGoodsPageConfirm(context, rpx);
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
              buildDownloadHeaderContainerB("lib/images/TOP_HEADER_1.JPG", rpx));
        } else if (saveLongPatternB) {
          todayTotalWrapList.add(
              buildDownloadHeaderContainerB("lib/images/TOP_HEADER_2.JPG", rpx));
        } else {
          todayTotalWrapList.add(
              buildDownloadHeaderContainerB("lib/images/TOP_HEADER_3.JPG", rpx));
        }
      }

      todayTotalWrapList
          .add(buildImageSwiperBottom(_needSaveLongImageForBlack(), rpx));

      todayTotalWrapList.add(
        buildProductListHeaderContainer('PICK SUPER LIST', '甄选超榜',
            '#今日上新# 每日20:00准时更新甄选榜单', _needSaveLongImageForBlack(), 80, rpx),
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
            child: _buildSingleProductContainer(val, 1));
      }).toList();
      todayTotalWrapList.addAll(listWidget);

      if (_yesterdayGoodList.length != 0) {
        todayTotalWrapList.add(buildProductListHeaderContainer(
            'TIMEKEEPING LIST',
            '计时榜单',
            '#即将下架# 明日20:00即将下架产品',
            _needSaveLongImageForBlack(), 80, rpx));

        List<Widget> yesterdayListWidget = _yesterdayGoodList.map((val) {
          return InkWell(
              onTap: () {
                RouterHome.flutoRouter.navigateTo(
                  context,
                  RouterConfig.detailsPath +
                      "?id=${val['goodId']}&showPay=true",
                );
              },
              child: _buildSingleProductContainer(val, 2));
        }).toList();

        todayTotalWrapList.addAll(yesterdayListWidget);
      }

      if (_mondayGoodList.length != 0) {
        todayTotalWrapList.add(buildProductListHeaderContainer(
            '',
            '好生活 没那么贵',
            '#每周更新# 每周一10:00准时上架产品',
            _needSaveLongImageForBlack(), 0, rpx));

        List<Widget> mondayListWidget = _mondayGoodList.map((val) {
          return InkWell(
              onTap: () {
                RouterHome.flutoRouter.navigateTo(
                  context,
                  RouterConfig.detailsPath +
                      "?id=${val['goodId']}&showPay=true",
                );
              },
              child: _buildSingleProductContainer(val, 3));
        }).toList();

        todayTotalWrapList.addAll(mondayListWidget);
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


  Widget _buildSingleProductContainer(val, type) {
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
          context.read<SelectedGoodInfoProvide>().getGoodInfosById(val['goodId']);
          if (type == 1) {
            downloadStartDate =
                formatDate(DateTime.now().add(Duration(days: 0)), mdFormat) + ' 20:00';
            downloadEndDate = formatDate(DateTime.now().add(Duration(days: 2)), mdFormat) + ' 20:00';
          }else if(type == 2){
            downloadStartDate =
                formatDate(DateTime.now().add(Duration(days: -1)), mdFormat) + ' 20:00';
            downloadEndDate = formatDate(DateTime.now().add(Duration(days: 1)), mdFormat) + ' 20:00';
          }else if(type == 3){
            var nowDayOfWeek = DateTime.now().weekday;
            downloadStartDate =
                formatDate(DateTime.now().add(Duration(days: 1 - nowDayOfWeek)), mdFormat) + ' 10:00';
            print('downloadStartDate ' + downloadStartDate.toString());

            downloadEndDate =
                formatDate(DateTime.now().add(Duration(days: 8 - nowDayOfWeek)), mdFormat) + ' 10:00';
            print('downloadEndDate ' + downloadEndDate.toString());

          }
        },
        child: Row(
          children: <Widget>[
            makeImageArea(val, 360, rpx),
            buildTitleAndPrice(val, true, rpx),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadContainers() {
    var goodInfo = context.read<SelectedGoodInfoProvide>().goodInfo;
    return Column(
      children: [
        enableSingleImageDownloadA
            ? buildDownloadHeaderContainerA(goodInfo, downloadStartDate, downloadEndDate, rpx)
            // : _buildDownloadHeaderContainerB("lib/images/TOP_HEADER_1.JPG"),
            : buildShareSingeProductBigImage(goodInfo.detailImages[0], rpx),
        // enableSingleImageDownloadA
        //     ? Container()
        //     : buildImageSwiperBottom(true, rpx),
        enableSingleImageDownloadA
            ? buildDownloadProductDetailInfoA(goodInfo, rpx)
            : buildDownloadProductDetailInfoB(goodInfo, appletCodePath, downloadEndDate, rpx, context),
        enableSingleImageDownloadA ? _downloadSingleProductContainer(goodInfo) : Container(),
        enableSingleImageDownloadA ? buildCommonBottom(
          Colors.white,
          rpx,
        ) : Container(),
      ],
    );
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
        // onLongPress: _showSingleImage(goodInfo.goodId),
        child: Row(
          children: <Widget>[
            buildDownloadImageInfo(goodInfo, enableSingleImageDownloadA, rpx),
            makeDownloadImageArea(
              goodInfo,
              enableSingleImageDownloadA ? 400 : 420,
              rpx
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
                          if(checkIsLogin(context)){
                            setState(() {
                              enableSingleImageDownloadB = true;
                              Navigator.pop(context);
                            });
                          }
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
    returnGroupGoodsPageConfirm(context, rpx);
    print(result);
  }


  void getTodayGroupGoods() {
    FormData formData = new FormData.fromMap(
        {
          "type" : 1
        });

    requestDataByUrl('queryGoodsListByType', formData: formData).then((val) {
      var data = json.decode(val.toString());
      List<Map> newGoodList = (data['dataList'] as List).cast();
      print('newGoodList data ' + newGoodList.toString());

      newGoodList
          .map((val) => {
                if (val['hotSale'].toString() == '1')
                  {
                    hotImages.add(val['hotSaleImage'].toString()),
                    hotGoodIds.add(val['goodId'].toString())
                  },
      }).toList();

      setState(() {
        _todayGoodList.addAll(newGoodList);
      });
    });
  }

  void getYesterdayGroupGoods() {
    FormData formData = new FormData.fromMap({
      "type" : 2
    });

    requestDataByUrl('queryGoodsListByType', formData: formData).then((val) {
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

  void getMondayGroupGoods() {
    FormData formData = new FormData.fromMap(
        {
          "type" : 4
        });

    requestDataByUrl('queryGoodsListByType', formData: formData).then((val) {
      var data = json.decode(val.toString());
      List<Map> mondayGoodList = (data['dataList'] as List).cast();
      print('mondayGoodList data ' + mondayGoodList.toString());

      mondayGoodList
          .map((val) => {
        if (val['hotSale'].toString() == '1')
          {
            hotImages.add(val['hotSaleImage'].toString()),
            hotGoodIds.add(val['goodId'].toString())
          },

      }).toList();

      setState(() {
        _mondayGoodList.addAll(mondayGoodList);
      });
    });
  }

  void _getAppletCode(shareUser, goodId) {
    FormData formData = new FormData.fromMap({
      'shareUser': shareUser,
      'goodId': goodId,
    });

    requestDataByUrl('queryAppletCodeToken', formData: formData).then((val) {
      var data = json.decode(val.toString());
      print("getAppletCode file path " + data['dataList'][0].toString());
      setState(() {
        appletCodePath = data['dataList'][0].toString();
      });
    });
  }

}