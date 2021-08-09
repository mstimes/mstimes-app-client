import 'dart:ui';

import 'package:flutter/material.dart';

class ServiceTextPage extends StatelessWidget {
  double rpx;

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;

    return Scaffold(
        appBar: AppBar(
          primary: true,
          elevation: 0,
          automaticallyImplyLeading: true,
          leading: BackButton(color: Colors.black),
          toolbarHeight: 80 * rpx,
          backgroundColor: Colors.grey[100],
          title: Text(
            '关于我们',
            style: TextStyle(
                fontSize: 30 * rpx,
                fontWeight: FontWeight.w400,
                color: Colors.black),
          ),
        ),
        body: Container(
          child: ListView(
            children: [
              Container(
                child: ClipOval(
                  child: Image.asset(
                    "lib/images/person.png",
                    // color: Colors.white,
                    height: 160 * rpx,
                    width: 160 * rpx,
                    // fit: BoxFit.fill,
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
