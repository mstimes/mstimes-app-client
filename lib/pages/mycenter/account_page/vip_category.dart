import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:mstimes/utils/color_util.dart';

class VipCategory extends StatefulWidget {
  const VipCategory({Key key}) : super(key: key);

  @override
  _VipCategoryState createState() => _VipCategoryState();
}

class VipCardTab {
  final String titleHeader;
  final String title;
  final String titleBottom;
  final String color;
  final String privilegeHeader;
  const VipCardTab(
      {this.titleHeader,
      this.title,
      this.titleBottom,
      this.color,
      this.privilegeHeader});
}

const List<VipCardTab> vipCardTabs = const <VipCardTab>[
  const VipCardTab(
      titleHeader: "EXCLUSIVELY FOR SILVER",
      title: "银卡VIP",
      titleBottom: "邀请2位好友 / 消费满 ¥888 解锁",
      color: silver,
      privilegeHeader: "银卡VIP · 专属特权"),
  const VipCardTab(
      titleHeader: "EXCLUSIVELY FOR PLATINUM",
      title: "铂金VIP",
      titleBottom: "邀请8位好友 / 消费满 ¥2888 解锁",
      color: platinum,
      privilegeHeader: "铂金卡VIP · 专属特权"),
  const VipCardTab(
      titleHeader: "EXCLUSIVELY FOR PRIVATE",
      title: "黑钻VIP",
      titleBottom: "邀请20位好友 / 消费满 ¥8888 解锁",
      color: vipBlack,
      privilegeHeader: "黑钻卡VIP · 专属特权")
];

class VipConditionTab {
  final String header;
  final String info;
  final String bottom;
  const VipConditionTab({this.header, this.info, this.bottom});
}

const List<VipConditionTab> vipConditionTabs = const <VipConditionTab>[
  const VipConditionTab(
    header: "方式一",
    info: "",
    bottom: "享受该等级的专属礼遇,期待您的加入。",
  ),
  const VipConditionTab(
    header: "方式二",
    info: "",
    bottom: "享受该等级的专属礼遇,期待您的加入。",
  ),
];

var vipConditionMainInfos = [
  vipConditionTabs[0].info,
  vipConditionTabs[1].info
];

class _VipCategoryState extends State<VipCategory> {
  double rpx;
  String privilegeHeader;
  int vipCardIndex = 0;

  @override
  void initState() {
    super.initState();
    privilegeHeader = vipCardTabs[vipCardIndex].privilegeHeader;
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;

    return Scaffold(
      appBar: AppBar(
        leading: buildBackButton(),
        backgroundColor: Colors.white,
        primary: true,
        elevation: 0,
        automaticallyImplyLeading: true,
        toolbarHeight: 80 * rpx,
        title: Text(
          'VIP专属计划',
          style: TextStyle(
              fontSize: 26 * rpx,
              fontWeight: FontWeight.w500,
              color: Colors.black),
        ),
      ),
      body: ListView(
        children: <Widget>[
          _buildHeaderInfo(),
          _buildSwiperVipCard(),
          _buildPrivilege(),
          _buildUpgradeVipCondition(),
        ],
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Container(
        margin:
            EdgeInsets.only(left: 40 * rpx, top: 30 * rpx, bottom: 10 * rpx),
        child: Text(
          '欢迎加入 VIP专属奖励计划',
          style: TextStyle(fontSize: 26 * rpx, fontWeight: FontWeight.w700),
        ));
  }

  Widget _buildSwiperVipCard() {
    return Container(
      height: 300 * rpx,
      child: Swiper(
        onIndexChanged: (value) {
          setState(() {
            vipCardIndex = value;
            privilegeHeader = vipCardTabs[vipCardIndex].privilegeHeader;
          });
        },
        scrollDirection: Axis.horizontal,
        loop: false,
        itemBuilder: (context, index) {
          return _buildVipCard(
              vipCardTabs[index].titleHeader,
              vipCardTabs[index].title,
              vipCardTabs[index].titleBottom,
              vipCardTabs[index].color,
              rpx);
        },
        itemCount: vipCardTabs.length,
      ),
    );
  }

  Widget _buildVipCard(vipTypeHeader, vipType, vipTypeBottom, color, rpx) {
    return Column(children: [
      Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
            top: 30 * rpx, bottom: 10 * rpx, left: 40 * rpx, right: 40 * rpx),
        height: 260 * rpx,
        width: 650 * rpx,
        decoration: new BoxDecoration(
          color: ColorUtil.fromHex(color),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20 * rpx),
            topRight: Radius.circular(20 * rpx),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                vipTypeHeader,
                style: TextStyle(
                    fontSize: 30 * rpx,
                    fontWeight: FontWeight.w300,
                    color: Colors.white),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20 * rpx),
              alignment: Alignment.center,
              child: Text(
                vipType,
                style: TextStyle(
                    fontSize: 30 * rpx,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40 * rpx),
              alignment: Alignment.center,
              child: Text(
                vipTypeBottom,
                style: TextStyle(
                    fontSize: 23 * rpx,
                    fontWeight: FontWeight.w300,
                    color: Colors.white),
              ),
            )
          ],
        ),
      ),
    ]);
  }

  Widget _buildPrivilege() {
    return Column(
      children: [_createPrivilegeHeader(), _createPrivilegeContainer()],
    );
  }

  Widget _createPrivilegeHeader() {
    return Container(
      margin: EdgeInsets.only(top: 30 * rpx, bottom: 20 * rpx),
      alignment: Alignment.center,
      child: Text(
        privilegeHeader,
        style: TextStyle(fontSize: 26 * rpx, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _createPrivilegeContainer() {
    return Stack(children: [
      Container(
        height: 360 * rpx,
        width: 750 * rpx,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0 * rpx)),
          border: new Border.all(width: 1 * rpx, color: Colors.grey[200]),
        ),
      ),
      _createPrivilegeIcons(),
    ]);
  }

  Widget _createPrivilegeIcons() {
    return Container(
      child: Column(
        children: [
          Container(
            margin:
                EdgeInsets.only(left: 40 * rpx, top: 30 * rpx, right: 40 * rpx),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    RouterHome.flutoRouter
                        .navigateTo(context, RouterConfig.fundPath);
                  },
                  child: _buildFirstUpgradeGift(),
                ),
                InkWell(
                  onTap: () {
                    RouterHome.flutoRouter.navigateTo(
                        context, RouterConfig.drawingRecordsPagePath);
                  },
                  child: _buildVipDay(),
                ),
                InkWell(
                    onTap: () {
                      RouterHome.flutoRouter
                          .navigateTo(context, RouterConfig.drawingPagePath);
                    },
                    child: vipCardIndex == 2
                        ? _buildCronContainer('蜜豆奖励', addSetValue(0),
                            "lib/images/m_bean.png", 20, 85, 10, 70, 70)
                        : _buildCronContainer(
                            '蜜豆奖励',
                            addSetValue(0),
                            "lib/images/mbean_platinum.png",
                            20,
                            85,
                            10,
                            70,
                            70)),
                InkWell(
                    onTap: () {
                      RouterHome.flutoRouter.navigateTo(
                          context, RouterConfig.drawingRecordsPagePath);
                    },
                    child: vipCardIndex == 2
                        ? _buildCronContainer('专属客服', addSetValue(0),
                            "lib/images/service_black.png", 30, 80, 10, 60, 60)
                        : _buildCronContainer(
                            '专属客服',
                            addSetValue(0),
                            "lib/images/service_platinum.png",
                            30,
                            80,
                            10,
                            60,
                            60)),
                // child: _buildCronContainer('专属客服', addSetValues(0, 1),
                //     "lib/images/service_black.png", 30, 80, 10, 60, 60)),
              ],
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(left: 40 * rpx, top: 30 * rpx, right: 40 * rpx),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      RouterHome.flutoRouter
                          .navigateTo(context, RouterConfig.drawingPagePath);
                    },
                    child: _buildCronContainer('专属折扣', addSetValues(0, 1),
                        "lib/images/discount_black.png", 40, 70, 10, 40, 40)),
                InkWell(
                    onTap: () {
                      RouterHome.flutoRouter.navigateTo(
                          context, RouterConfig.drawingRecordsPagePath);
                    },
                    child: _buildCronContainer('专属盲盒', addSetValues(0, 1),
                        "lib/images/blind_box_1.png", 30, 70, 5, 45, 45)),
                InkWell(
                    onTap: () {
                      RouterHome.flutoRouter.navigateTo(
                          context, RouterConfig.drawingRecordsPagePath);
                    },
                    child: _buildCronContainer('延长退货', addSetValues(0, 1),
                        "lib/images/15_return.png", 30, 70, 5, 50, 50)),
                InkWell(
                    onTap: () {
                      RouterHome.flutoRouter
                          .navigateTo(context, RouterConfig.fundPath);
                    },
                    child: _buildCronContainer('线下俱乐部', addSetValues(0, 1),
                        "lib/images/club_black.png", 35, 70, 0, 50, 50)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Set addSetValue(value) {
    Set s = new Set();
    s.add(value);
    return s;
  }

  Set addSetValues(value1, value2) {
    Set s = new Set();
    s.add(value1);
    s.add(value2);
    return s;
  }

  Widget _getMBeansRewardCornerMark() {
    if (vipCardIndex == 1) {
      return _buildCornerMark(10, 65, 25, 50, platinumColor, '2.5倍');
    } else if (vipCardIndex == 2) {
      return _buildCornerMark(10, 65, 25, 50, blackColor9, '5倍');
    } else {
      return Container();
    }
  }

  Widget _getVipDayCornerMark() {
    if (vipCardIndex == 0) {
      return _buildCornerMark(5, 65, 25, 70, silverColor, '2倍蜜豆');
    } else if (vipCardIndex == 1) {
      return _buildCornerMark(5, 65, 25, 70, platinumColor, '5倍蜜豆');
    } else if (vipCardIndex == 2) {
      return _buildCornerMark(5, 60, 25, 70, blackColor9, '10倍蜜豆');
    }
  }

  Widget _buildCornerMark(
      topSize, leftSize, heightSize, widthSize, colorType, text) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
          top: topSize * rpx, left: leftSize * rpx, right: 0 * rpx),
      height: heightSize * rpx,
      width: widthSize * rpx,
      decoration: new BoxDecoration(
        color: colorType,
        borderRadius: BorderRadius.all(Radius.circular(20 * rpx)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 15 * rpx, color: Colors.white),
      ),
    );
  }

  Widget _buildCronContainer(String cronText, Set lockSet, cron, leftSize,
      textTopSize, textLeftSize, heightSize, widthSize) {
    // lock cron default params
    int outerContainerTopSize = 10;
    if (lockSet.contains(vipCardIndex)) {
      leftSize = 30;
      textTopSize = 80;
      textLeftSize = 5;
      heightSize = 50;
      widthSize = 50;

      if (cronText == '线下俱乐部') {
        leftSize = 35;
        textLeftSize = 0;
      }

      if (vipCardIndex == 0) {
        cron = "lib/images/lock_sliver.png";
      } else if (vipCardIndex == 1) {
        cron = "lib/images/lock_platinum.png";
      }
    } else {
      if (cronText == '蜜豆奖励') {
        outerContainerTopSize = 0;
      }
    }

    return Container(
      margin: EdgeInsets.only(
          left: 10 * rpx,
          top: outerContainerTopSize * rpx,
          bottom: 10 * rpx,
          right: 10 * rpx),
      width: 130 * rpx,
      height: 120 * rpx,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10 * rpx, left: leftSize * rpx),
            child: Image.asset(
              cron,
              height: heightSize * rpx,
              width: widthSize * rpx,
            ),
          ),
          cronText == '蜜豆奖励' ? _getMBeansRewardCornerMark() : Container(),
          cronText == '会员日' ? _getVipDayCornerMark() : Container(),
          Container(
              margin: EdgeInsets.only(
                  top: textTopSize * rpx, left: textLeftSize * rpx),
              child: Text(cronText, style: TextStyle(fontSize: 25 * rpx),))
        ],
      ),
    );
  }

  Widget _buildFirstUpgradeGift() {
    return Container(
      margin: EdgeInsets.only(
          left: 10 * rpx, top: 10 * rpx, bottom: 10 * rpx, right: 10 * rpx),
      width: 130 * rpx,
      height: 120 * rpx,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10 * rpx, left: 30 * rpx),
            child: Image.asset(
              _getCron("lib/images/gift_silver.png",
                  "lib/images/gift_platinum.png", "lib/images/gift_black.png"),
              height: 55 * rpx,
              width: 55 * rpx,
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 80 * rpx, left: 20 * rpx),
              child: Text('首升礼', style: TextStyle(fontSize: 25 * rpx)))
        ],
      ),
    );
  }

  Widget _buildVipDay() {
    return Container(
      margin: EdgeInsets.only(
          left: 10 * rpx, top: 10 * rpx, bottom: 10 * rpx, right: 10 * rpx),
      width: 130 * rpx,
      height: 120 * rpx,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10 * rpx, left: 25 * rpx),
            child: Image.asset(
              _getCron(
                  "lib/images/vipday_silver.png",
                  "lib/images/vipday_platinum.png",
                  "lib/images/vipday_private.png"),
              height: 65 * rpx,
              width: 65 * rpx,
            ),
          ),
          _getVipDayCornerMark(),
          Container(
              margin: EdgeInsets.only(top: 80 * rpx, left: 20 * rpx),
              child: Text('会员日', style: TextStyle(fontSize: 25 * rpx)))
        ],
      ),
    );
  }

  String _getCron(silver, platinum, private) {
    if (vipCardIndex == 0) {
      return silver;
    } else if (vipCardIndex == 1) {
      return platinum;
    } else if (vipCardIndex == 2) {
      return private;
    }
  }

  Widget buildBackButton() {
    return IconButton(
      color: Colors.black,
      icon: Icon(Icons.arrow_back_ios_outlined),
      onPressed: () {
        RouterHome.flutoRouter.navigateTo(context, RouterConfig.myPagePath);
      },
    );
  }

  _buildUpgradeVipCondition() {
    String title = '满足以下任一条件成为银卡高级会员！';
    if (vipCardIndex == 1) {
      title = '满足以下任一条件成为铂金卡高级会员！';
    } else if (vipCardIndex == 2) {
      title = '满足以下任一条件成为黑钻卡高级会员！';
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
                top: 30 * rpx, bottom: 20 * rpx, left: 50 * rpx),
            child: Text(
              title,
              style: TextStyle(fontSize: 30 * rpx, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(top: 10 * rpx, bottom: 0 * rpx, left: 50 * rpx),
            child: Text(
              '完成后，您将获得相应的 ADVANCED VIP会籍,',
              style: TextStyle(fontSize: 25 * rpx, fontWeight: FontWeight.w300),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: 10 * rpx, bottom: 20 * rpx, left: 50 * rpx),
            child: Text(
              '享受该等级的专属礼遇,期待您的加入。',
              style: TextStyle(fontSize: 25 * rpx, fontWeight: FontWeight.w300),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 30 * rpx, left: 70 * rpx),
            height: 460 * rpx,
            width: 600 * rpx,
            decoration: new BoxDecoration(
              color: Colors.white,
            ),
            child: Swiper(
              scrollDirection: Axis.horizontal,
              loop: false,
              itemBuilder: (context, index) {
                if (vipCardIndex == 0) {
                  vipConditionMainInfos[0] =
                      "成功邀请两位好友，同时好友累计消费满88元。完成后，T+1 天您将自动加入 ADVANCED 银卡VIP会员奖励计划。";
                  vipConditionMainInfos[1] =
                      "自己累计消费满888元。完成后，T+1 天您将自动加入 ADVANCED 银卡VIP会员奖励计划。";
                } else if (vipCardIndex == 1) {
                  vipConditionMainInfos[0] =
                      "新邀请5位好友，同时新邀好友累计消费满888元。完成后，T+1 天您将自动加入 ADVANCED 铂金卡VIP会员奖励计划。";
                  vipConditionMainInfos[1] =
                      "自己下单累计消费满3888元。完成后，T+1 天您将自动加入 ADVANCED 铂金卡VIP会员奖励计划。";
                } else if (vipCardIndex == 2) {
                  vipConditionMainInfos[0] =
                      "新邀请10位好友，同时新邀好友累计消费满2888元。完成后，T+1 天您将自动加入 ADVANCED 黑钻卡VIP会员奖励计划。";
                  vipConditionMainInfos[1] =
                      "自己下单累计消费满8888元。完成后，T+1 天您将自动加入 ADVANCED 黑钻卡VIP会员奖励计划。";
                }

                return _createUpgradeConditions(
                    vipConditionTabs[index].header,
                    vipConditionMainInfos[index],
                    vipConditionTabs[index].bottom);
              },
              itemCount: vipConditionTabs.length,
              control: new SwiperPagination(
                  alignment: Alignment.topCenter,
                  builder: DotSwiperPaginationBuilder(
                    color: Colors.black54,
                    activeColor: Colors.black12,
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget _createUpgradeConditions(header, mainInfo, bottom) {
    return Container(
      height: 300 * rpx,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
                left: 40 * rpx, top: 80 * rpx, bottom: 30 * rpx),
            child: Text(
              header,
              style: TextStyle(fontSize: 35 * rpx, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 40 * rpx, right: 40 * rpx),
            child: Text(
              mainInfo,
              style: TextStyle(fontSize: 26 * rpx, fontWeight: FontWeight.w300),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: 40 * rpx, top: 30 * rpx, bottom: 30 * rpx),
            child: Text(
              bottom,
              style: TextStyle(fontSize: 26 * rpx, fontWeight: FontWeight.w300),
            ),
          ),
        ],
      ),
    );
  }
}
