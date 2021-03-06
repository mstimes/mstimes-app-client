class FlutterQiNiuConfig {
/*
{
  "token": "token",
  "key": "key",
  "filePath": "filePath"
}
*/

  String token;
  String key;
  String filePath;

  FlutterQiNiuConfig({
    this.token,
    this.filePath,
    this.key,
  });

  FlutterQiNiuConfig.fromJson(Map<String, dynamic> json) {
    token = json["token"]?.toString();
    key = json["key"]?.toString();
    filePath = json["filePath"]?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["token"] = token;
    data["key"] = key;
    data["filePath"] = filePath;
    return data;
  }
}
