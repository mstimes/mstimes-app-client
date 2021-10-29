import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:mstimes/common/control.dart';
import 'package:mstimes/common/wechat.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/fund_summary.dart';
import 'package:mstimes/model/local_share/account_info.dart';
import 'package:mstimes/model/m_beans.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:mstimes/tools/common_container.dart';
import 'package:mstimes/utils/color_util.dart';
import 'package:mstimes/utils/date_utils.dart';

class MyMBeansPage extends StatefulWidget {
  MyMBeansPage({Key key}) : super(key: key);

  @override
  _MyMBeansPageState createState() => _MyMBeansPageState();
}

class _MyMBeansPageState extends State<MyMBeansPage> {
  double rpx;
  DateTime startDate = null;
  DateTime endDate = null;
  int pageNum = 0;
  int pageSize = 20;
  List<Map> _getMBeanRecordsList = [];
  int mType = -1;
  int relationType = -1;
  MBeans mbeansSummary = new MBeans();
  List<DataList> fundSummary = new List<DataList>();
  List<DataList> fundTodaySummary = new List<DataList>();
  List<DataList> fundMonthSummary = new List<DataList>();
  int totalCounts = 0;

  @override
  void initState() {
    super.initState();

    startDate = DateTime.parse("2021-01-01");
    endDate = endDate = DateTime.now().add(new Duration(days: 1));

    _getMBeansSummary(UserInfo.getUserInfo().userNumber);
    _getMBeanRecords();
  }

  void _getMBeansSummary(userNumber) {
    FormData formData = new FormData.fromMap({"userNumber": userNumber});

    requestDataByUrl('queryMBeans', formData: formData).then((val) {
      var data = json.decode(val.toString());
      if (debug) {
        print("queryMBeans data " + data.toString());
      }

      setState(() {
        mbeansSummary = MBeans.fromJson(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: mainColor,
        primary: true,
        leading: _buildBackButton(),
        elevation: 0,
        title: Text(
          '我的蜜豆',
          style: TextStyle(
              fontSize: 26 * rpx,
              fontWeight: FontWeight.bold,
              color: Colors.white),
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
              _getMBeanRecords();
            }
          }),
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      color: Colors.white,
      icon: Icon(Icons.arrow_back_ios_outlined),
      onPressed: () {
        RouterHome.flutoRouter.navigateTo(context, RouterConfig.myPagePath);
      },
    );
  }

  Widget _wrapList() {
    List<Widget> wrapList = List<Widget>();
    wrapList.add(_mbeansSummary(rpx));

    if (debug) {
      print(
          '_fundOrderList.length : ' + _getMBeanRecordsList.length.toString());
    }

    if (totalCounts > 0) {
      wrapList.add(_buildDateRange());
    }

    if (_getMBeanRecordsList.length != 0) {
      List<Widget> listWidget = _getMBeanRecordsList.map((val) {
        return Container(
          width: 720 * rpx,
          height: 420 * rpx,
          margin: EdgeInsets.only(
              left: 6 * rpx, top: 6 * rpx, right: 6 * rpx, bottom: 6 * rpx),
          //设置 child 居中
          // alignment: Alignment(0, 0),
          //边框设置
          decoration: new BoxDecoration(
            //背景
            color: Colors.white,
            //设置四周圆角 角度
            borderRadius: BorderRadius.all(Radius.circular(5.0 * rpx)),
            //设置四周边框
            border: new Border.all(width: 1 * rpx, color: Colors.grey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildIncomeRemindRow(val),
              _buildMBeansRow(val),
              _buildGoodNameRow(val),
              _buildOrderNumberRow(val),
              _buildRealPriceRow(val),
              _buildOrderTimeRow(val)
            ],
          ),
        );
      }).toList();

      if (listWidget.length >= totalCounts) {
        listWidget.add(buildCommonListBottom(rpx));
      }
      wrapList.addAll(listWidget);
    } else {
      // if (totalCounts > 0) {
      wrapList.add(Container(
        height: 800 * rpx,
        alignment: Alignment.center,
        child: Text('暂无数据'),
      ));
      // } else {
      //   wrapList.add(buildInviteFriendsContainer());
      // }
    }

    return ListView(
      children: wrapList,
    );
  }

  Widget buildInviteFriendsContainer() {
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
            '邀请好友下单可获取蜜豆，快去邀请吧',
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

  Widget _buildIncomeRemindRow(val) {
    var title = "恭喜您，由于 " + val['userName'].toString() + " 产生一笔订单，您获得一次蜜豆奖励！";
    if (val['type'] == 1) {
      title = "恭喜您，由于您产生一笔订单，获得一次蜜豆奖励！";
    }
    return Expanded(
        child: Column(
      children: [
        Container(
          margin:
              EdgeInsets.only(left: 20 * rpx, top: 30 * rpx, right: 40 * rpx),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.grey[500],
                fontSize: 26 * rpx,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ));
  }

  Widget _buildMBeansRow(val) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 20 * rpx, top: 10 * rpx),
          child: Text(
            '获得蜜豆：',
            style: TextStyle(color: Colors.black),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 40 * rpx, top: 10 * rpx),
          child: Text(
            val['beanCounts'].toString(),
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildGoodNameRow(val) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 20 * rpx, top: 10 * rpx),
          child: Text(
            '商品名称：',
            style: TextStyle(color: Colors.black),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 40 * rpx, top: 10 * rpx),
          child: Text(
            val['goodName'].toString(),
            style: TextStyle(color: Colors.black),
          ),
        )
      ],
    );
  }

  Widget _buildRealPriceRow(val) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 20 * rpx, top: 10 * rpx),
          child: Text(
            '下单金额：',
            style: TextStyle(color: Colors.black),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 40 * rpx, top: 10 * rpx),
          child: Text(
            '¥',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20 * rpx,
                fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10 * rpx, top: 10 * rpx),
          child: Text(
            val['price'].toString(),
            style: TextStyle(color: Colors.black),
          ),
        )
      ],
    );
  }

  Widget _buildOrderTimeRow(val) {
    return Row(
      children: [
        Container(
          margin:
              EdgeInsets.only(left: 20 * rpx, top: 10 * rpx, bottom: 50 * rpx),
          child: Text(
            '下单时间：',
            style: TextStyle(color: Colors.black),
          ),
        ),
        Container(
          margin:
              EdgeInsets.only(left: 40 * rpx, top: 10 * rpx, bottom: 50 * rpx),
          child: Text(
            val['createDate'].toString(),
            style: TextStyle(color: Colors.black),
          ),
        )
      ],
    );
  }

  Widget _buildOrderNumberRow(val) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 20 * rpx, top: 10 * rpx),
          child: Text(
            '订单编号：',
            style: TextStyle(color: Colors.black),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 40 * rpx, top: 10 * rpx),
          child: Text(
            val['orderNumber'].toString(),
            style: TextStyle(color: Colors.black),
          ),
        )
      ],
    );
  }

  Widget _mbeansSummary(rpx) {
    return Container(
        height: 300 * rpx,
        width: 700 * rpx,
        margin: EdgeInsets.only(bottom: 10 * rpx),
        decoration: new BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0 * rpx),
                bottomRight: Radius.circular(30.0 * rpx))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 300 * rpx,
              height: 200 * rpx,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        left: 10 * rpx, top: 60 * rpx, bottom: 20 * rpx),
                    child: Text('可用蜜豆',
                        style: TextStyle(
                          fontSize: 23 * rpx,
                          color: Colors.white,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10 * rpx),
                    child: Text(
                        mbeansSummary.dataList == null
                            ? '0'
                            : (mbeansSummary.dataList[0].sumCounts -
                                    mbeansSummary.dataList[0].usedCounts)
                                .toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35 * rpx,
                            fontWeight: FontWeight.w700)),
                  )
                ],
              ),
            ),
            Expanded(child: Container()),
            Container(
              child: Row(
                children: [
                  Container(
                    height: 60 * rpx,
                    child: Container(
                      margin: EdgeInsets.only(left: 30 * rpx, bottom: 10 * rpx),
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Text('蜜豆总数',
                                style: TextStyle(
                                  fontSize: 23 * rpx,
                                  color: Colors.white,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 10 * rpx, bottom: 10 * rpx),
                            child: Text(
                                mbeansSummary.dataList == null
                                    ? '0'
                                    : mbeansSummary.dataList[0].sumCounts
                                        .toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28 * rpx,
                                    fontWeight: FontWeight.w500)),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    height: 60 * rpx,
                    margin: EdgeInsets.only(
                        left: 30 * rpx, bottom: 10 * rpx, right: 30 * rpx),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Text('已用蜜豆',
                              style: TextStyle(
                                fontSize: 23 * rpx,
                                color: Colors.white,
                              )),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(left: 10 * rpx, bottom: 10 * rpx),
                          child: Text(
                              mbeansSummary.dataList == null
                                  ? '0'
                                  : mbeansSummary.dataList[0].usedCounts
                                      .toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28 * rpx,
                                  fontWeight: FontWeight.w500)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  Widget _buildChangeButton(text, mt, rt, mtIndex, rtIndex) {
    bool select = false;
    if (mtIndex == mType) {
      select = true;
    } else if (rtIndex == relationType) {
      select = true;
    }

    if (select) {
      return Container(
        height: 50 * rpx,
        child: FlatButton(
          color: buttonColor,
          onPressed: () {
            setState(() {
              _getMBeanRecordsList.clear();
              if (mt != null) {
                mType = mt;
              }
              if (rt != null) {
                relationType = rt;
              }
              _getMBeanRecords();
            });
          },
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      return Container(
        height: 50 * rpx,
        child: OutlineButton(
          borderSide: new BorderSide(color: buttonColor),
          onPressed: () {
            setState(() {
              _getMBeanRecordsList.clear();
              if (mt != null) {
                mType = mt;
              }
              if (rt != null) {
                relationType = rt;
              }

              _getMBeanRecords();
            });
          },
          child: Text(
            text,
            style: TextStyle(color: buttonColor),
          ),
        ),
      );
    }
  }

  Widget _buildRelationRow() {
    return Container(
      margin: EdgeInsets.only(top: 30 * rpx, bottom: 20 * rpx),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 120 * rpx),
            child: _buildChangeButton('全部', null, -1, null, -1),
          ),
          Container(
            margin: EdgeInsets.only(left: 30 * rpx),
            child: _buildChangeButton('直属', null, 1, null, 1),
          ),
          Container(
            margin: EdgeInsets.only(left: 30 * rpx),
            child: _buildChangeButton('间接', null, 2, null, 2),
          )
        ],
      ),
    );
  }

  Widget _buildAgentLevelRow() {
    return Container(
      margin: EdgeInsets.only(top: 20 * rpx, bottom: 10 * rpx),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 60 * rpx),
            width: 120 * rpx,
            child: _buildChangeButton('全部', -1, null, -1, null),
          ),
          Container(
            margin: EdgeInsets.only(left: 30 * rpx),
            width: 100 * rpx,
            child: _buildChangeButton('M0', 0, null, 0, null),
          ),
          Container(
            margin: EdgeInsets.only(left: 30 * rpx),
            width: 100 * rpx,
            child: _buildChangeButton('M1', 1, null, 1, null),
          ),
          Container(
            margin: EdgeInsets.only(left: 30 * rpx),
            width: 100 * rpx,
            child: _buildChangeButton('M2', 2, null, 2, null),
          ),
          Container(
            margin: EdgeInsets.only(left: 30 * rpx),
            width: 100 * rpx,
            child: _buildChangeButton('M3', 3, null, 3, null),
          )
        ],
      ),
    );
  }

  void _getMBeanRecords() {
    if (debug) {
      print('_getMBeanRecordsList startTime : ' +
          formatDate(startDate, ymdFormat) +
          ", endTime : " +
          formatDate(endDate, ymdFormat));
    }

    FormData formData = new FormData.fromMap({
      "userNumber": UserInfo.getUserInfo().userNumber,
      "startTime": formatDate(startDate, ymdFormat),
      "endTime": formatDate(startDate, ymdFormat),
      // "startTime": DateFormat("yyyy-MM-dd").format(startDate),
      // "endTime": DateFormat("yyyy-MM-dd").format(endDate),
      "pageNum": pageNum,
      "pageSize": pageSize
    });

    requestDataByUrl('queryMyMBeanRecords', formData: formData).then((val) {
      var data = json.decode(val.toString());
      List<Map> list = (data['dataList'] as List).cast();
      if (debug) {
        print("_getMBeanRecordsList : " +
            _getMBeanRecordsList.toString() +
            ",_getMBeanRecordsList length" +
            _getMBeanRecordsList.length.toString());
      }
      totalCounts = int.parse(data['pageTotalCount'].toString());

      if (list.isNotEmpty && list.length > 0) {
        setState(() {
          _getMBeanRecordsList.addAll(list);
        });
      }
    });
  }

  Widget _buildDateRange() {
    return Row(
      children: [
        _buildStartDate(),
        Container(child: Text('至')),
        _buildEndDate()
      ],
    );
  }

  Widget _buildStartDate() {
    return Container(
      child: FlatButton(
        child: Text(
            formatDate(startDate, ymdFormat),
          // DateFormat("yyyy-MM-dd").format(startDate),
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
        color: Colors.grey[200],
        onPressed: () async {
          var result = await showDatePicker(
              builder: (context, child) {
                return Theme(
                  data: ThemeData.dark(),
                  child: child,
                );
              },
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030));
          setState(() {
            if (result != null) {
              _getMBeanRecordsList.clear();
              startDate = result;
              _getMBeanRecords();
            }
          });
        },
      ),
    );
  }

  Widget _buildEndDate() {
    return Container(
      child: FlatButton(
        child: Text(
          formatDate(endDate, ymdFormat),
          // DateFormat("yyyy-MM-dd").format(endDate),
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
        color: Colors.grey[200],
        onPressed: () async {
          var result = await showDatePicker(
              builder: (context, child) {
                return Theme(
                  data: ThemeData.dark(),
                  child: child,
                );
              },
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030));
          setState(() {
            if (result != null) {
              _getMBeanRecordsList.clear();
              endDate = result;
              _getMBeanRecords();
            }
          });
        },
      ),
    );
  }
}
