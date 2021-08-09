import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:mstimes/routers/router_config.dart';
import 'dart:convert';

class Goods extends StatefulWidget {
  final int classify;
  Goods({Key key, @required this.classify}) : super(key: key);

  @override
  _GoodsState createState() => _GoodsState();
}

class _GoodsState extends State<Goods> {
  double rpx;
  int pageNum = 0;
  int pageSize = 20;
  List<Map> _clothesGoodList = [];

  @override
  void initState() {
    super.initState();
    _getGoodsByClassify();
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
            textColor: Colors.amber[900],
            refreshingText: "顾家",
            refreshedText: "顾家",
            refreshText: "",
            refreshReadyText: "",
            noMoreText: "",
          ),
          footer: ClassicalFooter(
            showInfo: false,
            bgColor: Colors.white,
            textColor: Colors.amber[900],
            loadingText: "小顾正在努力加载中...",
            loadedText: "闪速加载...",
            loadFailedText: "网络遇到问题，无法加载更多...",
            noMoreText: "",
          ),
          onRefresh: () async {},
          onLoad: () async {
            ++pageNum;
            _getGoodsByClassify();
          }),
    );
  }

  void _getGoodsByClassify() {
    FormData formData = new FormData.fromMap({
      "classify": widget.classify,
      "pageNum": pageNum,
      "pageSize": pageSize
    });
    requestDataByUrl('queryGoodsList', formData: formData).then((val) {
      var data = json.decode(val.toString());
      List<Map> newGoodList = (data['dataList'] as List).cast();
      setState(() {
        _clothesGoodList.addAll(newGoodList);
      });
    });
  }

  Widget _wrapList() {
    if (_clothesGoodList.length != 0) {
      List<Widget> listWidget = _clothesGoodList.map((val) {
        return InkWell(
          onTap: () {
            RouterHome.flutoRouter.navigateTo(
              context,
              RouterConfig.detailsPath + "?id=${val['goodId']}",
            );
          },
          child: Container(
            width: 360 * rpx,
            margin: EdgeInsets.only(left: 5 * rpx, top: 3 * rpx),
            //设置 child 居中
            alignment: Alignment(0, 0),
            //边框设置
            decoration: new BoxDecoration(
              //背景
              color: Colors.white,
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              //设置四周边框
              border: new Border.all(width: 1, color: Colors.white),
            ),
            child: Column(
              children: <Widget>[
                Image.network(
                  QINIU_OBJECT_STORAGE_URL + val['mainImage'],
                  width: 360 * rpx,
                ),
                Text(
                  val['title'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black45, fontSize: 30 * rpx),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '团购价 ￥${val['groupPrice']}',
                        style: TextStyle(
                            color: Colors.amber[900], fontSize: 32.0 * rpx),
                      ),
                    ),
                    Text(
                      '￥${val['oriPrice']}',
                      style: TextStyle(
                          color: Colors.black26,
                          fontSize: 32.0 * rpx,
                          decoration: TextDecoration.lineThrough),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text('');
    }
  }
}
