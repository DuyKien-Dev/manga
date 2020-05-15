
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english/models/Source.dart';
import 'package:english/screens/download/DownloadScreen.dart';
import 'package:english/screens/main/MainScreen.dart';
import 'package:english/utils/DownLoad.dart';
import 'package:english/utils/LocalJson.dart';
import 'package:english/utils/PreferencesUtil.dart';
import 'package:english/utils/SaveDownloadJson.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  dynamic tagList;
  dynamic recommends = [];
  List<dynamic> categoryList = new List<dynamic>();
  dynamic searchList;
  int part = 1;
  void getData() async {
    //init download data;

    List<Source> listSource = getSource();
    String key = PreferencesUtil.getPreferences("server");
    if (key.length == 0) {
      PreferencesUtil.setPreferences("server", listSource[0].server[0].keyword);
      key = listSource[0].server[0].keyword;
    }
    for (final source in listSource) {
      for (final server in source.server) {
        if (server.keyword.compareTo(key) == 0) {
          //download taglist
          tagList = await DownLoad.DownloadManga(uri: server.taglist, folder: "taglist");
          if (tagList["recommends"] != null) {
            dynamic data = [];
            //get category
            categoryList = tagList["allTags"];
            int i = 0;
            //download recomend
            for (final recomend in tagList["recommends"]) {
              if (i > 2) {
                break;
              }
              setState(() {
                part++;
              });
              final t = await DownLoad.DownloadManga(uri: recomend["tJLink"], folder: "taglist");
              if (t != null) {
                recommends.add({"tagName": recomend["tagName"], "mangas": t["mangas"], "nextLink": t["nextLink"]});
              }
              i++;
            }
          }

          //download index
          PreferencesUtil.setPreferences("searchUri", server.index);
          await LocalJson.init("searchList" + key);
          if (PreferencesUtil.getPreferences("searchList" + key).compareTo("") == 0) {
            searchList = await DownLoad.DownloadManga(uri: server.index, folder: "taglist");
            PreferencesUtil.setPreferences("searchList" + key, "ok");
            LocalJson.writeToFile(searchList);
          } else {
            // searchList = jsonDecode(PreferencesUtil.getPreferences("searchList" + key));
            searchList = LocalJson.getIndexData("searchList" + key);
          }
          print(searchList.length);
          break;
        }
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => MainScreen(
                categoryList: categoryList,
                recommends: recommends,
                searchList: searchList,
              )),
    );
  }

  void checknetwork() async {
    await SaveDownloadJson.init();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        getData();
      }
    } on SocketException catch (_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DownloadScreen(back: false)),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checknetwork();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Container(
            width: width,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("lib/assets/gifs/getdata.gif"),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Download $part /4 data...",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
