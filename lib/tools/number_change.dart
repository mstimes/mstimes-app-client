import 'package:flutter/material.dart';
import 'package:mstimes/provide/good_select_type.dart';
import 'package:provider/provider.dart';

class NumChangeWidget extends StatefulWidget {
  final double height;
  int num;
  final ValueChanged<int> onValueChanged;
  int currentReceiverNum;
  int typeIndex;
  int specIndex;

  NumChangeWidget(
      {Key key,
      this.height = 55,
      this.num = 0,
      this.onValueChanged,
      this.currentReceiverNum,
      this.typeIndex,
      this.specIndex})
      : super(key: key);

  @override
  _NumChangeWidgetState createState() {
    return _NumChangeWidgetState();
  }
}

class _NumChangeWidgetState extends State<NumChangeWidget> {
  double rpx;

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return Container(
      height: widget.height * rpx,
      margin: EdgeInsets.only(right: 30 * rpx),
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
                    context.read<GoodSelectBottomProvide>().decrease(widget.specIndex);
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
              context.read<GoodSelectBottomProvide>().getCurrentTypeNumberChangeSize(
                  widget.currentReceiverNum,
                  widget.typeIndex,
                  widget.specIndex),
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
                  context.read<GoodSelectBottomProvide>().increment(widget.specIndex);
                }),
          ),
        ],
      ),
    );
  }

  void _minusNum() {
    if (widget.num == 0) {
      return;
    }

    setState(() {
      widget.num -= 1;

      if (widget.onValueChanged != null) {
        widget.onValueChanged(widget.num);
      }
    });
  }

  void _addNum() {
    setState(() {
      widget.num += 1;

      if (widget.onValueChanged != null) {
        widget.onValueChanged(widget.num);
      }
    });
  }
}
