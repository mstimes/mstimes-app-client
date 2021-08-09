import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 直接通过`类名称`访问里面的方法，方法为 静态方法
class ScreenAdaper {
  static init(context) {
    /// 设计稿 --- 宽/高
    // ScreenUtil.init();
    // ScreenUtil.init(width: 750, height: 1334);
    // ScreenUtil.init(width: 750, height: 1334, allowFontScaling: true);
  }

  static sp(double value) {
    return ScreenUtil().setSp(value, allowFontScalingSelf: true);

    /// 获取 计算后的字体
  }

  static height(double value) {
    return ScreenUtil().setHeight(value);

    /// 获取 计算后的高度
  }

  static width(double value) {
    return ScreenUtil().setWidth(value);

    /// 获取 计算后的宽度
  }

  static screenHeight() {
    // return ScreenUtil.screenHeight;

    /// 获取 计算后的屏幕高度
  }

  static screenWidth() {
    // return ScreenUtil.screenWidth;

    /// 获取 计算后的屏幕高度
  }
}
