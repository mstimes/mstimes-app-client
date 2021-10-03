import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/provide/select_good_provider.dart';
import 'package:mstimes/routers/router_config.dart';
import 'package:provider/provider.dart';

class GroupGoodsImageSwiper extends StatelessWidget {
  final List<dynamic> swiperImageUrls;
  final List<dynamic> goodIds;
  GroupGoodsImageSwiper({Key key, this.swiperImageUrls, this.goodIds})
      : super();

  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    List<dynamic> totateImages = swiperImageUrls;
    return Container(
      color: Colors.white,
      height: 750 * rpx,
      width: 750 * rpx,
      child: Swiper(
        autoplay: true,
        itemCount: totateImages.length,
        itemBuilder: (context, index) {
          String swiperImageUrl =
              QINIU_OBJECT_STORAGE_URL + totateImages[index].toString();
          // if (debug) {
          //   print('swiperImageUrl ' + swiperImageUrl);
          // }
          return InkWell(
            onTap: () {
              // if(!checkIsLogin(context)){
              //   // 腾讯应用上架前置登陆
              //   return;
              // }
              context.read<SelectedGoodInfoProvide>().getGoodInfosById(int.parse(goodIds[index]));

              RouterHome.flutoRouter.navigateTo(
                context,
                RouterConfig.detailsPath +
                    "?id=" +
                    goodIds[index].toString() +
                    "&showPay=true",
              );
            },
            child: Image.network(
              swiperImageUrl,
              fit: BoxFit.fill,
            ),
          );
        },
        pagination: new SwiperPagination(
            builder: DotSwiperPaginationBuilder(
          color: Colors.black54,
          activeColor: Colors.white,
        )),
      ),
    );
  }
}
