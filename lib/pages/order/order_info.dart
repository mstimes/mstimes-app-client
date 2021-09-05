import 'package:flutter/material.dart';
import 'package:mstimes/utils/color_util.dart';

class OrderInfoPage extends StatefulWidget {
  const OrderInfoPage({Key key}) : super(key: key);

  @override
  _OrderInfoPageState createState() => _OrderInfoPageState();
}

class _OrderInfoPageState extends State<OrderInfoPage> {
  double rpx;

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: mainColor,
          leading: Container(
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  size: 25,
                )),
          ),
          title: Text(
            '确认订单',
            style: TextStyle(
                fontSize: 30 * rpx,
                color: Colors.white,
                fontWeight: FontWeight.w400),
          )),
      body: Stack(
        children: [
          Center(child: Text('abc'),),
        ],
      ),
    );
  }
}
