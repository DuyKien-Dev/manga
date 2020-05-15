import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class DownLoad {
  static CancelToken token = new CancelToken();

  static Future<String> createFolder(String name) async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String dir = directory.absolute.path;
      final myDir = new Directory('${dir}/${name}');
      bool isThere = await myDir.exists();
      if (isThere) {
        return myDir.path;
      } else {
        myDir.create(recursive: true);
        return myDir.path;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<dynamic> DownloadManga({@required String uri, @required folder}) async {
    print(uri);
    String fileName = uri.substring(uri.lastIndexOf("/") + 1);
    String path = await downloadFile(uri, fileName, folder, (rec, total) {});

    if (path != null) {
      List<int> bytes = File(path).readAsBytesSync();
      var string = utf8.decode(GZipDecoder().decodeBytes(bytes));
      return jsonDecode(string);
    }
    return null;
  }

  static Future<String> DownloadImage({@required String uri, @required folder, @required String chap}) async {
    String fileName = chap + uri.substring(uri.lastIndexOf("/") + 1);
    String path = await downloadFile(uri, fileName, folder, (rec, total) {});

    if (path != null) {
      return path;
    }
    return null;
  }

  static Future<String> downloadFile(String uri, String name, String folderName, Function onProgress) async {
    Dio dio = Dio();
    token = new CancelToken();

    try {
      String dirPath = await createFolder(folderName);

      if (dirPath != null) {
        dirPath = "${dirPath}/${name}";
        final res = await http.get(uri);
        if (res.statusCode == 200) {
          await dio.download(uri, dirPath, onReceiveProgress: onProgress, cancelToken: token);
          return dirPath;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static String getExt(String path) {
    var ext = path.split(".").last;
    if (ext.length > 2) ext = 'gz';
    return ext;
  }
}
