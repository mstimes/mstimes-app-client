import 'package:flutter/material.dart';
import 'package:mstimes/product/good_list.dart';
import 'package:mstimes/routers/router_config.dart';

class GoodsPage extends StatelessWidget {
  double rpx;
  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[700],
        primary: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          '全部团品',
          style: TextStyle(fontSize: 36 * rpx, fontWeight: FontWeight.bold),
          // title: Container(
          //   padding: EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 6),
          //   child: TextField(
          //     maxLines: 1,
          //     autofocus: false,
          //     // TextFiled装饰
          //     decoration: InputDecoration(
          //         filled: true,
          //         contentPadding: EdgeInsets.all(10),
          //         fillColor: Colors.white,
          //         border: OutlineInputBorder(
          //             borderSide: BorderSide.none,
          //             gapPadding: 0,
          //             borderRadius: BorderRadius.all(Radius.circular(20))),
          //         hintText: '衬衫女',
          //         suffixIcon: Icon(Icons.search)),
          //   ),
        ),
      ),
      body: Container(
        child: TabbedAppBar(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          RouterHome.flutoRouter.navigateTo(
            context,
            RouterConfig.uploadProductPath,
          );
        },
        backgroundColor: Colors.amber[900],
        child: Icon(Icons.add),
        tooltip: "add",
      ),
    );
  }
}

class TabbedAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: choiceTabs.length,
        child: Scaffold(
            appBar: PreferredSize(
              child: AppBar(
                backgroundColor: Colors.white,
                shadowColor: Colors.amber[900],
                elevation: 8,
                bottom: TabBar(
                  isScrollable: true,
                  labelColor: Colors.black,
                  indicatorWeight: 3.0,
                  indicatorColor: Colors.amber[900],
                  tabs: choiceTabs.map((ChoiceTab choiceTab) {
                    return Tab(
                      text: choiceTab.title,
                    );
                  }).toList(),
                ),
              ),
              preferredSize: Size.fromHeight(49),
            ),
            body: Container(
              child: TabBarView(children: [
                Goods(classify: 1),
                Goods(classify: 2),
                Goods(classify: 3),
                Goods(classify: 4),
                Goods(classify: 0),
              ]),
            )));
  }
}

class ChoiceTab {
  final String title;
  final IconData icon;
  final String typeIndex;
  const ChoiceTab({this.title, this.icon, this.typeIndex});
}

const List<ChoiceTab> choiceTabs = const <ChoiceTab>[
  const ChoiceTab(title: "服饰"),
  const ChoiceTab(title: "家居百货"),
  const ChoiceTab(title: "食品"),
  const ChoiceTab(title: "电器"),
  const ChoiceTab(title: "其他"),
];

// class ChoiceCard extends StatelessWidget {
//   const ChoiceCard({Key key, this.choiceTab}) : super(key: key);

//   final ChoiceTab choiceTab;

//   @override
//   Widget build(BuildContext context) {
//     final TextStyle textStyle = Theme.of(context).textTheme.display1;
//     return new Card(
//       color: Colors.white,
//       child: new Center(
//         child: new Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             new Goods(classify: 1),
//             new Text(choiceTab.title, style: textStyle),
//           ],
//         ),
//       ),
//     );
//   }
// }
