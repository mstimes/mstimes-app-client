import 'package:flutter/material.dart';

class OrderInfoAddReciverProvide with ChangeNotifier {
  bool _add = false;
  int _receiverCounts = 0;
  int _deleteIndex = -1;
  int _currentSelectReceiverIndex = 1;

  // [{1: {0: 3}}, {1: {0: 1}, 2: {0: 2}, 3: {0: 3}}]
  // 外层说明：[收件人1, 收件人2]
  // 内层说明：[{type: {specific: num}}]
  List<Map> _receiverOrderInfos = List();
  List<Map> _receiverSelectTypeNumInfos = List();
  List<Widget> _showReceiverOrderSelect = List();

  bool get add => _add;
  int get receiverCounts => _receiverCounts;
  List get receiverOrderInfos => _receiverOrderInfos;
  List get showReceiverOrderSelect => _showReceiverOrderSelect;
  List get receiverSelectTypeNumInfos => _receiverSelectTypeNumInfos;
  int get deleteIndex => _deleteIndex;
  int get currentSelectReceiverIndex => _currentSelectReceiverIndex;

  OrderInfoAddReciverProvide();

  void resetCurrentSelectIndex(int index) {
    this._currentSelectReceiverIndex = index;
  }

  void incrementReceiverCounts() {
    _receiverCounts++;
  }

  void deleteReceiverInfo(int deleteIndex) {
    this._deleteIndex = deleteIndex;
    notifyListeners();
  }

  void resetDeleteIndex(int deleteIndex) {
    this._deleteIndex = deleteIndex;
    notifyListeners();
  }

  void addReceiverOrderSelectInfo(Map typeValueMap, Map typeSelectMap) {
    if (_receiverOrderInfos.isEmpty) {
      _receiverOrderInfos.add(typeValueMap);
      _receiverSelectTypeNumInfos.add(typeSelectMap);
    } else {
      _receiverOrderInfos[_currentSelectReceiverIndex - 1] = typeValueMap;
      _receiverSelectTypeNumInfos[_currentSelectReceiverIndex - 1] =
          typeSelectMap;
    }
    // print(
    //     '[OrderInfoAddReciverProvide] addReceiverOrderSelectInfo _receiverOrderInfos : ' +
    //         _receiverOrderInfos.toString());
    notifyListeners();
  }

  void initAddReceiverOrderSelectInfo() {
    Map initTypeValueMap = {
      1: {0: 1}
    };
    Map initSelectTypeNumMap = {1: 1};
    _receiverOrderInfos.add(initTypeValueMap);
    _receiverSelectTypeNumInfos.add(initSelectTypeNumMap);
    // print(
    //     '[OrderInfoAddReciverProvide] initAddReceiverOrderSelectInfo , _receiverOrderInfos : ' +
    //         _receiverOrderInfos.toString());
  }

  List<Widget> getOrderSelectInfos() {
    // print(
    //     'order_info_add:getOrderSelectInfos,' + receiverOrderInfos.toString());
    receiverOrderInfos.forEach((element) {
      element.keys.forEach((typeIndex) {
        element[typeIndex].keys.forEach((specIndex) {
          showReceiverOrderSelect.add(Container(
              child: Row(
            children: <Widget>[
              Container(
                child: Text(
                  typeIndex.toString() +
                      "->" +
                      element[typeIndex][specIndex].toString(),
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          )));
        });
      });
    });
    return showReceiverOrderSelect;
  }

  void enableAddReciver(bool enable) {
    this._add = enable;
  }

  void addReciverInfo() {
    this._add = true;
    notifyListeners();
  }

  void clear() {
    _receiverOrderInfos.clear();
    _receiverSelectTypeNumInfos.clear();
    _showReceiverOrderSelect.clear();
    _receiverCounts = 0;
    _currentSelectReceiverIndex = 1;
  }
}
