import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provide/provide.dart';
import 'package:mstimes/provide/upload_release_provide.dart';
import 'package:mstimes/service/qiniu_storge.dart';
import 'package:mstimes/utils/color_util.dart';

class ProductReleaseDetail extends StatefulWidget {
  TabController tabController;
  ProductReleaseDetail({Key key, this.tabController}) : super(key: key);

  @override
  _ProductReleaseDetailState createState() => _ProductReleaseDetailState();
}

class _ProductReleaseDetailState extends State<ProductReleaseDetail> {
  ScrollController _controller = ScrollController();
  final picker = ImagePicker();
  Map<String, File> imageMap = Map();
  int detailImageCounts = 25;
  double rpx;

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return ListView(
      controller: _controller,
      children: _buildDetailImages(detailImageCounts),
    );
  }

  List<Widget> _buildDetailImages(containerCounts) {
    List<Widget> widgets = List();
    for (int i = 0; i < containerCounts; i++) {
      widgets.add(_buildDetailImageContainer(i));
    }
    widgets.add(_buildNextToDetailInfos(context));
    return widgets;
  }

  Widget _buildDetailImageContainer(number) {
    final uploadGoodInfosProvide =
        Provide.value<UploadGoodInfosProvide>(context);
    FocusNode _focusNode = FocusNode();
    String detailImagesKeyType = 'detailImages';
    String imageName = 'detailImage_' + number.toString();
    // String imageDesc = imageName + '_desc';
    String detailDescKeyType = 'detailImagesDesc';
    return Container(
      child: Row(
        children: <Widget>[
          Container(
              height: number > 0 ? 420 * rpx : 460 * rpx,
              width: 720 * rpx,
              alignment: Alignment(0, 0),
              margin: EdgeInsets.only(left: 10, top: 0),
              decoration: new BoxDecoration(
                //背景
                color: Colors.white,
                //设置四周边框
                border: new Border.all(width: 1, color: Colors.grey),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: new BoxDecoration(
                      //背景
                      color: Colors.white,
                      //设置四周边框
                      border: new Border.all(width: 1, color: Colors.grey),
                    ),
                    child: Container(
                      width: 420 * rpx,
                      child: Column(
                        children: <Widget>[
                          _buildTitle(number),
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              _getImageByGallery(
                                  detailImagesKeyType, imageName, number);
                            },
                            child: imageMap[imageName] == null
                                ? IconButton(
                                    icon: Icon(
                                      Icons.add,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      _getImageByGallery(detailImagesKeyType,
                                          imageName, number);
                                    })
                                : Image.file(imageMap[imageName]),
                          )),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      width: 290 * rpx,
                      height: number > 0 ? 420 * rpx : 460 * rpx,
                      child: TextField(
                        focusNode: _focusNode,
                        minLines: 1,
                        maxLines: 5,
                        enabled: true,
                        onChanged: (value) {
                          uploadGoodInfosProvide.setUploadMapInfo(
                              detailDescKeyType, number, value);
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration.collapsed(
                            hintStyle: TextStyle(
                                fontSize: 15.0, color: Colors.grey[400]),
                            hintText: "图片描述信息（选填）"),
                      ))
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildTitle(number) {
    if (number == 0) {
      return Container(
        height: 40 * rpx,
        width: 420 * rpx,
        color: buttonColor,
        child: Text(
          '商品详图',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      );
    } else {
      return Container();
    }
  }

  Future _getImageByGallery(keyType, imageName, number) async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery);
    uploadImage(keyType, imageName, number, pickedFile.path, context);
    setState(() {
      if (pickedFile != null) {
        imageMap[imageName] = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget _buildReceiverButton() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      width: 700 * rpx,
      height: 50 * rpx,
      color: Colors.white,
      child: Container(
        child: OutlineButton(
            borderSide: new BorderSide(color: mainColor),
            onPressed: () {
              // setState(() {
              //   this.needAddReceiver = true;
              //   currentReceiverNum++;
              //   print('_buildReceiverButton , allReceivers : ' +
              //       allReceivers.toString() +
              //       ", length : " +
              //       allReceivers.length.toString());
              //   allReceivers.removeLast();
              // }
              // );
            },
            child: Text(
              '添加详图',
              style: TextStyle(color: mainColor, fontSize: 14.0),
            )),
      ),
    );
  }

  Widget _buildNextToDetailInfos(context) {
    return Container(
        padding: EdgeInsets.only(left: 0, right: 0, top: 6, bottom: 26),
        width: 750 * rpx,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                InkWell(
                    onTap: () {
                      widget.tabController.animateTo(3);
                    },
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                              width: 600 * rpx,
                              height: 75 * rpx,
                              margin: EdgeInsets.only(left: 75 * rpx),
                              alignment: Alignment(0, 0),
                              //边框设置
                              decoration: new BoxDecoration(
                                //背景
                                color: buttonColor,
                                //设置四周圆角 角度
                                // borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Container(
                                child: Text(
                                  '下一步',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30 * rpx,
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                        ],
                      ),
                    ))
              ],
            ),
          ],
        ));
  }
}
