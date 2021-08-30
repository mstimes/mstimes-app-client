import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:mstimes/provide/drawing_record_provide.dart';
import 'package:mstimes/provide/select_discount.dart';
import 'package:provide/provide.dart';
import 'package:mstimes/pages/product/group/group_goods.dart';
import 'package:mstimes/provide/detail_good_infos.dart';
import 'package:mstimes/provide/order_info_add.dart';
import 'package:mstimes/provide/reveiver_address_provide.dart';
import 'package:mstimes/provide/upload_order_provide.dart';
import 'package:mstimes/provide/upload_release_provide.dart';
import 'package:mstimes/routers/router_config.dart';
import 'provide/good_select_type.dart';

Future<void> main() async {
  // init router
  final FluroRouter fluroRouter = FluroRouter();
  RouterConfig.defineRouters(fluroRouter);
  RouterHome.flutoRouter = fluroRouter;

  // init provider
  var detailInfoProvider = DetailGoodInfoProvide();
  var goodTypeBadgerProvide = GoodSelectBottomProvide(0, 1);
  var orderInfoAddReciverProvide = OrderInfoAddReciverProvide();
  var receiverAddressProvide = ReceiverAddressProvide();
  var uploadGoodInfosProvide = UploadGoodInfosProvide();
  var uploadOrderProvide = UploadOrderProvide();
  var drawingRecordProvide = DrawingRecordProvide();
  var selectDiscountProvide = SelectDiscountProvide();

  var providers = Providers();
  providers
    ..provide(Provider<DetailGoodInfoProvide>.value(detailInfoProvider))
    ..provide(Provider<GoodSelectBottomProvide>.value(goodTypeBadgerProvide))
    ..provide(
        Provider<OrderInfoAddReciverProvide>.value(orderInfoAddReciverProvide))
    ..provide(Provider<ReceiverAddressProvide>.value(receiverAddressProvide))
    ..provide(Provider<UploadOrderProvide>.value(uploadOrderProvide))
    ..provide(Provider<DrawingRecordProvide>.value(drawingRecordProvide))
    ..provide(Provider<UploadGoodInfosProvide>.value(uploadGoodInfosProvide))
    ..provide(Provider<SelectDiscountProvide>.value(selectDiscountProvide));

  runApp(ProviderNode(
      child: MaterialApp(
        title: "MsTimes App",
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: GroupGoods(),
            // child: ScreenShotPage(),
          ),
        ),
      ),
      providers: providers));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    //设置启动图生效时间
    var _duration = new Duration(seconds: 6);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Image.asset('lib/images/Default~iphone.png'),
      ),
    );
  }
}
