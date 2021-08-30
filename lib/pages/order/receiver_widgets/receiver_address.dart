import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:mstimes/common/control.dart';
import 'package:mstimes/common/valid.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/identify_address.dart';
import 'package:mstimes/provide/order_info_add.dart';
import 'package:mstimes/provide/reveiver_address_provide.dart';
import 'package:mstimes/utils/color_util.dart';

class ReceiverAddress extends StatefulWidget {
  final int index;
  ReceiverAddress({Key key, @required this.index}) : super(key: key);

  @override
  ReceiverAddressState createState() => ReceiverAddressState();
}

class ReceiverAddressState extends State<ReceiverAddress> {
  // ScrollController _controller;
  double rpx;
  var _keyword;
  Timer _getBaiduTokenTimer;
  String _access_token;
  bool autoIdenfify = false;

  void initTimer() {
    if (_getBaiduTokenTimer == null) {
      getTokenResult();
      _getBaiduTokenTimer = Timer.periodic(Duration(minutes: 1), (timer) {
        print('_getBaiduTokenTimer start...');
        getTokenResult();
      });
    }
  }

  void getTokenResult() async {
    Map<String, dynamic> requestMap = Map();
    requestMap['grant_type'] = "client_credentials";
    requestMap['client_id'] = "y3RPWWG1RUA2QmqpWFRisXaQ";
    requestMap['client_secret'] = "p6inB6fx6n2wKLAwgeAXTQbrPBDZXuFq";
    await requestDataForJson('getBaiduToken', queryParameters: requestMap)
        .then((val) {
      var data = json.decode(val.toString());
      if (debug) {
        print('get token data : ' + data.toString());
      }

      if (data != null) {
        if (debug) {
          print('refresh token success, access_token : ' +
              data['access_token'].toString());
        }
        _access_token = data['access_token'].toString();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initTimer();
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return Container(
      width: 730 * rpx,
      height: 400 * rpx,
      margin: EdgeInsets.only(left: 10 * rpx, top: 10 * rpx, right: 0),
      alignment: Alignment(0, 0),
      decoration: new BoxDecoration(
        color: Colors.white,
        border: new Border.all(width: 1, color: Colors.white),
      ),
      child: Container(
        child: Column(
          children: <Widget>[
            _buildTitle(),
            Divider(
              color: Colors.grey[400],
            ),
            Container(
                height: 310 * rpx,
                margin: EdgeInsets.only(left: 6, top: 2, right: 6),
                alignment: Alignment(0, 0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(child: _buildReceiverInfo()),
                      _buildIdentifyButton()
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      width: 730 * rpx,
      height: 40 * rpx,
      child: Row(
        children: <Widget>[
          Container(
            child: Text('收件人信息'),
          ),
          Expanded(child: Container()),
          _showDeleteButton(),
        ],
      ),
    );
  }

  Widget _showDeleteButton() {
    if (widget.index > 1) {
      return IconButton(
          onPressed: () {
            print('delete receiver index : ' + widget.index.toString());
            final orderInfoAddReciverProvide =
                Provide.value<OrderInfoAddReciverProvide>(context);
            orderInfoAddReciverProvide.deleteReceiverInfo(widget.index);
          },
          color: Colors.grey,
          icon: Icon(
            Icons.highlight_off,
            size: 25 * rpx,
          ));
    }
    return Container();
  }

  Widget _buildReceiverInfo() {
    return Provide<ReceiverAddressProvide>(
        builder: (context, child, addressInfo) {
      if (addressInfo.identifyAddressMap[widget.index.toString()] == null) {
        return _buildTextFieldInput();
      } else {
        return _buildIdentifyResult(addressInfo);
      }
    });
  }

  // Widget _buildReceiverInfo() {
  //     if (!autoIdenfify) {
  //       return _buildTextFieldInput();
  //     } else {
  //       return _buildIdentifyResult();
  //     }
  // }

  Widget _buildTextFieldInput() {
    return TextField(
      autofocus: false,
      minLines: 1,
      maxLines: 5,
      maxLength: 100,
      enabled: true,
      controller: TextEditingController.fromValue(TextEditingValue(
          text: '${this._keyword == null ? "" : this._keyword}', //判断keyword是否为空
          // 保持光标在最后
          selection: TextSelection.fromPosition(TextPosition(
              affinity: TextAffinity.downstream,
              offset: '${this._keyword}'.length)))),
      onChanged: (value) {
        this.setState(() {
          this._keyword = value;
        });
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration.collapsed(
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey[400]),
          hintText:
              "收件人姓名,手机，地址信息，支持黏贴信息并智能识别\n 如：小顾，188*********，浙江省 杭州市 xx区 xx街道 xxx"),
    );
  }

  Widget _buildIdentifyResult(identifyAddressModel) {
    final receiverAddressProvide =
        Provide.value<ReceiverAddressProvide>(context);

    IdentifyAddressModel addressInfo =
        identifyAddressModel.identifyAddressMap[widget.index.toString()];


    TextEditingController _personController;

    return Container(
      height: 220 * rpx,
      child: Column(
        children: <Widget>[
          Container(
            height: 50 * rpx,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Form(
                      child: TextFormField(
                        controller: _personController,
                        textAlign: TextAlign.center,
                        initialValue: addressInfo.person,
                        decoration: InputDecoration(labelText: '收件人'),
                        onChanged: (String value) {
                          addressInfo.person = value;
                          receiverAddressProvide
                              .identifyAddressMap[widget.index.toString()] =
                          addressInfo;
                        },
                      ),
                    )),
              ],
            ),
          ),
          Container(
            height: 50 * rpx,
            child: TextFormField(
              textAlign: TextAlign.center,
              initialValue: addressInfo.phonenum,
              decoration: InputDecoration(labelText: '电话号码'),
              validator: (value) {
                if (value.isEmpty) {
                  return '请输入电话号码';
                }
                return null;
              },
              onChanged: (String value) {
                addressInfo.phonenum = value;
                receiverAddressProvide
                    .identifyAddressMap[widget.index.toString()] = addressInfo;
              },
            ),
          ),
          Container(
            height: 50 * rpx,
            child: TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(labelText: '省份区域'),
              initialValue:
              addressInfo.province + addressInfo.city + addressInfo.town,
              onChanged: (String value) {
                addressInfo.province = value;
                receiverAddressProvide
                    .identifyAddressMap[widget.index.toString()] = addressInfo;
              },
            ),
          ),
          Container(
            height: 50 * rpx,
            child: TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(labelText: '详细地址'),
              initialValue: addressInfo.detail,
              onChanged: (String value) {
                addressInfo.detail = value;
                receiverAddressProvide
                    .identifyAddressMap[widget.index.toString()] = addressInfo;
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildIdentifyButton() {
    return Provide<ReceiverAddressProvide>(
        builder: (context, child, addressInfo) {
      if (debug) {
        print('_buildIdentifyButton widget.index: ' +
            widget.index.toString() +
            ",identifyAddressMap: " +
            addressInfo.identifyAddressMap.toString() +
            ",addressInfo.identifyAddressMap[widget.index] :" +
            addressInfo.identifyAddressMap[widget.index.toString()].toString());
      }

      if (addressInfo.identifyAddressMap[widget.index.toString()] == null) {
        return Container(
          margin: EdgeInsets.only(bottom: 0),
          child: RaisedButton(
              color: buttonColor,
              textColor: Colors.white,
              elevation: 0,
              onPressed: () {
                if (debug) {
                  print('smart adjust... index: ' + widget.index.toString());
                }
                // if (this._keyword == null) {
                //   showAlertDialog(context, "请填写收件人信息", 140.00, rpx);
                //   return;
                // }

                Map<String, dynamic> map = Map();
                map['text'] = this._keyword;
                map['confidence'] = 50;
                map['access_token'] = _access_token;
                _identifyReceierAddress(map, context);
              },
              child: Text('智能识别')),
        );
      } else {
        return Container(
          margin: EdgeInsets.only(bottom: 0),
          child: RaisedButton(
              color: buttonColor,
              textColor: Colors.white,
              elevation: 0,
              onPressed: () {
                if (debug) {
                  print('clear receiver info... index: ' +
                      widget.index.toString());
                }
                setState(() {
                  addressInfo.identifyAddressMap[widget.index.toString()] =
                      null;
                });
              },
              child: Text('清空')),
        );
      }
    });
  }

  void _identifyReceierAddress(requestMap, BuildContext context) async {
    return Provide.value<ReceiverAddressProvide>(context)
        .getIndentifyResult(widget.index.toString(), requestMap);
  }
}
