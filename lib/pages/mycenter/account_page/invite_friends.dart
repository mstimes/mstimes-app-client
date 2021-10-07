import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:mstimes/tools/common_container.dart';
import 'package:mstimes/utils/color_util.dart';

class InviteFriendsPage extends StatefulWidget {
  const InviteFriendsPage({Key key}) : super(key: key);

  @override
  _InviteFriendsPageState createState() => _InviteFriendsPageState();
}

class InviteStatusTab {
  final String title;
  const InviteStatusTab({this.title});
}

const List<InviteStatusTab> couponStatusTabs = const <InviteStatusTab>[
  const InviteStatusTab(title: "已邀请"),
  const InviteStatusTab(title: "下单客户"),
];

class _InviteFriendsPageState extends State<InviteFriendsPage> {
  double rpx;
  int pageNum = 0;
  int pageSize = 20;
  int totalCounts = 0;
  List<Map> _inviteFriendsList = [];

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: _buildBackButton(),
        backgroundColor: Colors.white,
        primary: true,
        elevation: 0,
        title: Text(
          '我的邀请',
          style: TextStyle(
              fontSize: 26 * rpx,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ),
      body: EasyRefresh(
          child: _wrapList(),
          header: ClassicalHeader(
            showInfo: false,
            textColor: mainColor,
            refreshingText: "Ms时代",
            refreshedText: "Ms时代",
            refreshText: "",
            refreshReadyText: "",
            noMoreText: "",
          ),
          footer: ClassicalFooter(
            bgColor: Colors.transparent,
            textColor: Colors.black87,
            float: false,
            showInfo: false,
            infoText: "",
            loadingText: "",
            loadedText: "",
            loadFailedText: "网络遇到问题，无法加载更多...",
            noMoreText: "到底喽～",
          ),
          onRefresh: () async {},
          onLoad: () async {
            if (totalCounts > pageSize + pageNum * pageSize) {
              ++pageNum;
              // _getUserCouponRecords();
            }
          }),
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      color: Colors.black,
      icon: Icon(Icons.arrow_back_ios_outlined),
      onPressed: () {
        RouterHome.flutoRouter.navigateTo(context, RouterConfig.myPagePath);
      },
    );
  }

  Widget _wrapList() {
    List<Widget> wrapList = List<Widget>();

    if (_inviteFriendsList.length != 0) {
      List<Widget> listWidget = _inviteFriendsList.map((val) {
        return Container();
      }).toList();

      // if (listWidget.length >= totalCounts) {
      //   listWidget.add(buildCommonListBottom(rpx));
      // }

      wrapList.addAll(listWidget);
    } else {
      // wrapList.add(Container(
      //   height: 800 * rpx,
      //   alignment: Alignment.center,
      //   child: Text('暂无数据'),
      // ));
      wrapList.add(buildInviteFriendsContainer(context, rpx));
    }

    return ListView(
      children: wrapList,
    );
  }
}
