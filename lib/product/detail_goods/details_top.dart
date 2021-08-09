import 'package:flutter/material.dart';
import 'package:mstimes/model/local_share/account_info.dart';
import 'package:provide/provide.dart';
import 'package:mstimes/provide/detail_good_infos.dart';

import 'details_swiper.dart';

class DetailsGoodTop extends StatelessWidget {
  double rpx;
  UserInfo userInfo = UserInfo.getUserInfo();
  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return Provide<DetailGoodInfoProvide>(builder: (context, child, val) {
      var goodInfo = Provide.value<DetailGoodInfoProvide>(context)
          .goodDetailModel
          .dataList[0];
      if (goodInfo != null) {
        return Container(
          color: Colors.grey[200],
          padding: EdgeInsets.all(2.0),
          child: Column(
            children: <Widget>[
              GoodsImageSwiper(swiperImageUrls: goodInfo.rotateImages),
              buildTopContent(goodInfo, context),
            ],
          ),
        );
      } else {
        return Text("商品详情不存在！");
      }
    });
  }

  Widget buildTopContent(goodInfo, context) {
    return Container(
        width: 750 * rpx,
        height: userInfo.isAgent() ? 260 * rpx : 200 * rpx,
        margin: EdgeInsets.only(
            left: 0 * rpx, top: 10 * rpx, right: 0 * rpx, bottom: 10 * rpx),
        decoration: new BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(5.0 * rpx)),
          border: new Border.all(width: 1 * rpx, color: Colors.black),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getGoodPrice(goodInfo.oriPrice, goodInfo.groupPrice),
            Container(
              padding: EdgeInsets.only(
                  left: 30 * rpx,
                  top: 10 * rpx,
                  bottom: 10 * rpx,
                  right: 50 * rpx),
              child: Text(
                goodInfo.brand == null
                    ? '' + goodInfo.description
                    : goodInfo.brand + " | " + goodInfo.description,
                style: TextStyle(color: Colors.white),
              ),
            ),
            _showDiscountInfos(goodInfo)
          ],
        ));
  }

  Widget _showDiscountInfos(goodInfo) {
    if (userInfo.isAgent()) {
      return Container(
        width: 700 * rpx,
        height: 50 * rpx,
        margin: EdgeInsets.only(
            left: 15 * rpx, top: 10 * rpx, right: 15 * rpx, bottom: 10 * rpx),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0 * rpx)),
          border: new Border.all(width: 1 * rpx, color: Colors.white),
        ),
        child: Container(
          padding: EdgeInsets.only(
              left: 30 * rpx, top: 5 * rpx, bottom: 5 * rpx, right: 30 * rpx),
          child: Row(children: _showProfitList(goodInfo)
              // Container(
              //   margin: EdgeInsets.only(left: 60 * rpx),
              //   child: Text(
              //     '优惠减免  ' + goodInfo.bonus.toString(),
              //     style: TextStyle(
              //         fontWeight: FontWeight.bold, fontSize: 25 * rpx),
              //   ),
              // ),
              ),
        ),
      );
    } else {
      return Container();
    }
  }

  List<Widget> _showProfitList(goodInfo) {
    List<Widget> list = List<Widget>();
    if (userInfo.level == 0) {
      list.add(_showM0AgentProfitSharing(goodInfo, 100, 'M0分润  '));
      list.add(_showAgentEqualLevelProfit(goodInfo, 150, '同级分润 '));
      return list;
    } else if (userInfo.level == 1) {
      list.add(_showM0AgentProfitSharing(goodInfo, 60, 'M0分润  '));
      list.add(_showM1AgentProfitSharing(goodInfo, 60, 'M1分润  '));
      list.add(_showAgentEqualLevelProfit(goodInfo, 60, '同级分润  '));

      return list;
    } else if (userInfo.level == 2) {
      list.add(_showM0AgentProfitSharing(goodInfo, 30, 'M0分润  '));
      list.add(_showM1AgentProfitSharing(goodInfo, 30, 'M1分润  '));
      list.add(_showM2AgentProfitSharing(goodInfo, 30, 'M2分润  '));
      list.add(_showAgentEqualLevelProfit(goodInfo, 40, '同级  '));

      return list;
    }

    list.add(_showM0AgentProfitSharing(goodInfo, 10, 'M0分润  '));
    list.add(_showM1AgentProfitSharing(goodInfo, 15, 'M1分润  '));
    list.add(_showM2AgentProfitSharing(goodInfo, 15, 'M2分润  '));
    list.add(_showM3AgentProfitSharing(goodInfo, 15, 'M3分润  '));
    list.add(_showAgentEqualLevelProfit(goodInfo, 15, '同级 '));

    return list;
  }

  Widget _showM0AgentProfitSharing(goodInfo, leftPadding, levelName) {
    return Container(
      margin: EdgeInsets.only(left: leftPadding * rpx),
      child: Text(
        _selectProfitSharingPrice(0, levelName, goodInfo),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25 * rpx),
      ),
    );
  }

  Widget _showM1AgentProfitSharing(goodInfo, leftPadding, levelName) {
    return Container(
      margin: EdgeInsets.only(left: leftPadding * rpx),
      child: Text(
        _selectProfitSharingPrice(1, levelName, goodInfo),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25 * rpx),
      ),
    );
  }

  Widget _showM2AgentProfitSharing(goodInfo, leftPadding, levelName) {
    return Container(
      margin: EdgeInsets.only(left: leftPadding * rpx),
      child: Text(
        _selectProfitSharingPrice(2, levelName, goodInfo),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25 * rpx),
      ),
    );
  }

  Widget _showM3AgentProfitSharing(goodInfo, leftPadding, levelName) {
    return Container(
      margin: EdgeInsets.only(left: leftPadding * rpx),
      child: Text(
        _selectProfitSharingPrice(3, levelName, goodInfo),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25 * rpx),
      ),
    );
  }

  Widget _showAgentEqualLevelProfit(goodInfo, leftPadding, name) {
    return Container(
      margin: EdgeInsets.only(left: leftPadding * rpx),
      child: Text(
        name + goodInfo.equalLevelProfit.toString(),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25 * rpx),
      ),
    );
  }

  String _selectProfitSharingPrice(agentLevel, levelName, goodInfo) {
    if (agentLevel == 0) {
      return levelName + goodInfo.zeroProfit.toString();
    }
    if (agentLevel == 1) {
      return levelName + goodInfo.firstProfit.toString();
    }
    if (agentLevel == 2) {
      return levelName + goodInfo.secondProfit.toString();
    }
    if (agentLevel == 3) {
      return levelName + goodInfo.thirdProfit.toString();
    }
    return levelName + goodInfo.zeroProfit.toString();
  }

  Widget getDetailTopImages(url) {
    return Container(
        // height: 500,
        width: 730 * rpx,
        child: Image.network(url, fit: BoxFit.fill));
  }

  Widget getGoodBriefTitle(name) {
    return Container(
      width: 730 * rpx,
      padding: EdgeInsets.only(left: 15.0 * rpx),
      margin: EdgeInsets.only(top: 18.0 * rpx),
      // 后端字段改为goodBriefTitle
      child: Text(name,
          maxLines: 2,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 36 * rpx)),
    );
  }

  Widget getGoodPrice(presentPrice, groupPrice) {
    return Container(
      width: 730 * rpx,
      padding: EdgeInsets.only(left: 15.0),
      margin: EdgeInsets.only(top: 18.0),
      child: Row(
        children: <Widget>[
          Text(
            '特卖价￥',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20 * rpx,
                fontWeight: FontWeight.bold),
          ),
          Text(
            '${groupPrice} ',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 40 * rpx),
          ),
          Text(
            '￥${presentPrice}',
            style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.lineThrough,
                fontSize: 25 * rpx),
          )
        ],
      ),
    );
  }
}
