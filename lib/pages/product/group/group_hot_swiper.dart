import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:mstimes/common/valid.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/routers/router_config.dart';

class GroupGoodsImageSwiper extends StatelessWidget {
  final List<dynamic> swiperImageUrls;
  final List<dynamic> goodIds;
  GroupGoodsImageSwiper({Key key, this.swiperImageUrls, this.goodIds})
      : super();

  @override
  Widget build(BuildContext context) {
    List<dynamic> totateImages = swiperImageUrls;
    return Container(
      color: Colors.white,
      height: 430,
      width: 750,
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
