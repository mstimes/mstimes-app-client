import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:mstimes/common/wechat.dart';

var moneyFormat = NumberFormat('0,000');

Widget buildCommonPrice(fund, price, smallSize, largeSize, fontColor, rpx,
    mainAxisAlignment, remainDecimal) {
  if (fund == null || fund.isEmpty) {
    return Container(
      width: 240 * rpx,
      margin: EdgeInsets.only(top: 5 * rpx, left: 0 * rpx),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Text(
            '¥ ',
            style: TextStyle(
                fontSize: smallSize * rpx,
                fontWeight: FontWeight.bold,
                color: fontColor),
          ),
          Text(
            '0',
            style: TextStyle(
                fontSize: largeSize * rpx,
                fontWeight: FontWeight.bold,
                color: fontColor),
          ),
          Text(
            '.00',
            style: TextStyle(
                fontSize: smallSize * rpx,
                fontWeight: FontWeight.bold,
                color: fontColor),
          ),
        ],
      ),
    );
  } else {
    return Container(
      width: 300 * rpx,
      margin: EdgeInsets.only(top: 5 * rpx, left: 10 * rpx),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Text(
            '¥ ',
            style: TextStyle(
                fontSize: smallSize * rpx,
                fontWeight: FontWeight.w600,
                color: fontColor),
          ),
          Text(
            int.parse(price.substring(0, price.length - 3)) > 1000
                ? moneyFormat
                    .format(int.parse(price.substring(0, price.length - 3)))
                : price.substring(0, price.length - 3),
            style: TextStyle(
                fontSize: largeSize * rpx,
                fontWeight: FontWeight.w600,
                color: fontColor),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Text(
              remainDecimal == true
                  ? price.substring(price.length - 3, price.length)
                  : '',
              style: TextStyle(
                  fontSize: smallSize * rpx,
                  fontWeight: FontWeight.w600,
                  color: fontColor),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildSingleSummitButton(
    buttonName, widthSize, heightSize, radiusSize, rpx) {
  return Container(
      width: widthSize * rpx,
      height: heightSize * rpx,
      //边框设置
      decoration: new BoxDecoration(
        //背景
        color: Colors.black,
        //设置四周圆角 角度
        borderRadius: BorderRadius.all(Radius.circular(radiusSize * rpx)),
      ),
      child: Container(
        alignment: Alignment.center,
        child: Text(
          buttonName,
          style: TextStyle(
              color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w400),
        ),
      ));
}

Widget buildCommonVerticalDivider(h, rpx) {
  return SizedBox(
    height: h * rpx,
    child: VerticalDivider(
      color: Colors.black54,
      width: 20 * rpx,
      thickness: 2 * rpx,
      indent: 10 * rpx,
      endIndent: 5 * rpx,
    ),
  );
}

Widget buildCommonHorizontalDivider() {
  return Divider(
    color: Colors.grey[400],
  );
}

Widget buildCommonListBottom(rpx) {
  return Container(
    margin: EdgeInsets.only(top: 20 * rpx, bottom: 10 * rpx),
    alignment: Alignment.center,
    child: Text(
      '没有更多数据',
      style: TextStyle(fontSize: 23 * rpx),
    ),
  );
}

Widget buildCommonBottom(colorStyle, rpx) {
  return Container(
    margin: EdgeInsets.only(top: 30 * rpx, bottom: 80 * rpx),
    child: Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 5 * rpx),
      child: Text(
        '她时代  ·  正如闺蜜般懂你',
        style: TextStyle(
            color: colorStyle, fontSize: 28 * rpx, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

Widget buildInviteFriendsContainer(rpx) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        margin: EdgeInsets.only(top: 300 * rpx),
        child: Text(
          '这里空空如也',
          style: TextStyle(
              color: Colors.black,
              fontSize: 30 * rpx,
              fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 40 * rpx),
        child: Text(
          '邀请好友下单可获取升级奖励，快去邀请吧',
          style: TextStyle(
              color: Colors.black,
              fontSize: 26 * rpx,
              fontWeight: FontWeight.w400),
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 100 * rpx),
        child: InkWell(
          onTap: () {
            callInviteFriends();
          },
          child: buildSingleSummitButton('现在去邀请', 280, 60, 0, rpx),
        ),
      )
    ],
  );
}
