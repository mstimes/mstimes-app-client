import 'package:flutter/material.dart';

class DetailsGoodBottom extends StatelessWidget {
  double rpx;
  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return Container(
        padding: EdgeInsets.only(left: 0, right: 0, top: 6, bottom: 26),
        width: 750 * rpx,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                InkWell(
                    child: Column(
                  children: <Widget>[
                    Container(
                        width: 100 * rpx,
                        alignment: Alignment.center,
                        child: Icon(Icons.home, size: 20, color: Colors.amber)),
                    Text(
                      '首页',
                      style: TextStyle(color: Colors.black, fontSize: 20 * rpx),
                    )
                  ],
                )),
                InkWell(
                    child: Column(
                  children: <Widget>[
                    Container(
                      width: 100 * rpx,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.shopping_cart,
                        size: 20,
                        color: Colors.amber,
                      ),
                    ),
                    Text(
                      '购物车',
                      style: TextStyle(color: Colors.black, fontSize: 20 * rpx),
                    )
                  ],
                )),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    height: 80 * rpx,
                  ),
                ),
                InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    width: 400 * rpx,
                    height: 70 * rpx,
                    color: Colors.amber[800],
                    child: Text(
                      '求复团',
                      style: TextStyle(color: Colors.white, fontSize: 32 * rpx),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  height: 60 * rpx,
                  width: 50 * rpx,
                ),
              ],
            ),
          ],
        ));
  }
}
