import 'package:flutter/material.dart';
import 'package:mstimes/common/control.dart';

class GoodSelectBottomProvide with ChangeNotifier {
  int _typeIndex = 1;
  Map<int, Map> typeValueKV = Map();
  Map<int, Map> typeNumChangeKV = Map();

  int _value;
  bool _fromOrderInfo = false;
  int _typeSpecNums = 0;
  int _currentReceiverIndex = 1;

  int get typeIndex => _typeIndex;
  int get value => _value;
  bool get fromOrderInfo => _fromOrderInfo;
  int get typeSpecNums => _typeSpecNums;
  int get currentReceiverIndex => _currentReceiverIndex;

  GoodSelectBottomProvide(this._value, this._typeIndex);

  void resetCurrentReceiverIndex(int receiverIndex) {
    this._currentReceiverIndex = receiverIndex;
  }

  void setFromOrderInfo(bool enable) {
    this._fromOrderInfo = enable;
  }

  void updateTypeIndex(typeIndex) {
    this._typeIndex = typeIndex;
  }

  void initValueByIndex(int receiverIndex) {
    Map initTypeValueMap = {1: 1};
    Map initTypeNumChangeMap = {
      1: {0: 1},
    };
    typeValueKV[receiverIndex - 1] = initTypeValueMap;
    typeNumChangeKV[receiverIndex - 1] = initTypeNumChangeMap;
  }

  Map queryTypeValueMap() {
    if (debug) {
      print(
          'GoodTypeBadgerProvide, queryTypeValueMap() _currentReceiverIndex : ' +
              _currentReceiverIndex.toString());
    }

    if (typeValueKV[_currentReceiverIndex - 1] == null) {
      return Map();
    }
    return typeValueKV[_currentReceiverIndex - 1];
  }

  Map queryTypeNumChangeMap() {
    if (typeNumChangeKV[_currentReceiverIndex - 1] == null) {
      return Map();
    }
    return typeNumChangeKV[_currentReceiverIndex - 1];
  }

  String getCurrentTypeNumberChangeSize(
      currentReceiverNum, typeIndex, specIndex) {
    if (typeValueKV.isEmpty ||
        typeNumChangeKV[currentReceiverNum - 1] == null ||
        typeNumChangeKV[currentReceiverNum - 1][typeIndex] == null ||
        typeNumChangeKV[currentReceiverNum - 1][typeIndex][specIndex] == null) {
      return '0';
    }

    // print('getCurrentTypeNumberChangeSize _currentReceiverIndex : ' +
    //     currentReceiverNum.toString() +
    //     ", _typeIndex : " +
    //     typeIndex.toString() +
    //     ", index : " +
    //     specIndex.toString());
    int val = typeNumChangeKV[currentReceiverNum - 1][typeIndex][specIndex];
    // print('getCurrentTypeNumberChangeSize, val: ' +
    //     val.toString() +
    //     ",index: " +
    //     specIndex.toString());
    return val.toString();
  }

  void increment(index) {
    Map typeValueMap;
    Map typeNumChangeMap;
    if (typeValueKV[_currentReceiverIndex - 1] == null) {
      typeValueMap = Map();
      typeNumChangeMap = Map();
      typeValueKV[_currentReceiverIndex - 1] = typeValueMap;
      typeNumChangeKV[_currentReceiverIndex - 1] = typeNumChangeMap;
      print('[Debug] increment typeValueKV[_currentReceiverIndex] == null');
    } else {
      typeValueMap = typeValueKV[_currentReceiverIndex - 1];
      typeNumChangeMap = typeNumChangeKV[_currentReceiverIndex - 1];
    }

    print('[Debug] increment typeValueMap : ' + typeValueMap.toString());
    var indexVal = typeValueMap[_typeIndex];
    if (indexVal == null) {
      indexVal = 0;
    }
    _value = indexVal;
    typeValueMap[_typeIndex] = ++_value;

    var changeNumberKV = typeNumChangeMap[_typeIndex];
    var changeNum;
    if (changeNumberKV == null) {
      typeNumChangeMap[_typeIndex] = {index: 1};
      _typeSpecNums++;
    } else {
      changeNum = typeNumChangeMap[_typeIndex][index];
      if (changeNum == null) {
        changeNum = 0;
      }
      typeNumChangeMap[_typeIndex][index] = ++changeNum;
      _typeSpecNums++;
    }
    notifyListeners();
  }

  void decrease(index) {
    if (typeValueKV[_currentReceiverIndex - 1] == null) {
      return;
    }

    var changeNumberKV = typeNumChangeKV[_currentReceiverIndex - 1][_typeIndex];
    var changeNum;
    print('_typeIndex >>>>> ' + _typeIndex.toString());
    if (changeNumberKV == null) {
      typeNumChangeKV[_currentReceiverIndex - 1][_typeIndex] = {index: 0};
      _typeSpecNums--;
    } else {
      changeNum = typeNumChangeKV[_currentReceiverIndex - 1][_typeIndex][index];
      if (changeNum == null || changeNum < 1) {
        typeNumChangeKV[_currentReceiverIndex - 1][_typeIndex][index] = 0;
        return;
      }
      print(
          'typeNumChangeMap.[_typeIndex][index] >>>>> ' + changeNum.toString());
      typeNumChangeKV[_currentReceiverIndex - 1][_typeIndex][index] =
          --changeNum;
      _typeSpecNums--;
    }

    var indexVal = typeValueKV[_currentReceiverIndex - 1][_typeIndex];
    print('indexVal >>>>> ' + indexVal.toString());
    if (indexVal == null || indexVal == 0) {
      return;
    }
    _value = --indexVal;
    typeValueKV[_currentReceiverIndex - 1][_typeIndex] = _value;

    notifyListeners();
  }

  void clear() {
    typeValueKV = {};
    typeNumChangeKV = {};
    _typeIndex = 1;
    _fromOrderInfo = false;
    _currentReceiverIndex = 1;
    _typeSpecNums = 0;
  }
}
