import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mstimes/common/valid.dart';
import 'package:mstimes/model/local_share/order_info.dart';
import 'package:mstimes/provide/add_reveiver_provide.dart';
import 'package:mstimes/tools/common_container.dart';
import 'package:mstimes/common/control.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/identify_address.dart';
import 'package:mstimes/utils/color_util.dart';
import 'dart:io';

import 'package:provider/src/provider.dart';


class AddReceiverAddress extends StatefulWidget {
  AddReceiverAddress({Key key}) : super(key: key);

  @override
  AddReceiverAddressState createState() => AddReceiverAddressState();
}

class AddReceiverAddressState extends State<AddReceiverAddress> {
  GlobalKey<FormState> _addressInfoFormKey = new GlobalKey<FormState>();
  double rpx;
  var _keyword;
  Timer _getBaiduTokenTimer;
  String _access_token;
  bool autoIdenfify = false;
  bool clearAddress = false;

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
    return Scaffold(
      appBar: AppBar(
          backgroundColor: mainColor,
          leading: Container(
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  size: 25,
                )),
          ),
          title: Text(
            '收件人管理',
            style: TextStyle(
                fontSize: 30 * rpx,
                color: Colors.white,
                fontWeight: FontWeight.w400),
          )),
      body: Stack(
        children: [
          ListView(
            children: <Widget>[
              Container(
                width: 730 * rpx,
                margin: EdgeInsets.only(left: 10 * rpx, top: 50 * rpx, right: 10 * rpx),
                alignment: Alignment(0, 0),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  border: new Border.all(width: 1, color: Colors.white),
                ),
                child: Column(
                  children: <Widget>[
                    _buildTitle(),
                    Divider(
                      color: Colors.grey[400],
                    ),
                    Container(
                        height: 310 * rpx,
                        margin: EdgeInsets.only(left: 20 * rpx, top: 30 * rpx, right: 20 * rpx, bottom: 30 * rpx),
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
            ],
          ),
          Positioned(
            bottom: 15,
            left: 0,
            child: _buildUseAddressBottom(),
          )
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      width: 730 * rpx,
      height: 40 * rpx,
      margin: EdgeInsets.only(top: 30 * rpx, left: 20 * rpx, bottom: 10 * rpx),
      child: Row(
        children: <Widget>[
          Container(
            child: Text('收件人信息', style: TextStyle(fontSize: 28 * rpx, fontWeight: FontWeight.w400),),
          ),
          Expanded(child: Container()),
          // _showDeleteButton(),
        ],
      ),
    );
  }

  // Widget _showDeleteButton() {
  //   if (widget.index > 1) {
  //     return IconButton(
  //         onPressed: () {
  //           print('delete receiver index : ' + widget.index.toString());
  //           context.read<OrderInfoAddReciverProvide>().deleteReceiverInfo(widget.index);
  //         },
  //         color: Colors.grey,
  //         icon: Icon(
  //           Icons.highlight_off,
  //           size: 25 * rpx,
  //         ));
  //   }
  //   return Container();
  // }

  Widget _buildReceiverInfo() {
    final addReceiverAddress = context.watch<AddReceiverAddressProvide>();
      print('_buildReceiverInfo get ...');
      if (addReceiverAddress.identifyAddress == null) {
        return _buildTextFieldInput();
      } else {
        return _buildIdentifyResult(addReceiverAddress.identifyAddress);
      }
  }

  Widget _buildTextFieldInput() {
    IdentifyAddressModel identifyAddressModel = LocalOrderInfo.getLocalOrderInfo().identifyAddressResult;

    if(identifyAddressModel == null || clearAddress){
      return Form(
        key: _addressInfoFormKey,
        child: TextFormField(
          autofocus: false,
          minLines: 1,
          maxLines: 5,
          maxLength: 100,
          enabled: true,
          cursorColor: Colors.grey,
          controller: TextEditingController.fromValue(TextEditingValue(
              text: '${this._keyword == null ? "" : this._keyword}', //判断keyword是否为空
              // 保持光标在最后
              selection: TextSelection.fromPosition(TextPosition(
                  affinity: TextAffinity.downstream,
                  offset: '${this._keyword}'.length)))),
          onSaved: (value) {
            this._keyword = value;
          },
          textInputAction: TextInputAction.done,
          decoration: InputDecoration.collapsed(
              hintStyle: TextStyle(fontSize: 28 * rpx, color: Colors.grey[400]),
              hintText:
              "收件人姓名,手机，地址信息，支持黏贴信息并智能识别\n 如：蜜糖，188*********，浙江省 杭州市 xx区 xx街道 xxx"),
        ),
      );
    }

    return Form(
      key: _addressInfoFormKey,
      child: TextFormField(
        autofocus: false,
        minLines: 1,
        maxLines: 5,
        maxLength: 100,
        enabled: true,
        initialValue: identifyAddressModel.province + identifyAddressModel.city + identifyAddressModel.town + identifyAddressModel.detail + identifyAddressModel.person + identifyAddressModel.phonenum,
        onSaved: (value) {
          this._keyword = value;
        },
        cursorColor: Colors.black,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            floatingLabelBehavior: null,
            suffixStyle: TextStyle(color: Colors.black),
            suffixIcon: Container(
              height: 60 * rpx,
              width: 60 * rpx,
              child: InkWell(
                  onTap: () {
                    context.read<AddReceiverAddressProvide>().clear();
                    setState(() {
                      clearAddress = true;
                    });
                  },
                  child: Icon(
                    Icons.highlight_remove,
                    size: 40 * rpx,
                  )),
            )),
      ),
    );
  }

  Widget _buildIdentifyResult(IdentifyAddressModel identifyAddressModel) {
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
                        initialValue: identifyAddressModel.person,
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(labelText: '收件人'),
                        onChanged: (String value) {
                          identifyAddressModel.person = value;
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
              initialValue: identifyAddressModel.phonenum,
              cursorColor: Colors.grey,
              decoration: InputDecoration(labelText: '电话号码'),
              validator: (value) {
                if (value.isEmpty) {
                  return '请输入电话号码';
                }
                return null;
              },
              onChanged: (String value) {
                identifyAddressModel.phonenum = value;
              },
            ),
          ),
          Container(
            height: 50 * rpx,
            child: TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(labelText: '省份区域'),
              initialValue:
              identifyAddressModel.province + identifyAddressModel.city + identifyAddressModel.town,
              onChanged: (String value) {
                identifyAddressModel.province = value;
              },
            ),
          ),
          Container(
            height: 50 * rpx,
            child: TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(labelText: '详细地址'),
              cursorColor: Colors.grey,
              initialValue: identifyAddressModel.detail,
              onChanged: (String value) {
                identifyAddressModel.detail = value;
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildIdentifyButton() {
    final addReceiverAddress = context.read<AddReceiverAddressProvide>();
    if (addReceiverAddress.identifyAddress == null) {
        return Container(
          margin: EdgeInsets.only(bottom: 15 * rpx),
          child: InkWell(
            onTap: (){
              var _addressInfoForm = _addressInfoFormKey.currentState;
              _addressInfoForm.save();

              if (this._keyword == null) {
                showAlertDialog(context, "请填写收件人信息", 140.00, rpx);
                return;
              }

              Map<String, dynamic> map = Map();
              map['text'] = this._keyword;
              map['confidence'] = 50;
              map['access_token'] = _access_token;

              _identifyReceierAddress(map, context);
            },
            child: Container(
              width: 180 * rpx,
              padding: EdgeInsets.only(left: 30 * rpx, right: 30 * rpx, top: 15 * rpx, bottom: 15 * rpx),
              alignment: Alignment.center,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5 * rpx)),
                color: buttonColor,
              ),
              child: Text('智能识别', style: TextStyle(color: Colors.white, fontSize: 26 * rpx, fontWeight: FontWeight.w500),),
            ),
          ),
        );
      } else {
        return Container(
          margin: EdgeInsets.only(bottom: 20 * rpx),
          child: InkWell(
              onTap: (){
                context.read<AddReceiverAddressProvide>().clear();
                setState(() {
                  clearAddress = true;
                });
              },
            child: Container(
              width: 150 * rpx,
              padding: EdgeInsets.only(left: 30 * rpx, right: 30 * rpx, top: 15 * rpx, bottom: 15 * rpx),
              alignment: Alignment.center,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5 * rpx)),
                color: buttonColor,
                // border: new Border.all(width: 1, color: Colors.white),
              ),
              child: Text('重置', style: TextStyle(color: Colors.white, fontSize: 26 * rpx, fontWeight: FontWeight.w500),),
            )
          ),
        );
      }
  }

  Widget _buildUseAddressBottom() {
    return InkWell(
      onTap: (){
        // 更新地址信息缓存
        final addReceiverAddress = context.read<AddReceiverAddressProvide>();
        print('更新地址信息缓存 addReceiverAddress ' + addReceiverAddress.identifyAddress.toString());
        LocalOrderInfo.getLocalOrderInfo().identifyAddressResult = addReceiverAddress.identifyAddress;

        // 持久化最新地址

        // 清除识别地址信息
        // addReceiverAddress.clear();

        // 关闭当前页面
        Navigator.pop(context);
      },
      child: Container(
          padding: EdgeInsets.only(
          left: 50 * rpx, right: 40 * rpx, top: 15 * rpx, bottom: Platform.isIOS ? 30 * rpx * rpx : 3 * rpx),
          width: 750 * rpx,
          color: Colors.white,
        child: buildSingleSummitButton('使用', 280, 80, 10, rpx)
      )
    );
  }

  void _identifyReceierAddress(requestMap, BuildContext context) async {
    return context.read<AddReceiverAddressProvide>().getIndentifyResult(requestMap);
  }
}
