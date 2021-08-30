import 'package:flutter/material.dart';
import 'package:mstimes/provide/select_discount.dart';
import 'package:mstimes/tools/common_container.dart';
import 'package:mstimes/utils/color_util.dart';
import 'package:provide/provide.dart';


class CouponSelectItemPage extends StatefulWidget {
  final List<Map> couponList;
  final int selectedIndex;

  const CouponSelectItemPage({Key key, this.pCtx, @required this.couponList, @required this.selectedIndex})
      : super(key: key);
  final BuildContext pCtx;

  @override
  _CouponSelectItemPageState createState() => _CouponSelectItemPageState();
}


class _CouponSelectItemPageState extends State<CouponSelectItemPage> {
  ScrollController controller = ScrollController();
  double rpx;
  int enableCheckBoxIndex = -1;
  bool selectUnused = false;

  @override
  void initState() {
    enableCheckBoxIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;

    return SingleChildScrollView(
      controller: controller,
      child: Column(
        children:[
          _buildCouponsTop(),
          _buildUnuseCouponContainer(),
          _genCouponList(),
          _buildCouponsBottom()
        ],
      ),
    );
  }

  Widget _buildCouponsTop(){
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 50 * rpx),
          child: Text('可用优惠券 ( ' + widget.couponList.length.toString() + ' )'
          , style: TextStyle(fontSize: 26 * rpx, fontWeight: FontWeight.w400),),
        ),
        Expanded(child: Container()),
        Container(
          margin: EdgeInsets.only(right: 30 * rpx, top: 20 * rpx),
            width: 100 * rpx,
            height: 80 * rpx,
            child: IconButton(
                alignment: Alignment.topCenter,
                icon: Icon(
                  Icons.close,
                  color: Color(0xff666666),
                  size: 50 * rpx,
                ),
                onPressed: () {
                  Navigator.pop(context);
                })),
      ],
    );
  }

  Widget _buildCouponsBottom(){
    final selectDiscountProvide =
    Provide.value<SelectDiscountProvide>(context);

    return InkWell(
      onTap: (){
        if(!selectUnused){
          selectDiscountProvide.enable();
        }
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.only(top: 30 * rpx, bottom: 60 * rpx),
        child: buildSingleSummitButton('确认', 600, 80, 10, rpx),
      ),
    );
  }

  Widget _buildUnuseCouponContainer(){
    final selectDiscountProvide =
    Provide.value<SelectDiscountProvide>(context);

    return InkWell(
      onTap: (){
        setState(() {
          enableCheckBoxIndex = -1;
          selectUnused = true;
          selectDiscountProvide.clear();
        });
      },
      child: Container(
        margin: EdgeInsets.only(top: 10 * rpx, bottom: 10 * rpx, left: 50 * rpx),
        child: Row(
          children: [
            buildCheckBox(-1),
            Container(
              alignment: Alignment.center,
              child: Text('不使用优惠券', style: TextStyle(
                  fontSize: 30 * rpx,
                  fontWeight: FontWeight.w600,
                  color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _genCouponList() {
    final selectDiscountProvide =
    Provide.value<SelectDiscountProvide>(context);

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(left: 15 * rpx, top: 20 * rpx),
      controller: controller,
      itemCount: widget.couponList.length,
      itemBuilder: (context, index) {
        return Container(
          height: 240 * rpx,
          margin: EdgeInsets.only(left: 5 * rpx, right: 10 * rpx, bottom: 10 * rpx),
          padding: EdgeInsets.only(top: 30 * rpx),
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            border: new Border.all(width: 1, color: Colors.black26),
          ),
          child: InkWell(
            onTap: (){
              setState(() {
                enableCheckBoxIndex = index;
                selectDiscountProvide.setSelectCoupon(index, widget.couponList[index]);
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    // width: 240 * rpx,
                    // height: 100 * rpx,
                    margin: EdgeInsets.only(left: 20 * rpx, right: 10 * rpx, bottom: 10 * rpx),
                    child: Row(
                      children: [
                        buildCheckBox(index),
                        Container(
                          margin: EdgeInsets.only(left: 20 * rpx, top: 10 * rpx),
                          child: Text(
                            '¥ ',
                            style: TextStyle(
                                fontSize: 40 * rpx,
                                fontWeight: FontWeight.w300,
                                color:
                                Colors.black),
                          ),
                        ),
                        Container(
                          child: Text(
                            widget.couponList[index]['discountCoupon'].toString(),
                            style: TextStyle(
                                fontSize: 100 * rpx,
                                fontWeight: FontWeight.w300,
                                color:
                                Colors.black),
                          ),
                        )
                      ],
                    )),
                Expanded(child: Container()),
                Container(
                  margin: EdgeInsets.only(right: 80 * rpx, bottom: 10 * rpx),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          widget.couponList[index]['couponCategory'].toString(),
                          style: TextStyle(
                              fontSize: 23 * rpx,
                              fontWeight: FontWeight.w400,
                              color:
                              yellowColor1),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15 * rpx),
                        child: Row(children: [
                          Container(
                            child: Text(
                              '优惠码 ',
                              style: TextStyle(
                                  fontSize: 30 * rpx,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                          Container(
                            child: Text(
                              widget.couponList[index]['couponCode'].toString(),
                              style: TextStyle(
                                  fontSize: 30 * rpx,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                        ]),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 18 * rpx),
                        child: Text(
                          widget.couponList[index]['validDate'].toString(),
                          style: TextStyle(
                              fontSize: 23 * rpx,
                              fontWeight: FontWeight.w300,
                              color:
                              Colors.black),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 18 * rpx),
                        child: Text(
                          widget.couponList[index]['useRule'].toString(),
                          style: TextStyle(
                              fontSize: 23 * rpx,
                              fontWeight: FontWeight.w300,
                              color:
                              Colors.black),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildCheckBox(index){
    if(index == enableCheckBoxIndex){
      return Container(
            margin: EdgeInsets.only(left: 10 * rpx, right: 10 * rpx),
            child: ClipOval(
                child: Image.asset(
                  "lib/images/circle_right.png",
                  height: 30 * rpx,
                  width: 30 * rpx,
                )
            ),
      );
    }else {
      return Container(
            margin: EdgeInsets.only(left: 10 * rpx, right: 10 * rpx),
            child: ClipOval(
                child: Image.asset(
                  "lib/images/circle.png",
                  height: 30 * rpx,
                  width: 30 * rpx,
                )
            ),
      );
    }
  }
}