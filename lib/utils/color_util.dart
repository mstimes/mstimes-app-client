import 'package:flutter/material.dart';

class ColorUtil {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    var color = int.parse(buffer.toString(), radix: 16);
    print('color' + color.toString());
    return Color(color);
  }
}

int deepGreen = 0xFF33A7A9;
int lightOrange = 0xFFEE705B;
int darkYellow = 0xFFEEA93A;
int deepYellow = 0xFFDB9666;
int orangeYellow = 0xFFFF5E00;
int orange = 0xFFFE942F;
int lightGreen = 0xFF33A7A9;
int lightGreen_200 = 0xFF7EA8A9;
int smogBlue = 0xFF5B82A3;
int darkGrey = 0xFF5D656D;
int lightGrey = 0xFF708BA3;
int lightBlue = 0xFF8997A3;
// int mainRed = 0xFFC8102E;
// String mainRed = '#DC1915';
// String mainRed = '#DD0125';
String mainRed = '#C8012E';
String bigRed = '#8F0A00';
String deepRed = '#541E1B';
String coffee = '#6A4E5A';
String black = '#1C1C1C';
String deepYellow2 = '#F6CBA8';
const String vipBlack = '#222222';
const String platinum = '#54565A';
const String silver = '#76777A';
// const String silver = '#bfbfbf';
// const String silver = '#8a8a8a';
const String yellow1 = '#C3AF82';

// Color mainColor = Color(lightGreen);
Color mainColor = ColorUtil.fromHex(mainRed);
Color homeBackgroundColor = ColorUtil.fromHex(bigRed);
Color backgroundFontColor = ColorUtil.fromHex(deepYellow2);
// Color backgroundFontColor = Colors.white;
Color goodsFontColor = ColorUtil.fromHex(deepRed);
Color blackColor9 = ColorUtil.fromHex(vipBlack);
Color platinumColor = ColorUtil.fromHex(platinum);
Color silverColor = ColorUtil.fromHex(silver);
// Color tabBarColor = Colors.amber[900];
//Color buttonColor = Color(lightGrey);
Color coffeeColor = ColorUtil.fromHex(coffee);
Color buttonColor = Colors.black;
Color yellowColor1 = ColorUtil.fromHex(yellow1);

// Color priceContainerColor = Color(lightGrey);
// Color priceAndShoppingCartColor = Color(lightGrey);
Color priceContainerColor = ColorUtil.fromHex(coffee);
Color priceAndShoppingCartColor = ColorUtil.fromHex(coffee);
// Color priceColor = Color(smogBlue);
Color priceColor = Colors.white;
// Color backgroudColor = Color(lightGreen_200);
// Color backgroudColor = Color(0xFFE798A0);
Color backgroudColor = ColorUtil.fromHex('#D0C3C0');
Color myIncomeColor = ColorUtil.fromHex(coffee);
Color incomeColor = Colors.black;
