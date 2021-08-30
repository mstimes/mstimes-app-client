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
import 'package:intl/intl.dart';

class DrawingAuditPage extends StatefulWidget {
  DrawingAuditPage({Key key}) : super(key: key);
  @override
  _DrawingAuditPageState createState() => _DrawingAuditPageState();
}

class _DrawingAuditPageState extends State<DrawingAuditPage> {
  double rpx;
  int pageNum = 0;
  int pageSize = 20;
  DateTime startDate = null;
  DateTime endDate = null;
  List<Map> _drawingRecordsList = [];
  var userInfo;
  int totalCounts = 0;
  int queryStatus = 0;
  var refuseReason;
  Map<int, String> refuseReasonMap = new Map();

  @override
  void initState() {
    super.initState();

    startDate = DateTime.parse("2021-01-01");
    endDate = DateTime.now().add(new Duration(days: 1));
    userInfo = UserInfo.getUserInfo();

    _getDrawingAuditRecords();
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
          '提款审核',
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
            if (totalCounts > pageSize + pageNum * pageSize) {
              ++pageNum;
              _getDrawingAuditRecords();
            }
          }),
    );
  }

  void _getDrawingAuditRecords() {
    if (debug) {
      print('_getDrawingRecords startTime : ' +
          formatDate(startDate, ymdFormat) +
          ", endTime : " +
          formatDate(endDate, ymdFormat));
    }

    FormData formData = new FormData.fromMap({
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

      totalCounts = data['pageTotalCount'];
      print('queryDrawingRecordsByStatus ' + totalCounts.toString());
      List<Map> drawingRecordsList = (data['dataList'] as List).cast();
      setState(() {
        _drawingRecordsList.addAll(drawingRecordsList);
      });
    });
  }

  Widget _wrapList() {
    List<Widget> wrapList = List<Widget>();
    wrapList.add(_buildDateRange());

    if (_drawingRecordsList.length != 0) {
      wrapList.add(buildCommonHorizontalDivider());
      List<Widget> listWidget = _drawingRecordsList.map((val) {
        return Container(
          height: 360 * rpx,
          child: Column(children: [
            Row(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _createBankInfoRow(val),
                  _createBankNumberInfoRow(val),
                  _createUserNameRow(val),
                  _createDepositRegionRow(val),
                  _createDepositBankRow(val),
                  _createCreateTimeRow(val),
                  _createRefuseReasonRow(val),
                ],
              ),
              Expanded(child: Container()),
              Container(
                margin: EdgeInsets.only(right: 30 * rpx, bottom: 20 * rpx),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _createDrawingAmountRow(val),
                    _createDrawingAuditButtonRow(val),
                    _createRefuseReasonSelect(val)
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
      wrapList.add(Container(
        height: 800 * rpx,
        alignment: Alignment.center,
        child: Text(''),
      ));
    }

    return ListView(
      children: wrapList,
    );
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
      child: Row(
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

  Widget _createDepositRegionRow(val) {
    return Container(
      margin: EdgeInsets.only(left: 50 * rpx, right: 30 * rpx, top: 20 * rpx),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                child: Text(
                  val['depositRegion'].toString(),
                  style: TextStyle(color: Colors.grey, fontSize: 23 * rpx),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _createUserNameRow(val) {
    return Container(
      margin: EdgeInsets.only(left: 50 * rpx, right: 30 * rpx, top: 20 * rpx),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                child: Text(
                  val['userName'].toString(),
                  style: TextStyle(color: Colors.grey, fontSize: 23 * rpx),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _createDepositBankRow(val) {
    return Container(
      margin: EdgeInsets.only(left: 50 * rpx, right: 30 * rpx, top: 20 * rpx),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                child: Text(
                  val['depositBank'].toString(),
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
                  val['amount'].toString() + '.00',
                  style: TextStyle(
                      color: Colors.black,
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

  Widget _createDrawingAuditButtonRow(val) {
    return Container(
      margin: EdgeInsets.only(top: 10 * rpx, bottom: 30 * rpx),
      child: Row(
        children: [
          Container(
            child: InkWell(
              onTap: () {
                _auditPass(val['id']);
              },
              child: Container(
                width: 80 * rpx,
                alignment: Alignment.center,
                height: 60 * rpx,
                decoration: new BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(10.0 * rpx)),
                  border: new Border.all(width: 1 * rpx, color: Colors.white),
                ),
                child: Text(
                  '通过',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 23 * rpx,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(
            child: InkWell(
              onTap: () {
                setState(() {
                  _auditRefuse(val['id']);
                });
              },
              child: Container(
                width: 80 * rpx,
                margin: EdgeInsets.only(left: 20 * rpx),
                alignment: Alignment.center,
                height: 60 * rpx,
                decoration: new BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(10.0 * rpx)),
                  border: new Border.all(width: 1 * rpx, color: Colors.white),
                ),
                child: Text(
                  '拒绝',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 23 * rpx,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem<dynamic>> _buildDropdownMenuItems() {
    List<DropdownMenuItem<dynamic>> list =
        new List<DropdownMenuItem<dynamic>>();
    list.add(
      DropdownMenuItem(
          child: Row(children: <Widget>[
            Text('姓名与帐号不匹配', style: TextStyle(fontSize: 25 * rpx)),
            SizedBox(width: 4),
          ]),
          value: '姓名与帐号不匹配'),
    );
    list.add(
      DropdownMenuItem(
          child: Row(children: <Widget>[
            Text('开户行与地区不匹配', style: TextStyle(fontSize: 25 * rpx)),
            SizedBox(width: 4),
          ]),
          value: '开户行与地区不匹配'),
    );
    list.add(
      DropdownMenuItem(
          child: Row(children: <Widget>[
            Text('银行卡号错误', style: TextStyle(fontSize: 25 * rpx)),
            SizedBox(width: 4),
          ]),
          value: '银行卡号错误'),
    );
    list.add(
      DropdownMenuItem(
          child: Row(children: <Widget>[
            Text('提款人姓名错误', style: TextStyle(fontSize: 25 * rpx)),
            SizedBox(width: 4),
          ]),
          value: '提款人姓名错误'),
    );
    list.add(
      DropdownMenuItem(
          child: Row(children: <Widget>[
            Text('开户信息错误', style: TextStyle(fontSize: 25 * rpx)),
            SizedBox(width: 4),
          ]),
          value: '开户信息错误'),
    );
    list.add(
      DropdownMenuItem(
          child: Row(children: <Widget>[
            Text('信息不完整', style: TextStyle(fontSize: 25 * rpx)),
            SizedBox(width: 4),
          ]),
          value: '信息不完整'),
    );
    list.add(
      DropdownMenuItem(
          child: Row(children: <Widget>[
            Text('其他原因', style: TextStyle(fontSize: 25 * rpx)),
            SizedBox(width: 4),
          ]),
          value: '其他原因'),
    );
    return list;
  }

  _createRefuseReasonSelect(val) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 50 * rpx),
          height: 80 * rpx,
          width: 300 * rpx,
          child: _showDropdownList(val['id']),
        )
      ],
    );
  }

  Widget _showDropdownList(id) {
    return DropdownButton(
        value: refuseReasonMap[id] == null ? refuseReason : refuseReasonMap[id],
        underline: Container(height: 0),
        hint: Text(
          '选择拒绝原因',
          style: TextStyle(fontSize: 25 * rpx),
        ),
        items: _buildDropdownMenuItems(),
        onChanged: (value) => setState(() => {refuseReasonMap[id] = value}));
  }

  void _auditPass(id) {
    FormData formData = new FormData.fromMap(
        {"newStatus": 1, "refuseReason": '', "drawingId": id});
    requestDataByUrl('updateDrawingStatus', formData: formData).then((val) {
      var data = json.decode(val.toString());
      setState(() {
        _drawingRecordsList.clear();
        _getDrawingAuditRecords();
        if (debug) {
          print("updateDrawingStatus list : " + data.toString());
        }
      });
    });
  }

  void _auditRefuse(id) {
    FormData formData = new FormData.fromMap(
        {"newStatus": 2, "refuseReason": refuseReasonMap[id], "drawingId": id});
    requestDataByUrl('updateDrawingStatus', formData: formData).then((val) {
      var data = json.decode(val.toString());
      setState(() {
        _drawingRecordsList.clear();
        _getDrawingAuditRecords();
        if (debug) {
          print("updateDrawingStatus list : " + data.toString());
        }
      });
    });
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
              _getDrawingAuditRecords();
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
              _getDrawingAuditRecords();
            }
          });
        },
      ),
    );
  }
}
