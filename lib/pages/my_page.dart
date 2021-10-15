import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:mstimes/common/control.dart';
import 'package:mstimes/common/valid.dart';
import 'package:mstimes/common/wechat.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/account_order_summary.dart';
import 'package:mstimes/model/fund_summary.dart';
import 'package:mstimes/model/local_share/account_info.dart';
import 'package:mstimes/model/m_beans.dart';
import 'package:mstimes/provide/drawing_record_provide.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:mstimes/tools/common_container.dart';
import 'package:mstimes/utils/color_util.dart';
import 'package:provider/provider.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class VipPrivilegeTab {
  final String title;
  const VipPrivilegeTab({this.title});
}

const List<VipPrivilegeTab> vipPrivilegeTabs = const <VipPrivilegeTab>[
  const VipPrivilegeTab(title: "首升礼"),
  const VipPrivilegeTab(title: "蜜豆奖励"),
  const VipPrivilegeTab(title: "专属会员日"),
];

class _MyPageState extends State<MyPage> {
  double rpx;
  bool isBackendManager = false;
  bool isReadOnly = false;
  List<DataList> fundSummary = new List<DataList>();
  List<DataList> fundTodaySummary = new List<DataList>();
  List<DataList> fundMonthSummary = new List<DataList>();
  List<ResultDataList> accountOrderSummary = new List<ResultDataList>();

  int groupSumOrderCounts = 0;
  int groupMonthOrderCounts = 0;
  int groupTodayOrderCounts = 0;

  MBeans mbeansSummary = new MBeans();

  var userInfo;
  @override
  void initState() {
    super.initState();

    userInfo = UserInfo.getUserInfo();
    if (!userInfo.isAgent()) {
      _getAccountOrderSummary();
      _getMBeansSummary(UserInfo.getUserInfo().userNumber);
    } else {
      _getFundSummary(userInfo.userId);
      _getFundTodaySummary(userInfo.userId);
      _getFundMonthSummary(userInfo.userId);
      _getGroupSumOrderCounts(userInfo.userId);
      _getMonthGroupOrderCounts(userInfo.userId);
      _getTodayGroupOrderCounts(userInfo.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    // final drawingRecordProvide = Provide.value<DrawingRecordProvide>(context);
    context.read<DrawingRecordProvide>().getLastByAgentId();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: mainColor,
        primary: true,
        elevation: 0,
        leading: _buildBackButton(),
        toolbarHeight: 60 * rpx,
        title: Text(
          '个人中心',
          style: TextStyle(
              fontSize: 30 * rpx,
              fontWeight: FontWeight.w400,
              color: Colors.white),
        ),
      ),
      body: ListView(
        children: <Widget>[
          _topHeader(context),
          _buildVipCategorys(),
          // _buildUpgradeImage(context),
          _myIncomeOrOrders(context),
          _buildAccountInfos(),
          _buildIncomeInfos(),
          _buildInvideFriends(),
          _buildMyWalletInfos(),
          _showBackendManage(context),
          _showFinanceManage(context),
          // _addBottom(),
          about()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          RouterHome.flutoRouter
              .navigateTo(context, RouterConfig.groupGoodsPath);
        },
        backgroundColor: Colors.black26,
        child: Image.asset(
          'lib/images/home1.png',
          height: 50 * rpx,
          width: 50 * rpx,
        ),
        tooltip: "main",
      ),
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      color: Colors.white,
      icon: Icon(Icons.arrow_back_ios_outlined),
      onPressed: () {
        RouterHome.flutoRouter.navigateTo(context, RouterConfig.groupGoodsPath);
      },
    );
  }

  void _getMBeansSummary(userNumber) {
    FormData formData = new FormData.fromMap({"userNumber": userNumber});

    requestDataByUrl('queryMBeans', formData: formData).then((val) {
      var data = json.decode(val.toString());
      if (debug) {
        print("queryMBeans data " + data.toString());
      }

      setState(() {
        mbeansSummary = MBeans.fromJson(data);
      });
    });
  }

  Widget _buildVipCategorys() {
    if (UserInfo.getUserInfo().isAgent()) {
      return Container();
    }

    return InkWell(
      onTap: () {
        RouterHome.flutoRouter
            .navigateTo(context, RouterConfig.vipCategoryPagePath);
      },
      child: Container(
        margin: EdgeInsets.only(top: 30 * rpx, left: 40 * rpx, right: 40 * rpx),
        height: 180 * rpx,
        width: 750 * rpx,
        decoration: new BoxDecoration(
          //背景
          color: blackColor9,
          //设置四周圆角 角度
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15 * rpx),
            topRight: Radius.circular(15 * rpx),
          ),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _createVipCategoryHeader(),
              _createVipContainerSwiperInfo()
            ]),
      ),
    );
  }

  Widget _createVipCategoryHeader() {
    return Container(
      child: Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '成为 ',
              style: TextStyle(
                  fontSize: 26 * rpx,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            Text(
              'ADVANCED',
              style: TextStyle(
                  fontSize: 26 * rpx,
                  fontWeight: FontWeight.w300,
                  color: Colors.white),
            ),
            Text(
              ' 会员 解锁权益',
              style: TextStyle(
                  fontSize: 26 * rpx,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createVipContainerSwiperInfo() {
    return Container(
      width: 750 * rpx,
      margin: EdgeInsets.only(top: 15 * rpx),
      height: 50 * rpx,
      alignment: Alignment.center,
      child: Swiper(
          scrollDirection: Axis.vertical,
          autoplay: true,
          itemBuilder: (context, index) {
            return Container(
              alignment: Alignment.center,
              width: 750 * rpx,
              margin: EdgeInsets.only(top: 15 * rpx),
              child: Text(
                vipPrivilegeTabs[index].title.toString() + ' >',
                style: TextStyle(color: Colors.white, fontSize: 25 * rpx),
              ),
            );
          },
          itemCount: vipPrivilegeTabs.length),
    );
  }

  Widget _showBackendManage(context) {
    print('UserInfo.getUserInfo().level ' +
        UserInfo.getUserInfo().level.toString());
    if (UserInfo.getUserInfo().level == 50) {
      return Container(
          width: 720 * rpx,
          height: 260 * rpx,
          padding:
              EdgeInsets.only(left: 10 * rpx, right: 10 * rpx, top: 20 * rpx),
          decoration: new BoxDecoration(
            //背景
            color: Colors.white,
            //设置四周圆角 角度
            // borderRadius: BorderRadius.all(Radius.circular(20.0 * rpx)),
          ),
          margin:
              EdgeInsets.only(top: 15 * rpx, left: 10 * rpx, right: 10 * rpx),
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 160 * rpx,
                      height: 50 * rpx,
                      margin: EdgeInsets.only(left: 20 * rpx),
                      child: Text('后台管理',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 30 * rpx, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey[400],
                ),
                Container(
                    padding: EdgeInsets.only(
                        left: 10 * rpx,
                        right: 10 * rpx,
                        top: 10 * rpx,
                        bottom: 3 * rpx),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            RouterHome.flutoRouter.navigateTo(
                              context,
                              RouterConfig.uploadProductPath,
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 40 * rpx, top: 20 * rpx, right: 50 * rpx),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 13 * rpx),
                                  child: Image.asset(
                                    "lib/images/upload_goods1.png",
                                    height: 45 * rpx,
                                    width: 45 * rpx,
                                  ),
                                ),
                                Text('商品上架')
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 18 * rpx, top: 23 * rpx, right: 50 * rpx),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 15 * rpx),
                                  child: Image.asset(
                                    "lib/images/change_date.png",
                                    height: 40 * rpx,
                                    width: 40 * rpx,
                                  ),
                                ),
                                Text('日期调整')
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ));
    }

    return Container();
  }

  Widget _showFinanceManage(context) {
    if (UserInfo.getUserInfo().level == 60) {
      return Container(
          width: 720 * rpx,
          height: 260 * rpx,
          padding:
              EdgeInsets.only(left: 10 * rpx, right: 10 * rpx, top: 20 * rpx),
          decoration: new BoxDecoration(
            //背景
            color: Colors.white,
            //设置四周圆角 角度
            // borderRadius: BorderRadius.all(Radius.circular(20.0 * rpx)),
          ),
          margin:
              EdgeInsets.only(top: 15 * rpx, left: 10 * rpx, right: 10 * rpx),
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 160 * rpx,
                      height: 50 * rpx,
                      margin: EdgeInsets.only(left: 20 * rpx),
                      child: Text('财务管理',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 30 * rpx, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey[400],
                ),
                Container(
                    padding: EdgeInsets.only(
                        left: 10 * rpx,
                        right: 10 * rpx,
                        top: 10 * rpx,
                        bottom: 3 * rpx),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            RouterHome.flutoRouter.navigateTo(
                                context, RouterConfig.drawingAuditPagePath);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 40 * rpx, top: 20 * rpx, right: 50 * rpx),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 13 * rpx),
                                  child: Image.asset(
                                    "lib/images/finance_audit.png",
                                    height: 40 * rpx,
                                    width: 40 * rpx,
                                  ),
                                ),
                                Text('提款审核')
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            RouterHome.flutoRouter.navigateTo(context,
                                RouterConfig.drawingAuditRecordsPagePath);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 40 * rpx, top: 20 * rpx, right: 50 * rpx),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 13 * rpx),
                                  child: Image.asset(
                                    "lib/images/audit_records.png",
                                    height: 40 * rpx,
                                    width: 40 * rpx,
                                  ),
                                ),
                                Text('审核记录')
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ));
    }

    return Container();
  }

  Widget _topHeader(context) {
    var userInfo = UserInfo.getUserInfo();
    if(!userInfo.isLogin()){
      return Container(
        padding: EdgeInsets.only(left: 40 * rpx, top: 30 * rpx),
        decoration: new BoxDecoration(
          color: mainColor,
        ),
        child: InkWell(
          onTap: (){
            checkIsLogin(context);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topCenter,
                width: 120 * rpx,
                height: 150 * rpx,
                // 设置图片为圆形
                child: Container(
                  child: ClipOval(
                      child: Image.asset(
                        "lib/images/person_default.png",
                        width: 120 * rpx,
                        height: 120 * rpx,
                      )
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 40 * rpx, top: 30 * rpx),
                child: Text('登陆/注册', style: TextStyle(color: Colors.white, fontSize: 28 * rpx, fontWeight: FontWeight.w400),),
              )
            ],
          ),
        ),
      );
    }
    return Container(
        padding:
            EdgeInsets.only(left: 20 * rpx, top: 10 * rpx, bottom: 30 * rpx),
        decoration: new BoxDecoration(
          //背景
          color: mainColor,
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                  width: 160 * rpx,
                  height: 160 * rpx,
                  // 设置图片为圆形
                  child: Container(
                    child: ClipOval(
                      child: userInfo.imageUrl == null
                          ? Image.asset(
                              "lib/images/person_default.jpg",
                              height: 130 * rpx,
                              width: 130 * rpx,
                            )
                          : Image.network(
                              userInfo.imageUrl,
                              height: 130 * rpx,
                              width: 130 * rpx,
                            ),
                    ),
                  ),
                ),
                _buildUserTypeName()
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 40 * rpx, top: 20 * rpx),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            child: Text('昵称：',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28 * rpx,
                                )),
                          ),
                          Container(
                            child: Text(
                                userInfo.userName == null || userInfo.userName == '0'
                                    ? "mstimes"
                                    : userInfo.userName,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26 * rpx,
                                    fontWeight: FontWeight.bold)),
                          ),
                          _buildUserLabel()
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8 * rpx),
                    child: Row(
                      children: [
                        Container(
                          child: Text(userInfo.isAgent() ? '引荐人：' : '推荐官：',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28 * rpx,
                              )),
                        ),
                        Container(
                          child: Text(
                              userInfo.parentAgentName == null || userInfo.parentAgentName == ''
                                  ? 'MSTIMES'
                                  : userInfo.parentAgentName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26 * rpx,
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                  _buildInvideCodeOrUserNumber()
                ],
              ),
            )
          ],
        ));
  }

  Widget _buildInvideCodeOrUserNumber() {
    if (userInfo.isAgent()) {
      return Container(
        margin: EdgeInsets.only(top: 8 * rpx),
        child: Row(
          children: [
            Text('邀请码：',
                style: TextStyle(color: Colors.white, fontSize: 28 * rpx)),
            Text(userInfo.inviteCode == null ? "MSTIMES" : userInfo.inviteCode,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26 * rpx,
                    fontWeight: FontWeight.bold)),
            Container(
                margin: EdgeInsets.only(left: 20 * rpx),
                height: 40 * rpx,
                width: 120 * rpx,
                child: OutlineButton(
                  borderSide: BorderSide(color: Colors.white, width: 1.5),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: userInfo.inviteCode));
                    showAlertDialog(context, '邀请码复制成功', 180.00, rpx);
                  },
                  child: Text(
                    '复制',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18 * rpx,
                        fontWeight: FontWeight.bold),
                  ),
                ))
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: 12 * rpx),
        child: Row(
          children: [
            Text('用户编号：',
                style: TextStyle(color: Colors.white, fontSize: 28 * rpx)),
            Text(userInfo.userNumber,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25 * rpx,
                    fontWeight: FontWeight.w600)),
            Container(
                margin: EdgeInsets.only(left: 20 * rpx),
                height: 40 * rpx,
                width: 120 * rpx,
                child: OutlineButton(
                  borderSide: BorderSide(color: Colors.white, width: 1.5),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: userInfo.userNumber));
                    showAlertDialog(context, '编号复制成功', 180.00, rpx);
                  },
                  child: Text(
                    '复制',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18 * rpx,
                        fontWeight: FontWeight.bold),
                  ),
                ))
          ],
        ),
      );
    }
  }

  Widget _buildUserTypeName() {
    int widthSize = 150;
    int heightSize = 50;
    int leftSize = 15;
    int nameSize = 20;

    String name = UserInfo.getUserInfo().isAgent()
        ? _selectManagerName(UserInfo.getUserInfo())
        : _selectAccountName(UserInfo.getUserInfo());

    Color color = buttonColor;
    if (!UserInfo.getUserInfo().isAgent()) {
      color = _selectNameBackendColor(UserInfo.getUserInfo());
      widthSize = 140;
      heightSize = 45;
      leftSize = 20;
      nameSize = 18;
    }

    return Container(
      width: widthSize * rpx,
      height: heightSize * rpx,
      margin: EdgeInsets.only(left: leftSize * rpx, top: 110 * rpx),
      //边框设置
      decoration: new BoxDecoration(
        //背景
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(5.0 * rpx)),
      ),
      child: Container(
        margin: EdgeInsets.only(left: 10 * rpx),
        alignment: Alignment.center,
        child: Text(
          name,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: nameSize * rpx),
        ),
      ),
    );
  }

  String _selectManagerName(agentInfo) {
    if (agentInfo.level == 0) {
      return '甄选推荐官';
    }
    if (agentInfo.level == 1) {
      return '高级理事';
    }
    if (agentInfo.level == 2) {
      return '资深总监';
    }
    if (agentInfo.level == 3) {
      return '执行主理人';
    }
    if (agentInfo.level == 50) {
      return '后台管理';
    }
    if (agentInfo.level == 60) {
      return '财务官';
    }
    if (agentInfo.level == 70) {
      return '平台售后';
    }
    return '甄选推荐官';
  }

  String _selectAccountName(accountInfo) {
    if (accountInfo.level == 0) {
      return '蜜糖';
    }
    if (accountInfo.level == 1) {
      return '银卡会员';
    }
    if (accountInfo.level == 2) {
      return '铂金卡会员';
    }
    if (accountInfo.level == 3) {
      return '尊享卡会员';
    }
    return '蜜糖';
  }

  Color _selectNameBackendColor(accountInfo) {
    if (accountInfo.level == 0) {
      return buttonColor;
    }
    if (accountInfo.level == 1) {
      return silverColor;
    }
    if (accountInfo.level == 2) {
      return platinumColor;
    }
    if (accountInfo.level == 3) {
      return blackColor9;
    }
    return buttonColor;
  }

  Widget _buildUserLabel() {
    return Container(
        margin: EdgeInsets.only(left: 8 * rpx), child: _selectUserLabelImage());
  }

  Widget _selectUserLabelImage() {
    if (userInfo.isAgent()) {
      if (userInfo.level == 0) {
        return Image.asset(
          'lib/images/M0.png',
          height: 40 * rpx,
          width: 40 * rpx,
        );
      }
      if (userInfo.level == 1) {
        return Image.asset(
          'lib/images/M1.png',
          height: 40 * rpx,
          width: 40 * rpx,
        );
      }
      if (userInfo.level == 2) {
        return Image.asset(
          'lib/images/M2.png',
          height: 40 * rpx,
          width: 40 * rpx,
        );
      }
      if (userInfo.level == 3) {
        return Image.asset(
          'lib/images/M3.png',
          height: 40 * rpx,
          width: 40 * rpx,
        );
      }
      return Container();
    } else {
      if (userInfo.level == 0) {
        return Container();
      } else if (userInfo.level == 1) {
        return Image.asset(
          'lib/images/silver_vip.png',
          height: 40 * rpx,
          width: 40 * rpx,
        );
      } else if (userInfo.level == 2) {
        return Image.asset(
          'lib/images/platinum_vip.png',
          height: 40 * rpx,
          width: 40 * rpx,
        );
      } else if (userInfo.level == 3) {
        return Image.asset(
          'lib/images/private_vip.png',
          height: 40 * rpx,
          width: 40 * rpx,
        );
      }
    }
  }

  Widget _buildAccountInfos() {
    if (!userInfo.isAgent()) {
      return Container(
          width: 750 * rpx,
          height: 260 * rpx,
          padding:
              EdgeInsets.only(left: 10 * rpx, right: 10 * rpx, top: 20 * rpx),
          decoration: new BoxDecoration(
            color: Colors.white,
          ),
          margin:
              EdgeInsets.only(top: 30 * rpx, left: 10 * rpx, right: 10 * rpx),
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 160 * rpx,
                      height: 50 * rpx,
                      margin: EdgeInsets.only(left: 30 * rpx, top: 10 * rpx),
                      child: Text('我的',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 28 * rpx, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey[400],
                ),
                Container(
                    padding: EdgeInsets.only(
                        left: 10 * rpx,
                        right: 10 * rpx,
                        top: 10 * rpx,
                        bottom: 10 * rpx),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            RouterHome.flutoRouter.navigateTo(
                                context, RouterConfig.myIncomePagePath);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 20 * rpx,
                                top: 13 * rpx,
                                bottom: 10 * rpx,
                                right: 30 * rpx),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 15 * rpx),
                                  child: Image.asset(
                                    "lib/images/my_order.png",
                                    height: 40 * rpx,
                                    width: 40 * rpx,
                                  ),
                                ),
                                Text('我的订单', style: TextStyle(fontSize: 25 * rpx))
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            RouterHome.flutoRouter.navigateTo(
                                context, RouterConfig.myMBeansPagePath);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 40 * rpx,
                                top: 6 * rpx,
                                bottom: 10 * rpx,
                                right: 30 * rpx),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 3 * rpx),
                                  child: Image.asset(
                                    "lib/images/m_bean.png",
                                    height: 55 * rpx,
                                    width: 55 * rpx,
                                  ),
                                ),
                                Text('我的蜜豆', style: TextStyle(fontSize: 25 * rpx))
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            RouterHome.flutoRouter.navigateTo(
                                context, RouterConfig.couponPagePath);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 40 * rpx,
                                top: 12 * rpx,
                                bottom: 10 * rpx,
                                right: 30 * rpx),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 13 * rpx),
                                  child: Image.asset(
                                    "lib/images/coupon.png",
                                    height: 40 * rpx,
                                    width: 40 * rpx,
                                  ),
                                ),
                                Text('代金券', style: TextStyle(fontSize: 25 * rpx))
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            RouterHome.flutoRouter.navigateTo(
                                context, RouterConfig.inviteFriendsPagePath);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 40 * rpx,
                                top: 6 * rpx,
                                bottom: 10 * rpx,
                                right: 30 * rpx),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 3 * rpx),
                                  child: Image.asset(
                                    "lib/images/invite_friends.png",
                                    height: 55 * rpx,
                                    width: 55 * rpx,
                                  ),
                                ),
                                Text('我的邀请', style: TextStyle(fontSize: 25 * rpx))
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ));
    } else {
      return Container();
    }
  }

  Widget _buildIncomeInfos() {
    if (userInfo.isAgent()) {
      return Container(
          width: 750 * rpx,
          height: 260 * rpx,
          padding:
              EdgeInsets.only(top: 20 * rpx, left: 10 * rpx),
          decoration: new BoxDecoration(
            color: Colors.white,
          ),
          margin:
              EdgeInsets.only(top: 15 * rpx, left: 10 * rpx, right: 10 * rpx),
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 160 * rpx,
                      height: 50 * rpx,
                      margin: EdgeInsets.only(left: 20 * rpx),
                      child: Text('我的业绩',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 30 * rpx, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey[400],
                ),
                Container(
                    padding: EdgeInsets.only(
                        left: 10 * rpx,
                        right: 0 * rpx,
                        top: 10 * rpx,
                        bottom: 10 * rpx),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            RouterHome.flutoRouter.navigateTo(
                                context, RouterConfig.myIncomePagePath);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 40 * rpx,
                                top: 10 * rpx,
                                bottom: 10 * rpx,
                                right: 30 * rpx),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 8 * rpx),
                                  child: Image.asset(
                                    "lib/images/retail_1.png",
                                    height: 55 * rpx,
                                    width: 55 * rpx,
                                  ),
                                ),
                                Text('零售收益', style: TextStyle(fontSize: 25 * rpx))
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            RouterHome.flutoRouter.navigateTo(
                                context, RouterConfig.passivityIncomePagePath);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 35 * rpx,
                                top: 10 * rpx,
                                bottom: 10 * rpx,
                                right: 30 * rpx),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 10 * rpx),
                                  child: Image.asset(
                                    "lib/images/passivity_income1.png",
                                    height: 55 * rpx,
                                    width: 55 * rpx,
                                  ),
                                ),
                                Text('被动收益', style: TextStyle(fontSize: 25 * rpx))
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            RouterHome.flutoRouter.navigateTo(
                                context, RouterConfig.myGroupPagePath);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 35 * rpx,
                                top: 16 * rpx,
                                bottom: 10 * rpx,
                                right: 30 * rpx),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 16 * rpx),
                                  child: Image.asset(
                                    "lib/images/group2.png",
                                    height: 45 * rpx,
                                    width: 45 * rpx,
                                  ),
                                ),
                                Text('我的团队', style: TextStyle(fontSize: 25 * rpx))
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            RouterHome.flutoRouter
                                .navigateTo(context, RouterConfig.myFunsPath);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 35 * rpx,
                                top: 21 * rpx,
                                bottom: 10 * rpx,
                                right: 30 * rpx),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 16 * rpx),
                                  child: Image.asset(
                                    "lib/images/my_funs.png",
                                    height: 40 * rpx,
                                    width: 40 * rpx,
                                  ),
                                ),
                                Text('我的粉丝', style: TextStyle(fontSize: 25 * rpx))
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ));
    } else {
      return Container();
    }
  }

  Widget _buildMyWalletInfos() {
    // if (userInfo.isAgent() && UserInfo.getUserInfo().level < 10 ||
    //     UserInfo.getUserInfo().level >= 70) {
    if (userInfo.isAgent()) {
      return Container(
          width: 750 * rpx,
          height: 260 * rpx,
          padding:
              EdgeInsets.only(top: 20 * rpx, left: 10 * rpx),
          decoration: new BoxDecoration(
            //背景
            color: Colors.white,
            //设置四周圆角 角度
            // borderRadius: BorderRadius.all(Radius.circular(20.0 * rpx)),
          ),
          margin:
              EdgeInsets.only(top: 15 * rpx, left: 10 * rpx, right: 10 * rpx),
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 160 * rpx,
                      height: 50 * rpx,
                      margin: EdgeInsets.only(left: 20 * rpx),
                      child: Text('账户管理',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 30 * rpx, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey[400],
                ),
                Container(
                    padding: EdgeInsets.only(
                        left: 10 * rpx,
                        right: 0 * rpx,
                        top: 10 * rpx,
                        bottom: 10 * rpx),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            RouterHome.flutoRouter
                                .navigateTo(context, RouterConfig.fundPath);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 30 * rpx,
                                top: 18 * rpx,
                                bottom: 10 * rpx,
                                right: 50 * rpx),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 20 * rpx),
                                  child: Image.asset(
                                    "lib/images/remain.png",
                                    height: 40 * rpx,
                                    width: 40 * rpx,
                                  ),
                                ),
                                Text('账户余额', style: TextStyle(fontSize: 25 * rpx))
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            RouterHome.flutoRouter.navigateTo(
                                context, RouterConfig.drawingPagePath);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 40 * rpx,
                                top: 10 * rpx,
                                bottom: 10 * rpx,
                                right: 50 * rpx),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 13 * rpx),
                                  child: Image.asset(
                                    "lib/images/withdraw.png",
                                    height: 55 * rpx,
                                    width: 55 * rpx,
                                  ),
                                ),
                                Text('提现', style: TextStyle(fontSize: 25 * rpx))
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            RouterHome.flutoRouter.navigateTo(
                                context, RouterConfig.drawingRecordsPagePath);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 40 * rpx,
                                top: 13 * rpx,
                                bottom: 10 * rpx,
                                right: 50 * rpx),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 15 * rpx),
                                  child: Image.asset(
                                    "lib/images/withdraw_records.png",
                                    height: 50 * rpx,
                                    width: 50 * rpx,
                                  ),
                                ),
                                Text('提现记录', style: TextStyle(fontSize: 25 * rpx))
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ));
    } else {
      return Container();
    }
  }

  Widget _myIncomeOrOrders(context) {
    return Container(
        width: 720 * rpx,
        height: userInfo.isAgent() ? 460 * rpx : 360 * rpx,
        padding: EdgeInsets.only(
            left: 10 * rpx,
            right: 10 * rpx,
            top: userInfo.isAgent() ? 10 * rpx : 0 * rpx),
        decoration: new BoxDecoration(
          //背景
          color: Colors.white,
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(20.0 * rpx)),
        ),
        margin: EdgeInsets.only(top: 15 * rpx, left: 10 * rpx, right: 10 * rpx),
        child: Container(
          child: Column(
            children: [
              userInfo.isAgent()
                  ? Row(
                      children: [
                        Container(
                          width: 160 * rpx,
                          height: 50 * rpx,
                          margin: EdgeInsets.only(left: 20 * rpx),
                          child: Text('我的收益',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 30 * rpx,
                                  fontWeight: FontWeight.w700)),
                        ),
                        Expanded(child: Container()),
                        userInfo.isAgent()
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  RouterHome.flutoRouter.navigateTo(
                                      context, RouterConfig.myIncomePagePath);
                                },
                                child: Container(
                                  width: 150 * rpx,
                                  height: 50 * rpx,
                                  margin: EdgeInsets.only(
                                      left: 10 * rpx, top: 10 * rpx),
                                  child: Text('订单详情 >',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 26 * rpx,
                                          fontWeight: FontWeight.w400)),
                                ),
                              ),
                      ],
                    )
                  : Container(),
              userInfo.isAgent()
                  ? Divider(
                      color: Colors.grey[400],
                    )
                  : Container(),
              Container(
                padding: EdgeInsets.only(
                    left: 10 * rpx,
                    right: 10 * rpx,
                    top: 10 * rpx,
                    bottom: 30 * rpx),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 500 * rpx,
                      height: 150 * rpx,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 20 * rpx),
                            child: Text(userInfo.isAgent() ? '累计营业额' : '累计金额',
                                style: TextStyle(
                                    fontSize: 26 * rpx, color: myIncomeColor)),
                          ),
                          userInfo.isAgent()
                              ? buildCommonPrice(
                                  fundSummary,
                                  fundSummary.isEmpty
                                      ? null
                                      : fundSummary[0].totalSales,
                                  25,
                                  45,
                                  myIncomeColor,
                                  rpx,
                                  MainAxisAlignment.center,
                                  true)
                              : buildCommonPrice(
                                  accountOrderSummary,
                                  accountOrderSummary.isEmpty
                                      ? null
                                      : accountOrderSummary[0].sumPrice + ".00",
                                  25,
                                  45,
                                  myIncomeColor,
                                  rpx,
                                  MainAxisAlignment.center,
                                  true)
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30 * rpx),
                      child: Row(
                        children: [
                          Container(
                            width: 335 * rpx,
                            height: 130 * rpx,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                      userInfo.isAgent() ? '团队收益' : '累计订单',
                                      style: TextStyle(
                                          fontSize: 25 * rpx,
                                          color: myIncomeColor)),
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 20 * rpx),
                                    child: UserInfo.getUserInfo().isAgent()
                                        ? Text(
                                            fundSummary.isEmpty
                                                ? '¥0.00'
                                                : '¥' +
                                                    fundSummary[0].groupIncome,
                                            style: TextStyle(
                                                fontSize: 35 * rpx,
                                                fontWeight: FontWeight.w600,
                                                color: myIncomeColor),
                                          )
                                        : Text(
                                            accountOrderSummary.isEmpty
                                                ? '0'
                                                : accountOrderSummary[0]
                                                    .sumCount,
                                            style: TextStyle(
                                                fontSize: 35 * rpx,
                                                fontWeight: FontWeight.w600,
                                                color: myIncomeColor),
                                          ))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 66 * rpx,
                            child: VerticalDivider(
                              color: Colors.black54,
                              width: 20 * rpx,
                              thickness: 2 * rpx,
                              indent: 10 * rpx,
                              endIndent: 5 * rpx,
                            ),
                          ),
                          Container(
                            width: 335 * rpx,
                            height: 130 * rpx,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                      userInfo.isAgent() ? '个人收益' : '累计蜜豆',
                                      style: TextStyle(
                                          fontSize: 25 * rpx,
                                          color: myIncomeColor)),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(top: 20 * rpx),
                                  child: UserInfo.getUserInfo().isAgent()
                                      ? Text(
                                          fundSummary.isEmpty
                                              ? '¥0.00'
                                              : '¥' + fundSummary[0].myIncome,
                                          style: TextStyle(
                                              fontSize: 35 * rpx,
                                              fontWeight: FontWeight.w600,
                                              color: myIncomeColor),
                                        )
                                      : Text(
                                          mbeansSummary.dataList == null
                                              ? '0'
                                              : mbeansSummary
                                                  .dataList[0].sumCounts
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: 35 * rpx,
                                              fontWeight: FontWeight.w600,
                                              color: myIncomeColor),
                                        ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  _buildInvideFriends() {
    if (userInfo.isAgent()) {
      return Container();
    } else {
      return InkWell(
        onTap: () {
          callInviteFriends(context, rpx);
        },
        child: Container(
          margin: EdgeInsets.only(top: 20 * rpx, bottom: 30 * rpx),
          height: 160 * rpx,
          padding:
              EdgeInsets.only(left: 10 * rpx, right: 10 * rpx, top: 10 * rpx),
          decoration: new BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30 * rpx, left: 50 * rpx),
                    child: Image.asset(
                      "lib/images/invite_reward2.png",
                      height: 50 * rpx,
                      width: 50 * rpx,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30 * rpx, left: 20 * rpx),
                    child: Text(
                      '邀请有奖',
                      style: TextStyle(
                          fontSize: 30 * rpx, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    }
  }

  // _buildUpgradeImage(context) {
  //   if (userInfo.isAgent()) {
  //     return Container();
  //   } else {
  //     return InkWell(
  //       onTap: () {
  //         RouterHome.flutoRouter
  //             .navigateTo(context, RouterConfig.invitePagePath);
  //       },
  //       child: CustomPaint(
  //         child: Container(
  //           margin:
  //               EdgeInsets.only(top: 30 * rpx, left: 40 * rpx, right: 40 * rpx),
  //           height: 60 * rpx,
  //           width: 200 * rpx,
  //           decoration: new BoxDecoration(
  //             //背景
  //             color: blackColor9,
  //             //设置四周圆角 角度
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(15 * rpx),
  //               topRight: Radius.circular(15 * rpx),
  //             ),
  //           ),
  //           child: Container(
  //             alignment: Alignment.center,
  //             child: Text(
  //               '成为甄选推荐官',
  //               style: TextStyle(
  //                   fontSize: 30 * rpx,
  //                   fontWeight: FontWeight.w700,
  //                   color: Colors.white),
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  // }

  Widget about() {
    // if (UserInfo.getUserInfo().level == 80) {
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
            style: TextStyle(fontSize: 23 * rpx),
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
    // }

    return Container();
  }

  Widget _addBottom() {
    if (UserInfo.getUserInfo().level != 70) {
      return Container(
          margin: EdgeInsets.only(top: 30 * rpx, bottom: 80 * rpx),
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 5 * rpx),
            child: Text(
              '她时代  ·  正如闺蜜般懂你',
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 28 * rpx,
                  fontWeight: FontWeight.w600),
            ),
          ));
    }
    return Container();
  }

  void _getGroupSumOrderCounts(agentId) {
    FormData formData = new FormData.fromMap({
      "queryType": 2,
      "userId": agentId,
    });
    requestDataByUrl('queryOrderCounts', formData: formData).then((val) {
      var data = json.decode(val.toString());
      if (debug) {
        print("_getGroupSumOrderCounts data " + data.toString());
      }

      setState(() {
        if (data['dataList'] != null) {
          groupSumOrderCounts = int.parse(data['dataList'][0].toString());
        }
      });
    });
  }

  void _getMonthGroupOrderCounts(agentId) {
    FormData formData = new FormData.fromMap({
      "queryType": 2,
      "userId": agentId,
      "startTime": new DateTime(DateTime.now().year, DateTime.now().month, 1),
      "endTime": DateTime.now().add(new Duration(days: 1)),
    });
    requestDataByUrl('queryOrderCounts', formData: formData).then((val) {
      var data = json.decode(val.toString());

      setState(() {
        if (data['dataList'] != null) {
          groupMonthOrderCounts = int.parse(data['dataList'][0].toString());
        }
      });
    });
  }

  void _getTodayGroupOrderCounts(agentId) {
    FormData formData = new FormData.fromMap({
      "queryType": 2,
      "userId": agentId,
      "startTime": DateTime.now(),
      "endTime": DateTime.now().add(new Duration(days: 1)),
    });
    requestDataByUrl('queryOrderCounts', formData: formData).then((val) {
      var data = json.decode(val.toString());

      setState(() {
        if (data['dataList'] != null) {
          groupTodayOrderCounts = int.parse(data['dataList'][0].toString());
        }
      });
    });
  }

  void _getAccountOrderSummary() {
    FormData formData = new FormData.fromMap({
      "userNumber": UserInfo.getUserInfo().userNumber,
      "startTime": DateTime.parse("2021-01-01"),
      "endTime": DateTime.now().add(new Duration(days: 1))
    });
    requestDataByUrl('queryAccountOrderSummary', formData: formData)
        .then((val) {
      var data = json.decode(val.toString());
      if (debug) {
        print("queryAccountOrderSummary data " + data.toString());
      }

      setState(() {
        accountOrderSummary = AccountOrderSummary.fromJson(data).dataList;
      });
    });
  }

  void _getFundSummary(agentId) {
    FormData formData = new FormData.fromMap({
      "agentId": agentId,
    });
    requestDataByUrl('queryFundSummary', formData: formData).then((val) {
      var data = json.decode(val.toString());
      if (debug) {
        print("queryFundSummary data " + data.toString());
      }

      setState(() {
        fundSummary = FundSummary.fromJson(data).dataList;
      });
    });
  }

  void _getFundTodaySummary(agentId) {
    FormData formData = new FormData.fromMap({
      "agentId": agentId,
      "startDate": DateTime.now(),
      "endDate": DateTime.now().add(new Duration(days: 1)),
    });
    requestDataByUrl('queryFundSummary', formData: formData).then((val) {
      var data = json.decode(val.toString());

      setState(() {
        fundTodaySummary = FundSummary.fromJson(data).dataList;
      });
    });
  }

  void _getFundMonthSummary(agentId) {
    FormData formData = new FormData.fromMap({
      "agentId": agentId,
      "startDate": new DateTime(DateTime.now().year, DateTime.now().month, 1),
      "endDate": DateTime.now().add(new Duration(days: 1)),
    });
    requestDataByUrl('queryFundSummary', formData: formData).then((val) {
      var data = json.decode(val.toString());

      setState(() {
        fundMonthSummary = FundSummary.fromJson(data).dataList;
      });
    });
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    paint.color = Colors.lightBlue;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;

    var startPoint = Offset(0, size.height / 2);
    var controlPoint1 = Offset(size.width / 4, size.height / 3);
    var controlPoint2 = Offset(3 * size.width / 4, size.height / 3);
    var endPoint = Offset(size.width, size.height / 2);

    var path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
