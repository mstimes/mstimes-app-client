import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:mstimes/pages/mycenter/account_page/coupon_page.dart';
import 'package:mstimes/pages/mycenter/account_page/invite_friends.dart';
import 'package:mstimes/pages/mycenter/account_page/my_mbeans.dart';
import 'package:mstimes/pages/mycenter/account_page/vip_category.dart';
import 'package:mstimes/pages/mycenter/fund_manage/drawing.dart';
import 'package:mstimes/pages/mycenter/fund_manage/drawing_audit.dart';
import 'package:mstimes/pages/mycenter/fund_manage/drawing_audit_records.dart';
import 'package:mstimes/pages/mycenter/fund_manage/drawing_records.dart';
import 'package:mstimes/pages/mycenter/fund_manage/fund.dart';
import 'package:mstimes/pages/mycenter/my_funs.dart';
import 'package:mstimes/pages/mycenter/my_group.dart';
import 'package:mstimes/pages/mycenter/my_income.dart';
import 'package:mstimes/pages/mycenter/passivity_income.dart';
import 'package:mstimes/pages/order/confirm_order.dart';
import 'package:mstimes/pages/order/order_info.dart';
import 'package:mstimes/pages/goods_page.dart';
import 'package:mstimes/pages/index.dart';
import 'package:mstimes/pages/login/invite_page.dart';
import 'package:mstimes/pages/login/private_text_page%20copy.dart';
import 'package:mstimes/pages/login/registry.dart';
import 'package:mstimes/pages/login/select_acc_type.dart';
import 'package:mstimes/pages/login/service_text_page.dart';
import 'package:mstimes/pages/login/verify_page.dart';
import 'package:mstimes/pages/my_page.dart';
import 'package:mstimes/pages/order/receiver_infos.dart';
import 'package:mstimes/pages/order/receiver_widgets/add_receiver.dart';
import 'package:mstimes/pages/product/detail_goods.dart';
import 'package:mstimes/pages/product/group/main_page.dart';
import 'package:mstimes/pages/product/group/new_goods.dart';
import 'package:mstimes/result_pages/drawing_result.dart';
import 'package:mstimes/result_pages/pay_result.dart';
import 'package:mstimes/pages/upload/release_good_infos.dart';
import 'package:mstimes/pages/upload/release_detail_image.dart';
import 'package:mstimes/pages/upload/release_upload.dart';

import '../pages/login/login.page.dart';

// define all handlers
Handler detailsHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return DetailGoods(int.parse(params['id'].first), params['showPay'].first);
  },
);

// Handler setOrderInfosHandler = Handler(
//   handlerFunc: (BuildContext context, Map<String, List<String>> params) {
//     return SetOrderInfos();
//   },
// );

Handler orderInfosHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return OrderInfos();
  },
);

Handler orderInfoPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return OrderInfoPage();
  },
);

Handler uploadProductHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return UploadReleaseImages();
  },
);

Handler uploadDetailImageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return ProductReleaseDetail();
  },
);

Handler uploadProductInfosHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return ReleaseGoodInfos();
  },
);

Handler groupGoodsHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return GroupGoods();
  },
);

Handler newGoodsHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return NewGoods();
  },
);

Handler bindPhoneNumberPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return RegistryPage();
  },
);

Handler verifyPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return VerifyPage();
  },
);

Handler invitePageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return InvitePage();
  },
);

Handler indexPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return IndexPage();
  },
);

Handler goodsPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return GoodsPage();
  },
);

Handler myIncomePageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return MyIncomePage();
  },
);

Handler myGroupPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return MyGroupPage();
  },
);

Handler myPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return MyPage();
  },
);

Handler serviceTextPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return ServiceTextPage();
  },
);

Handler privateTextPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return PrivateTextPage();
  },
);

Handler aboutPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return ServiceTextPage();
  },
);
Handler loginPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return LoginPage();
  },
);
Handler paySuccessPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return PayResultPage(1);
  },
);
Handler payFailedPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return PayResultPage(0);
  },
);
Handler selectAccTypePageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return SelectAccountTypePage();
  },
);

// Handler confirmOrderPageHandler = Handler(
//   handlerFunc: (BuildContext context, Map<String, List<String>> params) {
//     return ConfirmOrderPage();
//   },
// );

Handler myFunsPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return MyFunsPage();
  },
);

Handler fundPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return FundPage();
  },
);

Handler passivityIncomePageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return PassivityIncomePage();
  },
);

Handler drawingPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return DrawingPage();
  },
);

Handler drawingResultHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return DrawingResultPage();
  },
);

Handler drawingRecordsPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return DrawingRecordsPage();
  },
);

Handler drawingAuditPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return DrawingAuditPage();
  },
);

Handler drawingAuditRecordsPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return DrawingAuditRecordsPage();
  },
);

Handler vipCategoryPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return VipCategory();
  },
);

Handler couponPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return CouponPage();
  },
);

Handler myMBeansPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return MyMBeansPage();
  },
);

Handler inviteFriendsPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return InviteFriendsPage();
  },
);

Handler addReceiverAddressPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return AddReceiverAddress();
  },
);
