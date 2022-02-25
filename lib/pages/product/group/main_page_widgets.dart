import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mstimes/common/valid.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/local_share/account_info.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:mstimes/utils/color_util.dart';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';

Widget buildProductListHeaderContainer(top, title, bottom, needForBlack, topSize, rpx) {
  return Container(
      height: 180 * rpx,
      width: 450 * rpx,
      margin: EdgeInsets.only(top: topSize * rpx, bottom: 30 * rpx),
      child: _buildProductListHeader(top, title, bottom, needForBlack, rpx));
}

Widget _buildProductListHeader(top, title, bottom, needForBlack, rpx) {
  return Column(
    children: [
      Container(
        margin: EdgeInsets.only(bottom: 15 * rpx),
        child: Text(
          top,
          style: TextStyle(
              color: needForBlack ? Colors.white : backgroundFontColor,
              fontSize: 28 * rpx,
              fontWeight: FontWeight.w500),
        ),
      ),
      Text(
        title,
        style: TextStyle(
            color: needForBlack ? Colors.white : backgroundFontColor,
            fontSize: 38 * rpx,
            fontWeight: FontWeight.w700),
      ),
      Container(
        margin: EdgeInsets.only(top: 15 * rpx),
        child: Text(
          bottom,
          style: TextStyle(
            color: needForBlack ? Colors.white : backgroundFontColor,
            fontSize: 23 * rpx,
          ),
        ),
      )
    ],
  );
}

Widget buildImageSwiperBottom(colorForBlack, rpx) {
  return Container(
    margin: EdgeInsets.only(top: 30 * rpx),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(
            left: 10 * rpx,
          ),
          child: Image.asset(
            colorForBlack
                ? "lib/images/zp_white.png"
                : "lib/images/zp_yellow.png",
            height: 35 * rpx,
            width: 35 * rpx,
          ),
        ),
        Container(
            margin: EdgeInsets.only(left: 10 * rpx, right: 10 * rpx),
            child: Text(
              '正品授权',
              style: TextStyle(
                  fontSize: 23 * rpx,
                  color: colorForBlack ? Colors.white : backgroundFontColor,
                  fontWeight: FontWeight.bold),
            )),
        SizedBox(
          height: 50 * rpx,
          child: VerticalDivider(
            color: backgroundFontColor,
            width: 20 * rpx,
            thickness: 2 * rpx,
            indent: 10 * rpx,
            endIndent: 5 * rpx,
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: 20 * rpx,
          ),
          child: Image.asset(
            colorForBlack
                ? "lib/images/sale_white.png"
                : "lib/images/sale_yellow.png",
            height: 35 * rpx,
            width: 35 * rpx,
          ),
        ),
        Container(
            margin: EdgeInsets.only(left: 10 * rpx, right: 10 * rpx),
            child: Text(
              '限时特卖',
              style: TextStyle(
                  fontSize: 23 * rpx,
                  color: colorForBlack ? Colors.white : backgroundFontColor,
                  fontWeight: FontWeight.bold),
            )),
        SizedBox(
          height: 50 * rpx,
          child: VerticalDivider(
            color: backgroundFontColor,
            width: 20 * rpx,
            thickness: 2 * rpx,
            indent: 10 * rpx,
            endIndent: 5 * rpx,
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: 20 * rpx,
          ),
          child: Image.asset(
            colorForBlack
                ? "lib/images/discount_white.png"
                : "lib/images/discount_yellow.png",
            height: 35 * rpx,
            width: 35 * rpx,
          ),
        ),
        Container(
            margin: EdgeInsets.only(left: 10 * rpx, right: 10 * rpx),
            child: Text(
              '全网低价',
              style: TextStyle(
                  fontSize: 23 * rpx,
                  color: colorForBlack ? Colors.white : backgroundFontColor,
                  fontWeight: FontWeight.bold),
            )),
        SizedBox(
          height: 50 * rpx,
          child: VerticalDivider(
            color: backgroundFontColor,
            width: 20 * rpx,
            thickness: 2 * rpx,
            indent: 10 * rpx,
            endIndent: 5 * rpx,
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: 20 * rpx,
          ),
          child: Image.asset(
            colorForBlack
                ? "lib/images/trace_white.png"
                : "lib/images/trace_yellow.png",
            height: 45 * rpx,
            width: 45 * rpx,
          ),
        ),
        Container(
            margin: EdgeInsets.only(left: 10 * rpx, right: 10 * rpx),
            child: Text(
              '品牌溯源',
              style: TextStyle(
                  fontSize: 23 * rpx,
                  color: colorForBlack ? Colors.white : backgroundFontColor,
                  fontWeight: FontWeight.bold),
            )),
      ],
    ),
  );
}


Widget buildShareSingeProductBigImage(image, rpx) {
  String imageUrl = QINIU_OBJECT_STORAGE_URL + image;
  return Container(
    // margin: EdgeInsets.only(left: 10 * rpx, right: 10 * rpx),
    height: 1000 * rpx,
    child: ClipRRect(
      // borderRadius: BorderRadius.circular(20 * rpx),
      child: Image.network(imageUrl),
    ),
  );
}

Widget buildDownloadHeaderContainerA(goodInfo, downloadStartDate, downloadEndDate, rpx) {
  return Container(
    width: 750 * rpx,
    margin: EdgeInsets.only(top: 100 * rpx, bottom: 30 * rpx),
    child: Row(
        children: [
          Container(
            width: 200 * rpx,
            height: 160 * rpx,
            margin: EdgeInsets.only(
                left: 30 * rpx, top: 10 * rpx, right: 50 * rpx, bottom: 0 * rpx),
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50.0 * rpx),
                  bottomRight: Radius.circular(50.0 * rpx)),
              border: new Border.all(width: 1 * rpx, color: Colors.white),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10 * rpx),
                  child: Text('限时特卖',
                      style: TextStyle(
                          fontSize: 30 * rpx,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20 * rpx),
                  child: Text(downloadStartDate,
                      style: TextStyle(
                          fontSize: 20 * rpx,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                ),
                Container(
                  child: Text('~',
                      style: TextStyle(
                          fontSize: 20 * rpx,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                ),
                Container(
                  child: Text(downloadEndDate,
                      style: TextStyle(
                          fontSize: 20 * rpx,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                )
              ],
            ),
          ),
          Container(
            width: 400 * rpx,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  // margin:
                  // EdgeInsets.only(top: 30 * rpx, bottom: 30 * rpx, left: 10 * rpx),
                  child: Text(
                    'MS时代 x ',
                    style: TextStyle(
                        fontSize: 40 * rpx,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  // margin: EdgeInsets.only(top: 30 * rpx, bottom: 30 * rpx),
                  child: Text(
                    goodInfo.brand.toString(),
                    style: TextStyle(
                        fontSize: 40 * rpx,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          )
        ]),
  );
}

Widget buildDownloadHeaderContainerB(imagePath, rpx) {
  return Container(
    margin: EdgeInsets.only(top: 20 * rpx),
    child: ClipRRect(
      child: Image.asset(imagePath),
    ),
  );
}

Widget buildOrderingContainer(val, rpx) {
  return Container(
    margin: EdgeInsets.only(left: 40 * rpx, bottom: 30 * rpx),
    width: 220 * rpx,
    height: 50 * rpx,
    //边框设置
    decoration: new BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20 * rpx),
          topRight: Radius.circular(20 * rpx)),
    ),
    child: Container(
      alignment: Alignment.center,
      width: 200 * rpx,
      child: Text(
        '立即下单',
        style: TextStyle(
            fontSize: 23 * rpx,
            color: Colors.white,
            fontWeight: FontWeight.w400),
      ),
    ),
  );
}

Widget buildWillOrderContainer(val, rpx) {
  return Container(
    margin: EdgeInsets.only(left: 40 * rpx, bottom: 30 * rpx),
    width: 220 * rpx,
    height: 50 * rpx,
    //边框设置
    decoration: new BoxDecoration(
      color: goodsFontColor,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20 * rpx),
          topRight: Radius.circular(20 * rpx)),
    ),
    child: Container(
      alignment: Alignment.center,
      child: Text(
        '即将开启',
        style: TextStyle(
            fontSize: 23 * rpx,
            color: Colors.white,
            fontWeight: FontWeight.w400),
      ),
    ),
  );
}




Widget makeImageArea(val, size, rpx) {
  String imageUrl = QINIU_OBJECT_STORAGE_URL + val['mainImage'];
  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        margin: EdgeInsets.only(left: 10 * rpx, right: 10 * rpx),
        width: size * rpx,
        height: size * rpx,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20 * rpx),
          child: val['mainImage'] == null ? '' : Image.network(imageUrl),
        ),
      ),
      buildSaleOutLabel(val, rpx),
      buildSecondKillLabel(val, rpx),
    ],
  );
}

Widget buildSaleOutLabel(val, rpx){
  if(val['saleOut'] == 1){
    return Container(
        alignment: Alignment.center,
        child: Container(
          child: ClipRRect(
            child: Image.asset(
              "lib/images/sale_out.png",
              width: 160 * rpx,
              height: 160 * rpx,
            ),
          ),
        )
    );
  } else{
    return Container();
  }
}

Widget buildSecondKillLabel(val, rpx) {
  if (val['secondKill'] == 1) {
    return Positioned(
        top: 0,
        right: 30 * rpx,
        child: Container(
          child: ClipRRect(
            child: Image.asset(
              "lib/images/second_kill_1.png",
              width: 90 * rpx,
              height: 90 * rpx,
            ),
          ),
        )
    );
  } else{
    return Container();
  }
}

Widget buildTitleAndPrice(val, today, rpx) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(
                top: 60 * rpx, left: 50 * rpx, right: 50 * rpx),
            child: Text(
              val['title'],
              maxLines: 3,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 28 * rpx,
                  color: goodsFontColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        _buildPrice(val, rpx),
        today == true
            ? buildOrderingContainer(val, rpx)
            : buildWillOrderContainer(val, rpx)
      ],
    ),
  );
}

Widget _buildPrice(val, rpx) {
  var groupPriceArr = val['groupPrice'].toString().split(".");
  return Container(
    width: 400 * rpx,
    height: 40 * rpx,
    margin: EdgeInsets.only(left: 40 * rpx, bottom: 20 * rpx),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 200 * rpx,
          height: 40 * rpx,
          child: Row(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      margin: EdgeInsets.only(bottom: 2 * rpx),
                      child: Text('￥',
                          style: TextStyle(
                              color: goodsFontColor,
                              fontSize: 24.0 * rpx,
                              fontWeight: FontWeight.w600))
                  ),
                  Text(
                    groupPriceArr[0],
                    style: TextStyle(
                        color: goodsFontColor,
                        fontSize: 35.0 * rpx,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 2 * rpx),
                    child: Text(groupPriceArr.length == 1 ? '' : "." + groupPriceArr[1].toString(),
                        style: TextStyle(
                            color: goodsFontColor,
                            fontSize: 24.0 * rpx,
                            fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 10 * rpx),
                child: Text(
                  '￥${val['oriPrice']}',
                  style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                      fontSize: 25 * rpx,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        Expanded(child: Container()),
      ],
    ),
  );
}

Widget buildDownloadButtonContainer(rpx) {
  return Container(
    margin: EdgeInsets.only(left: 20 * rpx, bottom: 50 * rpx),
    width: 260 * rpx,
    height: 40 * rpx,
    color: Colors.black,
    child: FlatButton(
      child: Text(
        '即刻选购',
        style: TextStyle(
            fontSize: 20 * rpx,
            color: Colors.white,
            fontWeight: FontWeight.w400),
      ),
    ),
  );
}

Widget buildDownloadImageInfo(goodInfo, enableSingleImageDownloadA, rpx) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(
                top: enableSingleImageDownloadA ? 60 * rpx : 50 * rpx,
                left: 50 * rpx,
                right: 50 * rpx),
            child: Text(
              goodInfo.title.toString(),
              maxLines: 3,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 28 * rpx,
                  color: goodsFontColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Container(
          width: enableSingleImageDownloadA ? 280 * rpx : 300 * rpx,
          height: enableSingleImageDownloadA ? 70 * rpx : 100 * rpx,
          margin:
          EdgeInsets.only(left: 20 * rpx, bottom: 0 * rpx, top: 60 * rpx),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: enableSingleImageDownloadA ? 280 * rpx : 300 * rpx,
                height: enableSingleImageDownloadA ? 70 * rpx : 100 * rpx,
                child: Column(
                  children: [
                    enableSingleImageDownloadA
                        ? Container()
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text('(市场价)',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15.0 * rpx,
                                  decoration:
                                  TextDecoration.lineThrough,
                                  fontWeight: FontWeight.w300)),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10 * rpx),
                          child: Text(
                            '￥${goodInfo.oriPrice}',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 23.0 * rpx,
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 15 * rpx),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('(特卖价)',
                              style: TextStyle(
                                  color: goodsFontColor,
                                  fontSize: 15.0 * rpx,
                                  fontWeight: FontWeight.w600)),
                          Text(
                            '￥${goodInfo.groupPrice}',
                            style: TextStyle(
                                color: goodsFontColor,
                                fontSize: 35.0 * rpx,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Expanded(child: Container()),
            ],
          ),
        ),
        buildDownloadButtonContainer(rpx),
      ],
    ),
  );
}

Widget makeDownloadImageArea(goodInfo, size, rpx) {
  String imageUrl = QINIU_OBJECT_STORAGE_URL + goodInfo.mainImage;
  return Container(
    margin: EdgeInsets.only(left: 10 * rpx, right: 10 * rpx),
    width: size * rpx,
    height: size * rpx,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20 * rpx),
      child: goodInfo.mainImage == null ? '' : Image.network(imageUrl),
    ),
  );
}

 returnGroupGoodsPageConfirm(context, rpx) {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return new AlertDialog(
        backgroundColor: Colors.black45,
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10 * rpx),
                child: Text('素材保存成功，是否返回首页？',
                    style:
                    TextStyle(fontSize: 25 * rpx, color: Colors.white)),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('否',
                style: TextStyle(fontSize: 23 * rpx, color: Colors.white)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          new FlatButton(
            child: new Text('是',
                style: TextStyle(fontSize: 25 * rpx, color: Colors.white)),
            onPressed: () {
              RouterHome.flutoRouter
                  .navigateTo(context, RouterConfig.groupGoodsPath);
            },
          ),
        ],
      );
    },
  );
}

Widget buildDownloadImagePrice(goodInfo, rpx) {
  return Container(
    margin: EdgeInsets.only(top: 20 * rpx, left: 70 * rpx),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('￥',
            style: TextStyle(
              fontSize: 26 * rpx,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        Text('${goodInfo.groupPrice}',
            style: TextStyle(
              fontSize: 40 * rpx,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        Container(
          margin: EdgeInsets.only(left: 10 * rpx),
          child: Text(
            '￥${goodInfo.oriPrice} ',
            style: TextStyle(
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
                fontSize: 28 * rpx,
                fontWeight: FontWeight.w300),
          ),
        ),
      ],
    ),
  );
}

Widget buildDownloadProductDetailInfoA(goodInfo, rpx) {
  int len = goodInfo.description.toString().length;
  int substractCounts = 0;
  int modShift = 0;
  for (int i = 0; i < len; i++) {
    if (isAlphabetOrNumber(goodInfo.description.toString()[i])) {
      substractCounts++;
    }
  }
  len -= substractCounts;

  int mod = len ~/ 3;
  for (int i = 0; i < mod; i++) {
    if (isAlphabetOrNumber(goodInfo.description.toString()[i])) {
      modShift++;
    }
  }
  mod += modShift ~/ 2;
  for (int i = mod; i < len; i++) {
    if (isAlphabetOrNumber(goodInfo.description.toString()[i])) {
      mod++;
    } else {
      break;
    }
  }

  String firstLine = goodInfo.description.toString().substring(0, mod);
  String secordLine = goodInfo.description.toString().substring(mod, len);

  return Container(
    margin: EdgeInsets.only(
        left: 100 * rpx, right: 100 * rpx, top: 50 * rpx, bottom: 30 * rpx),
    width: 700 * rpx,
    alignment: Alignment.center,
    child: Column(children: [
      Text(firstLine,
          style: TextStyle(
            fontSize: 30 * rpx,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          )),
      Container(
        margin: EdgeInsets.only(top: 20 * rpx),
        child: Text(secordLine,
            style: TextStyle(
              fontSize: 30 * rpx,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            )),
      ),
      buildDownloadImagePrice(goodInfo, rpx)
    ]),
  );
}

Widget buildDownloadProductDetailInfoB(goodInfo, appletCodePath, downloadEndDate, rpx, context){
  return Container(
    margin: EdgeInsets.only(top: 20 * rpx),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 400 * rpx,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 35 * rpx),
                    child: Text(goodInfo.brand,
                        style: TextStyle(
                          fontSize: 40 * rpx,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,)
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10 * rpx, left: 35 * rpx),
                    child: Text(goodInfo.titleDesc,
                        style: TextStyle(
                          fontSize: 30 * rpx,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        )),
                  ),
                  Container(
                    // margin: EdgeInsets.only(top: 10 * rpx, left: 150 * rpx, right: 150 * rpx),
                    margin: EdgeInsets.only(top: 10 * rpx, left: 35 * rpx),
                    child: Text(goodInfo.description,
                        style: TextStyle(
                          fontSize: 23 * rpx,
                          fontWeight: FontWeight.w300,
                          // color: Colors.black,
                        )),
                  ),
                ],
              ),
            ),
            buildPrice(goodInfo, rpx),
          ],
        ),
        Container(
          margin: EdgeInsets.only(right: 60 * rpx),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  buildLimitTime(downloadEndDate, rpx),
                  buildShareUserContainer(appletCodePath, rpx, context)
                ],
              ),
              buildAppletCodeImage(appletCodePath, rpx)
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildLimitTime(downloadEndDate, rpx){
  return Container(
    margin: EdgeInsets.only(left: 20 * rpx, top: 60 * rpx),
    child: Row(
      children: [
        Container(
          // height: 50 * rpx,
          padding: EdgeInsets.only(left: 20 * rpx, right: 20 * rpx, top: 10 * rpx, bottom: 10 * rpx),
          decoration: new BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5 * rpx),
              bottomLeft: Radius.circular(5 * rpx),
            ),
          ),
          child: Text('限时活动',
              style: TextStyle(
                fontSize: 23 * rpx,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              )),
        ),
        Container(
          // height: 50 * rpx,
          padding: EdgeInsets.only(left: 30 * rpx, right: 30 * rpx, top: 8 * rpx, bottom: 10 * rpx),
          decoration: new BoxDecoration(
            color: Colors.white,
            border: new Border.all(width: 1 * rpx, color: Colors.black),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(5 * rpx),
              bottomRight: Radius.circular(5 * rpx),
            ),
          ),
          child: Text(downloadEndDate + ' 结束',
              style: TextStyle(
                fontSize: 23 * rpx,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              )),
        )
      ],
    ),
  );
}

Widget buildPrice(goodInfo, rpx){
  return Container(
    // margin: EdgeInsets.only(top: 20 * rpx, left: 100 * rpx),
    margin: EdgeInsets.only(top: 0 * rpx, right: 30 * rpx, bottom: 60 * rpx),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(right: 20 * rpx),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15 * rpx, left: 5 * rpx),
                child: Text('¥',
                    style: TextStyle(
                        fontSize: 20 * rpx,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey)),
              ),
              Container(
                margin: EdgeInsets.only(top: 15 * rpx),
                child: Text(
                  ' ${goodInfo.oriPrice}.00',
                  style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                      fontSize: 28 * rpx,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10 * rpx),
              child: Text('活动价¥',
                  style: TextStyle(
                      fontSize: 22 * rpx,
                      fontWeight: FontWeight.w800,
                      color: Colors.black)),
            ),
            Container(
              margin: EdgeInsets.only(left: 10 * rpx),
              child: Text(goodInfo.groupPriceDotBefore,
                  style: TextStyle(
                      fontSize: 60 * rpx,
                      fontWeight: FontWeight.w800,
                      color: Colors.black)),
            ),
            Container(
              margin: EdgeInsets.only(top: 12 * rpx),
              child: Text("." + goodInfo.groupPriceDotAfter,
                  style: TextStyle(
                      fontSize: 30 * rpx,
                      fontWeight: FontWeight.w800,
                      color: Colors.black)),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildShareUserContainer(appletCodePath, rpx, context){
  return Container(
    margin: EdgeInsets.only(left: 30 * rpx, bottom: 20 * rpx, right: 40 * rpx),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30 * rpx),
          child: Row(
            children: [
              Container(
                width: 70 * rpx,
                height: 70 * rpx,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20 * rpx),
                  child: Image.network(UserInfo.getUserInfo().imageUrl),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 30 * rpx),
                  child: Text(UserInfo.getUserInfo().userName + '的蜜蜜花园',
                      style: TextStyle(
                        fontSize: 30 * rpx,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      )
                  )
              ),
            ],
          ),
        ),

      ],
    ),
  );
}

Widget buildAppletCodeImage(appletCodePath, rpx) {
  if(appletCodePath != ''){
    String appletCodeUrl = QINIU_OBJECT_STORAGE_URL + appletCodePath;
    return Container(
      margin: EdgeInsets.only(top: 10 * rpx),
      child: Column(
        children: [
          Container(
            // alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 6 * rpx),
            width: 100 * rpx,
            height: 100 * rpx,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20 * rpx),
              child: Image.network(appletCodeUrl),
            ),
          ),
          Container(
            child: Text(
              '长按识别购买',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20 * rpx,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }else {
    return Container();
  }
}