import 'package:flutter/material.dart';
import 'package:mstimes/model/local_share/release_images.dart';
import 'package:mstimes/provide/upload_release_provide.dart';
import 'package:mstimes/pages/upload/release_detail_image.dart';
import 'package:mstimes/pages/upload/release_good_details.dart';
import 'package:mstimes/pages/upload/release_good_infos.dart';
import 'package:mstimes/pages/upload/release_main_images.dart';
import 'package:mstimes/utils/color_util.dart';
import 'package:provide/provide.dart';

const bucketName = 'ghome-bucket';

const List<ChoiceUploadTab> choiceTabs = const <ChoiceUploadTab>[
  const ChoiceUploadTab(title: "基本信息", typeIndex: "1"),
  const ChoiceUploadTab(title: "商品主图", typeIndex: "2"),
  const ChoiceUploadTab(title: "商品详图", typeIndex: "3"),
  const ChoiceUploadTab(title: "详情信息", typeIndex: "4")
];

class ChoiceUploadTab {
  final String title;
  final String typeIndex;
  const ChoiceUploadTab({this.title, this.typeIndex});
}

class UploadReleaseImages extends StatefulWidget {
  @override
  _UploadReleaseImagesState createState() => _UploadReleaseImagesState();
}

class _UploadReleaseImagesState extends State<UploadReleaseImages>
    with SingleTickerProviderStateMixin {
  TabController mTabController;
  PageController mPageController = PageController(initialPage: 0);
  var currentPage = 0;
  var isPageCanChanged = true;

  @override
  void initState() {
    super.initState();
    mTabController = TabController(
      length: choiceTabs.length,
      vsync: this,
    );

    mTabController.addListener(() {
      //TabBar的监听
      if (mTabController.indexIsChanging) {
        //判断TabBar是否切换
        print(mTabController.index);
        onPageChange(mTabController.index, p: mPageController);
      }
    });
  }

  onPageChange(int index, {PageController p, TabController t}) async {
    if (p != null) {
      // 判断是哪一个切换
      isPageCanChanged = false;
      await mPageController.animateToPage(index,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease); //等待pageview切换完毕,再释放pageivew监听
      isPageCanChanged = true;
    } else {
      mTabController.animateTo(index); //切换Tabbar
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadGoodInfosProvide =
        Provide.value<UploadGoodInfosProvide>(context);

    return DefaultTabController(
        length: choiceTabs.length,
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: PreferredSize(
            child: AppBar(
                backgroundColor: mainColor,
                primary: true,
                elevation: 0,
                leading: Container(
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        uploadGoodInfosProvide.clear();
                        LocalReleaseImages.getImagesMap()
                            .localImagesMap
                            .clear();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 25,
                      )),
                ),
                title: Row(
                  children: <Widget>[
                    Container(
                      child: Text(
                        '商品上架',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
                bottom: TabBar(
                    controller: mTabController,
                    indicatorColor: Colors.white,
                    indicatorWeight: 3.0,
                    tabs: choiceTabs.map((ChoiceUploadTab choiceUploadTab) {
                      return Tab(
                        text: choiceUploadTab.title,
                      );
                    }).toList())),
            preferredSize: Size.fromHeight(90.0),
          ),
          // body: Container(
          //   child: TabBarView(children: [
          //     ReleaseGoodInfos(
          //       tabController: mTabController,
          //     ),
          //     UploadMainImages(),
          //     ProductReleaseDetail(),
          //     ReleaseGoodDetails()
          //   ]),
          // )
          body: PageView.builder(
            itemCount: choiceTabs.length,
            onPageChanged: (index) {
              if (isPageCanChanged) {
                //由于pageview切换是会回调这个方法,又会触发切换tabbar的操作,所以定义一个flag,控制pageview的回调
                onPageChange(index);
              }
            },
            controller: mPageController,
            itemBuilder: (BuildContext context, int index) {
              return choicePage(index);
            },
          ),
        ));
  }

  Widget choicePage(index) {
    print('_choicePage index : ' + index.toString());
    if (index == 0) {
      return ReleaseGoodInfos(
        tabController: mTabController,
      );
    } else if (index == 1) {
      return UploadMainImages(
        tabController: mTabController,
      );
    } else if (index == 2) {
      return ProductReleaseDetail(
        tabController: mTabController,
      );
    } else if (index == 3) {
      return ReleaseGoodDetails();
    }
  }
}
