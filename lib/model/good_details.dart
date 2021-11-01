class GoodDetailModel {
  bool success;
  int code;
  String msg;
  List<DataList> dataList;
  int pageCount;
  int pageSize;
  int pageTotalCount;
  bool pageHasMoreData;

  GoodDetailModel(
      {this.success,
      this.code,
      this.msg,
      this.dataList,
      this.pageCount,
      this.pageSize,
      this.pageTotalCount,
      this.pageHasMoreData});

  GoodDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    if (json['dataList'] != null) {
      dataList = new List<DataList>();
      json['dataList'].forEach((v) {
        dataList.add(new DataList.fromJson(v));
      });
    }
    pageCount = json['pageCount'];
    pageSize = json['pageSize'];
    pageTotalCount = json['pageTotalCount'];
    pageHasMoreData = json['pageHasMoreData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.dataList != null) {
      data['dataList'] = this.dataList.map((v) => v.toJson()).toList();
    }
    data['pageCount'] = this.pageCount;
    data['pageSize'] = this.pageSize;
    data['pageTotalCount'] = this.pageTotalCount;
    data['pageHasMoreData'] = this.pageHasMoreData;
    return data;
  }
}

class DataList {
  int goodId;
  String title;
  String description;
  String oriPrice;
  String groupPrice;
  int beans;
  int groupNum;
  String mainImage;
  List<String> detailImages;
  List<String> rotateImages;
  String categories;
  String specifics;
  int hotSale;
  String hotSaleImage;
  String brand;
  String goodName;
  String material;
  String component;
  String productionDate;
  String expirationDate;
  String guaranteePeriod;
  String productionPlace;
  String shippingInfo;
  String unShippingInfo;
  String shippingTimeLimit;
  String afterSales;
  String equalLevelProfit;
  String zeroProfit;
  String firstProfit;
  String secondProfit;
  String thirdProfit;
  int saleOut;
  int diffType;
  String diffPriceInfo;
  Map diffPriceInfoMap;

  DataList(
      {this.goodId,
      this.title,
      this.description,
      this.oriPrice,
      this.groupPrice,
      this.beans,
      this.groupNum,
      this.mainImage,
      this.detailImages,
      this.rotateImages,
      this.categories,
      this.specifics,
      this.hotSale,
      this.hotSaleImage,
      this.brand,
      this.goodName,
      this.material,
      this.component,
      this.productionDate,
      this.expirationDate,
      this.guaranteePeriod,
      this.productionPlace,
      this.shippingInfo,
      this.unShippingInfo,
      this.shippingTimeLimit,
      this.afterSales,
      this.equalLevelProfit,
      this.zeroProfit,
      this.firstProfit,
      this.secondProfit,
      this.thirdProfit,
      this.saleOut,
      this.diffType,
      this.diffPriceInfo});

  DataList.fromJson(Map<String, dynamic> json) {
    goodId = json['goodId'];
    title = json['title'];
    description = json['description'];
    oriPrice = json['oriPrice'];
    groupPrice = json['groupPrice'];
    beans = json['beans'];
    groupNum = json['groupNum'];
    mainImage = json['mainImage'];
    detailImages = json['detailImages'].cast<String>();
    rotateImages = json['rotateImages'].cast<String>();
    categories = json['categories'];
    specifics = json['specifics'];
    hotSale = json['hotSale'];
    hotSaleImage = json['hotSaleImage'];
    brand = json['brand'];
    goodName = json['goodName'];
    material = json['material'];
    component = json['component'];
    productionDate = json['productionDate'];
    expirationDate = json['expirationDate'];
    guaranteePeriod = json['guaranteePeriod'];
    productionPlace = json['productionPlace'];
    shippingInfo = json['shippingInfo'];
    unShippingInfo = json['unShippingInfo'];
    shippingTimeLimit = json['shippingTimeLimit'];
    afterSales = json['afterSales'];
    equalLevelProfit = json['equalLevelProfit'];
    zeroProfit = json['zeroProfit'];
    firstProfit = json['firstProfit'];
    secondProfit = json['secondProfit'];
    thirdProfit = json['thirdProfit'];
    saleOut = json['saleOut'];
    diffType = json['diffType'];
    diffPriceInfo = json['diffPriceInfo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goodId'] = this.goodId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['oriPrice'] = this.oriPrice;
    data['groupPrice'] = this.groupPrice;
    data['beans'] = this.beans;
    data['groupNum'] = this.groupNum;
    data['mainImage'] = this.mainImage;
    data['detailImages'] = this.detailImages;
    data['rotateImages'] = this.rotateImages;
    data['categories'] = this.categories;
    data['specifics'] = this.specifics;
    data['hotSale'] = this.hotSale;
    data['hotSaleImage'] = this.hotSaleImage;
    data['brand'] = this.brand;
    data['goodName'] = this.goodName;
    data['material'] = this.material;
    data['component'] = this.component;
    data['productionDate'] = this.productionDate;
    data['expirationDate'] = this.expirationDate;
    data['guaranteePeriod'] = this.guaranteePeriod;
    data['productionPlace'] = this.productionPlace;
    data['shippingInfo'] = this.shippingInfo;
    data['unShippingInfo'] = this.unShippingInfo;
    data['shippingTimeLimit'] = this.shippingTimeLimit;
    data['afterSales'] = this.afterSales;
    data['equalLevelProfit'] = this.equalLevelProfit;
    data['zeroProfit'] = this.zeroProfit;
    data['firstProfit'] = this.firstProfit;
    data['secondProfit'] = this.secondProfit;
    data['thirdProfit'] = this.thirdProfit;
    data['saleOut'] =  this.saleOut;
    data['diffType'] = this.diffType;
    data['diffPriceInfo'] = this.diffPriceInfo;
    return data;
  }
}
