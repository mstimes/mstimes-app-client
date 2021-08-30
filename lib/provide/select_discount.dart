import 'package:flutter/material.dart';

class SelectDiscountProvide with ChangeNotifier{

  int selectedIndex = -1;
  Map selectedCoupon;

  int selectedIndexTmp = -1;
  Map selectedCouponTmp;

  void setSelectCoupon(index, coupon){
    this.selectedIndexTmp = index;
    this.selectedCouponTmp = coupon;
  }

  void enable(){
    this.selectedIndex = this.selectedIndexTmp;
    this.selectedCoupon = this.selectedCouponTmp;
    notifyListeners();
  }

  void clear(){
    this.selectedIndex = -1;
    this.selectedCoupon = null;
    notifyListeners();
  }

}