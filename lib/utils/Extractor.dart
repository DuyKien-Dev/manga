import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';

class Extractor {
  static dynamic gzExtract(String path) {
    if (Directory(path).existsSync()) {
      List<int> bytes = File(path).readAsBytesSync();
      var string = utf8.decode(GZipDecoder().decodeBytes(bytes));
      return jsonDecode(string);
    }
    return null;
  }
}
