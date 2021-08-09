import 'package:flutter/material.dart';
import 'package:mstimes/model/local_share/account_info.dart';
import 'package:mstimes/routers/router_config.dart';

class SelectAccountTypePage extends StatefulWidget {
  const SelectAccountTypePage({Key key}) : super(key: key);

  @override
  _SelectAccountTypePageState createState() => _SelectAccountTypePageState();
}

class _SelectAccountTypePageState extends State<SelectAccountTypePage> {
  double rpx;
  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    UserInfo userInfo = UserInfo.getUserInfo();

    Widget vipAccImageArea = new Container(
      alignment: Alignment.topCenter,
      // 设置图片为圆形
      child: ClipOval(
        child: Image.asset(
          "lib/images/vip.png",
          height: 130 * rpx,
          width: 130 * rpx,
          fit: BoxFit.cover,
        ),
      ),
    );

    Widget vipAccTextContainer = new Container(
      margin: EdgeInsets.only(top: 5 * rpx),
      child: Text(
        '我是VIP客户',
        style: TextStyle(fontSize: 23 * rpx, fontWeight: FontWeight.w800),
      ),
    );

    Widget recommendImageArea = new Container(
      margin: EdgeInsets.only(top: 100 * rpx),
      alignment: Alignment.topCenter,
      // 设置图片为圆形
      child: ClipOval(
        child: Image.asset(
          "lib/images/recommend.png",
          height: 120 * rpx,
          width: 120 * rpx,
          fit: BoxFit.cover,
        ),
      ),
    );

    Widget recommendTextContainer = new Container(
      margin: EdgeInsets.only(top: 5 * rpx),
      child: Text(
        '我是品质推荐官',
        style: TextStyle(fontSize: 23 * rpx, fontWeight: FontWeight.w800),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                print('vip account');
                userInfo.setUserType(0);
                RouterHome.flutoRouter
                    .navigateTo(context, RouterConfig.invitePagePath);
              },
              child: vipAccImageArea,
            ),
            vipAccTextContainer,
            InkWell(
              onTap: () {
                print('recommend');
                userInfo.setUserType(1);
                RouterHome.flutoRouter
                    .navigateTo(context, RouterConfig.invitePagePath);
              },
              child: recommendImageArea,
            ),
            recommendTextContainer
          ],
        ));
  }
}
