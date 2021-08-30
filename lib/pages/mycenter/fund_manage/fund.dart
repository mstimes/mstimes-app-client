import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mstimes/common/control.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/local_share/account_info.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:mstimes/utils/color_util.dart';
import 'package:intl/intl.dart';
import 'package:mstimes/utils/date_utils.dart';

class FundPage extends StatefulWidget {
  FundPage({Key key}) : super(key: key);

  @override
  _FundPageState createState() => _FundPageState();
}

class _FundPageState extends State<FundPage> {
  double rpx;
  DateTime startDate = null;
  DateTime endDate = null;
  int pageNum = 0;
  int pageSize = 20;
  List<Map> _funsInfoList = [];
  int mType = -1;
  int relationType = -1;
  var fundInfoData;
  int funsCount = 0;

  @override
  void initState() {
    super.initState();

    _getFundSummary(UserInfo.getUserInfo().userId);
  }

  void _getFundSummary(agentId) {
    FormData formData = new FormData.fromMap({
      "agentId": agentId,
    });
    requestDataByUrl('queryFund', formData: formData).then((val) {
      var data = json.decode(val.toString());
      if (debug) {
        print("queryFund data " + data.toString());
      }

      setState(() {
        fundInfoData = (data['dataList'] as List).cast();
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
          '账户中心',
          style: TextStyle(fontSize: 30 * rpx, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        // alignment: Alignment.center,
        children: [
          _buildTopBackground(),
          _buildFundInfo(),
          _buildWithdrawFundsbutton()
        ],
      ),
    );
  }

  Widget _buildTopBackground() {
    return Container(
      height: 400 * rpx,
      width: 750 * rpx,
      margin: EdgeInsets.only(bottom: 10 * rpx),
      decoration: new BoxDecoration(
          //背景
          color: mainColor,
          //设置四周圆角 角度
          // borderRadius: BorderRadius.all(Radius.circular(10.0 * rpx)),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50.0 * rpx),
              bottomRight: Radius.circular(50.0 * rpx))),
    );
  }

  Widget _buildFundInfo() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 100 * rpx, left: 80 * rpx),
      height: 400 * rpx,
      width: 600 * rpx,
      decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0 * rpx))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 60 * rpx, bottom: 20 * rpx),
            child: Text(
              '账户余额',
              style: TextStyle(fontSize: 30 * rpx, color: Colors.grey),
            ),
          ),
          Container(
              child: Text(
            fundInfoData == null || fundInfoData[0]['totalRemain'] == null
                ? '0.00'
                : fundInfoData[0]['totalRemain'].toString() + "0",
            style: TextStyle(
                fontSize: 45 * rpx,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          )),
          Expanded(child: Container()),
          Divider(
            color: Colors.grey[400],
          ),
          Container(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10 * rpx, left: 20 * rpx),
                  child: Row(children: [
                    Text(
                      '冻结金额：',
                      style: TextStyle(fontSize: 30 * rpx, color: Colors.grey),
                    ),
                  ]),
                ),
                Expanded(child: Container()),
                Container(
                  margin: EdgeInsets.only(top: 10 * rpx, right: 30 * rpx),
                  child: Text(
                    fundInfoData == null ||
                            fundInfoData[0]['freezeAmount'] == null
                        ? '0.00'
                        : fundInfoData[0]['freezeAmount'].toString() + "0",
                    style: TextStyle(fontSize: 30 * rpx, color: Colors.grey),
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: 20 * rpx, top: 20 * rpx, bottom: 20 * rpx),
                  child: Container(
                    child: Text('可提现金额：',
                        style:
                            TextStyle(fontSize: 30 * rpx, color: Colors.black)),
                  ),
                ),
                Expanded(child: Container()),
                Container(
                  margin: EdgeInsets.only(
                      right: 30 * rpx, top: 20 * rpx, bottom: 20 * rpx),
                  child: Text(
                      fundInfoData == null ||
                              fundInfoData[0]['totalRemain'] == null
                          ? '0.00'
                          : (fundInfoData[0]['totalRemain'] -
                                      fundInfoData[0]['drawingAmount'] -
                                      fundInfoData[0]['freezeAmount'])
                                  .toString() +
                              "0",
                      style:
                          TextStyle(fontSize: 30 * rpx, color: Colors.black)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWithdrawFundsbutton() {
    return Column(children: [
      Container(
        margin: EdgeInsets.only(top: 550 * rpx, left: 40 * rpx),
      ),
      InkWell(
        onTap: () {
          RouterHome.flutoRouter
              .navigateTo(context, RouterConfig.drawingPagePath);
        },
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 0 * rpx),
          height: 80 * rpx,
          width: 660 * rpx,
          decoration: new BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(10.0 * rpx))),
          child: Text(
            '提现',
            style: TextStyle(
                color: Colors.white,
                fontSize: 30 * rpx,
                fontWeight: FontWeight.w700),
          ),
        ),
      ),
    ]);
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

  void _getFunsInfoList() {
    if (debug) {
      print('_getFunsInfoList startTime : ' +
          formatDate(startDate, ymdFormat) +
          ", endTime : " +
          formatDate(endDate, ymdFormat));
    }

    FormData formData = new FormData.fromMap({
      "agentId": UserInfo.getUserInfo().userId,
      "startTime": DateFormat("yyyy-MM-dd").format(startDate),
      "endTime": DateFormat("yyyy-MM-dd").format(endDate),
      "pageNum": pageNum,
      "pageSize": pageSize
    });

    requestDataByUrl('queryMyFuns', formData: formData).then((val) {
      var data = json.decode(val.toString());
      List<Map> funsInfoList = (data['dataList'] as List).cast();
      if (debug) {
        print("_getFunsInfoList : " +
            funsInfoList.toString() +
            ",funsInfoList length" +
            funsInfoList.length.toString());
      }

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
