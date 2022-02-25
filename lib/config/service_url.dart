import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:mstimes/common/control.dart';

// const QINIU_OBJECT_STORAGE_URL = "http://qrhl3la00.hn-bkt.clouddn.com/";
const QINIU_OBJECT_STORAGE_URL = "https://ghomelifevvip.com/";
const GHOME_SERVER_URL = 'https://server.ghomelifevvip.com';
const BAIDU_NLP_URL = "https://aip.baidubce.com";
const WECHAT_OPEN_URL = "https://api.weixin.qq.com";
const LOCAL_URL = "http://30.225.212.182:8080";
const WECHART_PAY = "https://api.mch.weixin.qq.com/pay/unifiedorder";

// const MOCK_SERVER_URL =
//     'https://www.easy-mock.com/mock/5faea95d90e2202de96cd1de/';

const servicePath = {
  'createUserCoupons': GHOME_SERVER_URL + '/coupon/createUserCoupons',

  // 商品信息
  'queryGoodsList': GHOME_SERVER_URL + '/goods/queryGoodsList',
  'queryGoodsListByType': GHOME_SERVER_URL + '/goods/queryGoodsListByType',
  'queryGoodById': GHOME_SERVER_URL + '/goods/queryGoodById',

  // 商品上架
  'uploadReleaseGoods': GHOME_SERVER_URL + '/upload/goodRelease',

  // 订单信息
  'uploadOrder': GHOME_SERVER_URL + '/order/uploadOrderInfo',
  'queryOrders': GHOME_SERVER_URL + '/order/queryOrderRecordsByType',
  'queryOrderCounts': GHOME_SERVER_URL + '/order/queryOrderCounts',
  'exportOrder': GHOME_SERVER_URL + '/order/export',
  'queryAccountOrderSummary':
      GHOME_SERVER_URL + '/order/queryAccountOrderSummary',
  'createUsualAddress': GHOME_SERVER_URL + '/user/createUsualAddress',
  'queryLastUsualAddress': GHOME_SERVER_URL + '/user/queryLastUsualAddress',

  // 用户管理
  'registerUser': GHOME_SERVER_URL + '/user/newUser',
  'queryAgentRelations': GHOME_SERVER_URL + '/user/queryAgentRelations',
  'countAgentRelations': GHOME_SERVER_URL + '/user/countAgentRelations',
  'queryMyFuns': GHOME_SERVER_URL + '/funs/queryMyFuns',
  'queryFunsSummary': GHOME_SERVER_URL + '/funs/queryFunsSummary',
  'queryFunsCount': GHOME_SERVER_URL + '/funs/queryFunsCount',

  // 分润管理
  'queryFundSummary': GHOME_SERVER_URL + '/fund/queryFundSummary',
  'queryFundOrder': GHOME_SERVER_URL + '/fund/queryFundOrderInfos',
  'queryPassitityIncomeCounts':
      GHOME_SERVER_URL + '/fund/queryPassivityIncomeCounts',

  // 外部服务
  'getQiniuToken': GHOME_SERVER_URL + '/qiniu/getToken',
  'getBaiduToken': BAIDU_NLP_URL + '/oauth/2.0/token',
  'identifyReceiverAddress': BAIDU_NLP_URL + '/rpc/2.0/nlp/v1/address',

  // 微信服务
  'wechatAccessToken': WECHAT_OPEN_URL + '/sns/oauth2/access_token',
  'wechatUserInfo': WECHAT_OPEN_URL + '/sns/userinfo',
  "queryAppletCodeToken": GHOME_SERVER_URL + '/wechat/queryAppletCodeToken',
  "queryAppletCode": 'https://api.weixin.qq.com/wxa/getwxacodeunlimit',

  // 登录
  'login': GHOME_SERVER_URL + '/user/login',
  'sendPhoneVerify': GHOME_SERVER_URL + '/user/sendPhoneVerify',
  'checkPhoneVerify': GHOME_SERVER_URL + '/user/checkPhoneVerify',
  'loginByPhoneNo': GHOME_SERVER_URL + '/user/loginByPhoneNo',
  'updatePhoneNumber': GHOME_SERVER_URL + '/user/updatePhoneNumber',

  // 微信支付
  'doRepay': GHOME_SERVER_URL + '/pay/queryPrepayOrder',
  'callPay': WECHART_PAY,

  // 资金信息
  'queryFund': GHOME_SERVER_URL + '/fund/queryFundByAgentId',

  // 账户管理
  'createDrawingRecords': GHOME_SERVER_URL + '/drawing/createRecords',
  'getLastDrawingRecord': GHOME_SERVER_URL + '/drawing/getLastDrawingRecord',
  'queryDrawingRecordsByStatus':
      GHOME_SERVER_URL + '/drawing/queryDrawingRecordsByStatus',

  // 财务管理
  'updateDrawingStatus': GHOME_SERVER_URL + '/drawing/updateDrawingStatus',

  // 代金券
  'queryUserCoupons': GHOME_SERVER_URL + '/coupon/queryUserCoupons',

  // 蜜豆
  'queryMBeans': GHOME_SERVER_URL + '/mbeans/queryMBeans',
  'queryMyMBeanRecords': GHOME_SERVER_URL + '/mbeans/queryMyMBeanRecords',

};

Future requestDataByUrl(urlPath, {formData, paramsMap}) async {
  if (debug) {
    print("[RequestDataByUrl] request url : " +
        servicePath[urlPath] +
        "?" +
        formData.toString() +
        " begin...");
  }

  try {
    Dio dio = new Dio();
    dio.options.responseType = ResponseType.plain;

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true;
      };
    };

    Response response;
    if (formData == null && paramsMap == null) {
      response = await dio.post(servicePath[urlPath]);
    } else if (formData == null) {
      response = await dio.post(servicePath[urlPath], data: paramsMap);
    } else {
      response = await dio.post(servicePath[urlPath], data: formData);
    }

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("[RequestDataByUrl] request url : " +
          urlPath +
          " error, statusCode : " +
          response.statusCode.toString() +
          ", statusMessage : " +
          response.statusMessage);
    }
  } catch (e) {
    return print(e);
  }
}

Future requestDataForJson(urlPath, {queryParameters, bodyParameters}) async {
  if (debug) {
    print('requestDataForJson : urlPath : ' +
        urlPath +
        ", queryParameters : " +
        queryParameters.toString() +
        ',bodyParameters: ' +
        bodyParameters.toString());
  }

  try {
    BaseOptions baseOptions = BaseOptions(
        queryParameters: queryParameters, responseType: ResponseType.plain);
    Dio dio = new Dio(baseOptions);
    Response response = await dio.post(
      servicePath[urlPath],
      data: bodyParameters,
    );
    if (debug) {
      print('requestDataForJson response finished.');
    }

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("[RequestDataByUrl] request url : " +
          urlPath +
          " error, statusCode : " +
          response.statusCode.toString() +
          ", statusMessage : " +
          response.statusMessage);
    }
  } catch (e) {
    return print(e);
  }
}
