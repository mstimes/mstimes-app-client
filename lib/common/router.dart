import 'package:mstimes/model/local_share/account_info.dart';
import 'package:mstimes/model/local_share/order_info.dart';
import 'package:mstimes/routers/router_config.dart';

import 'constant.dart';

void indexPageAfterLogin(context){
  String indexPage = UserInfo.getUserInfo().indexPage;
  print('indexPage ==== ' + indexPage);
  if(indexPage == TO_DETAIL_GOOD_PAGE){
    // int indexGoodId = UserInfo.getUserInfo().indexDetailGoodId;
    RouterHome.flutoRouter.navigateTo(
      context,
      RouterConfig.detailsPath +
          "?id=" + LocalOrderInfo.getLocalOrderInfo().goodInfo.goodId.toString() + "&showPay=true",
    );
  }else if(indexPage == TO_MY_PAGE){
    RouterHome.flutoRouter
        .navigateTo(context, RouterConfig.myPagePath);
  }
}