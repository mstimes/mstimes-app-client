import 'package:mstimes/pages/login/login.page.dart';
import 'package:sign_in_apple/sign_in_apple.dart';

// Platform messages are asynchronous, so we initialize in an async method.
Future<void> initApplePlatformState(context) async {
  SignInApple.handleAppleSignInCallBack(onCompleteWithSignIn: (String name,
      String mail,
      String userIdentifier,
      String authorizationCode,
      String identifyToken) async {

    postUserLogin(3, userIdentifier, null, context);

  }, onCompleteWithError: (AppleSignInErrorCode code) async {
    var errorMsg = "unknown";
    switch (code) {
      case AppleSignInErrorCode.canceled:
        errorMsg = "user canceled request";
        break;
      case AppleSignInErrorCode.failed:
        errorMsg = "request fail";
        break;
      case AppleSignInErrorCode.invalidResponse:
        errorMsg = "request invalid response";
        break;
      case AppleSignInErrorCode.notHandled:
        errorMsg = "request not handled";
        break;
      case AppleSignInErrorCode.unknown:
        errorMsg = "request fail unknown";
        break;
    }
    print(errorMsg);
  });
}