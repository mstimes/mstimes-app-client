import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:mstimes/common/control.dart';
import 'package:mstimes/common/wechat.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/local_share/account_info.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:mstimes/tools/common_container.dart';
import 'package:mstimes/utils/color_util.dart';
import 'package:date_format/date_format.dart';
import 'package:mstimes/utils/date_utils.dart';

class CouponPage extends StatefulWidget {
  const CouponPage({Key key}) : super(key: key);

  @override
  _CouponPageState createState() => _CouponPageState();
}

class CouponStatusTab {
  final String title;
  const CouponStatusTab({this.title});
}

const List<CouponStatusTab> couponStatusTabs = const <CouponStatusTab>[
  const CouponStatusTab(title: "待使用"),
  const CouponStatusTab(title: "已使用"),
  const CouponStatusTab(title: "已过期"),
];

class _CouponPageState extends State<CouponPage> {
  double rpx;
  int pageNum = 0;
  int pageSize = 20;
  DateTime startDate = null;
  DateTime endDate = null;
  List<Map> _userCouponList = [];

  int queryStatus = 1;
  int totalCounts = 0;

  @override
  void initState() {
    super.initState();
    startDate = DateTime.parse("2021-01-01");
    endDate = DateTime.now().add(new Duration(days: 1));

    if(UserInfo().isLogin()){
      _getUserCouponRecords();
    }
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return DefaultTabController(
      length: couponStatusTabs.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: _buildBackButton(),
          backgroundColor: Colors.white,
          primary: true,
          elevation: 0,
          title: Text(
            '奖励与购物券',
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
                _getUserCouponRecords();
              }
            }),
      ),
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
    wrapList.add(_buildCouponStatus());

    if (_userCouponList.length != 0) {
      List<Widget> listWidget = _userCouponList.map((val) {
        return Container(
          child: Column(children: [
            Row(children: [
              Container(
                height: 260 * rpx,
                width: 300 * rpx,
                margin: EdgeInsets.only(left: 80 * rpx, right: 10 * rpx),
                child: Row(
                  children: [
                    Container(
                      child: Text(
                        '¥ ',
                        style: TextStyle(
                            fontSize: 40 * rpx,
                            fontWeight: FontWeight.w300,
                            color:
                                queryStatus == 3 ? Colors.grey : Colors.black),
                      ),
                    ),
                    Container(
                      child: Text(
                        val['discountCoupon'].toString(),
                        style: TextStyle(
                            fontSize: 100 * rpx,
                            fontWeight: FontWeight.w300,
                            color:
                                queryStatus == 3 ? Colors.grey : Colors.black),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 30 * rpx, bottom: 10 * rpx),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        val['couponCategory'].toString(),
                        style: TextStyle(
                            fontSize: 23 * rpx,
                            fontWeight: FontWeight.w400,
                            color:
                                queryStatus == 3 ? Colors.grey : yellowColor1),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15 * rpx),
                      child: Row(children: [
                        Container(
                          child: Text(
                            '优惠码 ',
                            style: TextStyle(
                                fontSize: 30 * rpx,
                                fontWeight: FontWeight.w500,
                                color: queryStatus == 3
                                    ? Colors.grey
                                    : Colors.black),
                          ),
                        ),
                        Container(
                          child: Text(
                            val['couponCode'].toString(),
                            style: TextStyle(
                                fontSize: 30 * rpx,
                                fontWeight: FontWeight.w500,
                                color: queryStatus == 3
                                    ? Colors.grey
                                    : Colors.black),
                          ),
                        ),
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 18 * rpx),
                      child: Text(
                        queryStatus == 2
                            ? val['usedDate'].toString()
                            : val['validDate'].toString(),
                        style: TextStyle(
                            fontSize: 23 * rpx,
                            fontWeight: FontWeight.w300,
                            color:
                                queryStatus == 3 ? Colors.grey : Colors.black),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 18 * rpx),
                      child: Text(
                        val['useRule'].toString(),
                        style: TextStyle(
                            fontSize: 23 * rpx,
                            fontWeight: FontWeight.w300,
                            color:
                                queryStatus == 3 ? Colors.grey : Colors.black),
                      ),
                    ),
                  ],
                ),
              )
            ]),
            buildCommonHorizontalDivider()
          ]),
        );
      }).toList();

      if (listWidget.length >= totalCounts) {
        listWidget.add(buildCommonListBottom(rpx));
      }

      wrapList.addAll(listWidget);
    } else {
      wrapList.add(buildInviteFriendsContainer(rpx));
    }

    return ListView(
      children: wrapList,
    );
  }

  Widget buildInviteFriendsContainer(rpx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 300 * rpx),
          child: Text(
            '这里空空如也',
            style: TextStyle(
                color: Colors.black,
                fontSize: 30 * rpx,
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 40 * rpx),
          child: Text(
            '邀请好友下单可获取升级奖励，快去邀请吧',
            style: TextStyle(
                color: Colors.black,
                fontSize: 26 * rpx,
                fontWeight: FontWeight.w400),
          ),
        ),
        // Container(
        //   margin: EdgeInsets.only(top: 100 * rpx),
        //   child: InkWell(
        //     onTap: () {
        //       callInviteFriends(context, rpx);
        //     },
        //     child: buildSingleSummitButton('现在去邀请', 280, 60, 0, rpx),
        //   ),
        // )
      ],
    );
  }

  Widget _buildCouponStatus() {
    return Container(
      width: 750 * rpx,
      margin: EdgeInsets.only(top: 0 * rpx, bottom: 15 * rpx, left: 0 * rpx),
      child: Row(
        children: [
          Container(
            width: 250 * rpx,
            height: 120 * rpx,
            child: _buildChangeButton('待使用', null, 1, null, 1),
          ),
          Container(
            width: 250 * rpx,
            height: 120 * rpx,
            child: _buildChangeButton('已使用', null, 2, null, 2),
          ),
          Container(
            width: 250 * rpx,
            height: 120 * rpx,
            child: _buildChangeButton('已过期', null, 3, null, 3),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeButton(text, mt, qt, mtIndex, qtIndex) {
    bool select = false;
    if (qtIndex == queryStatus) {
      select = true;
    }

    if (select) {
      return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          setState(() {
            _userCouponList.clear();
            if (qt != null) {
              queryStatus = qt;
            }
            _getUserCouponRecords();
          });
        },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30 * rpx),
              alignment: Alignment.center,
              color: Colors.transparent,
              height: 60 * rpx,
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 23 * rpx,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5 * rpx),
              alignment: Alignment.center,
              color: Colors.black,
              height: 6 * rpx,
              width: 80 * rpx,
            )
          ],
        ),
      );
    } else {
      return InkWell(
        highlightColor: Colors.white,
        splashColor: Colors.white,
        onTap: () {
          setState(() {
            _userCouponList.clear();
            if (qt != null) {
              queryStatus = qt;
            }
            _getUserCouponRecords();
          });
        },
        child: Container(
          height: 60 * rpx,
          alignment: Alignment.center,
          color: Colors.white,
          child: Text(
            text,
            style: TextStyle(
                color: Colors.black,
                fontSize: 23 * rpx,
                fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  void _getUserCouponRecords() {
    FormData formData = new FormData.fromMap({
      "userNumber": UserInfo.getUserInfo().userNumber,
      "status": queryStatus,
      "startDate": formatDate(startDate, ymdFormat),
      "endDate": formatDate(endDate, ymdFormat),
      // "startDate": DateFormat("yyyy-MM-dd").format(startDate),
      // "endDate": DateFormat("yyyy-MM-dd").format(endDate),
      "pageNum": pageNum,
      "pageSize": pageSize
    });

    print('userNumber ' +
        UserInfo.getUserInfo().userNumber +
        ',queryStatus ' +
        queryStatus.toString() +
        ' formData' +
        formData.toString());
    requestDataByUrl('queryUserCoupons', formData: formData).then((val) {
      var data = json.decode(val.toString());
      if (debug) {
        print("queryUserCoupons list : " + data.toString());
      }

      totalCounts = data['pageTotalCount'];
      print('queryUserCoupons ' + totalCounts.toString());
      List<Map> userCouponList = (data['dataList'] as List).cast();
      setState(() {
        _userCouponList.addAll(userCouponList);
      });
    });
  }

  void _testServerInterface() {
    FormData formData = new FormData.fromMap({
      "category": 1,
      "receiverUnionId": 'ow_d35iNzrCwEb8i8LsfkpJR2MwI',
      "sharerUnionId": 'ow_d35iNzrCwEb8i8LsfkpJR2MwI'
    });
    requestDataByUrl('createUserCoupons', formData: formData).then((val) {
      var data = json.decode(val.toString());
      if (debug) {
        print("createUserCoupons list : " + data.toString());
      }
    });
  }
}
