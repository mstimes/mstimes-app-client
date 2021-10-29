import 'package:flutter/material.dart';
import 'package:mstimes/model/local_share/order_info.dart';
import 'package:mstimes/provide/good_select_type.dart';
import 'package:provider/provider.dart';

class NumberChangeWidget extends StatefulWidget {
  final double height;
  int num = 1;
  final ValueChanged<int> onValueChanged;

  NumberChangeWidget(
      {Key key,
      this.height = 55,
      this.num = 1,
      this.onValueChanged})
      : super(key: key);

  @override
  _NumberChangeWidgetState createState() {
    return _NumberChangeWidgetState();
  }
}

class _NumberChangeWidgetState extends State<NumberChangeWidget> {
  double rpx;

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return Container(
      height: widget.height * rpx,
      margin: EdgeInsets.only(right: 30 * rpx, top: 50 * rpx),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1 * rpx),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 50 * rpx,
            height: 50 * rpx,
            alignment: Alignment.center,
            child: Center(
              child: IconButton(
                  color: Colors.grey[600],
                  icon: Icon(
                    Icons.remove,
                    color: Colors.grey,
                    size: 30 * rpx,
                  ),
                  onPressed: () {
                    _minusNum();
                    // context.read<GoodSelectBottomProvide>().decrease(widget.specIndex);
                  }),
            ),
          ),
          Container(
            width: 0.5,
            color: Colors.grey,
          ),
          Container(
            width: 80 * rpx,
            alignment: Alignment.center,
            child: Text(
              // context.read<GoodSelectBottomProvide>().getCurrentTypeNumberChangeSize(
              //     widget.currentReceiverNum,
              //     widget.typeIndex,
              //     widget.specIndex),
              widget.num.toString(),
              maxLines: 1,
              style: TextStyle(fontSize: 30 * rpx, color: Colors.black),
            ),
          ),
          Container(
            width: 0.5,
            color: Colors.grey,
          ),
          Container(
            width: 50 * rpx,
            alignment: Alignment.center,
            child: IconButton(
                color: Colors.grey[600],
                icon: Icon(
                  Icons.add,
                  color: Colors.grey,
                  size: 30 * rpx,
                ),
                onPressed: () {
                  _addNum();
                  // context.read<GoodSelectBottomProvide>().increment(widget.specIndex);
                }),
          ),
        ],
      ),
    );
  }

  void _minusNum() {
    if (widget.num == 1) {
      return;
    }

    setState(() {
      widget.num -= 1;

      if (widget.onValueChanged != null) {
        widget.onValueChanged(widget.num);
      }
    });

    LocalOrderInfo.getLocalOrderInfo().setOrderInfoKV('num', widget.num);
  }

  void _addNum() {
    setState(() {
      widget.num += 1;

      if (widget.onValueChanged != null) {
        widget.onValueChanged(widget.num);
      }
    });

    LocalOrderInfo.getLocalOrderInfo().setOrderInfoKV('num', widget.num);
  }
}
