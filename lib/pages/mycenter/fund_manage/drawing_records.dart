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
import "package:intl/intl.dart";

class DrawingRecordsPage extends StatefulWidget {
  DrawingRecordsPage({Key key}) : super(key: key);
  @override
  _DrawingRecordsPageState createState() => _DrawingRecordsPageState();
}

class _DrawingRecordsPageState extends State<DrawingRecordsPage> {
  double rpx;
  int pageNum = 0;
  int pageSize = 20;
  DateTime startDate = null;
  DateTime endDate = null;
  List<Map> _drawingRecordsList = [];
  List<DataList> fundSummary = new List<DataList>();
  List<DataList> fundTodaySummary = new List<DataList>();
  List<DataList> fundMonthSummary = new List<DataList>();
  int myOrderCounts = 0;
  int funsOrderCounts = 0;
  var userInfo;
  int totalOrderCounts = 0;
  int queryStatus = 0;

  @override
  void initState() {
    super.initState();

    startDate = DateTime.parse("2021-01-01");
    endDate = DateTime.now().add(new Duration(days: 1));
    userInfo = UserInfo.getUserInfo();

    if (userInfo.isAgent()) {
      _getFundSummary(userInfo.userId);
      _getFundTodaySummary(userInfo.userId);
      _getFundMonthSummary(userInfo.userId);
      _getMyOrderCounts(userInfo.userId);
      _getFunsOrderCounts(userInfo.userId);
    }

    _getDrawingRecords();
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainColor,
        primary: true,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          '提款记录',
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
            showInfo: false,
            bgColor: Colors.white,
            textColor: mainColor,
            loadingText: "",
            loadedText: "",
            loadFailedText: "网络遇到问题，无法加载更多...",
            noMoreText: "到底喽～",
          ),
          onRefresh: () async {},
          onLoad: () async {
            if (totalOrderCounts > pageSize + pageNum * pageSize) {
              ++pageNum;
              _getDrawingRecords();
            }
          }),
    );
  }

  void _getFundSummary(userId) {
    if (debug) {
      print('_getFundSummary startTime : ' +
          formatDate(startDate, ymdFormat) +
          ", endTime : " +
          formatDate(endDate, ymdFormat));
    }
    FormData formData = new FormData.fromMap({
      "agentId": userId,
      "startDate": DateFormat("yyyy-MM-dd").format(startDate),
      "endDate": DateFormat("yyyy-MM-dd").format(endDate)
    });
    requestDataByUrl('queryFundSummary', formData: formData).then((val) {
      var data = json.decode(val.toString());
      if (debug) {
        print("_getFundSummary : " + data.toString());
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

  void _getDrawingRecords() {
    if (debug) {
      print('_getDrawingRecords startTime : ' +
          formatDate(startDate, ymdFormat) +
          ", endTime : " +
          formatDate(endDate, ymdFormat));
    }

    FormData formData = new FormData.fromMap({
      "agentId": userInfo.userId,
      "status": queryStatus,
      "startTime": DateFormat("yyyy-MM-dd").format(startDate),
      "endTime": DateFormat("yyyy-MM-dd").format(endDate),
      "pageNum": pageNum,
      "pageSize": pageSize
    });
    requestDataByUrl('queryDrawingRecordsByStatus', formData: formData)
        .then((val) {
      var data = json.decode(val.toString());
      if (debug) {
        print("queryDrawingRecordsByStatus list : " + data.toString());
      }

      totalOrderCounts = data['pageTotalCount'];
      print('queryDrawingRecordsByStatus ' + totalOrderCounts.toString());
      List<Map> drawingRecordsList = (data['dataList'] as List).cast();
      setState(() {
        _drawingRecordsList.addAll(drawingRecordsList);
      });
    });
  }

  void _getMyOrderCounts(userId) {
    FormData formData = new FormData.fromMap({
      'queryType': 1,
      "userId": UserInfo.getUserInfo().userId,
      "userNumber": UserInfo.getUserInfo().userNumber,
      "startTime": DateFormat("yyyy-MM-dd").format(startDate),
      "endTime": DateFormat("yyyy-MM-dd").format(endDate),
    });
    requestDataByUrl('queryOrderCounts', formData: formData).then((val) {
      var data = json.decode(val.toString());
      if (debug) {
        print("_getMyOrderCounts : " + data.toString());
      }
      print("_getMyOrderCounts : " + data.toString());

      setState(() {
        if (data['dataList'] != null) {
          myOrderCounts = int.parse(data['dataList'][0].toString());
        }
      });
    });
  }

  void _getFunsOrderCounts(userId) {
    FormData formData = new FormData.fromMap({
      'queryType': 3,
      "userId": UserInfo.getUserInfo().userId,
      "userNumber": UserInfo.getUserInfo().userNumber,
      "startTime": DateFormat("yyyy-MM-dd").format(startDate),
      "endTime": DateFormat("yyyy-MM-dd").format(endDate),
    });
    requestDataByUrl('queryOrderCounts', formData: formData).then((val) {
      var data = json.decode(val.toString());
      if (debug) {
        print("_getFunsOrderCounts : " + data.toString());
      }
      print("_getFunsOrderCounts : " + data.toString());

      setState(() {
        if (data['dataList'] != null) {
          funsOrderCounts = int.parse(data['dataList'][0].toString());
        }
      });
    });
  }

  Widget myIncomeSummary(rpx) {
    return Container(
        height: 200 * rpx,
        width: 700 * rpx,
        decoration: new BoxDecoration(
          color: mainColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 680 * rpx,
              height: 200 * rpx,
              child: Row(
                children: <Widget>[
                  Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: 50 * rpx,
                                top: 30 * rpx,
                                bottom: 20 * rpx),
                            child: Text('待提金额',
                                style: TextStyle(
                                  fontSize: 23 * rpx,
                                  color: Colors.white,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20 * rpx),
                            child: Text(
                                fundSummary.isEmpty
                                    ? '0.00'
                                    : fundSummary[0].myIncome,
                                style: TextStyle(
                                    fontSize: 30 * rpx,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding:
                                EdgeInsets.only(left: 50 * rpx, top: 10 * rpx),
                            child: Text('已提金额',
                                style: TextStyle(
                                  fontSize: 23 * rpx,
                                  color: Colors.white,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20 * rpx),
                            child: Text(
                                fundSummary.isEmpty
                                    ? '0.00'
                                    : fundSummary[0].myIncome,
                                style: TextStyle(
                                    fontSize: 30 * rpx,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Widget _wrapList() {
    List<Widget> wrapList = List<Widget>();
    if (userInfo.isAgent()) {
      wrapList.add(myIncomeSummary(rpx));
    }

    if (userInfo.isAgent()) {
      wrapList.add(_buildOrderingType());
    }

    wrapList.add(_buildDateRange());

    if (_drawingRecordsList.length != 0) {
      wrapList.add(buildCommonHorizontalDivider());
      List<Widget> listWidget = _drawingRecordsList.map((val) {
        return Container(
          height: 260 * rpx,
          child: Column(children: [
            Row(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _createBankInfoRow(val),
                  _createBankNumberInfoRow(val),
                  _createCreateTimeRow(val),
                  _createRefuseReasonRow(val),
                ],
              ),
              Expanded(child: Container()),
              Container(
                margin: EdgeInsets.only(right: 50 * rpx, bottom: 20 * rpx),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _createDrawingAmountRow(val),
                    _createDrawingStatusRow(val)
                  ],
                ),
              )
            ]),
            buildCommonHorizontalDivider()
          ]),
        );
      }).toList();
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

  Widget _buildOrderingType() {
    return Container(
      margin: EdgeInsets.only(top: 0 * rpx, bottom: 15 * rpx, left: 0 * rpx),
      child: Row(
        children: [
          Container(
            width: 250 * rpx,
            height: 100 * rpx,
            child: _buildChangeButton('待到账', null, 0, null, 0),
          ),
          Container(
            width: 250 * rpx,
            height: 100 * rpx,
            child: _buildChangeButton('已到账', null, 1, null, 1),
          ),
          Container(
            width: 250 * rpx,
            height: 100 * rpx,
            child: _buildChangeButton('拒绝申请', null, 2, null, 2),
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
        onTap: () {
          setState(() {
            _drawingRecordsList.clear();
            if (qt != null) {
              queryStatus = qt;
            }
            _getDrawingRecords();
          });
        },
        child: Container(
          alignment: Alignment.center,
          color: Colors.red[900],
          height: 60 * rpx,
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontSize: 23 * rpx,
                fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          setState(() {
            _drawingRecordsList.clear();
            if (qt != null) {
              queryStatus = qt;
            }
            _getDrawingRecords();
          });
        },
        child: Container(
          height: 60 * rpx,
          alignment: Alignment.center,
          color: Colors.red[800],
          child: Text(
            text,
            style: TextStyle(
                color: backgroundFontColor,
                fontSize: 23 * rpx,
                fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  Widget buildOrderButtomInfo(val) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 6 * rpx),
          child: Row(
            children: [
              // buildPerson(val),
              Expanded(child: Container()),
              Container(
                margin: EdgeInsets.only(
                    left: 20 * rpx,
                    bottom: 10 * rpx,
                    top: 6 * rpx,
                    right: 20 * rpx),
                child: Text(
                  '下单时间 ' + val['createTime'],
                  style: TextStyle(
                      color: Color.fromRGBO(77, 99, 104, 1),
                      fontSize: 25 * rpx),
                  textAlign: TextAlign.left,
                ),
              )
            ],
          ),
        ),
        // Container(
        //   margin: EdgeInsets.only(left: 20 * rpx, top: 6 * rpx),
        //   child: Container(
        //     child: Text(
        //       '收件地址：' + val['orderAddress'],
        //       style: TextStyle(
        //           color: Color.fromRGBO(77, 99, 104, 1), fontSize: 25 * rpx),
        //       textAlign: TextAlign.left,
        //       maxLines: 1,
        //     ),
        //   ),
        // )
      ],
    );
  }

  // Widget buildPerson(val) {
  //   return Container(
  //     alignment: Alignment.centerLeft,
  //     margin: EdgeInsets.only(left: 20 * rpx),
  //     child: Text(
  //       queryType == 2 ? '下单人：' + val['doOrderPerson'] : '收件人：' + val['person'],
  //       style: TextStyle(
  //           color: Color.fromRGBO(77, 99, 104, 1), fontSize: 25 * rpx),
  //     ),
  //   );
  // }

  Widget buildClassify(val) {
    List<dynamic> goodCategories = jsonDecode(val['goodCategories']);
    List<dynamic> goodSpecifics = jsonDecode(val['goodSpecifics']);
    print('goodCategories goodSpecifics ' +
        goodCategories.toString() +
        "," +
        goodSpecifics.toString());
    return Container(
      margin: EdgeInsets.only(left: 50 * rpx, bottom: 10 * rpx, top: 20 * rpx),
      child: Row(
        children: [
          Container(
            // alignment: Alignment.topLeft,
            margin: EdgeInsets.only(right: 20 * rpx),
            child: Text(
              goodCategories[val['classify'] - 1].toString() +
                  " " +
                  goodSpecifics[val['specification']],
              style: TextStyle(
                  color: Color.fromRGBO(77, 99, 104, 1), fontSize: 25 * rpx),
            ),
          ),
          Container(
            // alignment: Alignment.topLeft,
            margin: EdgeInsets.only(right: 30 * rpx),
            child: Text(
              '   x' + val['orderCount'].toString(),
              style: TextStyle(
                  color: Color.fromRGBO(77, 99, 104, 1), fontSize: 25 * rpx),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIncomeAndPrice(val) {
    if (userInfo.isAgent()) {
      return Container(
        margin: EdgeInsets.only(bottom: 5 * rpx),
        child: Row(
          children: [
            Container(
              // alignment: Alignment.bottomRight,
              margin: EdgeInsets.only(left: 20 * rpx),
              child: Text(
                '实付金额 ',
                style: TextStyle(
                    color: Color.fromRGBO(77, 99, 104, 1), fontSize: 25 * rpx),
              ),
            ),
            Container(
              // alignment: Alignment.bottomRight,
              margin: EdgeInsets.only(right: 20 * rpx),
              child: Text(
                (val['realPrice'] * val['orderCount']).toString() + '元',
                style: TextStyle(
                    color: Color.fromRGBO(77, 99, 104, 1), fontSize: 25 * rpx),
              ),
            ),
            Expanded(child: Container()),
            Container(
              // alignment: Alignment.topLeft,
              margin: EdgeInsets.only(right: 20 * rpx),
              child: Text(
                '收益 ',
                style: TextStyle(
                    color: Color.fromRGBO(77, 99, 104, 1), fontSize: 25 * rpx),
              ),
            ),
            Container(
              // alignment: Alignment.bottomRight,
              margin: EdgeInsets.only(right: 10 * rpx),
              child: Text(
                val['income'].toString(),
                style: TextStyle(
                    color: Color.fromRGBO(77, 99, 104, 1), fontSize: 25 * rpx),
              ),
            ),
            Container(
              // alignment: Alignment.bottomRight,
              margin: EdgeInsets.only(right: 10 * rpx),
              child: Text(
                val['equalLevelIncome'] > 0
                    ? '[同级 ' + val['equalLevelIncome'].toString() + "]"
                    : '',
                style: TextStyle(
                    color: Color.fromRGBO(77, 99, 104, 1), fontSize: 25 * rpx),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _createDrawingInfoRow(val) {
    return Container(
      margin: EdgeInsets.only(
          left: 10 * rpx, top: 10 * rpx, right: 10 * rpx, bottom: 10 * rpx),
      child: Row(
        children: [
          Container(
            height: 130 * rpx,
            width: 355 * rpx,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0 * rpx)),
              border: new Border.all(width: 1 * rpx, color: Colors.white),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    '提款金额',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 25 * rpx),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10 * rpx, top: 10 * rpx),
                  child: Text(
                    val['amount'].toString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 40 * rpx,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 6 * rpx),
            height: 130 * rpx,
            width: 355 * rpx,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0 * rpx)),
              border: new Border.all(width: 1 * rpx, color: Colors.white),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    '提款状态',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25 * rpx),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10 * rpx, top: 10 * rpx),
                  child: Text(
                    val['status'],
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30 * rpx,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createBankInfoRow(val) {
    return Container(
      margin: EdgeInsets.only(left: 50 * rpx, right: 30 * rpx),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                child: Text(
                  val['bankType'].toString(),
                  style: TextStyle(
                      color: Color.fromRGBO(77, 99, 104, 1),
                      fontSize: 28 * rpx),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _createBankNumberInfoRow(val) {
    return Container(
      margin: EdgeInsets.only(left: 50 * rpx, right: 30 * rpx, top: 20 * rpx),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                child: Text(
                  val['bankNumber'],
                  style: TextStyle(color: Colors.grey, fontSize: 23 * rpx),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _createCreateTimeRow(val) {
    return Container(
      margin: EdgeInsets.only(left: 50 * rpx, top: 20 * rpx, bottom: 10 * rpx),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                child: Text(
                  val['createTime'],
                  style: TextStyle(color: Colors.grey, fontSize: 23 * rpx),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _createRefuseReasonRow(val) {
    if (queryStatus == 2) {
      return Container(
        margin:
            EdgeInsets.only(left: 50 * rpx, bottom: 10 * rpx, top: 10 * rpx),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  child: Text(
                    '拒绝原因: ' + val['refuseReason'],
                    style: TextStyle(color: Colors.grey, fontSize: 23 * rpx),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Widget _createDrawingAmountRow(val) {
    return Container(
      margin: EdgeInsets.only(top: 50 * rpx, bottom: 20 * rpx),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                child: Text(
                  '-' + val['amount'].toString() + '.00',
                  style: TextStyle(
                      color: queryStatus == 0 ? mainColor : Colors.black,
                      fontSize: 33 * rpx,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _createDrawingStatusRow(val) {
    return Container(
      margin: EdgeInsets.only(top: 10 * rpx, bottom: 30 * rpx),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                child: Text(
                  val['status'],
                  style: TextStyle(color: Colors.grey, fontSize: 26 * rpx),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateRange() {
    return Container(
      width: 750 * rpx,
      height: 100 * rpx,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildStartDate(),
          Container(child: Text('至')),
          _buildEndDate()
        ],
      ),
    );
  }

  Widget _buildStartDate() {
    return Container(
      child: FlatButton(
        child: Text(
          DateFormat("yyyy-MM-dd").format(startDate),
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
        color: Colors.white,
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
              _drawingRecordsList.clear();
              startDate = result;
              _getDrawingRecords();
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
          DateFormat("yyyy-MM-dd").format(endDate),
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
        color: Colors.white,
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
              _drawingRecordsList.clear();
              endDate = result;
              _getDrawingRecords();
            }
          });
        },
      ),
    );
  }
}
