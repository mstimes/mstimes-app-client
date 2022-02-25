import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:mstimes/common/control.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/fund_summary.dart';
import 'package:mstimes/model/local_share/account_info.dart';
import 'package:mstimes/tools/common_container.dart';
import 'package:mstimes/utils/color_util.dart';
import 'package:mstimes/utils/date_utils.dart';

class PassivityIncomePage extends StatefulWidget {
  PassivityIncomePage({Key key}) : super(key: key);

  @override
  _PassivityIncomeState createState() => _PassivityIncomeState();
}

class _PassivityIncomeState extends State<PassivityIncomePage> {
  double rpx;
  DateTime startDate = null;
  DateTime endDate = null;
  int pageNum = 0;
  int pageSize = 20;
  List<Map> _fundOrderList = [];
  int mType = -1;
  int relationType = -1;
  var funsSummaryData;
  List<DataList> fundSummary = new List<DataList>();
  List<DataList> fundTodaySummary = new List<DataList>();
  List<DataList> fundMonthSummary = new List<DataList>();
  int passivityIncomeCounts = 0;

  @override
  void initState() {
    super.initState();

    startDate = DateTime.parse("2021-01-01");
    endDate = endDate = DateTime.now().add(new Duration(days: 1));

    _getFundSummary(UserInfo.getUserInfo().userId);
    _getFundTodaySummary(UserInfo.getUserInfo().userId);
    _getFundMonthSummary(UserInfo.getUserInfo().userId);
    _getPassitityIncomeCounts(UserInfo.getUserInfo().userId);
    _getFundOrderList();
  }

  void _getFundSummary(agentId) {
    FormData formData = new FormData.fromMap(
        {"agentId": agentId, "startDate": startDate, "endDate": endDate});

    requestDataByUrl('queryFundSummary', formData: formData).then((val) {
      var data = json.decode(val.toString());
      if (debug) {
        print("queryFundSummary data " + data.toString());
      }

      setState(() {
        fundSummary = FundSummary.fromJson(data).dataList;
      });
    });
  }

  void _getFundTodaySummary(agentId) {
    FormData formData = new FormData.fromMap({
      "agentId": agentId,
      "startDate": DateTime.now(),
      "endDate": DateTime.now().add(new Duration(days: 1)),
    });
    requestDataByUrl('queryFundSummary', formData: formData).then((val) {
      var data = json.decode(val.toString());

      setState(() {
        fundTodaySummary = FundSummary.fromJson(data).dataList;
      });
    });
  }

  void _getFundMonthSummary(agentId) {
    FormData formData = new FormData.fromMap({
      "agentId": agentId,
      "startDate": new DateTime(DateTime.now().year, DateTime.now().month, 1),
      "endDate": DateTime.now().add(new Duration(days: 1)),
    });
    requestDataByUrl('queryFundSummary', formData: formData).then((val) {
      var data = json.decode(val.toString());

      setState(() {
        fundMonthSummary = FundSummary.fromJson(data).dataList;
      });
    });
  }

  void _getPassitityIncomeCounts(agentId) {
    FormData formData = new FormData.fromMap({
      "agentId": agentId,
      "startTime": startDate,
      "endTime": endDate,
    });
    requestDataByUrl('queryPassitityIncomeCounts', formData: formData)
        .then((val) {
      var data = json.decode(val.toString());

      setState(() {
        passivityIncomeCounts = int.parse(data['dataList'][0].toString());
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
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          '被动收益',
          style: TextStyle(fontSize: 30 * rpx, fontWeight: FontWeight.bold),
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
            if (passivityIncomeCounts > pageSize + pageNum * pageSize) {
              ++pageNum;
              _getFundOrderList();
            }
          }),
    );
  }

  Widget _wrapList() {
    List<Widget> wrapList = List<Widget>();
    wrapList.add(funsSummary(rpx));
    wrapList.add(_buildDateRange());

    if (debug) {
      print('_fundOrderList.length : ' + _fundOrderList.length.toString());
    }

    if (_fundOrderList.length != 0) {
      List<Widget> listWidget = _fundOrderList.map((val) {
        return Container(
          width: 720 * rpx,
          height: 440 * rpx,
          margin: EdgeInsets.only(
              left: 6 * rpx, top: 6 * rpx, right: 6 * rpx, bottom: 6 * rpx),
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0 * rpx)),
            border: new Border.all(width: 1 * rpx, color: Colors.grey),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildIncomeRemindRow(val),
                _buildIncomeTypeRow(val),
                _buildIncomePriceRow(val),
                _buildGoodNameRow(val),
                _buildOrderNumberRow(val),
                _buildOrderTimeRow(val)
              ],
          )
        );
      }).toList();

      if (listWidget.length >= passivityIncomeCounts) {
        listWidget.add(buildCommonListBottom(rpx));
      }
      wrapList.addAll(listWidget);
    } else {
      wrapList.add(Container(
        height: 800 * rpx,
        alignment: Alignment.center,
        child: Text('暂无数据'),
      ));
    }

    return ListView(
      children: wrapList,
    );
  }

  Widget _buildIncomeRemindRow(val) {
    var title = "恭喜你获得由 " + val['userName'].toString() + " 产生的一笔订单，获得一笔被动收益奖励！";
    return Expanded(
        child: Container(
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
    );
  }

  Widget _buildIncomeTypeRow(val) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 20 * rpx, top: 10 * rpx),
          child: Text(
            '收益类型：',
            style: TextStyle(color: Colors.black),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 40 * rpx, top: 10 * rpx),
          child: Text(
            val['incomeType'].toString(),
            style: TextStyle(color: Colors.black),
          ),
        )
      ],
    );
  }

  Widget _buildIncomePriceRow(val) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 20 * rpx, top: 10 * rpx),
          child: Text(
            '收益金额：',
            style: TextStyle(color: Colors.black),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 40 * rpx, top: 10 * rpx),
          child: Text(
            val['incomePrice'].toString() + '0 元',
            style: TextStyle(color: Colors.black),
          ),
        )
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
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 40 * rpx, top: 10 * rpx, right: 10 * rpx),
            child: Text(
              val['goodName'].toString(),
              style: TextStyle(color: Colors.black),
            ),
          )
        ),
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
          margin: EdgeInsets.only(left: 40 * rpx),
          child: Text(
            val['realPriceSum'].toString(),
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
            val['createTime'].toString(),
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

  Widget funsSummary(rpx) {
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
                    child: Text('累计金额',
                        style: TextStyle(
                          fontSize: 23 * rpx,
                          color: Colors.white,
                        )),
                  ),
                  buildCommonPrice(
                      fundSummary,
                      fundSummary.isEmpty ? null : fundSummary[0].groupIncome,
                      25,
                      45,
                      Colors.white,
                      rpx,
                      MainAxisAlignment.center,
                      true)
                ],
              ),
            ),
            Expanded(child: Container()),
            Container(
              margin: EdgeInsets.only(left: 40 * rpx, right: 35 * rpx, bottom: 20 * rpx),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 60 * rpx,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          child: Text('总笔数',
                              style: TextStyle(
                                fontSize: 23 * rpx,
                                color: Colors.white,
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10 * rpx),
                          child: Text(
                              passivityIncomeCounts.toString(),
                              style: TextStyle(
                                fontSize: 23 * rpx,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    height: 60 * rpx,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          child: Text('本月收益',
                              style: TextStyle(
                                fontSize: 23 * rpx,
                                color: Colors.white,
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10 * rpx),
                          child: Text(
                              fundMonthSummary.isEmpty
                                  ? '0.00'
                                  : fundMonthSummary[0].groupIncome,
                              style: TextStyle(
                                fontSize: 23 * rpx,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    height: 60 * rpx,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          child: Text('今日收益',
                              style: TextStyle(
                                fontSize: 23 * rpx,
                                color: Colors.white,
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10 * rpx),
                          child: Text(
                              fundTodaySummary.isEmpty
                                  ? '0.00'
                                  : fundTodaySummary[0].groupIncome,
                              style: TextStyle(
                                fontSize: 23 * rpx,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  Widget _buildPersonInfoRow(val) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 10 * rpx, left: 20 * rpx),
      width: 730 * rpx,
      height: 100 * rpx,
      child: Row(
        children: [
          _createImageColumn(val),
          _createNameColumn(val),
          _createUserNumberColumn(val),
        ],
      ),
    );
  }

  // Widget _buildSaleInfoRow(val) {
  //   return Container(
  //     alignment: Alignment.topCenter,
  //     padding: EdgeInsets.only(top: 30 * rpx, left: 30 * rpx),
  //     width: 730 * rpx,
  //     height: 120 * rpx,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         _createMySaleColumn(val),
  //         _createMyIncomeColumn(val),
  //         _createOrderCountsColumn(val),
  //       ],
  //     ),
  //   );
  // }

  Widget _createJoinDateRow(val) {
    return Container(
      width: 700 * rpx,
      height: 70 * rpx,
      margin: EdgeInsets.only(left: 60 * rpx),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              '注册日期',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                  fontSize: 25 * rpx),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20 * rpx),
            child: Text(
              val['createTime'],
              style: TextStyle(color: Colors.grey, fontSize: 25 * rpx),
            ),
          )
        ],
      ),
    );
  }

  // Widget _createIntroRelationLevelColumn(val) {
  //   return Container(
  //     width: 70 * rpx,
  //     height: 130 * rpx,
  //     child: Column(
  //       children: [
  //         Container(
  //           alignment: Alignment.centerLeft,
  //           margin: EdgeInsets.only(left: 10 * rpx),
  //           child: Text(
  //             '层级',
  //             style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 color: Color.fromRGBO(77, 99, 104, 1),
  //                 fontSize: 28 * rpx),
  //           ),
  //         ),
  //         Container(
  //           alignment: Alignment.centerLeft,
  //           padding: EdgeInsets.only(top: 10 * rpx),
  //           margin: EdgeInsets.only(left: 10 * rpx),
  //           child: Text(
  //             val['layers'].toString(),
  //             style: TextStyle(
  //                 color: Color.fromRGBO(77, 99, 104, 1), fontSize: 28 * rpx),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _createOrderCountsColumn(val) {
    return Container(
      width: 220 * rpx,
      height: 100 * rpx,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              '订单数',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(77, 99, 104, 1),
                  fontSize: 28 * rpx),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10 * rpx),
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              val['orderCounts'].toString(),
              style: TextStyle(
                  color: Color.fromRGBO(77, 99, 104, 1), fontSize: 28 * rpx),
            ),
          )
        ],
      ),
    );
  }

  Widget _createMySaleColumn(val) {
    return Container(
      width: 220 * rpx,
      height: 100 * rpx,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              '消费金额',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(77, 99, 104, 1),
                  fontSize: 28 * rpx),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10 * rpx),
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              val['realPriceSum'].toString(),
              style: TextStyle(
                  color: Color.fromRGBO(77, 99, 104, 1), fontSize: 28 * rpx),
            ),
          )
        ],
      ),
    );
  }

  Widget _createMyIncomeColumn(val) {
    return Container(
      width: 220 * rpx,
      height: 100 * rpx,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              '收益',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(77, 99, 104, 1),
                  fontSize: 28 * rpx),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10 * rpx),
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              val['myIncomeSum'].toString(),
              style: TextStyle(
                  color: Color.fromRGBO(77, 99, 104, 1), fontSize: 28 * rpx),
            ),
          )
        ],
      ),
    );
  }

  Widget _createUserNumberColumn(val) {
    return Container(
      width: 400 * rpx,
      height: 130 * rpx,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20 * rpx),
            child: Text(
              '用户编号',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(77, 99, 104, 1),
                  fontSize: 28 * rpx),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              val['userNumber'].toString(),
              style: TextStyle(
                  color: Color.fromRGBO(77, 99, 104, 1), fontSize: 28 * rpx),
            ),
          )
        ],
      ),
    );
  }

  Widget _createImageColumn(val) {
    return Container(
      width: 80 * rpx,
      height: 80 * rpx,
      child: ClipOval(
        child: val['imageUrl'] == null
            ? Image.asset(
                "lib/images/person_default.jpg",
                height: 80 * rpx,
                width: 80 * rpx,
              )
            : Image.network(
                val['imageUrl'].toString(),
                height: 80 * rpx,
                width: 80 * rpx,
              ),
      ),
    );
  }

  Widget _createNameColumn(val) {
    return Container(
      width: 200 * rpx,
      height: 130 * rpx,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20 * rpx),
            child: Text(
              '昵称',
              style: TextStyle(
                  color: Color.fromRGBO(77, 99, 104, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 28 * rpx),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              val['userName'],
              style: TextStyle(
                  color: Color.fromRGBO(77, 99, 104, 1), fontSize: 28 * rpx),
            ),
          )
        ],
      ),
    );
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
              _fundOrderList.clear();
              if (mt != null) {
                mType = mt;
              }
              if (rt != null) {
                relationType = rt;
              }
              _getFundOrderList();
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
              _fundOrderList.clear();
              if (mt != null) {
                mType = mt;
              }
              if (rt != null) {
                relationType = rt;
              }

              _getFundOrderList();
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

  void _getFundOrderList() {
    if (debug) {
      print('_getFundOrderList startTime : ' +
          formatDate(startDate, ymdFormat) +
          ", endTime : " +
          formatDate(endDate, ymdFormat));
    }

    FormData formData = new FormData.fromMap({
      "userId": UserInfo.getUserInfo().userId,
      "startTime": formatDate(startDate, ymdFormat),
      "endTime": formatDate(endDate, ymdFormat),
    // "startTime": DateFormat("yyyy-MM-dd").format(startDate),
      // "endTime": DateFormat("yyyy-MM-dd").format(endDate),
      "pageNum": pageNum,
      "pageSize": pageSize
    });

    requestDataByUrl('queryFundOrder', formData: formData).then((val) {
      var data = json.decode(val.toString());
      List<Map> fundOrderList = (data['dataList'] as List).cast();
      if (debug) {
        print("_getFundOrderList : " +
            fundOrderList.toString() +
            ",_getFundOrderList length" +
            fundOrderList.length.toString());
      }

      if (fundOrderList.isNotEmpty && fundOrderList.length > 0) {
        setState(() {
          _fundOrderList.addAll(fundOrderList);
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
              _fundOrderList.clear();
              startDate = result;
              _getFundOrderList();
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
              _fundOrderList.clear();
              endDate = result;
              _getFundOrderList();
            }
          });
        },
      ),
    );
  }
}
