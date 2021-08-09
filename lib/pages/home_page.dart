// import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     getHttp();
//     return Scaffold(
//       body: Center(
//         child: Text("推荐"),
//       ),
//     );
//   }

//   void getHttp() async {
//     print("http...");
//     try {
//       Dio dio = new Dio();
//       (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//           (client) {
//         client.badCertificateCallback = (cert, host, port) {
//           return true;
//         };
//       };
//       Response response = await dio.get(
//           "https://www.easy-mock.com/mock/5faea95d90e2202de96cd1de/example/mock");
//       return print(response.data);
//     } catch (e) {
//       return print(e);
//     }
//   }
// }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController typeController = TextEditingController();
  var showText = "短视频推荐正在建设中，敬请期待...";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
            child: Center(
          child: Text(
            showText,
            // overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                backgroundColor: Colors.amber[600],
                fontSize: 20,
                color: Colors.white),
          ),
        )),
      ),
    );
  }

  void _choiceAction() {
    getHttp(typeController.text.toString()).then((value) => {
          setState(() {
            showText = value['data']['projects'][1]['address'].toString();
          })
        });
  }
}

Future getHttp(String typeText) async {
  print("http...");
  try {
    Dio dio = new Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (client) {
    //   client.badCertificateCallback = (cert, host, port) {
    //     return true;
    //   };
    // };

    // var params = {"name": typeText};
    Response response = await dio.get(
        "https://www.easy-mock.com/mock/5faea95d90e2202de96cd1de/example/mock");
    return response.data;
  } catch (e) {
    return print(e);
  }
}
