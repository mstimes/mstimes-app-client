import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeAlertPage extends StatefulWidget {
  const HomeAlertPage({Key key}) : super(key: key);

  @override
  _HomeAlertPageState createState() => _HomeAlertPageState();
}

class _HomeAlertPageState extends State<HomeAlertPage> {
  Timer timer;
  double rpx;

  @override
  void initState() {
    super.initState();

  }

  _save() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool("not_first_open", true);
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;

    timer = Timer(const Duration(milliseconds: 0), (){
      try{
          showDialog<Null>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return new AlertDialog(
                backgroundColor: Colors.black45,
                title: Center(child: Text('服务协议和隐私政策', style: TextStyle(fontSize: 25 * rpx, color: Colors.white))),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20 * rpx),
                        child: RichText(
                          text: TextSpan(children: <InlineSpan>[
                            TextSpan(
                              text:
                              '我们理解您关心您的信息是如何被使用和共享的。非常感谢您相信我们对个人信息处理的谨慎和敏感。关于我们如何在您使用Ms时代应用程序时采集及处理您的个人信息的。 ',
                              style : TextStyle(fontSize: 23 * rpx, color: Colors.white),
                            ),
                            TextSpan(
                              text: '',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 14, height: 2.0),
                            )
                          ]),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20 * rpx),
                        child: RichText(
                          text: TextSpan(children: <InlineSpan>[
                            TextSpan(
                              text:
                              '您需要注册成为Ms时代用户方可使用本软件的网上购物等功能，在您注册前仍可以浏览本软件中的商品和服务内容，详情请参考如下内容： ',
                              style : TextStyle(fontSize: 23 * rpx, color: Colors.white),
                            ),
                            TextSpan(
                              text: '',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 14, height: 2.0),
                            )
                          ]),
                        ),
                      ),
                      _showUserAndPrivatePolicy()
                    ],
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text('暂不使用',
                        style: TextStyle(fontSize: 26 * rpx, color: Colors.white)),
                    onPressed: () {
                      exit(0);
                    },
                  ),
                  new FlatButton(
                    child: new Text('同意',
                        style: TextStyle(fontSize: 26 * rpx, color: Colors.white)),
                    onPressed: () {
                      _save();
                      Navigator.pop(context);
                      RouterHome.flutoRouter.navigateTo(context, RouterConfig.groupGoodsPath);
                    },
                  ),
                ],
              );
            },
          );
      }catch (e){

      }
    });
    return Container();
  }



  Widget _showUserAndPrivatePolicy(){
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      InkWell(
        onTap: () {
          RouterHome.flutoRouter
              .navigateTo(context, RouterConfig.serviceTextPagePath);
        },
        child: Container(
          margin: EdgeInsets.only(top: 30 * rpx),
          alignment: Alignment.center,
          child: Text(
            '《用户协议》',
            style: TextStyle(color: Colors.blue[800], fontSize: 26 * rpx),
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 30 * rpx),
        alignment: Alignment.center,
        child: Text(
          '与',
          style: TextStyle(fontSize: 23 * rpx, color: Colors.white),
        ),
      ),
      InkWell(
        onTap: () {
          RouterHome.flutoRouter
              .navigateTo(context, RouterConfig.privateTextPagePath);
        },
        child: Container(
          margin: EdgeInsets.only(top: 30 * rpx),
          alignment: Alignment.center,
          child: Text(
            '《隐私政策》',
            style: TextStyle(color: Colors.blue[800], fontSize: 26 * rpx),
          ),
        ),
      ),
    ]
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
