import 'dart:convert';

import 'package:city_pickers/city_pickers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mstimes/common/control.dart';
import 'package:mstimes/common/valid.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/local_share/account_info.dart';
import 'package:mstimes/provide/drawing_record_provide.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:mstimes/tools/common_container.dart';
import 'package:mstimes/utils/color_util.dart';
import 'package:provider/provider.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({Key key}) : super(key: key);

  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  double rpx;
  Map _uploadDrawingInfos = Map();
  var bankType;
  var bankTypeLocal;
  var depositRegion = '';
  var depositRegionLocal = '';
  var lastDrawingRecordData;
  bool showLastBankType = false;
  bool showLastDepositRegion = false;

  var fundInfoData;

  GlobalKey<FormState> _drawingAmountFormKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _userNameFormKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _identityCardFormKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _bankNumberFormKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _depositBankFormKey = new GlobalKey<FormState>();

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
    // final drawingRecordProvide = Provide.value<DrawingRecordProvide>(context);
    List<Map> drawingRecordInfo = context.read<DrawingRecordProvide>().drawingRecordInfo;
    if (drawingRecordInfo != null && drawingRecordInfo[0]['bankType'] != null) {
      showLastBankType = true;
      bankType = drawingRecordInfo[0]['bankType'];
    }
    if (drawingRecordInfo != null &&
        drawingRecordInfo[0]['depositRegion'] != null) {
      showLastDepositRegion = true;
      depositRegion = drawingRecordInfo[0]['depositRegion'];
    }

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
      body: ListView(
        children: [
          _buildDrawingRow(),
          _buildPayTypeRow(),
          buildCommonHorizontalDivider(),
          _buildUserNameRow(),
          buildCommonHorizontalDivider(),
          _buildIdentityCardRow(),
          buildCommonHorizontalDivider(),
          _buildBankCardTypeRow(),
          buildCommonHorizontalDivider(),
          _buildBankCardNumberRow(),
          buildCommonHorizontalDivider(),
          _buildDepositBankRegionRow(),
          buildCommonHorizontalDivider(),
          _buildDepositBankRow(),
          buildCommonHorizontalDivider(),
          _buildWithdrawFundsbutton(),
          _buildRemindBottom()
        ],
      ),
    );
  }

  _buildDrawingRow() {
    return Container(
        height: 300 * rpx,
        width: 700 * rpx,
        margin: EdgeInsets.only(bottom: 10 * rpx),
        decoration: new BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0 * rpx),
                bottomRight: Radius.circular(30.0 * rpx))),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(child: Container()),
          Container(
            child: Form(
              key: _drawingAmountFormKey,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 30 * rpx, right: 20 * rpx),
                    child: Text(
                      '?????????????????????',
                      style: TextStyle(fontSize: 35 * rpx, color: Colors.white),
                    ),
                  ),
                  Container(
                    width: 300 * rpx,
                    height: 60 * rpx,
                    margin: EdgeInsets.only(
                        left: 30 * rpx,
                        top: 10 * rpx,
                        right: 3 * rpx,
                        bottom: 10 * rpx),
                    alignment: Alignment(0, 0),
                    child: TextFormField(
                      style: TextStyle(
                          fontSize: 50 * rpx,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      maxLines: 1,
                      // enabled: true,
                      onSaved: (value) {
                        _uploadDrawingInfos['amount'] = value;
                      },
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        WhitelistingTextInputFormatter(
                            RegExp("[0-9]")), //???????????????????????????????????????
                        LengthLimitingTextInputFormatter(8), //????????????
                      ],
                      decoration: InputDecoration.collapsed(
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                          hoverColor: Colors.white,
                          hintStyle: TextStyle(
                              fontSize: 15.0, color: Colors.grey[400]),
                          hintText: "?????????????????????"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: Container()),
          Container(
            alignment: Alignment.bottomLeft,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: 40 * rpx, right: 30 * rpx, bottom: 20 * rpx),
                  child: Text(
                    '?????????????????????',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(child: Container()),
                Container(
                  margin: EdgeInsets.only(
                      left: 30 * rpx, right: 30 * rpx, bottom: 20 * rpx),
                  child: Text(
                      fundInfoData == null ||
                              fundInfoData[0]['totalRemain'] == null
                          ? '0.00'
                          : (fundInfoData[0]['totalRemain'] -
                                      fundInfoData[0]['drawingAmount'] -
                                      fundInfoData[0]['freezeAmount'])
                                  .toString() +
                              "0",
                      style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          )
        ]));
  }

  _buildPayTypeRow() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(
              top: 30 * rpx, left: 20 * rpx, right: 50 * rpx, bottom: 15 * rpx),
          child: Text('????????????'),
        ),
        Container(
          margin: EdgeInsets.only(
              top: 30 * rpx, left: 20 * rpx, right: 50 * rpx, bottom: 15 * rpx),
          child: Text('???????????????'),
        )
      ],
    );
  }

  Widget _buildUserNameRow() {
    // return Provide<DrawingRecordProvide>(builder: (context, child, counter) {
    var counter = context.watch<DrawingRecordProvide>();
      return Form(
        key: _userNameFormKey,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: 15 * rpx,
                  left: 20 * rpx,
                  right: 50 * rpx,
                  bottom: 15 * rpx),
              child: Text('???????????????'),
            ),
            Container(
              width: 450 * rpx,
              height: 60 * rpx,
              margin: EdgeInsets.only(
                  left: 3 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 5 * rpx),
              alignment: Alignment(0, 0),
              child: TextFormField(
                initialValue: counter.drawingRecordInfo == null ||
                        counter.drawingRecordInfo[0]['userName'] == null
                    ? ''
                    : counter.drawingRecordInfo[0]['userName'],
                maxLines: 1,
                enabled: true,
                onSaved: (value) {
                  _uploadDrawingInfos['userName'] = value;
                },
                textInputAction: TextInputAction.done,
                validator: needStringCommonValid,
                enableInteractiveSelection: false,
                autofocus: false,
                decoration: InputDecoration.collapsed(
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.grey[400]),
                    hintText: "???????????????"),
              ),
            ),
          ],
        ),
      );
    // });
  }

  _buildIdentityCardRow() {
    // return Provide<DrawingRecordProvide>(builder: (context, child, counter) {
    var counter = context.watch<DrawingRecordProvide>();
      return Form(
        key: _identityCardFormKey,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: 15 * rpx,
                  left: 20 * rpx,
                  right: 50 * rpx,
                  bottom: 15 * rpx),
              child: Text('????????????'),
            ),
            Container(
              width: 450 * rpx,
              height: 60 * rpx,
              margin: EdgeInsets.only(
                  left: 3 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 5 * rpx),
              alignment: Alignment(0, 0),
              child: TextFormField(
                initialValue: counter.drawingRecordInfo == null ||
                        counter.drawingRecordInfo[0]['identityCard'] == null
                    ? ''
                    : counter.drawingRecordInfo[0]['identityCard'],
                maxLines: 1,
                enabled: true,
                onSaved: (value) {
                  _uploadDrawingInfos['identityCard'] = value;
                },
                textInputAction: TextInputAction.done,
                validator: needStringCommonValid,
                autofocus: false,
                decoration: InputDecoration.collapsed(
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.grey[400]),
                    hintText: "?????????????????????"),
              ),
            ),
          ],
        ),
      );
    // });
  }

  _buildBankCardTypeRow() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(
              top: 15 * rpx, left: 20 * rpx, right: 50 * rpx, bottom: 15 * rpx),
          child: Text('???????????????'),
        ),
        Container(
          height: 80 * rpx,
          width: 500 * rpx,
          child: _showDropdownList(),
        )
      ],
    );
  }

  _buildBankCardNumberRow() {
    // return Provide<DrawingRecordProvide>(builder: (context, child, counter) {
    var counter = context.watch<DrawingRecordProvide>();
      return Form(
        key: _bankNumberFormKey,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: 15 * rpx,
                  left: 20 * rpx,
                  right: 50 * rpx,
                  bottom: 15 * rpx),
              child: Text('??????'),
            ),
            Container(
              width: 450 * rpx,
              height: 60 * rpx,
              margin: EdgeInsets.only(
                  left: 3 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 5 * rpx),
              alignment: Alignment(0, 0),
              child: TextFormField(
                initialValue: counter.drawingRecordInfo == null ||
                        counter.drawingRecordInfo[0]['bankNumber'] == null
                    ? ''
                    : counter.drawingRecordInfo[0]['bankNumber'],
                maxLines: 1,
                enabled: true,
                onSaved: (value) {
                  _uploadDrawingInfos['bankNumber'] = value;
                },
                textInputAction: TextInputAction.done,
                validator: needStringCommonValid,
                decoration: InputDecoration.collapsed(
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.grey[400]),
                    hintText: "?????????????????????"),
              ),
            ),
          ],
        ),
      );
    // });
  }

  _buildDepositBankRegionRow() {
    if (showLastDepositRegion) {
      return Row(
        children: [
          Container(
            width: 120 * rpx,
            margin: EdgeInsets.only(
                top: 15 * rpx,
                left: 20 * rpx,
                right: 50 * rpx,
                bottom: 15 * rpx),
            child: Text('????????????'),
          ),
          InkWell(
            onTap: () {
              setState(() {
                showLastDepositRegion = false;
              });
            },
            child: Row(children: [
              Container(
                width: 380 * rpx,
                margin: EdgeInsets.only(
                    top: 15 * rpx,
                    left: 20 * rpx,
                    right: 50 * rpx,
                    bottom: 15 * rpx),
                child: Text(
                  depositRegion,
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    showLastDepositRegion = false;
                  });
                },
                child: Container(
                  height: 100 * rpx,
                  width: 100 * rpx,
                  child: Icon(
                    Icons.highlight_remove,
                    size: 40 * rpx,
                  ),
                ),
              )
            ]),
          ),
        ],
      );
    }

    // return Provide<DrawingRecordProvide>(builder: (context, child, counter) {
    var counter = context.watch<DrawingRecordProvide>();
      return Row(
        children: [
          Container(
            width: 120 * rpx,
            margin: EdgeInsets.only(
                top: 15 * rpx,
                left: 20 * rpx,
                right: 50 * rpx,
                bottom: 15 * rpx),
            child: Text('????????????'),
          ),
          InkWell(
            onTap: () {
              _clickEventFunc();
            },
            child: Row(children: [
              Container(
                width: 400 * rpx,
                margin: EdgeInsets.only(
                    top: 15 * rpx,
                    left: 20 * rpx,
                    right: 50 * rpx,
                    bottom: 15 * rpx),
                child: Text(
                  depositRegionLocal,
                ),
              ),
              Container(
                child: Icon(
                  Icons.arrow_drop_down,
                  size: 40 * rpx,
                ),
              )
            ]),
          ),
        ],
      );
    // });
  }

  _buildDepositBankRow() {
    var counter = context.watch<DrawingRecordProvide>();
    // return Provide<DrawingRecordProvide>(builder: (context, child, counter) {
      return Form(
        key: _depositBankFormKey,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: 15 * rpx,
                  left: 20 * rpx,
                  right: 50 * rpx,
                  bottom: 15 * rpx),
              child: Text('?????????'),
            ),
            Container(
              width: 450 * rpx,
              height: 60 * rpx,
              margin: EdgeInsets.only(
                  left: 3 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 5 * rpx),
              alignment: Alignment(0, 0),
              child: TextFormField(
                initialValue: counter.drawingRecordInfo == null ||
                        counter.drawingRecordInfo[0]['depositBank'] == null
                    ? ''
                    : counter.drawingRecordInfo[0]['depositBank'],
                maxLines: 1,
                enabled: true,
                onSaved: (value) {
                  _uploadDrawingInfos['depositBank'] = value;
                },
                textInputAction: TextInputAction.done,
                validator: needStringCommonValid,
                decoration: InputDecoration.collapsed(
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.grey[400]),
                    hintText: "???????????????????????????"),
              ),
            ),
          ],
        ),
      );
    // });
  }

  List<DropdownMenuItem<dynamic>> _buildDropdownMenuItems() {
    List<DropdownMenuItem<dynamic>> list =
        new List<DropdownMenuItem<dynamic>>();
    list.add(
      DropdownMenuItem(
          child: Row(children: <Widget>[
            Text('????????????'),
            SizedBox(width: 6),
          ]),
          value: '????????????'),
    );
    list.add(
      DropdownMenuItem(
          child: Row(children: <Widget>[
            Text('????????????'),
            SizedBox(width: 6),
          ]),
          value: '????????????'),
    );
    list.add(
      DropdownMenuItem(
          child: Row(children: <Widget>[
            Text('????????????'),
            SizedBox(width: 6),
          ]),
          value: '????????????'),
    );
    list.add(
      DropdownMenuItem(
          child: Row(children: <Widget>[
            Text('????????????'),
            SizedBox(width: 6),
          ]),
          value: '????????????'),
    );
    list.add(
      DropdownMenuItem(
          child: Row(children: <Widget>[
            Text('??????????????????'),
            SizedBox(width: 6),
          ]),
          value: '??????????????????'),
    );
    list.add(
      DropdownMenuItem(
          child: Row(children: <Widget>[
            Text('????????????'),
            SizedBox(width: 6),
          ]),
          value: '????????????'),
    );
    list.add(
      DropdownMenuItem(
          child: Row(children: <Widget>[
            Text('????????????'),
            SizedBox(width: 6),
          ]),
          value: '????????????'),
    );
    list.add(
      DropdownMenuItem(
          child: Row(children: <Widget>[
            Text('????????????'),
            SizedBox(width: 6),
          ]),
          value: '????????????'),
    );
    list.add(DropdownMenuItem(
        child: Row(children: <Widget>[
          Text('????????????'),
          SizedBox(width: 6),
        ]),
        value: '????????????'));

    list.add(
      DropdownMenuItem(
          child: Row(children: <Widget>[
            Text('????????????'),
            SizedBox(width: 6),
          ]),
          value: '????????????'),
    );
    list.add(
      DropdownMenuItem(
          child: Row(children: <Widget>[
            Text('????????????'),
            SizedBox(width: 6),
          ]),
          value: '????????????'),
    );
    list.add(
      DropdownMenuItem(
          child: Row(children: <Widget>[
            Text('????????????'),
            SizedBox(width: 6),
          ]),
          value: '????????????'),
    );
    list.add(
      DropdownMenuItem(
          child: Row(children: <Widget>[
            Text('????????????'),
            SizedBox(width: 6),
          ]),
          value: '????????????'),
    );
    list.add(
      DropdownMenuItem(
          child: Row(children: <Widget>[
            Text('????????????'),
            SizedBox(width: 6),
          ]),
          value: '????????????'),
    );
    list.add(
      DropdownMenuItem(
          child: Row(children: <Widget>[
            Text('????????????'),
            SizedBox(width: 6),
          ]),
          value: '????????????'),
    );
    list.add(
      DropdownMenuItem(
          child: Row(children: <Widget>[
            Text('????????????'),
            SizedBox(width: 6),
          ]),
          value: '????????????'),
    );
    list.add(
      DropdownMenuItem(
          child: Row(children: <Widget>[
            Text('????????????'),
            SizedBox(width: 6),
          ]),
          value: '????????????'),
    );
    list.add(
      DropdownMenuItem(
          child: Row(children: <Widget>[
            Text('????????????'),
            SizedBox(width: 6),
          ]),
          value: '????????????'),
    );
    list.add(DropdownMenuItem(
        child: Row(children: <Widget>[
          Text('???????????????'),
          SizedBox(width: 6),
        ]),
        value: '???????????????'));

    return list;
  }

  Widget _showDropdownList() {
    if (showLastBankType) {
      return DropdownButton(
        value: bankType,
        icon: InkWell(
          onTap: () {
            setState(() {
              showLastBankType = false;
            });
          },
          child: Container(
            height: 100 * rpx,
            width: 100 * rpx,
            child: InkWell(
                onTap: () {
                  setState(() {
                    showLastBankType = false;
                  });
                },
                child: Icon(
                  Icons.highlight_remove,
                  size: 40 * rpx,
                )),
          ),
        ),
        iconSize: 40 * rpx,
        underline: Container(height: 0),
        items: _buildDropdownMenuItems(),
        onChanged: (value) => {},
      );
    } else {
      return DropdownButton(
          value: bankTypeLocal,
          icon: Container(
            margin: EdgeInsets.only(left: 20 * rpx),
            child: Icon(Icons.arrow_circle_down),
          ),
          iconSize: 40 * rpx,
          underline: Container(height: 0),
          hint: Text('?????????????????????'),
          items: _buildDropdownMenuItems(),
          onChanged: (value) => setState(() => {
                bankTypeLocal = value,
                _uploadDrawingInfos['bankType'] = value
              }));
    }
  }

  void _clickEventFunc() async {
    Result tempResult = await CityPickers.showCityPicker(
        context: context,
        theme: Theme.of(context).copyWith(primaryColor: Color(0xfffe1314)),
        cancelWidget: Text(
          '??????',
          style: TextStyle(fontSize: 26 * rpx, color: Color(0xff999999)),
        ),
        confirmWidget: Text(
          '??????',
          style: TextStyle(fontSize: 26 * rpx, color: Color(0xfffe1314)),
        ),
        height: 220.0);
    if (tempResult != null) {
      setState(() {
        depositRegionLocal = tempResult.provinceName +
            " " +
            tempResult.cityName +
            " " +
            tempResult.areaName;
        _uploadDrawingInfos['depositRegion'] = depositRegionLocal;
      });
    }
  }

  Widget _buildWithdrawFundsbutton() {
    return InkWell(
      onTap: () {
        var _drawingAmountForm = _drawingAmountFormKey.currentState;
        var _userNameForm = _userNameFormKey.currentState;
        var _identityCardForm = _identityCardFormKey.currentState;
        var _bankNumberForm = _bankNumberFormKey.currentState;
        var _depositBankForm = _depositBankFormKey.currentState;

        if (_userNameForm.validate() &&
            _identityCardForm.validate() &&
            _bankNumberForm.validate() &&
            _depositBankForm.validate()) {
          _drawingAmountForm.save();
          _userNameForm.save();
          _identityCardForm.save();
          _bankNumberForm.save();
          _depositBankForm.save();

          if (int.parse(_uploadDrawingInfos['amount']).toInt() < 100) {
            showAlertDialog(context, '????????????????????????100???', 120, rpx);
            return;
          }
          if (int.parse(_uploadDrawingInfos['amount']).toInt() >
              fundInfoData[0]['totalRemain'] -
                  fundInfoData[0]['drawingAmount']) {
            showAlertDialog(context, '????????????????????????????????????', 100, rpx);
            return;
          }

          _uploadDrawingInfos['agentId'] = UserInfo.getUserInfo().userId;
          _uploadDrawingInfos['payType'] = 1;

          if (showLastBankType) {
            _uploadDrawingInfos['bankType'] = bankType;
          }
          if (showLastDepositRegion) {
            _uploadDrawingInfos['depositRegion'] = depositRegion;
          }

          _showConfirmInfo();
        }
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 40 * rpx, left: 40 * rpx, right: 40 * rpx),
        height: 70 * rpx,
        width: 600 * rpx,
        decoration: new BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(10.0 * rpx))),
        child: Text(
          '????????????',
          style: TextStyle(
              color: Colors.white,
              fontSize: 26 * rpx,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  _showConfirmInfo() {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          backgroundColor: Colors.black45,
          title: Container(
            alignment: Alignment.center,
            child: new Text(
              '??????????????????',
              style: TextStyle(fontSize: 30 * rpx, color: Colors.white),
            ),
          ),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10 * rpx),
                  child: Text('???????????????' + _uploadDrawingInfos['amount'] + ' ???',
                      style:
                          TextStyle(fontSize: 25 * rpx, color: Colors.white)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10 * rpx),
                  child: Text('??????????????? ???????????????',
                      style:
                          TextStyle(fontSize: 25 * rpx, color: Colors.white)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10 * rpx),
                  child: new Text('??????????????????' + _uploadDrawingInfos['userName'],
                      style:
                          TextStyle(fontSize: 25 * rpx, color: Colors.white)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10 * rpx),
                  child: new Text('????????????' + _uploadDrawingInfos['identityCard'],
                      style:
                          TextStyle(fontSize: 25 * rpx, color: Colors.white)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10 * rpx),
                  child: new Text('??????????????????' + _uploadDrawingInfos['bankType'],
                      style:
                          TextStyle(fontSize: 25 * rpx, color: Colors.white)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10 * rpx),
                  child: new Text('?????????' + _uploadDrawingInfos['bankNumber'],
                      style:
                          TextStyle(fontSize: 25 * rpx, color: Colors.white)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10 * rpx),
                  child: new Text(
                      '???????????????' + _uploadDrawingInfos['depositRegion'],
                      style:
                          TextStyle(fontSize: 25 * rpx, color: Colors.white)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10 * rpx),
                  child: new Text('????????????' + _uploadDrawingInfos['depositBank'],
                      style:
                          TextStyle(fontSize: 25 * rpx, color: Colors.white)),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('??????',
                  style: TextStyle(fontSize: 23 * rpx, color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text('??????',
                  style: TextStyle(fontSize: 25 * rpx, color: Colors.white)),
              onPressed: () {
                // final drawingRecordProvide =
                //     Provide.value<DrawingRecordProvide>(context);
                context.read<DrawingRecordProvide>().setNewDrawingInfos(_uploadDrawingInfos);

                postUploadDrawingInfos(jsonEncode(_uploadDrawingInfos));
                RouterHome.flutoRouter
                    .navigateTo(context, RouterConfig.drawingResultPath);
              },
            ),
          ],
        );
      },
    );
  }

  void postUploadDrawingInfos(_uploadDrawingInfoJson) async {
    await requestDataByUrl('createDrawingRecords',
            formData: _uploadDrawingInfoJson)
        .then((val) {
      var data = json.decode(val.toString());
      print('data' + data.toString());
    });
  }

  Widget _buildRemindBottom() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        margin: EdgeInsets.only(left: 30 * rpx, top: 50 * rpx),
        child: Text(
          '????????????????????????????????????????????????????????????',
          style: TextStyle(color: Colors.grey[700]),
        ),
      ),
      Container(
        margin: EdgeInsets.only(
            left: 30 * rpx, top: 10 * rpx, bottom: 10 * rpx, right: 30 * rpx),
        child: Text('???????????????????????????????????????????????????????????????????????????????????????????????????',
            style: TextStyle(color: Colors.grey[700])),
      ),
    ]);
  }
}
