import 'dart:async';
import 'dart:convert';

import 'package:english/screens/detail/DetailScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english/main.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:english/constants/ApiConstants.dart';
import 'package:english/utils/DownLoad.dart';
import 'package:english/utils/LocalJson.dart';
import 'package:english/utils/PreferencesUtil.dart';

Color headerColor = Color(0xffE74B6F);
Color bgColor = Color(0xffFFF8FA);
Color selectColor = Color(0xffE42D58);
Color chapColor = Color(0xffFFF8F6);
Color chapBoderColor = Color(0xffEFE8E6);
Color tabColor = Color(0xffF9F7F9);

class SearchScreen extends StatefulWidget {
  SearchScreen({this.searchList});
  List<dynamic> searchList = new List<dynamic>();
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isRn = false;
  void goToInforScreen(dynamic mangaItem) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InforScreen(
          manga: mangaItem,
        ),
      ),
    );

    // MangaSharePreferences.saveToHistories("histories", mangaItem);
    // if (MangaSharePreferences.countRate() == 1) {
    //   MyApp.platform.invokeMethod("rateManual");
    // }
    // setState(() {
    //   isDowloading = true;
    // });
    // MangaDowload.DownloadStory(mangaItem).then((onValue) {
    //   onValue.chaps.sort((a, b) {
    //     return a.chapNumber.compareTo(b.chapNumber);
    //   });
    //   Timer(Duration(milliseconds: 200), () async {
    //     await Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => InforScreen(
    //                 storyItem: onValue,
    //               )),
    //     );
    //     if (mounted) {
    //       setState(() {
    //         isDowloading = false;
    //       });
    //     }
    //   });
    // });
  }

  TextEditingController controller = new TextEditingController();

  List<dynamic> resultList = new List<dynamic>();
  bool isDowloading = false;
  void search(String str) {
    resultList = new List<dynamic>();
    widget.searchList.forEach((f) {
      String s = f["name"];
      if (s.toLowerCase().contains(str.toLowerCase())) {
        resultList.add(f);
      }
    });
    if (resultList.length > 0) {
      resultList[0].forEach((key, value) {
        if (key.toString().compareTo("rn") == 0) {
          isRn = true;
          resultList.sort((a, b) {
            int valB = int.tryParse(b["rn"]) ?? 0;
            int valA = int.tryParse(a["rn"]) ?? 0;
            return valB - valA;
          });
        }
      });
    }
    setState(() {});
  }

  @override
  void initState() {
    // print(LocalJson.getIndexData("searchList" + PreferencesUtil.getPreferences("server")));
    // widget.searchList = []; // jsonDecode(PreferencesUtil.getPreferences("searchList" + PreferencesUtil.getPreferences("server")));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _showDialog() {
    // PreferencesUtil.getPreferences("searchUri")

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        DownLoad.DownloadManga(
                uri: PreferencesUtil.getPreferences("searchUri"),
                folder: "taglist")
            .then((onValue) {
          widget.searchList = onValue;
          print(onValue.length);
          LocalJson.writeToFile(widget.searchList);
          Navigator.of(context).pop();
        });
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            content: Container(
              height: 250,
              child: new Column(
                children: <Widget>[
                  Image.asset(
                    "lib/assets/gifs/getdata.gif",
                    height: 200,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Download 1/1 data",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String temp = "";
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          color: headerColor,
          child: SafeArea(
            child: Container(
              width: width,
              height: height,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 50,
                    width: width,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        Expanded(
                            child: Center(
                          child: Text(
                            "Search mangas",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        )),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchScreen()),
                            );
                          },
                          icon: Icon(
                            Icons.update,
                            color: Colors.transparent,
                            size: 35,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: FloatingSearchBar.builder(
                      itemCount: resultList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                goToInforScreen(resultList[index]);
                              },
                              child: Container(
                                color: chapColor,
                                height: 110,
                                padding: EdgeInsets.only(
                                    left: 5,
                                    right: 5,
                                    top: index == 0 ? 15 : 0),
                                width: width,
                                child: Row(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius:
                                          new BorderRadius.circular(2),
                                      child: FadeInImage.assetNetwork(
                                        placeholder:
                                            'lib/assets/gifs/loading2.gif',
                                        image: resultList[index]["cover"],
                                        width: 90,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            " " + resultList[index]["name"],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          width: width - 100,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            " Last chap: " +
                                                resultList[index]["latest"].toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                        Text(
                                          isRn
                                              ? " Rate number: " +
                                                  resultList[index]["latest"]
                                                      .toString()
                                              : " Rate: " +
                                                  resultList[index]["r"]
                                                      .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(4),
                              height: 10,
                              color: chapColor,
                              child: Center(
                                child: Container(
                                  height: 1,
                                  color: chapBoderColor,
                                  width: width,
                                ),
                              ),
                            )
                          ],
                        );
                      },
                      controller: controller,
                      trailing: CircleAvatar(
                        backgroundColor: headerColor,
                        child: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (temp.length > 2) {
                              search(temp);
                            } else {
                              setState(() {
                                resultList.clear();
                              });
                            }
                          },
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: headerColor,
                          ),
                          onPressed: () {
                            resultList.clear();
                            controller.clear();
                            setState(() {});
                          },
                        ),
                      ),
                      onChanged: (String value) {
                        temp = value;
                      },
                      onTap: () {},
                      decoration: InputDecoration.collapsed(
                        hintText: "Type > 3 character",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        resultList.length == 0
            ? Positioned(
                bottom: 100,
                child: Container(
                  width: width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Image.asset("lib/assets/gifs/getdata.gif"),

                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Search results 0",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showDialog();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: HeaderColor,
                            height: 50,
                            width: 200,
                            child: Center(
                              child: Text(
                                "Update search data",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                height: 0,
              ),
        isDowloading
            ? Positioned(
                top: 0,
                left: 0,
                child: Container(
                  height: height,
                  width: width,
                  color: Colors.black12,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CupertinoActivityIndicator(
                        radius: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Dowloading",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Container(
                height: 0,
              )
      ],
    ));
  }
}
