import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:mstimes/pages/login/home_alert.dart';
import 'package:mstimes/provide/add_reveiver_provide.dart';
import 'package:mstimes/provide/drawing_record_provide.dart';
import 'package:mstimes/provide/login_provide.dart';
import 'package:mstimes/provide/select_discount.dart';
import 'package:mstimes/provide/select_good_provider.dart';
import 'package:mstimes/pages/product/group/main_page.dart';
import 'package:mstimes/provide/order_info_add.dart';
import 'package:mstimes/provide/reveiver_address_provide.dart';
import 'package:mstimes/provide/upload_order_provide.dart';
import 'package:mstimes/provide/upload_release_provide.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'provide/good_select_type.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';


Future<void> main() async {
  // init router
  final FluroRouter fluroRouter = FluroRouter();
  RouterConfig.defineRouters(fluroRouter);
  RouterHome.flutoRouter = fluroRouter;

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SelectedGoodInfoProvide()),
          ChangeNotifierProvider(create: (_) => GoodSelectBottomProvide(0, 1)),
          ChangeNotifierProvider(create: (_) => OrderInfoAddReciverProvide()),
          ChangeNotifierProvider(create: (_) => ReceiverAddressProvide()),
          ChangeNotifierProvider(create: (_) => UploadGoodInfosProvide()),
          ChangeNotifierProvider(create: (_) => UploadOrderProvide()),
          ChangeNotifierProvider(create: (_) => DrawingRecordProvide()),
          ChangeNotifierProvider(create: (_) => SelectDiscountProvide()),
          ChangeNotifierProvider(create: (_) => AddReceiverAddressProvide()),
          ChangeNotifierProvider(create: (_) => LoginProvide()),
        ],
      child: MaterialApp(
        title: "MsTimes App",
        // localizationsDelegates: [
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        //   GlobalCupertinoLocalizations.delegate,
        // ],
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: GroupGoods(),
            // child: HomeAlertPage(),
          ),
        ),
        // routes: <String, WidgetBuilder>{
        //   '/GroupGoodsPage': (BuildContext context) => new GroupGoods(),
        //   '/HomeAlertPage': (BuildContext context) => new HomeAlertPage(),
        // },
      )
    ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double rpx;
  bool notFirst = true;

  startTime() async {
    //设置启动图生效时间
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/HomeAlertPage');
  }

  @override
  void initState() {
    super.initState();
    startTime();
    get().then((value) => {});
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;

    return new Scaffold(
      body: (notFirst == null || !notFirst) ? HomeAlertPage() : GroupGoods(),
    );
  }

  Future get() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      notFirst = prefs.getBool("not_first_open");
    });
    return prefs.getBool("not_first_open");
  }

}
