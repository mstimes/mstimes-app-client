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
import 'package:intl/intl.dart';
import 'package:mstimes/utils/date_utils.dart';

class GroupInfoPage extends StatefulWidget {
  GroupInfoPage({Key key}) : super(key: key);

  @override
  _GroupInfoPageState createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  double rpx;
  DateTime startDate = null;
  DateTime endDate = null;
  int pageNum = 0;
  int pageSize = 20;
  List<Map> _agentList = [];
  int mType = -1;
  int relationType = -1;
  List<DataList> fundSummary = new List<DataList>();
  int totalCounts = 0;
  int directCounts = 0;

  @override
  void initState() {
    super.initState();

    startDate = DateTime.parse("2021-01-01");
    endDate = DateTime.now().add(new Duration(days: 1));

    _getFundSummary(UserInfo.getUserInfo().userId);
    _getAllAgentRelationCounts();
    _getDirectAgentRelationCounts();
    _getAgentRelationList();
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
            refreshingText: "Ms·时代",
            refreshedText: "Ms·时代",
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
              _getAgentRelationList();
            }
          }),
    );
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

  Widget _wrapList() {
    List<Widget> wrapList = List<Widget>();
    wrapList.add(myGroupSummary(rpx));
    wrapList.add(_buildRelationRow());
    wrapList.add(_buildAgentLevelRow());
    wrapList.add(_buildDateRange());

    if (debug) {
      print('_agentList.length : ' + _agentList.length.toString());
    }

    if (_agentList.length != 0) {
      List<Widget> listWidget = _agentList.map((val) {
        return Container(
          width: 720 * rpx,
          height: 340 * rpx,
          margin: EdgeInsets.only(
              left: 6 * rpx, top: 6 * rpx, right: 6 * rpx, bottom: 6 * rpx),
          //设置 child 居中
          alignment: Alignment(0, 0),
          //边框设置
          decoration: new BoxDecoration(
            //背景
            color: Colors.white,
            //设置四周圆角 角度
            borderRadius: BorderRadius.all(Radius.circular(15.0 * rpx)),
            //设置四周边框
            border: new Border.all(width: 1 * rpx, color: Colors.grey),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // _createAgentNumberRow(val),
              _buildPersonInfoRow(val),
              _buildIncomeInfoRow(val),
              // _buildIntrRelationInfoRow(val)
            ],
          ),
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
        child: Text('暂无数据'),
      ));
    }

    return ListView(
      children: wrapList,
    );
  }

  Widget myGroupSummary(rpx) {
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
                        left: 10 * rpx, top: 60 * rpx, bottom: 10 * rpx),
                    child: Text('团队营业额',
                        style: TextStyle(
                          fontSize: 23 * rpx,
                          color: Colors.white,
                        )),
                  ),
                  buildCommonPrice(
                      fundSummary,
                      fundSummary.isEmpty ? null : fundSummary[0].groupSales,
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
                      margin: EdgeInsets.only(left: 20 * rpx, bottom: 10 * rpx),
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Text('团队人数',
                                style: TextStyle(
                                  fontSize: 23 * rpx,
                                  color: Colors.white,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 10 * rpx, bottom: 2 * rpx),
                            child: Text(totalCounts.toString(),
                                style: TextStyle(
                                    fontSize: 23 * rpx,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    height: 60 * rpx,
                    margin: EdgeInsets.only(
                        left: 20 * rpx, bottom: 10 * rpx, right: 20 * rpx),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Text('直属人数',
                              style: TextStyle(
                                fontSize: 23 * rpx,
                                color: Colors.white,
                              )),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(left: 10 * rpx, bottom: 2 * rpx),
                          child: Text(directCounts.toString(),
                              style: TextStyle(
                                  fontSize: 23 * rpx,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
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

  Widget _buildIntrRelationInfoRow(val) {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: EdgeInsets.only(bottom: 20 * rpx, left: 50 * rpx, top: 30 * rpx),
      child: Text(
        '引荐关系: ' + val['introduceRelation'],
        maxLines: 1,
        style: TextStyle(
            color: Color.fromRGBO(77, 99, 104, 1),
            fontSize: 25 * rpx,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPersonInfoRow(val) {
    return Container(
      margin: EdgeInsets.only(
          left: 30 * rpx, right: 30 * rpx, bottom: 20 * rpx, top: 10 * rpx),
      padding: EdgeInsets.only(left: 10 * rpx),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _createImageColumn(val),
          _createAgentNameColumn(val),
          _createAgentLevelColumn(val),
          _createIntroRelationLevelColumn(val),
          _createJoinDateColumn(val)
        ],
      ),
    );
  }

  Widget _buildIncomeInfoRow(val) {
    return Container(
      margin: EdgeInsets.only(left: 30 * rpx, right: 30 * rpx, top: 20 * rpx),
      padding: EdgeInsets.only(top: 20 * rpx, left: 10 * rpx),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _createPersonIncomeColumn(val),
          buildCommonVerticalDivider(66, rpx),
          _createMyOrderCountsColumn(val),
          buildCommonVerticalDivider(66, rpx),
          _createGroupIncomeColumn(val),
          buildCommonVerticalDivider(66, rpx),
          _createGroupOrderCountsColumn(val)
        ],
      ),
    );
  }

  Widget _createJoinDateColumn(val) {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              '加入日期',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(77, 99, 104, 1),
                  fontSize: 25 * rpx),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 10 * rpx),
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              val['createDate'],
              style: TextStyle(
                  color: Color.fromRGBO(77, 99, 104, 1), fontSize: 25 * rpx),
            ),
          )
        ],
      ),
    );
  }

  Widget _createIntroRelationLevelColumn(val) {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              '层数',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(77, 99, 104, 1),
                  fontSize: 25 * rpx),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 10 * rpx),
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              val['layers'].toString(),
              style: TextStyle(
                  color: Color.fromRGBO(77, 99, 104, 1), fontSize: 25 * rpx),
            ),
          )
        ],
      ),
    );
  }

  Widget _createGroupIncomeColumn(val) {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              '团队收益',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(77, 99, 104, 1),
                  fontSize: 25 * rpx),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 10 * rpx),
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              val['groupIncome'],
              style: TextStyle(
                  color: Color.fromRGBO(77, 99, 104, 1), fontSize: 25 * rpx),
            ),
          )
        ],
      ),
    );
  }

  Widget _createGroupOrderCountsColumn(val) {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              '团队订单',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(77, 99, 104, 1),
                  fontSize: 25 * rpx),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 10 * rpx),
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              val['groupOrderCounts'].toString(),
              style: TextStyle(
                  color: Color.fromRGBO(77, 99, 104, 1), fontSize: 25 * rpx),
            ),
          )
        ],
      ),
    );
  }

  Widget _createPersonIncomeColumn(val) {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              '零售收益',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(77, 99, 104, 1),
                  fontSize: 25 * rpx),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 10 * rpx),
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              val['myIncome'],
              style: TextStyle(
                  color: Color.fromRGBO(77, 99, 104, 1), fontSize: 25 * rpx),
            ),
          )
        ],
      ),
    );
  }

  Widget _createMyOrderCountsColumn(val) {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              '零售订单',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(77, 99, 104, 1),
                  fontSize: 25 * rpx),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 10 * rpx),
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              val['myOrderCounts'].toString(),
              style: TextStyle(
                  color: Color.fromRGBO(77, 99, 104, 1), fontSize: 25 * rpx),
            ),
          )
        ],
      ),
    );
  }

  Widget _createAgentLevelColumn(val) {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              '职级',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(77, 99, 104, 1),
                  fontSize: 25 * rpx),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 10 * rpx),
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              val['levelName'],
              style: TextStyle(
                  color: Color.fromRGBO(77, 99, 104, 1), fontSize: 25 * rpx),
            ),
          )
        ],
      ),
    );
  }

  Widget _createAgentNumberRow(val) {
    return Container(
      margin: EdgeInsets.only(left: 30 * rpx, top: 10 * rpx, bottom: 10 * rpx),
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              '代理编号: ',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(77, 99, 104, 1),
                  fontSize: 25 * rpx),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              val['userNumber'],
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(77, 99, 104, 1),
                  fontSize: 25 * rpx),
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

  Widget _createAgentNameColumn(val) {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '代理昵称',
              maxLines: 1,
              style: TextStyle(
                  color: Color.fromRGBO(77, 99, 104, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 25 * rpx),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 10 * rpx),
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Text(
              val['agentName'],
              style: TextStyle(
                  color: Color.fromRGBO(77, 99, 104, 1), fontSize: 25 * rpx),
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
              _agentList.clear();
              if (mt != null) {
                mType = mt;
              }
              if (rt != null) {
                relationType = rt;
              }
              _getAgentRelationList();
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
              _agentList.clear();
              if (mt != null) {
                mType = mt;
              }
              if (rt != null) {
                relationType = rt;
              }

              _getAgentRelationList();
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

  void _getAllAgentRelationCounts() {
    FormData formData = new FormData.fromMap({
      "agentId": UserInfo.getUserInfo().userId,
      "mType": -1,
      "relationType": -1,
      "startDate": DateFormat("yyyy-MM-dd").format(startDate),
      "endDate": DateFormat("yyyy-MM-dd").format(endDate),
    });

    requestDataByUrl('countAgentRelations', formData: formData).then((val) {
      var data = json.decode(val.toString());
      List<Map> agentList = (data['dataList'] as List).cast();

      if (agentList.isNotEmpty && agentList.length > 0) {
        setState(() {
          totalCounts = int.parse(data['dataList'][0].toString());
        });
      }
    });
  }

  void _getDirectAgentRelationCounts() {
    FormData formData = new FormData.fromMap({
      "agentId": UserInfo.getUserInfo().userId,
      "mType": -1,
      "relationType": 1,
      "startDate": DateFormat("yyyy-MM-dd").format(startDate),
      "endDate": DateFormat("yyyy-MM-dd").format(endDate),
    });

    requestDataByUrl('countAgentRelations', formData: formData).then((val) {
      var data = json.decode(val.toString());
      List<Map> agentList = (data['dataList'] as List).cast();

      if (agentList.isNotEmpty && agentList.length > 0) {
        setState(() {
          directCounts = int.parse(data['dataList'][0].toString());
        });
      }
    });
  }

  void _getAgentRelationList() {
    if (debug) {
      print('__getAgentRelationList startTime : ' +
          formatDate(startDate, ymdFormat) +
          ", endTime : " +
          formatDate(endDate, ymdFormat) +
          "mType : " +
          mType.toString() +
          "relationType : " +
          relationType.toString());
    }

    FormData formData = new FormData.fromMap({
      "agentId": UserInfo.getUserInfo().userId,
      "mType": mType,
      "relationType": relationType,
      "startDate": DateFormat("yyyy-MM-dd").format(startDate),
      "endDate": DateFormat("yyyy-MM-dd").format(endDate),
      "pageNum": pageNum,
      "pageSize": pageSize
    });

    requestDataByUrl('queryAgentRelations', formData: formData).then((val) {
      var data = json.decode(val.toString());
      List<Map> agentList = (data['dataList'] as List).cast();
      if (debug) {
        print("queryAgentRelations agentList : " +
            agentList.toString() +
            ",agentList length" +
            agentList.length.toString());
      }

      if (agentList.isNotEmpty && agentList.length > 0) {
        setState(() {
          _agentList.addAll(agentList);
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
          DateFormat("yyyy-MM-dd").format(startDate),
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
              _agentList.clear();
              startDate = result;
              _getAgentRelationList();
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
              _agentList.clear();
              endDate = result;
              _getAgentRelationList();
            }
          });
        },
      ),
    );
  }
}
