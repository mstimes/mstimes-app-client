import 'package:fluro/fluro.dart';
import 'package:mstimes/routers/handler.dart';

// router静态化
class RouterHome {
  static FluroRouter flutoRouter;
}

// router配置
class RouterConfig {
  static String rootPath = '/';
  static String detailsPath = '/details';
  static String productBottomItemPath = '/product/bottomItem';

  // 订单管理
  static String setOrderInfosPath = '/order/setOrderInfos';
  static String queryOrderInfosPath = '/order/queryOrders';
  static String confirmOrderPagePath = '/order/confirmOrder';

  // 商品上架
  static String uploadProductPath = '/upload/productRelease';
  static String uploadDetailImagePath = '/upload/detailImages';
  static String uploadProductInfosPath = '/upload/productInfos';

  // 商品信息
  static String groupGoodsPath = '/product/groupGoods';
  static String goodsPagePath = '/product/goods';
  static String newGoodsPath = '/product/newGoods';

  // 登陆
  static String loginPagePath = '/login';
  static String registryPagePath = '/login/registry';
  static String verifyPagePath = '/login/verify';
  static String invitePagePath = '/login/invite';
  static String serviceTextPagePath = '/login/serviceTextPage';
  static String privateTextPagePath = '/login/privateTextPage';
  static String selectAccTypePagePath = '/login/selectAccTypePage';

  // 导航
  static String indexPagePath = '/page/index';
  static String myIncomePagePath = '/my/income';
  static String myGroupPagePath = '/my/group';

  // 页面
  static String myPagePath = '/myPage';
  static String aboutPagePath = '/my/aboutPage';
  static String myFunsPath = '/my/funs';
  static String fundPath = '/my/fundInfo';

  // 分润管理
  static String passivityIncomePagePath = '/fund/getFundOrderInfo';

  // 支付
  static String paySuccessPagePath = '/pay/successPage';
  static String payFailedPagePath = '/pay/failedPage';

  // 账户管理
  static String drawingPagePath = '/drawing/createRecords';
  static String drawingResultPath = '/drawing/resultPage';
  static String drawingRecordsPagePath = '/drawing/drawingRecordsPage';
  static String drawingAuditPagePath = '/drawing/drawingAuditPage';
  static String drawingAuditRecordsPagePath =
      '/drawing/drawingAuditRecordsPage';

  // 客户管理
  static String vipCategoryPagePath = '/vip/categoryPage';
  static String couponPagePath = '/vip/couponPage';
  static String inviteFriendsPagePath = '/account/inviteFriendsPage';

  // 蜜豆管理
  static String myMBeansPagePath = '/mbeans/myMBeansPage';

  // define all router configs
  static void defineRouters(FluroRouter fluroRouter) {
    fluroRouter.define(detailsPath, handler: detailsHandler);
    fluroRouter.define(setOrderInfosPath, handler: setOrderInfosHandler);
    fluroRouter.define(uploadProductPath, handler: uploadProductHandler);
    fluroRouter.define(uploadDetailImagePath,
        handler: uploadDetailImageHandler);
    fluroRouter.define(uploadProductInfosPath,
        handler: uploadProductInfosHandler);
    fluroRouter.define(groupGoodsPath, handler: groupGoodsHandler);
    fluroRouter.define(registryPagePath, handler: registryHandler);
    fluroRouter.define(verifyPagePath, handler: verifyPageHandler);
    fluroRouter.define(invitePagePath, handler: invitePageHandler);
    fluroRouter.define(indexPagePath, handler: indexPageHandler);
    fluroRouter.define(goodsPagePath, handler: goodsPageHandler);
    fluroRouter.define(myIncomePagePath, handler: myIncomePageHandler);
    fluroRouter.define(myGroupPagePath, handler: myGroupPageHandler);
    fluroRouter.define(myPagePath, handler: myPageHandler);
    fluroRouter.define(serviceTextPagePath, handler: serviceTextPageHandler);
    fluroRouter.define(privateTextPagePath, handler: privateTextPageHandler);
    fluroRouter.define(aboutPagePath, handler: aboutPageHandler);
    fluroRouter.define(loginPagePath, handler: loginPageHandler);
    fluroRouter.define(paySuccessPagePath, handler: paySuccessPageHandler);
    fluroRouter.define(payFailedPagePath, handler: payFailedPageHandler);
    fluroRouter.define(selectAccTypePagePath,
        handler: selectAccTypePageHandler);
    fluroRouter.define(confirmOrderPagePath, handler: confirmOrderPageHandler);
    fluroRouter.define(newGoodsPath, handler: newGoodsHandler);
    fluroRouter.define(myFunsPath, handler: myFunsPageHandler);
    fluroRouter.define(fundPath, handler: fundPageHandler);
    fluroRouter.define(passivityIncomePagePath,
        handler: passivityIncomePageHandler);
    fluroRouter.define(drawingPagePath, handler: drawingPageHandler);
    fluroRouter.define(drawingResultPath, handler: drawingResultHandler);
    fluroRouter.define(drawingRecordsPagePath,
        handler: drawingRecordsPageHandler);
    fluroRouter.define(drawingAuditPagePath, handler: drawingAuditPageHandler);
    fluroRouter.define(drawingAuditRecordsPagePath,
        handler: drawingAuditRecordsPageHandler);
    fluroRouter.define(vipCategoryPagePath, handler: vipCategoryPageHandler);
    fluroRouter.define(couponPagePath, handler: couponPageHandler);
    fluroRouter.define(myMBeansPagePath, handler: myMBeansPageHandler);
    fluroRouter.define(inviteFriendsPagePath,
        handler: inviteFriendsPageHandler);
  }
}
