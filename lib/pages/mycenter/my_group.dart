import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mstimes/pages/mycenter/group_info.dart';
import 'package:mstimes/utils/color_util.dart';

class MyGroupPage extends StatefulWidget {
  @override
  _MyGroupPageState createState() => _MyGroupPageState();
}

class ChoiceTab {
  final String title;
  final IconData icon;
  final String typeIndex;
  const ChoiceTab({this.title, this.icon, this.typeIndex});
}

const List<ChoiceTab> choiceTabs = const <ChoiceTab>[
  const ChoiceTab(title: "今日"),
  const ChoiceTab(title: "本月"),
  const ChoiceTab(title: "累计"),
];

class _MyGroupPageState extends State<MyGroupPage> {
  double rpx;
  int pageNum = 0;
  int pageSize = 10;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainColor,
        primary: true,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          '团队详情',
          style: TextStyle(fontSize: 30 * rpx, fontWeight: FontWeight.bold),
        ),
      ),
      body: GroupInfoPage(),
    );
  }
}
