import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mstimes/utils/date_utils.dart';
import 'package:provider/provider.dart';
import 'package:mstimes/provide/upload_release_provide.dart';
import 'package:mstimes/utils/color_util.dart';
import 'package:mstimes/common/valid.dart';

class ReleaseGoodInfos extends StatefulWidget {
  TabController tabController;
  ReleaseGoodInfos({Key key, this.tabController}) : super(key: key);
  @override
  _ReleaseGoodInfosState createState() => _ReleaseGoodInfosState();
}

class _ReleaseGoodInfosState extends State<ReleaseGoodInfos> {
  GlobalKey<FormState> _goodTitleFormKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _priceFormKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _profitShareingFormKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _categoryFormKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _specifyFormKey = new GlobalKey<FormState>();

  double rpx;
  ScrollController controller = ScrollController();
  List<Widget> _categoryWidgets = List<Widget>();
  List<Widget> _specificsWidgets = List<Widget>();
  DateTime groupStartDate;
  var _selectGoodTypeValue;
  var _selectHotSaleValue;
  String categoryType = 'categorys';
  int categoryNumber = 0;
  String specificType = 'specifics';
  int specificNumber = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
            controller: controller,
            child: Column(
              children: [
                _buildTitleInfo(),
                _buildHotSaleType(),
                _buildProductType(),
                _buildPrice(),
                Divider(
                  color: Colors.grey[400],
                ),
                _buildProfitShare(),
                Divider(
                  color: Colors.grey[400],
                ),
                _showProductCategoryTitle(),
                _buildProductCategorys(),
                Divider(
                  color: Colors.grey[400],
                ),
                _showProductSpecificsTitle(),
                _buildProductSpecifics(),
                _showGroupStartDateTitle(),
                _buildGroupStartDate(),
                _buildNextBottom(),
              ],
            )),
      ],
    );
  }

  Widget _buildTitleInfo() {
    // final uploadGoodInfosProvide =
    //     Provide.value<UploadGoodInfosProvide>(context);
    final uploadGoodInfosProvide = context.read<UploadGoodInfosProvide>();
    return Container(
      child: Form(
        key: _goodTitleFormKey,
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(
                  left: 10 * rpx, top: 6 * rpx, right: 3 * rpx, bottom: 0),
              child: Text(
                '商品标题',
                style:
                    TextStyle(fontSize: 30 * rpx, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              width: 600 * rpx,
              height: 70 * rpx,
              margin: EdgeInsets.only(left: 3, top: 5, right: 3, bottom: 5),
              alignment: Alignment(0, 0),
              decoration: new BoxDecoration(
                //背景
                color: Colors.white,
                //设置四周边框
                border: new Border.all(width: 1, color: Colors.grey),
              ),
              child: TextFormField(
                maxLines: 1,
                enabled: true,
                onSaved: (value) {
                  uploadGoodInfosProvide.setUploadInfo('goodTitle', value);
                },
                validator: needStringCommonValid,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration.collapsed(
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.grey[400]),
                    hintText: "最多允许输入10个字符(必填)"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHotSaleType() {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(
              left: 10 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 0),
          child: Text(
            '售卖类型',
            style: TextStyle(fontSize: 30 * rpx, fontWeight: FontWeight.w500),
          ),
        ),
        _selectHotSaleType(),
      ],
    );
  }

  Widget _selectHotSaleType() {
    // final uploadGoodInfosProvide =
    //     Provide.value<UploadGoodInfosProvide>(context);
    final uploadGoodInfosProvide = context.read<UploadGoodInfosProvide>();
    return DropdownButton(
        value: _selectHotSaleValue,
        icon: Icon(Icons.arrow_right),
        iconSize: 40,
        iconEnabledColor: Colors.grey,
        hint: Text(
          '正常商品(默认)',
          style: TextStyle(color: Colors.black),
        ),
        isExpanded: true,
        underline: Container(height: 1, color: Colors.grey),
        items: [
          DropdownMenuItem(
              child: Row(children: <Widget>[
                Text('正常商品'),
                SizedBox(width: 6),
              ]),
              value: 0),
          DropdownMenuItem(
              child: Row(children: <Widget>[
                Text('热卖商品'),
                SizedBox(width: 6),
              ]),
              value: 1),
        ],
        onChanged: (value) => setState(() => {
              _selectHotSaleValue = value,
              uploadGoodInfosProvide.setUploadInfo('hotSale', value),
            }));
  }

  Widget _buildProductType() {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(
              left: 10 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 0),
          child: Text(
            '商品类型',
            style: TextStyle(fontSize: 30 * rpx, fontWeight: FontWeight.w500),
          ),
        ),
        _showDropdownList(),
      ],
    );
  }

  Widget _showDropdownList() {
    // final uploadGoodInfosProvide =
    //     Provide.value<UploadGoodInfosProvide>(context);

    final uploadGoodInfosProvide = context.read<UploadGoodInfosProvide>();
    return DropdownButton(
        value: _selectGoodTypeValue,
        icon: Icon(Icons.arrow_right),
        iconSize: 40,
        iconEnabledColor: Colors.grey,
        hint: Text('请选择商品类目'),
        isExpanded: true,
        underline: Container(height: 1, color: Colors.grey),
        items: [
          DropdownMenuItem(
              child: Row(children: <Widget>[
                Text('美妆'),
                SizedBox(width: 6),
              ]),
              value: 1),
          DropdownMenuItem(
              child: Row(children: <Widget>[
                Text('洗护'),
                SizedBox(width: 6),
              ]),
              value: 2),
          DropdownMenuItem(
              child: Row(children: <Widget>[
                Text('食品'),
                SizedBox(width: 6),
              ]),
              value: 3),
          DropdownMenuItem(
              child: Row(children: <Widget>[
                Text('家居百货'),
                SizedBox(width: 6),
              ]),
              value: 4),
          DropdownMenuItem(
              child: Row(children: <Widget>[
                Text('服装'),
                SizedBox(width: 6),
              ]),
              value: 5),
          DropdownMenuItem(
              child: Row(children: <Widget>[
                Text('配饰'),
                SizedBox(width: 6),
              ]),
              value: 6),
          DropdownMenuItem(
              child: Row(children: <Widget>[
                Text('箱包'),
                SizedBox(width: 6),
              ]),
              value: 7),
          DropdownMenuItem(
              child: Row(children: <Widget>[
                Text('内衣'),
                SizedBox(width: 6),
              ]),
              value: 8),
          DropdownMenuItem(
              child: Row(children: <Widget>[
                Text('鞋帽'),
                SizedBox(width: 6),
              ]),
              value: 9),
          DropdownMenuItem(
              child: Row(children: <Widget>[
                Text('家电'),
                SizedBox(width: 6),
              ]),
              value: 10),
          DropdownMenuItem(
              child: Row(children: <Widget>[
                Text('生鲜'),
                SizedBox(width: 6),
              ]),
              value: 11),
          DropdownMenuItem(
              child: Row(children: <Widget>[
                Text('运动'),
                SizedBox(width: 6),
              ]),
              value: 12),
          DropdownMenuItem(
              child: Row(children: <Widget>[
                Text('母婴'),
                SizedBox(width: 6),
              ]),
              value: 13),
          DropdownMenuItem(
              child: Row(children: <Widget>[
                Text('户外'),
                SizedBox(width: 6),
              ]),
              value: 14),
          DropdownMenuItem(
              child: Row(children: <Widget>[
                Text('家纺'),
                SizedBox(width: 6),
              ]),
              value: 15),
          DropdownMenuItem(
              child: Row(children: <Widget>[
                Text('数码'),
                SizedBox(width: 6),
              ]),
              value: 16),
          DropdownMenuItem(
              child: Row(children: <Widget>[
                Text('手机'),
                SizedBox(width: 6),
              ]),
              value: 17),
          DropdownMenuItem(
              child: Row(children: <Widget>[
                Text('其他'),
                SizedBox(width: 6),
              ]),
              value: 0)
        ],
        onChanged: (value) => setState(() => {
              _selectGoodTypeValue = value,
              uploadGoodInfosProvide.setUploadInfo('goodType', value),
            }));
  }

  Widget _buildPrice() {
    // final uploadGoodInfosProvide =
    //     Provide.value<UploadGoodInfosProvide>(context);
    final uploadGoodInfosProvide = context.read<UploadGoodInfosProvide>();
    return Container(
      margin: EdgeInsets.only(
          left: 10 * rpx, top: 8 * rpx, right: 10 * rpx, bottom: 5 * rpx),
      child: Form(
        key: _priceFormKey,
        child: Row(
          children: <Widget>[
            Container(
              child: Text(
                '特卖价格',
                style:
                    TextStyle(fontSize: 25 * rpx, fontWeight: FontWeight.w300),
              ),
            ),
            Container(
              width: 120 * rpx,
              height: 60 * rpx,
              margin: EdgeInsets.only(
                  left: 3 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 5 * rpx),
              alignment: Alignment(0, 0),
              decoration: new BoxDecoration(
                //背景
                color: Colors.white,
                //设置四周边框
                border: new Border.all(width: 1, color: Colors.grey),
              ),
              child: TextFormField(
                maxLines: 1,
                enabled: true,
                onSaved: (value) {
                  uploadGoodInfosProvide.setUploadInfo('groupPrice', value);
                },
                textInputAction: TextInputAction.done,
                validator: needStringCommonValid,
                decoration: InputDecoration.collapsed(
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.grey[400]),
                    hintText: ""),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20 * rpx),
              child: Text(
                '市场价格',
                style:
                    TextStyle(fontSize: 25 * rpx, fontWeight: FontWeight.w300),
              ),
            ),
            Container(
              width: 120 * rpx,
              height: 60 * rpx,
              margin: EdgeInsets.only(left: 3, top: 5, right: 3, bottom: 5),
              alignment: Alignment(0, 0),
              decoration: new BoxDecoration(
                //背景
                color: Colors.white,
                //设置四周边框
                border: new Border.all(width: 1, color: Colors.grey),
              ),
              child: TextFormField(
                maxLines: 1,
                enabled: true,
                onSaved: (value) {
                  uploadGoodInfosProvide.setUploadInfo('marketPrice', value);
                },
                validator: needStringCommonValid,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration.collapsed(
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.grey[400]),
                    hintText: ""),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20 * rpx),
              child: Text(
                '蜜豆数',
                style:
                    TextStyle(fontSize: 25 * rpx, fontWeight: FontWeight.w300),
              ),
            ),
            Container(
              width: 120 * rpx,
              height: 60 * rpx,
              margin: EdgeInsets.only(
                  left: 3 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 5 * rpx),
              alignment: Alignment(0, 0),
              decoration: new BoxDecoration(
                //背景
                color: Colors.white,
                //设置四周边框
                border: new Border.all(width: 1, color: Colors.grey),
              ),
              child: TextFormField(
                initialValue: '0',
                maxLines: 1,
                enabled: true,
                onSaved: (value) {
                  uploadGoodInfosProvide.setUploadInfo('beanCounts', value);
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration.collapsed(
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.grey[400]),
                    hintText: ""),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfitShare() {
    // final uploadGoodInfosProvide =
    //     Provide.value<UploadGoodInfosProvide>(context);
    final uploadGoodInfosProvide = context.read<UploadGoodInfosProvide>();

    return Container(
      margin: EdgeInsets.only(left: 3, top: 3, right: 10, bottom: 5),
      child: Form(
        key: _profitShareingFormKey,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(
                  left: 10 * rpx,
                  top: 3 * rpx,
                  right: 3 * rpx,
                  bottom: 3 * rpx),
              child: Text(
                '代理分润',
                style:
                    TextStyle(fontSize: 30 * rpx, fontWeight: FontWeight.w500),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  child: Text(
                    '同级差额',
                    style: TextStyle(
                        fontSize: 25 * rpx, fontWeight: FontWeight.w300),
                  ),
                ),
                Container(
                    width: 180 * rpx,
                    height: 50 * rpx,
                    margin: EdgeInsets.only(
                        left: 3 * rpx,
                        top: 5 * rpx,
                        right: 3 * rpx,
                        bottom: 5 * rpx),
                    alignment: Alignment(0, 0),
                    decoration: new BoxDecoration(
                      //背景
                      color: Colors.white,
                      //设置四周边框
                      border: new Border.all(width: 1, color: Colors.grey),
                    ),
                    child: TextFormField(
                      maxLines: 1,
                      enabled: true,
                      onSaved: (value) {
                        uploadGoodInfosProvide.setUploadInfo(
                            'equalLevelProfit', value);
                      },
                      validator: needStringCommonValid,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration.collapsed(
                          hintStyle: TextStyle(
                              fontSize: 15.0, color: Colors.grey[400]),
                          hintText: ""),
                    )),
                Container(
                  margin: EdgeInsets.only(left: 60 * rpx),
                  child: Text(
                    'M0差额',
                    style: TextStyle(
                        fontSize: 25 * rpx, fontWeight: FontWeight.w300),
                  ),
                ),
                Container(
                    width: 180 * rpx,
                    height: 50 * rpx,
                    margin: EdgeInsets.only(
                        left: 3 * rpx,
                        top: 5 * rpx,
                        right: 3 * rpx,
                        bottom: 5 * rpx),
                    alignment: Alignment(0, 0),
                    decoration: new BoxDecoration(
                      //背景
                      color: Colors.white,
                      //设置四周边框
                      border: new Border.all(width: 1, color: Colors.grey),
                    ),
                    child: TextFormField(
                      maxLines: 1,
                      enabled: true,
                      onSaved: (value) {
                        uploadGoodInfosProvide.setUploadInfo(
                            'zeroProfit', value);
                      },
                      validator: needStringCommonValid,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration.collapsed(
                          hintStyle: TextStyle(
                              fontSize: 15.0, color: Colors.grey[400]),
                          hintText: ""),
                    )),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: 5 * rpx,
                      top: 10 * rpx,
                      right: 3 * rpx,
                      bottom: 5 * rpx),
                  child: Text(
                    'M1差额',
                    style: TextStyle(
                        fontSize: 25 * rpx, fontWeight: FontWeight.w300),
                  ),
                ),
                Container(
                    width: 120 * rpx,
                    height: 50 * rpx,
                    margin: EdgeInsets.only(left: 5 * rpx),
                    alignment: Alignment(0, 0),
                    decoration: new BoxDecoration(
                      //背景
                      color: Colors.white,
                      //设置四周边框
                      border: new Border.all(width: 1, color: Colors.grey),
                    ),
                    child: TextFormField(
                      maxLines: 1,
                      enabled: true,
                      onSaved: (value) {
                        uploadGoodInfosProvide.setUploadInfo(
                            'firstProfit', value);
                      },
                      validator: needStringCommonValid,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration.collapsed(
                          hintStyle: TextStyle(
                              fontSize: 15.0, color: Colors.grey[400]),
                          hintText: ""),
                    )),
                Container(
                  margin: EdgeInsets.only(left: 20 * rpx),
                  child: Text(
                    'M2差额',
                    style: TextStyle(
                        fontSize: 25 * rpx, fontWeight: FontWeight.w300),
                  ),
                ),
                Container(
                    width: 120 * rpx,
                    height: 50 * rpx,
                    margin:
                        EdgeInsets.only(left: 3, top: 10, right: 3, bottom: 5),
                    alignment: Alignment(0, 0),
                    decoration: new BoxDecoration(
                      //背景
                      color: Colors.white,
                      //设置四周边框
                      border: new Border.all(width: 1, color: Colors.grey),
                    ),
                    child: TextFormField(
                      maxLines: 1,
                      enabled: true,
                      onSaved: (value) {
                        uploadGoodInfosProvide.setUploadInfo(
                            'secondProfit', value);
                      },
                      validator: needStringCommonValid,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration.collapsed(
                          hintStyle: TextStyle(
                              fontSize: 15.0, color: Colors.grey[400]),
                          hintText: ""),
                    )),
                Container(
                  margin: EdgeInsets.only(left: 20 * rpx),
                  child: Text(
                    'M3差额',
                    style: TextStyle(
                        fontSize: 25 * rpx, fontWeight: FontWeight.w300),
                  ),
                ),
                Container(
                    width: 120 * rpx,
                    height: 50 * rpx,
                    margin:
                        EdgeInsets.only(left: 3, top: 10, right: 3, bottom: 5),
                    alignment: Alignment(0, 0),
                    decoration: new BoxDecoration(
                      //背景
                      color: Colors.white,
                      //设置四周边框
                      border: new Border.all(width: 1, color: Colors.grey),
                    ),
                    child: TextFormField(
                      initialValue: '0',
                      maxLines: 1,
                      enabled: true,
                      onSaved: (value) {
                        uploadGoodInfosProvide.setUploadInfo(
                            'thirdProfit', value);
                      },
                      validator: needStringCommonValid,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration.collapsed(
                          hintStyle: TextStyle(
                              fontSize: 15.0, color: Colors.grey[400]),
                          hintText: ""),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _showProductCategoryTitle() {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 5, top: 5, right: 3, bottom: 5),
              child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                        left: 10 * rpx,
                        top: 5 * rpx,
                        right: 3 * rpx,
                        bottom: 0),
                    child: Text(
                      '种类',
                      style: TextStyle(
                          fontSize: 30 * rpx, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5.0, left: 20, bottom: 5),
                    width: 60,
                    height: 25,
                    color: Colors.white,
                    child: Container(
                      child: OutlineButton(
                          borderSide: new BorderSide(color: mainColor),
                          onPressed: () {
                            setState(() {
                              _categoryWidgets.add(_buildCategoryContainter());
                            });
                          },
                          child: Text(
                            '添加',
                            style: TextStyle(color: mainColor, fontSize: 14.0),
                          )),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildProductCategorys() {
    if (_categoryWidgets.length == 0) {
      print('_categoryWidgets.length == 0');
      _categoryWidgets.add(_buildCategoryContainter());
    }
    return Form(
        key: _categoryFormKey,
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: _categoryWidgets,
        ));
  }

  Widget _buildCategoryContainter() {
    // final uploadGoodInfosProvide =
    //     Provide.value<UploadGoodInfosProvide>(context);
    final uploadGoodInfosProvide = context.read<UploadGoodInfosProvide>();
    return Container(
      margin: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 0),
      child: Row(
        children: <Widget>[
          Container(
            width: 200 * rpx,
            height: 60 * rpx,
            margin: EdgeInsets.only(left: 3, top: 5, right: 3, bottom: 5),
            alignment: Alignment(0, 0),
            decoration: new BoxDecoration(
              //背景
              color: Colors.white,
              //设置四周边框
              border: new Border.all(width: 1, color: Colors.grey),
            ),
            child: TextFormField(
              minLines: 1,
              maxLines: 2,
              enabled: true,
              onSaved: (value) {
                uploadGoodInfosProvide.setUploadMapInfo(
                    categoryType, categoryNumber++, value);
              },
              textInputAction: TextInputAction.done,
              validator: needStringCommonValid,
              decoration: InputDecoration.collapsed(
                  hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey[400]),
                  hintText: ""),
            ),
          ),
          Expanded(child: Container()),
          Container(
              width: 200 * rpx,
              height: 60 * rpx,
              margin: EdgeInsets.only(left: 3, top: 5, right: 3, bottom: 5),
              alignment: Alignment(0, 0),
              decoration: new BoxDecoration(
                //背景
                color: Colors.white,
                //设置四周边框
                border: new Border.all(width: 1, color: Colors.grey),
              ),
              child: TextFormField(
                maxLines: 1,
                enabled: true,
                onSaved: (value) {
                  if (value.isNotEmpty) {
                    uploadGoodInfosProvide.setUploadMapInfo(
                        categoryType, categoryNumber++, value);
                  }
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration.collapsed(
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.grey[400]),
                    hintText: ""),
              ))
        ],
      ),
    );
  }

  Widget _buildSpecificContainter() {
    // final uploadGoodInfosProvide =
    //     Provide.value<UploadGoodInfosProvide>(context);
    final uploadGoodInfosProvide = context.read<UploadGoodInfosProvide>();

    return Container(
      margin: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 0),
      child: Row(
        children: <Widget>[
          Container(
            width: 200 * rpx,
            height: 60 * rpx,
            margin: EdgeInsets.only(left: 3, top: 5, right: 3, bottom: 5),
            alignment: Alignment(0, 0),
            decoration: new BoxDecoration(
              //背景
              color: Colors.white,
              //设置四周边框
              border: new Border.all(width: 1, color: Colors.grey),
            ),
            child: TextFormField(
              maxLines: 1,
              enabled: true,
              onSaved: (value) {
                uploadGoodInfosProvide.setUploadMapInfo(
                    specificType, specificNumber++, value);
              },
              validator: needStringCommonValid,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration.collapsed(
                  hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey[400]),
                  hintText: ""),
            ),
          ),
          Expanded(child: Container()),
          Container(
              width: 200 * rpx,
              height: 60 * rpx,
              margin: EdgeInsets.only(left: 3, top: 5, right: 3, bottom: 5),
              alignment: Alignment(0, 0),
              decoration: new BoxDecoration(
                //背景
                color: Colors.white,
                //设置四周边框
                border: new Border.all(width: 1, color: Colors.grey),
              ),
              child: TextFormField(
                minLines: 1,
                maxLines: 2,
                enabled: true,
                onSaved: (value) {
                  if (value.isNotEmpty) {
                    uploadGoodInfosProvide.setUploadMapInfo(
                        specificType, specificNumber++, value);
                  }
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration.collapsed(
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.grey[400]),
                    hintText: ""),
              ))
        ],
      ),
    );
  }

  Widget _showProductSpecificsTitle() {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 5, top: 5, right: 3, bottom: 0),
              child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                        left: 10 * rpx,
                        top: 5 * rpx,
                        right: 3 * rpx,
                        bottom: 5 * rpx),
                    child: Text(
                      '规格',
                      style: TextStyle(
                          fontSize: 30 * rpx, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 5.0 * rpx, left: 20 * rpx, bottom: 5 * rpx),
                    width: 60,
                    height: 25,
                    color: Colors.white,
                    child: Container(
                      child: OutlineButton(
                          borderSide: new BorderSide(color: mainColor),
                          onPressed: () {
                            setState(() {
                              _specificsWidgets.add(_buildSpecificContainter());
                            });
                          },
                          child: Text(
                            '添加',
                            style: TextStyle(color: mainColor, fontSize: 14.0),
                          )),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildProductSpecifics() {
    if (_specificsWidgets.length == 0) {
      _specificsWidgets.add(_buildSpecificContainter());
    }
    return Form(
      key: _specifyFormKey,
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: _specificsWidgets,
      ),
    );
  }

  Widget _showGroupStartDateTitle() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
          left: 15 * rpx, top: 5 * rpx, right: 3 * rpx, bottom: 0),
      child: Text(
        '上架日期',
        style: TextStyle(fontSize: 30 * rpx, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildGroupStartDate() {
    // final uploadGoodInfosProvide =
    //     Provide.value<UploadGoodInfosProvide>(context);
    final uploadGoodInfosProvide = context.read<UploadGoodInfosProvide>();

    return Container(
      height: 70 * rpx,
      width: 680 * rpx,
      margin: EdgeInsets.only(top: 5 * rpx, bottom: 10 * rpx),
      child: RaisedButton(
        child: Text(
          groupStartDate == null
              ? '请选择上架日期'
              // : DateFormat("yyyy-MM-dd").format(groupStartDate),
          : formatDate(groupStartDate, ymdFormat),
          style: TextStyle(color: Colors.grey[500], fontSize: 13),
        ),
        color: Colors.white,
        onPressed: () async {
          var result = await showDatePicker(
              builder: (context, child) {
                return Theme(
                  data: ThemeData.dark(),
                  child: child,
                );
              },
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030));
          setState(() {
            groupStartDate = result;
          });
          uploadGoodInfosProvide.setUploadInfo(
              'groupStartDate', groupStartDate.toString());
        },
      ),
    );
  }

  Widget _buildNextBottom() {
    return Container(
        padding: EdgeInsets.only(left: 0, right: 0, top: 6, bottom: 10),
        width: 750 * rpx,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                InkWell(
                    onTap: () {
                      var _goodTitleForm = _goodTitleFormKey.currentState;
                      var _priceForm = _priceFormKey.currentState;
                      var _profitShareingForm =
                          _profitShareingFormKey.currentState;
                      var _categoryForm = _categoryFormKey.currentState;
                      var _specifyForm = _specifyFormKey.currentState;

                      if (_goodTitleForm.validate() &&
                          _priceForm.validate() &&
                          _profitShareingForm.validate() &&
                          _categoryForm.validate() &&
                          _specifyForm.validate()) {
                        //
                        // 先清空keytype再保存
                        context.read<UploadGoodInfosProvide>().clearByKeytype(categoryType);
                        context.read<UploadGoodInfosProvide>().clearByKeytype(specificType);

                        _goodTitleForm.save();
                        _priceForm.save();
                        _profitShareingForm.save();
                        _categoryForm.save();
                        _specifyForm.save();

                        widget.tabController.animateTo(1);
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
