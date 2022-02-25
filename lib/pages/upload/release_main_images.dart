import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mstimes/model/local_share/release_images.dart';
import 'package:provider/provider.dart';
import 'package:mstimes/common/valid.dart';
import 'package:mstimes/provide/upload_release_provide.dart';
import 'package:mstimes/service/qiniu_storge.dart';
import 'package:mstimes/utils/color_util.dart';

class UploadMainImages extends StatefulWidget {
  TabController tabController;
  UploadMainImages({Key key, this.tabController}) : super(key: key);

  @override
  _UploadMainImagesState createState() => _UploadMainImagesState();
}

class _UploadMainImagesState extends State<UploadMainImages> {
  GlobalKey<FormState> _goodMainImageDetailKey = new GlobalKey<FormState>();
  ScrollController controller = ScrollController();
  Map<String, File> imageMap = Map();
  Map<String, String> imagePathMap = Map();
  final picker = ImagePicker();
  double rpx;

  @override
  void initState() {
    super.initState();

    imageMap.clear();
    if (LocalReleaseImages.getImagesMap().localImagesMap.isNotEmpty) {
      imageMap = LocalReleaseImages.getImagesMap().localImagesMap;
    }
  }

  @override
  Widget build(BuildContext context) {
    qiniuTokenTimer(context);
    rpx = MediaQuery.of(context).size.width / 750;

    return Stack(
      children: <Widget>[
        ListView(
          controller: controller,
          children: [
            _buildMainImageContainer(),
            _buildMainImageDesc(),
            _buildRotateImageContainer(),
            _buildNextToProductDetail(context)
          ],
        ),
      ],
    );
  }

  Widget _buildMainImageContainer() {
    String imageName = 'mainImage';
    return Container(
      height: 540 * rpx,
      width: 710 * rpx,
      alignment: Alignment(0, 0),
      margin: EdgeInsets.only(left: 10, top: 6, right: 10),
      decoration: new BoxDecoration(
        //背景
        color: Colors.white,
        //设置四周边框
        border: new Border.all(width: 1, color: Colors.grey),
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 40 * rpx,
            width: 710 * rpx,
            color: buttonColor,
            child: Text(
              '商品主图',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: InkWell(
                onTap: () {
                  _getImageByGallery(null, null, imageName);
                },
                child: imageMap[imageName] == null
                    ? IconButton(
                        icon: Icon(
                          Icons.add,
                          size: 50 * rpx,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          _getImageByGallery(null, null, imageName);
                        })
                    : Image.file(imageMap[imageName])),
          ),
        ],
      ),
    );
  }

  Widget _buildMainImageDesc() {
    final uploadGoodInfosProvide = context.read<UploadGoodInfosProvide>();
    FocusNode _focusNode = FocusNode();
    return Container(
        width: 710 * rpx,
        height: 150 * rpx,
        margin: EdgeInsets.only(left: 2, bottom: 2, right: 2),
        decoration: new BoxDecoration(
          //背景
          color: Colors.grey[100],
          //设置四周边框
          border: new Border.all(width: 1, color: Colors.grey),
        ),
        child: Form(
          key: _goodMainImageDetailKey,
          child: TextFormField(
            focusNode: _focusNode,
            minLines: 1,
            maxLines: 5,
            enabled: true,
            onSaved: (value) {
              uploadGoodInfosProvide.setUploadInfo('mainImageDesc', value);
            },
            validator: needStringCommonValid,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration.collapsed(
                hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey[400]),
                hintText: "主图描述信息（必填）"),
          ),
        ));
  }

  Widget _buildRotateImageContainer() {
    String keyType = 'rotateImages';
    String image1 = 'rotateImage1';
    String image2 = 'rotateImage2';
    String image3 = 'rotateImage3';
    String image4 = 'rotateImage4';

    return Container(
      height: 670 * rpx,
      width: 710 * rpx,
      alignment: Alignment(0, 0),
      margin: EdgeInsets.only(left: 10 * rpx, top: 10 * rpx, right: 10 * rpx),
      decoration: new BoxDecoration(
        //背景
        color: Colors.white,
        //设置四周边框
        border: new Border.all(width: 1, color: Colors.grey),
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 40 * rpx,
            width: 710 * rpx,
            color: buttonColor,
            child: Text(
              '商品轮播图',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  height: 290 * rpx,
                  width: 340 * rpx,
                  alignment: Alignment(0, 0),
                  margin: EdgeInsets.only(
                      left: 10 * rpx,
                      top: 10 * rpx,
                      right: 10 * rpx,
                      bottom: 10 * rpx),
                  decoration: new BoxDecoration(
                    //背景
                    color: Colors.white,
                    //设置四周边框
                    border: new Border.all(width: 1, color: Colors.grey),
                  ),
                  child: InkWell(
                    onTap: () {
                      _getImageByGallery(keyType, 1, image1);
                    },
                    child: imageMap[image1] == null
                        ? IconButton(
                            icon: Icon(
                              Icons.add,
                              size: 50 * rpx,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              _getImageByGallery(keyType, 1, image1);
                            })
                        : Image.file(imageMap[image1]),
                  ),
                ),
                Container(
                  height: 290 * rpx,
                  width: 340 * rpx,
                  alignment: Alignment(0, 0),
                  margin: EdgeInsets.only(
                      left: 10 * rpx,
                      top: 10 * rpx,
                      right: 10 * rpx,
                      bottom: 10 * rpx),
                  decoration: new BoxDecoration(
                    //背景
                    color: Colors.white,
                    //设置四周边框
                    border: new Border.all(width: 1, color: Colors.grey),
                  ),
                  child: Container(
                    child: InkWell(
                      onTap: () {
                        _getImageByGallery(keyType, 2, image2);
                      },
                      child: imageMap[image2] == null
                          ? IconButton(
                              icon: Icon(
                                Icons.add,
                                size: 50 * rpx,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                _getImageByGallery(keyType, 2, image2);
                              })
                          : Image.file(imageMap[image2]),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  height: 290 * rpx,
                  width: 340 * rpx,
                  alignment: Alignment(0, 0),
                  margin: EdgeInsets.only(
                      left: 10 * rpx,
                      top: 10 * rpx,
                      right: 10 * rpx,
                      bottom: 10 * rpx),
                  decoration: new BoxDecoration(
                    //背景
                    color: Colors.white,
                    //设置四周边框
                    border: new Border.all(width: 1, color: Colors.grey),
                  ),
                  child: InkWell(
                    onTap: () {
                      _getImageByGallery(keyType, 3, image3);
                    },
                    child: imageMap[image3] == null
                        ? IconButton(
                            icon: Icon(
                              Icons.add,
                              size: 50 * rpx,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              _getImageByGallery(keyType, 3, image3);
                            })
                        : Image.file(imageMap[image3]),
                  ),
                ),
                Container(
                  height: 290 * rpx,
                  width: 340 * rpx,
                  alignment: Alignment(0, 0),
                  margin: EdgeInsets.only(
                      left: 10 * rpx,
                      top: 10 * rpx,
                      right: 10 * rpx,
                      bottom: 10 * rpx),
                  decoration: new BoxDecoration(
                    //背景
                    color: Colors.white,
                    //设置四周边框
                    border: new Border.all(width: 1, color: Colors.grey),
                  ),
                  child: InkWell(
                    onTap: () {
                      _getImageByGallery(keyType, 4, image4);
                    },
                    child: imageMap[image4] == null
                        ? IconButton(
                            icon: Icon(
                              Icons.add,
                              size: 50 * rpx,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              _getImageByGallery(keyType, 4, image4);
                            })
                        : Image.file(imageMap[image4]),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future _getImageByGallery(keyType, number, imageName) async {
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

  Widget _buildNextToProductDetail(context) {
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
                      var _goodMainImageDetail =
                          _goodMainImageDetailKey.currentState;

                      if (_goodMainImageDetail.validate()) {
                        _goodMainImageDetail.save();
                        widget.tabController.animateTo(2);
                      }
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
