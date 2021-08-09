import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mstimes/routers/router_config.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  // final List<BottomNavigationBarItem> bottomTabs = [
  //   BottomNavigationBarItem(
  //       icon: Icon(CupertinoIcons.bubble_left), label: "团品"),
  //   BottomNavigationBarItem(
  //       icon: Icon(CupertinoIcons.shopping_cart), label: "购买"),
  //   BottomNavigationBarItem(icon: Icon(CupertinoIcons.person), label: "我的"),
  // ];

  // final List tabBodies = [GroupGoods(), GoodsPage(), MyPage()];

  int curIndex = 0;
  var curPage;

  @override
  void initState() {
    // curPage = tabBodies[curIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(144, 145, 145, 100.0),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   currentIndex: curIndex,
      //   items: bottomTabs,
      //   onTap: (index) {
      //     setState(() {
      //       curIndex = index;
      //       curPage = tabBodies[curIndex];
      //     });
      //   },
      // ),
      body: curPage,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          RouterHome.flutoRouter.navigateTo(context, RouterConfig.myPagePath);
        },
        backgroundColor: Colors.amber[900],
        child: Icon(
          CupertinoIcons.person,
          semanticLabel: "我的",
        ),
        tooltip: "my",
      ),
    );
  }
}
