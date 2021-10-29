import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mstimes/model/local_share/order_info.dart';
import 'package:mstimes/provide/select_good_provider.dart';
import 'package:provider/provider.dart';
import 'package:mstimes/provide/detail_good_infos.dart';
import 'package:mstimes/provide/good_select_type.dart';
import 'package:mstimes/provide/order_info_add.dart';
import 'package:mstimes/tools/number_change.dart';

import '../product_select.dart';

class ReceiverSelectInfo extends StatefulWidget {
  final int index;

  ReceiverSelectInfo({Key key, @required this.index}) : super(key: key);

  @override
  _ReceiverSelectInfoState createState() => _ReceiverSelectInfoState();
}

class _ReceiverSelectInfoState extends State<ReceiverSelectInfo> {
  ScrollController controller = ScrollController();
  List<Widget> showReceiverOrderSelect = List();
  double rpx;

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return InkWell(
      onTap: () {
        // final goodTypeBadgerProvide =
        //     Provide.value<GoodSelectBottomProvide>(context);
        // final orderInfoAddReciverProvide =
        //     Provide.value<OrderInfoAddReciverProvide>(context);

        // context.read<GoodSelectBottomProvide>().setFromOrderInfo(true);
        // context.read<GoodSelectBottomProvide>().resetCurrentReceiverIndex(widget.index);
        // context.read<OrderInfoAddReciverProvide>().resetCurrentSelectIndex(widget.index);
        // showBottomItems(null, context, rpx);
      },
      child: SingleChildScrollView(
        controller: controller,
        child: Container(
          child: _genSelectGoodsList(controller),
        ),
      ),
    );
  }

  Widget _genSelectGoodsList(controller) {
    return Container(
        width: 730 * rpx,
        margin: EdgeInsets.only(left: 10 * rpx, top: 10 * rpx),
        decoration: new BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 0.5),
        ),
        child:
          Column(
            children:
                buildSelectInfos(context.read<OrderInfoAddReciverProvide>().receiverOrderInfos[widget.index - 1]),
          )
        // })
  );
  }

  List<Widget> buildSelectInfos(infos) {
    var goodInfo = LocalOrderInfo.getLocalOrderInfo().goodInfo;
    List<dynamic> categories = jsonDecode(goodInfo.categories);
    List<dynamic> specifics = jsonDecode(goodInfo.specifics);
    print('SelectInfos->buildSelectInfos()->_infos:' + infos.toString());
    showReceiverOrderSelect.clear();
    infos.keys.forEach((typeIndex) {
      infos[typeIndex].keys.forEach((specIndex) {
        print('typeIndex , specIndex' +
            typeIndex.toString() +
            "  " +
            specIndex.toString());
        showReceiverOrderSelect.add(Container(
            child: Row(
          children: <Widget>[
            Container(
              child: Text(
                categories[typeIndex - 1] + ' ' + specifics[specIndex],
                style: TextStyle(fontSize: 26 * rpx),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Container(
              child: NumChangeWidget(
                  currentReceiverNum: widget.index,
                  typeIndex: typeIndex,
                  specIndex: specIndex),
            )
          ],
        )));
      });
    });
    return showReceiverOrderSelect;
  }
}
