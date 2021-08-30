import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:mstimes/common/control.dart';
import 'package:mstimes/provide/order_info_add.dart';
import 'package:mstimes/utils/color_util.dart';

class AddReceiverButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      width: 130,
      height: 30,
      color: Colors.white,
      child: Container(
        child: OutlineButton(
            borderSide: new BorderSide(color: buttonColor),
            onPressed: () {
              final orderInfoAddReciverProvide =
                  Provide.value<OrderInfoAddReciverProvide>(context);
              orderInfoAddReciverProvide.initAddReceiverOrderSelectInfo();
              if (debug) {
                print('add receiver..._receiverOrderInfos: ' +
                    orderInfoAddReciverProvide.receiverOrderInfos.toString());
              }
              orderInfoAddReciverProvide.incrementReceiverCounts();
              // setState(() {});
            },
            child: Text(
              '添加新收件人',
              style: TextStyle(color: Colors.white, fontSize: 14.0),
            )),
      ),
    );
  }
}
