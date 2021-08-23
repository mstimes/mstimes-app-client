import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/local_share/account_info.dart';
import 'package:mstimes/order/product_select.dart';
import 'package:mstimes/provide/detail_good_infos.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:mstimes/utils/color_util.dart';
import 'package:mstimes/utils/date_utils.dart';
import 'package:provide/provide.dart';

import '../common/valid.dart';

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
  GlobalKey _repaintKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    getTommorrowGroupGoods();
    getTodayGroupGoods();
    getYesterdayGroupGoods();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Material(
  //     child: Scaffold(
  //       appBar: AppBar(title: Text('屏幕截图')),
  //       body: SafeArea(
  //         child: Stack(
  //           children: <Widget>[
  //             Positioned(
  //               left: 0,
  //               right: 0,
  //               top: 0,
  //               bottom: 60,
  //               child: SingleChildScrollView(
  //                   scrollDirection: Axis.vertical,
  //                   child: RepaintBoundary(
  //                     key: _repaintKey,
  //                     child: Container(
  //                       width: double.infinity,
  //                       color: Color(0xffe8eaed),
  //                       child: Column(
  //                         children: _getTodayWrapList(),
  //                       ),
  //                     ),
  //                   )),
  //             ),
  //             Positioned(
  //                 left: 0,
  //                 right: 0,
  //                 bottom: 0,
  //                 height: 60,
  //                 child: _bottomWidget()),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  List<Widget> _listWidget() {
    List<Widget> _list = List();
    for (int index = 0; index < 100; index++) {
      _list
          .add(Container(height: 50, child: Center(child: Text('屏幕截图$index'))));
    }
    return _list;
  }

  ///bottomWidget
  Widget _bottomWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      height: 60,
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: RaisedButton(
          color: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          onPressed: () {
            // showLoading(msg: '图片生成中...');
            _save();
          },
          child:
              Text('完成', style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return DefaultTabController(
      length: groupChoiceTabs.length,
      // scrollDirection: Axis.vertical,
      child: Stack(
        children: [
          RepaintBoundary(
            key: _repaintKey,
            child: Scaffold(
              backgroundColor: homeBackgroundColor,
              body: GestureDetector(
                onLongPress: _showCustomMenu,
                child: ListView(
                  children: _listWidget(),
                ),
              ),
              floatingActionButton: showFloatingActionButton(),
            ),
          ),
          Positioned(
              left: 0, right: 0, bottom: 0, height: 60, child: _bottomWidget()),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   rpx = MediaQuery.of(context).size.width / 750;
  //   return DefaultTabController(
  //     length: groupChoiceTabs.length,
  //     // scrollDirection: Axis.vertical,
  //     child: RepaintBoundary(
  //       key: _repaintKey,
  //       child: Scaffold(
  //         backgroundColor: homeBackgroundColor,
  //         // appBar: PreferredSize(
  //         //   child: AppBar(
  //         //       backgroundColor: mainColor,
  //         //       primary: true,
  //         //       elevation: 0,
  //         //       automaticallyImplyLeading: false,
  //         //       toolbarHeight: 120 * rpx,
  //         //       bottom: TabBar(
  //         //         indicatorWeight: 2.0,
  //         //         indicatorColor: Colors.white,
  //         //         tabs: groupChoiceTabs.map((GroupChoiceTab groupChoiceTab) {
  //         //           return Tab(
  //         //             text: groupChoiceTab.title,
  //         //           );
  //         //         }).toList(),
  //         //       ),
  //         //       title: Text(
  //         //         '她时代  ·  正当下',
  //         //         style: TextStyle(
  //         //             fontSize: 35 * rpx,
  //         //             fontWeight: FontWeight.w400,
  //         //             color: Colors.white),
  //         //       )),
  //         //   preferredSize: Size.fromHeight(100),
  //         // ),
  //         // body: GestureDetector(
  //         //   onLongPress: _showCustomMenu,
  //         //   child: TabBarView(children: [
  //         //     _getToday()
  //         //     // , _getTomorrow()
  //         //   ]),
  //         // ),
  //         // body: GestureDetector(
  //         //   onLongPress: _showCustomMenu,
  //         //   child: Column(
  //         //     children: _getTodayWrapList(),
  //         //   )
  //         //   // , _getTomorrow()
  //         //   ,
  //         // ),
  //         body: GestureDetector(
  //           onLongPress: _showCustomMenu,
  //           child: ListView(
  //             children: _listWidget(),
  //           ),
  //         ),
  //         floatingActionButton: showFloatingActionButton(),
  //       ),
  //     ),
  //   );
  // }

  String url = "https://i.loli.net/2020/01/14/w1dcNtf4SECG6yX.jpg";

  Offset _tapPosition;

  void _showCustomMenu() {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(500, 75, 10, 0),
        items: <PopupMenuEntry>[
          PopupMenuItem(
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    child: InkWell(
                      onTap: () {
                        print('press download');
                        _save();
                      },
                      child: Image.asset(
                        "lib/images/vip.png",
                        height: 35,
                        width: 35,
                      ),
                    ),
                    padding: EdgeInsets.only(right: 5),
                  ),
                  Padding(
                    child: Text(
                      "发起群聊",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    padding: EdgeInsets.only(left: 5, bottom: 5),
                  ),
                ],
              ),
            ),
          ),
        ]);
  }

  _save() async {
    // var response = await Dio()
    //     .get(url, options: Options(responseType: ResponseType.bytes));

    RenderRepaintBoundary boundary =
        _repaintKey.currentContext.findRenderObject();
    var image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();

    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(pngBytes + pngBytes),
        quality: 60,
        name: "hello");
    print(result);
  }

  Widget showFloatingActionButton() {
    UserInfo userInfo = UserInfo.getUserInfo();
    if (userInfo.isAgent()) {
      return FloatingActionButton(
        onPressed: () {
          if (checkIsLogin(context)) {
            RouterHome.flutoRouter.navigateTo(context, RouterConfig.myPagePath);
          }
        },
        backgroundColor: Colors.black26,
        child: Icon(
          CupertinoIcons.person,
          color: Colors.white,
          semanticLabel: "我的",
        ),
        tooltip: "my",
      );
    }
  }

  // Widget _getToday() {
  //   return EasyRefresh(
  //     child: _getTodayWrapList(),
  //     header: ClassicalHeader(
  //       showInfo: false,
  //       textColor: backgroundFontColor,
  //       refreshingText: "Ms时代",
  //       refreshedText: "Ms时代",
  //       refreshText: "",
  //       refreshReadyText: "",
  //       noMoreText: "",
  //     ),
  //     onRefresh: () async {},
  //   );
  // }

  List<Widget> _getTodayWrapList() {
    if (_todayGoodList.length != 0) {
      todayTotalWrapList.clear();
      todayTotalWrapList.add(Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 30 * rpx, bottom: 20 * rpx),
        child: Stack(
          children: [
            Text(
              '甄选超榜',
              style: TextStyle(
                  color: backgroundFontColor,
                  fontSize: 35 * rpx,
                  fontWeight: FontWeight.w600),
            ),
            Container(
              margin: EdgeInsets.only(top: 5 * rpx),
              child: Text(
                '#今日上新#每天24:00更新榜单',
                style: TextStyle(
                  color: backgroundFontColor,
                  fontSize: 20 * rpx,
                ),
              ),
            )
          ],
        ),
      ));

      List<Widget> listWidget = _todayGoodList.map((val) {
        return InkWell(
          onTap: () {
            if (checkIsLogin(context)) {
              RouterHome.flutoRouter.navigateTo(
                context,
                RouterConfig.detailsPath + "?id=${val['goodId']}&showPay=true",
              );
            }
          },
          child: Container(
            width: 700 * rpx,
            height: 360 * rpx,
            margin: EdgeInsets.only(
                left: 15 * rpx,
                top: 15 * rpx,
                right: 15 * rpx,
                bottom: 20 * rpx),
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15.0 * rpx)),
              border: new Border.all(width: 1 * rpx, color: Colors.white),
            ),
            child: Row(
              children: [
                makeImageArea(val),
                buildTitleAndPrice(val, true),
              ],
            ),
          ),
        );
      }).toList();

      todayTotalWrapList.addAll(listWidget);

      if (_yesterdayGoodList.length != 0) {
        todayTotalWrapList.add(Container(
          margin: EdgeInsets.only(top: 30 * rpx, bottom: 30 * rpx),
          child: Column(
            children: [
              Text(
                '计时榜单',
                style: TextStyle(
                    color: backgroundFontColor,
                    fontSize: 35 * rpx,
                    fontWeight: FontWeight.w600),
              ),
              Container(
                margin: EdgeInsets.only(top: 5 * rpx),
                child: Text(
                  '#即将下架#明日24:00准时下架',
                  style: TextStyle(
                    color: backgroundFontColor,
                    fontSize: 20 * rpx,
                  ),
                ),
              )
            ],
          ),
        ));

        List<Widget> yesterdayListWidget = _yesterdayGoodList.map((val) {
          return InkWell(
            onTap: () {
              RouterHome.flutoRouter.navigateTo(
                context,
                RouterConfig.detailsPath + "?id=${val['goodId']}",
              );
            },
            child: Container(
              width: 700 * rpx,
              height: 360 * rpx,
              margin: EdgeInsets.only(
                  left: 15 * rpx,
                  top: 15 * rpx,
                  right: 15 * rpx,
                  bottom: 20 * rpx),
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15.0 * rpx)),
                border: new Border.all(width: 1 * rpx, color: Colors.white),
              ),
              child: Row(
                children: <Widget>[
                  makeImageArea(val),
                  buildTitleAndPrice(val, true),
                ],
              ),
            ),
          );
        }).toList();

        todayTotalWrapList.addAll(yesterdayListWidget);
      }

      _addGroupGoodsBottom(todayTotalWrapList);
      return listWidget;
    } else {
      return List();
    }
  }

  Widget _getTomorrow() {
    return EasyRefresh(
      child: _tomorrowWrapList(),
      header: ClassicalHeader(
        showInfo: false,
        textColor: backgroundFontColor,
        refreshingText: "Ms时代",
        refreshedText: "Ms时代",
        refreshText: "",
        refreshReadyText: "",
        noMoreText: "",
      ),
      onRefresh: () async {},
    );
  }

  Widget _tomorrowWrapList() {
    if (_tommorrowGoodList.length > 0) {
      tommorrowWrapList.clear();
      tommorrowWrapList.add(Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 30 * rpx, bottom: 20 * rpx),
        child: ListView(
          children: [
            Text(
              '新品尝鲜',
              style: TextStyle(
                  color: backgroundFontColor,
                  fontSize: 35 * rpx,
                  fontWeight: FontWeight.w600),
            ),
            Container(
              margin: EdgeInsets.only(top: 5 * rpx),
              child: Text(
                '#即将上新#今日24:00上新榜单',
                style: TextStyle(
                  color: backgroundFontColor,
                  fontSize: 20 * rpx,
                ),
              ),
            )
          ],
        ),
      ));

      List<Widget> listWidget = _tommorrowGoodList.map((val) {
        return InkWell(
          onTap: () {
            RouterHome.flutoRouter.navigateTo(
              context,
              RouterConfig.detailsPath + "?id=${val['goodId']}&showPay=false",
            );
          },
          child: Container(
            width: 700 * rpx,
            height: 360 * rpx,
            margin: EdgeInsets.only(
                left: 15 * rpx,
                top: 15 * rpx,
                right: 15 * rpx,
                bottom: 20 * rpx),
            //设置 child 居中
            // alignment: Alignment(0, 0),
            //边框设置
            decoration: new BoxDecoration(
              //背景
              color: Colors.white,
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(15.0 * rpx)),
              //设置四周边框
              border: new Border.all(width: 1 * rpx, color: Colors.white),
            ),
            child: Row(
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                makeImageArea(val),
                buildTitleAndPrice(val, false),
              ],
            ),
          ),
        );
      }).toList();

      tommorrowWrapList.addAll(listWidget);
      _addGroupGoodsBottom(tommorrowWrapList);
      return ListView(
        children: tommorrowWrapList,
      );
    } else {
      return Text('');
    }
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
      margin: EdgeInsets.only(left: 50 * rpx, bottom: 20 * rpx),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 300 * rpx,
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
      child: FlatButton(
          child: Text(
            '立即下单',
            style: TextStyle(
                fontSize: 23 * rpx,
                color: Colors.white,
                fontWeight: FontWeight.w400),
          ),
          onPressed: () {
            if (checkIsLogin(context)) {
              _getGoodInfos(context, val['goodId']);
              showBottomItems(val['goodId'], context);
            }
          }),
    );
  }

  Future _getGoodInfos(BuildContext context, int goodId) async {
    return Provide.value<DetailGoodInfoProvide>(context)
        .getGoodInfosById(goodId);
  }

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

  Widget makeImageArea(val) {
    String imageUrl = QINIU_OBJECT_STORAGE_URL + val['mainImage'];
    return Container(
      // margin: EdgeInsets.only(left: 10 * rpx, right: 10 * rpx),
      width: 360 * rpx,
      height: 360 * rpx,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20 * rpx),
        child: val['mainImage'] == null ? '' : Image.network(imageUrl),
      ),
    );
  }

  void _addGroupGoodsBottom(List<Widget> list) {
    list.add(Container(
      margin: EdgeInsets.only(top: 30 * rpx, bottom: 80 * rpx),
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 5 * rpx),
        child: Text(
          '她时代  ·  正如闺蜜般懂你',
          style: TextStyle(
              color: backgroundFontColor,
              fontSize: 28 * rpx,
              fontWeight: FontWeight.w600),
        ),
      ),
    ));
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
      setState(() {
        _yesterdayGoodList.addAll(newGoodList);
      });
    });
  }
}
