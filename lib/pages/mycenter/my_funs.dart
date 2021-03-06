import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:mstimes/common/control.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/local_share/account_info.dart';
import 'package:mstimes/tools/common_container.dart';
import 'package:mstimes/utils/color_util.dart';
import 'package:mstimes/utils/date_utils.dart';

class MyFunsPage extends StatefulWidget {
  MyFunsPage({Key key}) : super(key: key);

  @override
  _MyFunsPageState createState() => _MyFunsPageState();
}

class _MyFunsPageState extends State<MyFunsPage> {
  double rpx;
  DateTime startDate = null;
  DateTime endDate = null;
  int pageNum = 0;
  int pageSize = 20;
  List<Map> _funsInfoList = [];
  int mType = -1;
  int relationType = -1;
  var funsSummaryData;
  int funsCount = 0;

  @override
  void initState() {
    super.initState();

    startDate = DateTime.parse("2021-01-01");
    endDate = DateTime.now().add(new Duration(days: 1));

    _getFunsSummary(UserInfo.getUserInfo().userId);
    _getFunsCountToday(UserInfo.getUserInfo().userId);
    _getFunsInfoList();
  }

  void _getFunsSummary(agentId) {
    FormData formData = new FormData.fromMap({
      "agentId": agentId,
    });
    requestDataByUrl('queryFunsSummary', formData: formData).then((val) {
      var data = json.decode(val.toString());
      if (debug) {
        print("queryFunsSummary data " + data.toString());
      }

      setState(() {
        funsSummaryData = (data['dataList'] as List).cast();
      });
    });
  }

  void _getFunsCountToday(agentId) {
    FormData formData = new FormData.fromMap({
      "agentId": agentId,
      "startTime": formatDate(DateTime.now(), ymdFormat),
      "endTime": formatDate(DateTime.now().add(new Duration(days: 1)), ymdFormat),
      // "startTime": DateFormat("yyyy-MM-dd").format(DateTime.now()),
      // "endTime": DateFormat("yyyy-MM-dd")
      //     .format(DateTime.now().add(new Duration(days: 1))),
    });
    requestDataByUrl('queryFunsCount', formData: formData).then((val) {
      var data = json.decode(val.toString());
      if (debug) {
        print("queryFunsCount data " + data.toString());
      }

      setState(() {
        funsCount = int.parse(data['dataList'][0].toString());
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
          '????????????',
          style: TextStyle(fontSize: 30 * rpx, fontWeight: FontWeight.bold),
        ),
      ),
      body: EasyRefresh(
          child: _wrapList(),
          header: ClassicalHeader(
            showInfo: false,
            textColor: mainColor,
            refreshingText: "Ms??????",
            refreshedText: "Ms??????",
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
            loadFailedText: "???????????????????????????????????????...",
            noMoreText: "????????????",
          ),
          onRefresh: () async {},
          onLoad: () async {
            ++pageNum;
            _getFunsInfoList();
          }),
    );
  }

  Widget _wrapList() {
    List<Widget> wrapList = List<Widget>();
    wrapList.add(funsSummary(rpx));

    wrapList.add(_buildDateRange());

    if (debug) {
      print('_funsInfoList.length : ' + _funsInfoList.length.toString());
    }

    if (_funsInfoList.length != 0) {
      List<Widget> listWidget = _funsInfoList.map((val) {
        return Container(
          width: 720 * rpx,
          height: 310 * rpx,
          margin: EdgeInsets.only(
              left: 6 * rpx, top: 6 * rpx, right: 6 * rpx, bottom: 6 * rpx),
          // alignment: Alignment(0, 0),
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15.0 * rpx)),
            border: new Border.all(width: 1 * rpx, color: Colors.grey),
          ),
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // _buildPersonInfoRow(val),
              // _buildSaleInfoRow(val),
              // Expanded(child: Container()),
              // _createJoinDateRow(val)
              _createImageColumn(val),
              _createFunsInfos(val)
            ],
          ),
        );
      }).toList();
      wrapList.addAll(listWidget);
    } else {
      wrapList.add(Container(
        height: 800 * rpx,
        alignment: Alignment.center,
        child: Text('????????????'),
      ));
    }

    return ListView(
      children: wrapList,
    );
  }

  // Widget _buildIntrRelationInfoRow(val) {
  //   return Container(
  //     alignment: Alignment.bottomLeft,
  //     height: 80 * rpx,
  //     margin: EdgeInsets.only(bottom: 10 * rpx, left: 20 * rpx),
  //     child: Text(
  //       '????????????: ' + val['introduceRelation'],
  //       maxLines: 1,
  //       style: TextStyle(
  //           color: Color.fromRGBO(77, 99, 104, 1), fontSize: 28 * rpx),
  //     ),
  //   );
  // }

  Widget funsSummary(rpx) {
    return Container(
        height: 300 * rpx,
        width: 700 * rpx,
        margin: EdgeInsets.only(bottom: 10 * rpx),
        decoration: new BoxDecoration(
            //??????
            color: mainColor,
            //?????????????????? ??????
            // borderRadius: BorderRadius.all(Radius.circular(10.0 * rpx)),
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
                        left: 10 * rpx, top: 80 * rpx, bottom: 10 * rpx),
                    child: Text('????????????',
                        style: TextStyle(
                          fontSize: 23 * rpx,
                          color: Colors.white,
                        )),
                  ),
                  buildCommonPrice(
                      funsSummaryData,
                      funsSummaryData == null ||
                              funsSummaryData[0]['realPriceSum'] == null
                          ? '0.00'
                          : funsSummaryData[0]['realPriceSum'].toString(),
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
                    child: Container(
                      margin: EdgeInsets.only(left: 30 * rpx, bottom: 10 * rpx),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            child: Text('????????????',
                                style: TextStyle(
                                  fontSize: 23 * rpx,
                                  color: Colors.white,
                                )),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 20 * rpx),
                              child: Text(
                                funsSummaryData == null ||
                                        funsSummaryData[0]['funsCount'] ==
                                            null
                                    ? '0'
                                    : funsSummaryData[0]['funsCount']
                                        .toString(),
                                style: TextStyle(
                                  fontSize: 23 * rpx,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          child: Text('????????????',
                              style: TextStyle(
                                fontSize: 23 * rpx,
                                color: Colors.white,
                              )),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 20 * rpx),
                            child: Text(
                              funsCount.toString(),
                              style: TextStyle(
                                fontSize: 23 * rpx,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  Widget _createFunsInfos(val){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPersonInfoRow(val),
        _buildSaleInfoRow(val),
        _createJoinDateRow(val)
      ],
    );
  }

  Widget _buildPersonInfoRow(val) {
    return Container(
      margin: EdgeInsets.only(top: 20 * rpx, left: 30 * rpx, right: 20 * rpx),
      height: 100 * rpx,
      child: Row(
          children: [
            _createNameColumn(val),
            _createUserNumberColumn(val),
          ],
        )
    );
  }

  Widget _buildSaleInfoRow(val) {
    return Container(
      margin: EdgeInsets.only(top: 15 * rpx, left: 30 * rpx, right: 40 * rpx),
      child: Row(
        children: [
          _createMySaleColumn(val),
          _createMyIncomeColumn(val),
          _createOrderCountsColumn(val),
        ],
      ),
    );
  }

  Widget _createJoinDateRow(val) {
    return Container(
      margin: EdgeInsets.only(left: 30 * rpx, bottom: 20 * rpx, top: 15 * rpx),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            child: Text(
              '????????????',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                  fontSize: 26 * rpx),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20 * rpx),
            child: Text(
              val['createTime'],
              style: TextStyle(color: Colors.grey, fontSize: 26 * rpx),
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
  //             '??????',
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
      height: 100 * rpx,
      margin: EdgeInsets.only(left: 120 * rpx),
      child: Column(
        children: [
          Container(
            child: Text(
              '?????????',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Color.fromRGBO(77, 99, 104, 1),
                  fontSize: 28 * rpx),
            ),
          ),
          Container(
            // padding: EdgeInsets.only(top: 10 * rpx),
            margin: EdgeInsets.only(left: 10 * rpx, top: 15 * rpx),
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
      height: 100 * rpx,
      child: Column(
        children: [
          Container(
            child: Text(
              '????????????',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Color.fromRGBO(77, 99, 104, 1),
                  fontSize: 28 * rpx),
            ),
          ),
          Container(
            // padding: EdgeInsets.only(top: 10 * rpx),
            margin: EdgeInsets.only(left: 10 * rpx, top: 15 * rpx),
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
      height: 100 * rpx,
      margin: EdgeInsets.only(left: 120 * rpx),
      child: Column(
        children: [
          Container(
            child: Text(
              '??????',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Color.fromRGBO(77, 99, 104, 1),
                  fontSize: 28 * rpx),
            ),
          ),
          Container(
            // padding: EdgeInsets.only(top: 10 * rpx),
            margin: EdgeInsets.only(left: 10 * rpx, top: 15 * rpx),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            child: Text(
              '????????????',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(77, 99, 104, 1),
                  fontSize: 28 * rpx),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 15 * rpx, right: 20 * rpx),
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
      width: 100 * rpx,
      height: 100 * rpx,
      margin: EdgeInsets.only(left: 30 * rpx, top: 80 * rpx, right: 30 * rpx),
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
      margin: EdgeInsets.only(right: 10 * rpx),
      child: Row(
        children: [
          Container(
            child: Text(
              '??????',
              style: TextStyle(
                  color: Color.fromRGBO(77, 99, 104, 1),
                  fontWeight: FontWeight.w800,
                  fontSize: 28 * rpx),
            ),
          ),
          Container(
            width: 140 * rpx,
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              val['userName'],
              overflow: TextOverflow.ellipsis,
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
              _funsInfoList.clear();
              if (mt != null) {
                mType = mt;
              }
              if (rt != null) {
                relationType = rt;
              }
              _getFunsInfoList();
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
              _funsInfoList.clear();
              if (mt != null) {
                mType = mt;
              }
              if (rt != null) {
                relationType = rt;
              }

              _getFunsInfoList();
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
            child: _buildChangeButton('??????', null, -1, null, -1),
          ),
          Container(
            margin: EdgeInsets.only(left: 30 * rpx),
            child: _buildChangeButton('??????', null, 1, null, 1),
          ),
          Container(
            margin: EdgeInsets.only(left: 30 * rpx),
            child: _buildChangeButton('??????', null, 2, null, 2),
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
            child: _buildChangeButton('??????', -1, null, -1, null),
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

  void _getFunsInfoList() {
    if (debug) {
      print('_getFunsInfoList startTime : ' +
          formatDate(startDate, ymdFormat) +
          ", endTime : " +
          formatDate(endDate, ymdFormat));
    }

    FormData formData = new FormData.fromMap({
      "agentId": UserInfo.getUserInfo().userId,
      "startTime": formatDate(startDate, ymdFormat),
      "endTime": formatDate(endDate, ymdFormat),
      // "startTime": DateFormat("yyyy-MM-dd").format(startDate),
      // "endTime": DateFormat("yyyy-MM-dd").format(endDate),
      "pageNum": pageNum,
      "pageSize": pageSize
    });

    requestDataByUrl('queryMyFuns', formData: formData).then((val) {
      var data = json.decode(val.toString());
      List<Map> funsInfoList = (data['dataList'] as List).cast();
      // if (debug) {
        print("_getFunsInfoList : " +
            funsInfoList.toString() +
            ",funsInfoList length" +
            funsInfoList.length.toString());
      // }

      if (funsInfoList.isNotEmpty && funsInfoList.length > 0) {
        setState(() {
          _funsInfoList.addAll(funsInfoList);
        });
      }
    });
  }

  Widget _buildDateRange() {
    return Row(
      children: [
        _buildStartDate(),
        Container(child: Text('???')),
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
              _funsInfoList.clear();
              startDate = result;
              _getFunsInfoList();
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
              _funsInfoList.clear();
              endDate = result;
              _getFunsInfoList();
            }
          });
        },
      ),
    );
  }
}
