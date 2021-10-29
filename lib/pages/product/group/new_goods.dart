import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mstimes/common/provider_call.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/pages/order/product_select.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:mstimes/utils/color_util.dart';
import 'package:mstimes/utils/date_utils.dart';

import '../../../common/valid.dart';

class NewGoods extends StatefulWidget {
  @override
  _NewGoodsState createState() => _NewGoodsState();
}

class GroupChoiceTab {
  final String title;
  const GroupChoiceTab({this.title});
}

const List<GroupChoiceTab> groupChoiceTabs = const <GroupChoiceTab>[
  const GroupChoiceTab(title: "今日好物"),
  // const GroupChoiceTab(title: "明日预告"),
];

class _NewGoodsState extends State<NewGoods> {
  int pageCount = 1;
  List<Map> _tommorrowGoodList = [];
  double rpx;
  List<Widget> tommorrowWrapList = new List();
  GlobalKey _repaintKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    getTommorrowGroupGoods();
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return DefaultTabController(
      length: groupChoiceTabs.length,
      child: Scaffold(
        backgroundColor: homeBackgroundColor,
        appBar: AppBar(
          backgroundColor: homeBackgroundColor,
          toolbarHeight: 80 * rpx,
          elevation: 0,
          title: Text(
            '全球严选好物  尽在Ms时代',
            style: TextStyle(
                fontSize: 30 * rpx,
                fontWeight: FontWeight.w400,
                color: backgroundFontColor),
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: RepaintBoundary(
                    child: Container(
                      width: double.infinity,
                      color: homeBackgroundColor,
                      child: GestureDetector(
                        onLongPress: _showCustomMenu,
                        child: Column(children: _tomorrowWrapList()),
                      ),
                    ),
                  )),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            RouterHome.flutoRouter
                .navigateTo(context, RouterConfig.groupGoodsPath);
          },
          backgroundColor: Colors.black26,
          // child: Icon(
          //   CupertinoIcons.house,
          //   color: Colors.white,
          //   semanticLabel: "首页",
          // ),
          child: Image.asset(
            'lib/images/home1.png',
            height: 50 * rpx,
            width: 50 * rpx,
          ),
          tooltip: "main",
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }

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
                      "",
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
    // return FloatingActionButton(
    //   isExtended: true,
    //   onPressed: () {
    //     // if (checkIsLogin(context)) {
    //     //   RouterHome.flutoRouter.navigateTo(context, RouterConfig.myPagePath);
    //     // }
    //   },
    //   backgroundColor: Colors.black26,
    //   child: ListView(
    //     children: [
    //       IconButton(
    //           icon: Icon(CupertinoIcons.person,
    //               color: Colors.white, semanticLabel: "我的"),
    //           onPressed: () {
    //             if (checkIsLogin(context)) {
    //               RouterHome.flutoRouter
    //                   .navigateTo(context, RouterConfig.myPagePath);
    //             }
    //           }),
    //       IconButton(
    //           icon: Icon(CupertinoIcons.person,
    //               color: Colors.white, semanticLabel: "我的"),
    //           onPressed: () {
    //             if (checkIsLogin(context)) {
    //               RouterHome.flutoRouter
    //                   .navigateTo(context, RouterConfig.myPagePath);
    //             }
    //           })
    //     ],
    //   ),
    //   tooltip: "my",
    // );
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

  // Widget _getTomorrow() {
  //   return EasyRefresh(
  //     child: _tomorrowWrapList(),
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

  List<Widget> _tomorrowWrapList() {
    print('_tomorrowWrapList length ' + _tommorrowGoodList.length.toString());

    if (_tommorrowGoodList.length > 0) {
      tommorrowWrapList.clear();
      tommorrowWrapList.add(Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 60 * rpx, bottom: 20 * rpx),
        child: Column(
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
      // return ListView(
      //   children: tommorrowWrapList,
      // );
      return tommorrowWrapList;
    } else {
      return List();
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
      margin: EdgeInsets.only(left: 40 * rpx, bottom: 20 * rpx),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 230 * rpx,
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
              print('new_goods ... ' + val['goodId'].toString());
              // getGoodInfosById(val['goodId'], context);
              showBottomItems(val['goodId'], context, rpx);
            }
          }),
    );
  }

  // Future _getGoodInfos(BuildContext context, int goodId) async {
  //   return Provide.value<DetailGoodInfoProvide>(context)
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

  Widget makeImageArea(val) {
    String imageUrl = QINIU_OBJECT_STORAGE_URL + val['mainImage'];
    return Container(
      margin: EdgeInsets.only(left: 10 * rpx, right: 10 * rpx),
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
      "type": 3
      // "groupStartDate":
      //     formatDate(DateTime.now().add(Duration(days: 1)), ymdFormat)
    });

    requestDataByUrl('queryGoodsListByType', formData: formData).then((val) {
      var data = json.decode(val.toString());
      List<Map> newGoodList = (data['dataList'] as List).cast();
      setState(() {
        _tommorrowGoodList.addAll(newGoodList);
      });
    });
  }
}
