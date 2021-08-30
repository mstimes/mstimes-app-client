import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mstimes/model/local_share/account_info.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:mstimes/utils/color_util.dart';

import 'order_records.dart';

double rpx;

class MyIncomePage extends StatefulWidget {
  @override
  _MyIncomePageState createState() => _MyIncomePageState();
}

class ChoiceTab {
  final String title;
  final IconData icon;
  final String typeIndex;
  const ChoiceTab({this.title, this.icon, this.typeIndex});
}

const List<ChoiceTab> choiceTabs = const <ChoiceTab>[
  const ChoiceTab(title: "今日"),
  const ChoiceTab(title: "本月"),
  const ChoiceTab(title: "累计"),
];

class _MyIncomePageState extends State<MyIncomePage> {
  int pageNum = 0;
  int pageSize = 10;
  UserInfo userInfo;

  @override
  void initState() {
    super.initState();
    userInfo = UserInfo.getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: userInfo.isAgent() ? mainColor : Colors.white,
          primary: true,
          elevation: 0,
          leading: _buildBackButton(),
          title: Text(
            userInfo.isAgent() ? '零售收益' : '订单详情',
            style: TextStyle(
                fontSize: 26 * rpx,
                fontWeight: FontWeight.bold,
                color: userInfo.isAgent() ? Colors.white : Colors.black),
          ),
        ),
        body: OrderRecordsPage());
  }

  Widget _buildBackButton() {
    return IconButton(
      color: userInfo.isAgent() ? Colors.white : Colors.black,
      icon: Icon(Icons.arrow_back_ios_outlined),
      onPressed: () {
        RouterHome.flutoRouter.navigateTo(context, RouterConfig.myPagePath);
      },
    );
  }
}
