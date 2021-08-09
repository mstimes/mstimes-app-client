import 'dart:io';

class LocalReleaseImages {
  Map<String, File> localImagesMap = Map();

  static LocalReleaseImages _instance = null;

  static LocalReleaseImages getImagesMap() {
    if (_instance == null) {
      _instance = new LocalReleaseImages();
    }
    return _instance;
  }

  // setLocalImagesKV(key, value) {
  //   localImagesMap[key] = value;
  // }

  // clear() {
  //   localImagesMap.clear();
  // }
}
