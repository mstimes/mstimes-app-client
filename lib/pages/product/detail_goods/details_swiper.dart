import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
// import 'package:mstimes/common/control.dart';
import 'package:mstimes/config/service_url.dart';

class GoodsImageSwiper extends StatelessWidget {
  final List<dynamic> swiperImageUrls;
  GoodsImageSwiper({Key key, this.swiperImageUrls}) : super();

  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    List<dynamic> totateImages = swiperImageUrls;
    return Container(
      color: Colors.white,
      height: 700 * rpx,
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
