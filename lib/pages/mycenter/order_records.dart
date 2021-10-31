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

class OrderRecordsPage extends StatefulWidget {
  OrderRecordsPage({Key key}) : super(key: key);
  @override
  _OrderRecordsPageState createState() => _OrderRecordsPageState();
}

class _OrderRecordsPageState extends State<OrderRecordsPage> {
  double rpx;
  int pageNum = 0;
  int pageSize = 20;
  DateTime startDate = null;
  DateTime endDate = null;
  List<Map> _orderList = [];
  List<DataList> fundSummary = new List<DataList>();
  List<DataList> fundTodaySummary = new List<DataList>();
  List<DataList> fundMonthSummary = new List<DataList>();
  int myOrderCounts = 0;
  int funsOrderCounts = 0;
  var userInfo;
  int totalOrderCounts = 0;
  int queryType = 0;

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
    } else {
      queryType = 3;
    }

    _getOrderInfos();
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
            if (totalOrderCounts > pageSize + pageNum * pageSize) {
              ++pageNum;
              _getOrderInfos();
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
      "startDate": formatDate(startDate, ymdFormat),
      "endDate": formatDate(endDate, ymdFormat),
      // "startDate": DateFormat("yyyy-MM-dd").format(startDate),
      // "endDate": DateFormat("yyyy-MM-dd").format(endDate)
    });
    requestDataByUrl('queryFundSummary', formData: formData).then((val) {
      var data = json.decode(val.toString());
      if (debug) {
        print("_getFundSummary : " + data.toString());
      }
      print("_getFundSummary : " + data.toString());

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

  void _getOrderInfos() {
    if (debug) {
      print('_getOrderInfos startTime : ' +
          formatDate(startDate, ymdFormat) +
          ", endTime : " +
          formatDate(endDate, ymdFormat));
    }

    FormData formData = new FormData.fromMap({
      "queryType": queryType,
      "userId": userInfo.userId,
      "userNumber": userInfo.userNumber,
      "startTime": formatDate(startDate, ymdFormat),
      "endTime": formatDate(endDate, ymdFormat),
      "pageNum": pageNum,
      "pageSize": pageSize
    });
    requestDataByUrl('queryOrders', formData: formData).then((val) {
      var data = json.decode(val.toString());
      if (debug) {
        print("queryOrders list : " + data.toString());
      }

      totalOrderCounts = data['pageTotalCount'];
      print('totalOrderCounts ' + totalOrderCounts.toString());
      List<Map> orderList = (data['dataList'] as List).cast();
      setState(() {
        _orderList.addAll(orderList);
      });
    });
  }

  void _getMyOrderCounts(userId) {
    FormData formData = new FormData.fromMap({
      'queryType': 1,
      "userId": UserInfo.getUserInfo().userId,
      "userNumber": UserInfo.getUserInfo().userNumber,
      "startTime": formatDate(startDate, ymdFormat),
      "endTime": formatDate(endDate, ymdFormat),
      // "startTime": DateFormat("yyyy-MM-dd").format(startDate),
      // "endTime": DateFormat("yyyy-MM-dd").format(endDate),
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
      "startTime": formatDate(startDate, ymdFormat),
      "endTime": formatDate(endDate, ymdFormat),
      // "startTime": DateFormat("yyyy-MM-dd").format(startDate),
      // "endTime": DateFormat("yyyy-MM-dd").format(endDate),
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
              // padding: EdgeInsets.only(left: 10 * rpx, top: 10 * rpx),
              width: 300 * rpx,
              height: 200 * rpx,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        left: 0 * rpx, top: 60 * rpx, bottom: 10 * rpx),
                    child: Text('我的收益',
                        style: TextStyle(
                          fontSize: 23 * rpx,
                          color: Colors.white,
                        )),
                  ),
                  buildCommonPrice(
                      fundSummary,
                      fundSummary.isEmpty ? null : fundSummary[0].myIncome,
                      25,
                      50,
                      Colors.white,
                      rpx,
                      MainAxisAlignment.center,
                      true),
                ],
              ),
            ),
            Expanded(child: Container()),
            Container(
              child: Row(
                children: [
                  Container(
                    height: 60 * rpx,
                    margin: EdgeInsets.only(
                        left: 30 * rpx,
                        bottom: 10 * rpx,
                        right: 30 * rpx,
                        top: 5 * rpx),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Text('订单数',
                              style: TextStyle(
                                fontSize: 23 * rpx,
                                color: Colors.white,
                              )),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 10 * rpx),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  (myOrderCounts + funsOrderCounts).toString(),
                                  style: TextStyle(
                                    fontSize: 23 * rpx,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )),
                        Container(
                          margin: EdgeInsets.only(left: 10 * rpx),
                          child: Text('笔',
                              style: TextStyle(
                                fontSize: 20 * rpx,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    height: 60 * rpx,
                    child: Container(
                      margin: EdgeInsets.only(left: 20 * rpx, bottom: 10 * rpx),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 5 * rpx),
                            width: 100 * rpx,
                            child: Text('本月收益',
                                style: TextStyle(
                                  fontSize: 23 * rpx,
                                  color: Colors.white,
                                )),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 5 * rpx, left: 10 * rpx),
                            child: Text(
                                fundMonthSummary.isEmpty
                                    ? '0.00'
                                    : fundMonthSummary[0].myIncome,
                                style: TextStyle(
                                  fontSize: 23 * rpx,
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    height: 60 * rpx,
                    child: Container(
                      margin: EdgeInsets.only(left: 20 * rpx, bottom: 10 * rpx),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 5 * rpx),
                            width: 100 * rpx,
                            child: Text('今日收益',
                                style: TextStyle(
                                  fontSize: 23 * rpx,
                                  color: Colors.white,
                                )),
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                  left: 10 * rpx,
                                  right: 20 * rpx,
                                  top: 5 * rpx),
                              child: Text(
                                  fundTodaySummary.isEmpty
                                      ? '0.00'
                                      : fundTodaySummary[0].myIncome,
                                  style: TextStyle(
                                    fontSize: 23 * rpx,
                                    color: Colors.white,
                                  ))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Widget _wrapList() {
    List<Widget> wrapList = List<Widget>();
    if (userInfo.isAgent()) {
      wrapList.add(myIncomeSummary(rpx));
    }
    wrapList.add(_buildDateRange());

    if (userInfo.isAgent()) {
      wrapList.add(_buildOrderingType());
    }

    if (_orderList.length != 0) {
      List<Widget> listWidget = _orderList.map((val) {
        return Container(
          width: 700 * rpx,
          height: 360 * rpx,
          margin: EdgeInsets.only(
              left: 6 * rpx, top: 10 * rpx, right: 6 * rpx, bottom: 6 * rpx),
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15.0 * rpx)),
            border: new Border.all(width: 1 * rpx, color: Colors.grey),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildOrderNumber(val),
              makeImageArea(val),
              buildOrderButtomInfo(val)
            ],
          ),
        );
      }).toList();

      if (listWidget.length >= totalOrderCounts) {
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

  // Widget _buildOrderQueryType() {
  //   return Container(
  //     margin: EdgeInsets.only(top: 30 * rpx, bottom: 20 * rpx),
  //     child: Row(
  //       children: [
  //         Container(
  //           margin: EdgeInsets.only(left: 120 * rpx),
  //           child: _buildChangeButton('团队订单', null, -1, null, -1),
  //         ),
  //         Container(
  //           margin: EdgeInsets.only(left: 30 * rpx),
  //           child: _buildChangeButton('零售订单', null, 1, null, 1),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildOrderingType() {
    return Container(
      margin: EdgeInsets.only(top: 0 * rpx, bottom: 15 * rpx, left: 60 * rpx),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 180 * rpx,
            child: _buildChangeButton('我的订单', null, 0, null, 0),
          ),
          Container(
            margin: EdgeInsets.only(left: 40 * rpx),
            width: 180 * rpx,
            child: _buildChangeButton('粉丝订单', null, 2, null, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeButton(text, mt, qt, mtIndex, qtIndex) {
    bool select = false;
    // if (mtIndex == orderType) {
    //   select = true;
    // } else

    if (qtIndex == queryType) {
      select = true;
    }

    if (select) {
      return Container(
        height: 50 * rpx,
        child: FlatButton(
          color: buttonColor,
          onPressed: () {
            setState(() {
              _orderList.clear();
              // if (mt != null) {
              //   orderType = mt;
              // }
              if (qt != null) {
                queryType = qt;
              }
              _getOrderInfos();
            });
          },
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 25 * rpx),
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
              _orderList.clear();
              // if (mt != null) {
              //   orderType = mt;
              // }
              if (qt != null) {
                queryType = qt;
              }
              _getOrderInfos();
            });
          },
          child: Text(
            text,
            style: TextStyle(color: buttonColor, fontSize: 25 * rpx),
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
              buildPerson(val),
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

  Widget buildPerson(val) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 20 * rpx),
      child: Text(
        queryType == 2 ? '下单人：' + val['doOrderPerson'] : '收件人：' + val['person'],
        style: TextStyle(
            color: Color.fromRGBO(77, 99, 104, 1), fontSize: 25 * rpx),
      ),
    );
  }

  Widget buildClassify(val) {
    // List<dynamic> goodCategories = jsonDecode(val['goodCategories']);
    // List<dynamic> goodSpecifics = jsonDecode(val['goodSpecifics']);
    // print('goodCategories goodSpecifics ' +
    //     goodCategories.toString() +
    //     "," +
    //     goodSpecifics.toString());
    return Container(
      margin: EdgeInsets.only(left: 50 * rpx, bottom: 10 * rpx, top: 20 * rpx),
      child: Row(
        children: [
          Container(
            // alignment: Alignment.topLeft,
            margin: EdgeInsets.only(right: 20 * rpx),
            child: Text(
              // goodCategories[val['classify'] - 1].toString() +
              //     " " +
              //     goodSpecifics[val['specification']],
              val['classify'].toString() + " " +  val['specification'].toString(),
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

  Widget buildOrderNumber(val) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 20 * rpx, bottom: 10 * rpx, top: 10 * rpx),
      child: Text(
        '订单编号 ' + val['orderNumber'],
        style: TextStyle(
            color: Color.fromRGBO(77, 99, 104, 1), fontSize: 25 * rpx),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget makeImageArea(val) {
    String imageUrl = QINIU_OBJECT_STORAGE_URL + val['mainImage'];

    return Container(
      width: 720 * rpx,
      height: 200 * rpx,
      margin: EdgeInsets.only(top: 5 * rpx, bottom: 5 * rpx),
      decoration: new BoxDecoration(
        //背景
        color: Colors.grey[100],
        //设置四周圆角 角度
        borderRadius: BorderRadius.all(Radius.circular(5.0 * rpx)),
        //设置四周边框
        border: new Border.all(width: 1 * rpx, color: Colors.white),
      ),
      child: Row(
        children: [
          Container(
            width: 170 * rpx,
            height: 180 * rpx,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20 * rpx),
              child: Image.network(imageUrl),
            ),
          ),
          Container(
            width: 530 * rpx,
            height: 180 * rpx,
            alignment: Alignment.topLeft,
            margin:
                EdgeInsets.only(top: 5 * rpx, bottom: 5 * rpx, left: 10 * rpx),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    val['title'],
                    style: TextStyle(
                        color: Color.fromRGBO(77, 99, 104, 1),
                        fontSize: 25 * rpx),
                  ),
                ),
                buildClassify(val),
                Expanded(child: Container()),
                buildIncomeAndPrice(val)
              ],
            ),
          )
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
              _orderList.clear();
              startDate = result;
              _getOrderInfos();
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
              _orderList.clear();
              endDate = result;
              _getOrderInfos();
            }
          });
        },
      ),
    );
  }
}
