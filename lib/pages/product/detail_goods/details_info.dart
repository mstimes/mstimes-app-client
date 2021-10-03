import 'package:flutter/material.dart';
import 'package:mstimes/config/service_url.dart';
import 'package:mstimes/model/good_details.dart';
import 'package:mstimes/model/local_share/order_info.dart';

class DetailsGoodInfo extends StatelessWidget {
  double rpx;
  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;

    DataList goodInfo = LocalOrderInfo.getLocalOrderInfo().goodInfo;
    // DataList goodInfo = context.watch<SelectedGoodInfoProvide>().goodInfo;
    if (goodInfo != null) {
      List<dynamic> detailImages = goodInfo.detailImages;
      return Container(
        color: Colors.grey[200],
        padding: EdgeInsets.all(2.0),
        child: Column(
          children: <Widget>[
            getImageDetailTitle(),
            _buildDetailImages(detailImages),
          ],
        ),
      );
    } else {
      return Text("商品详情信息不存在！");
    }
  }

  Widget getImageDetailTitle() {
    return Container(
      child: Center(
        child: Text('- 图文详情 -'),
      ),
    );
  }

  Widget getDetailImage(url) {
    if (url != null) {
      String detailImageUrl = QINIU_OBJECT_STORAGE_URL + url.toString();
      return Container(
          width: 730 * rpx,
          child: Image.network(detailImageUrl, fit: BoxFit.fill));
    } else {
      return Text('');
    }
  }

  Widget _buildDetailImages(detailImages) {
    ScrollController controller = ScrollController();
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 15 * rpx, left: 5 * rpx, right: 5 * rpx),
        controller: controller,
        itemCount: detailImages.length,
        itemBuilder: (context, index) {
          return getDetailImage(detailImages[index].toString());
        });
  }
}
