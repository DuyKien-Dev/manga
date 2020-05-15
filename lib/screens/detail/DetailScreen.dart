import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:english/main.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:english/constants/ApiConstants.dart';
import 'package:english/screens/read/ReadOfflineScreen.dart';
import 'package:english/screens/read/ReadOnlineScreen.dart';
import 'package:english/utils/DownLoad.dart';
import 'package:english/utils/PreferencesUtil.dart';
import 'package:english/utils/SaveDownloadJson.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:toast/toast.dart';

Color headerColor = Color(0xffE74B6F);
Color bgColor = Color(0xffFFF8FA);
Color selectColor = Color(0xffE42D58);
Color chapColor = Color(0xffFFF8F6);
Color chapBoderColor = Color(0xffEFE8E6);

class InforScreen extends StatefulWidget {
  dynamic manga;
  String name;
  InforScreen({this.manga}) {
    print(manga);
  }

  bool showAd = false;
  @override
  _InforScreenState createState() => _InforScreenState(showAd);
}

class _InforScreenState extends State<InforScreen> {
  AdmobInterstitial interstitialAd;
  _InforScreenState(this.isShow);
  ScrollController controller;
  bool first = false;
  int selectedChapIndex = 0;
  int length = 0;
  bool isLoad = true;
  bool isShow = false;
  dynamic detail;
  Future<void> downloadDetail() async {
    isShow = false;
    detail = await DownLoad.DownloadManga(uri: widget.manga["mJLink"], folder: "taglist");
    detail["chs"] = detail["chs"].reversed.toList();
    detail["name"] = widget.manga["name"];

    if (Random().nextInt(10) > 4) {
      getAd();
    } else {
      await Future.delayed(const Duration(milliseconds: 500), () => "1");
      setState(() {
        isShow = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    downloadDetail();
  }

  @override
  void dispose() {
    interstitialAd?.dispose();
    super.dispose();
  }

  void getAd() {
    interstitialAd = AdmobInterstitial(
      adUnitId: ADMOB_INTERSTITIAL_ID,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        handleEvent(event, args, 'Interstitial');
      },
    )..load();
  }

  void handleEvent(AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        interstitialAd.show();
        break;
      case AdmobAdEvent.opened:
        break;
      case AdmobAdEvent.closed:
        setState(() {
          isShow = true;
        });

        break;
      case AdmobAdEvent.failedToLoad:
        setState(() {
          isShow = true;
        });
        break;
      case AdmobAdEvent.rewarded:
        break;
      default:
    }
  }

  void _showDialog(String txt) {
    // PreferencesUtil.getPreferences("searchUri")

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          content: Container(
            height: MediaQuery.of(context).size.height - 200,
            width: MediaQuery.of(context).size.width - 40,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(5),
              child: Text(txt),
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              child: Text("OK"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        color: Colors.white,
        child: isShow
            ? ListView(
                padding: EdgeInsets.all(0),
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 280,
                        width: width,
                        child: FadeInImage(
                          // here `bytes` is a Uint8List containing the bytes for the in-memory image
                          placeholder: AssetImage("lib/assets/gifs/loading2.gif"),

                          image: NetworkImage(
                            detail["cover"],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: 280,
                        width: width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            // Where the linear gradient begins and ends
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            // Add one stop for each color. Stops should increase from 0 to 1
                            stops: [0.1, 0.5, 0.7, 0.9],
                            colors: [
                              // Colors are easy thanks to Flutter's Colors class.
                              Color.fromRGBO(0, 0, 0, 0.4),
                              Color.fromRGBO(0, 0, 0, 0.3),
                              Color.fromRGBO(0, 0, 0, 0.2),
                              Color.fromRGBO(0, 0, 0, 0.0),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 30,
                        left: 0,
                        child: Container(
                          height: 50,
                          width: 50,
                          child: FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 30,
                        right: 10,
                        child: Container(
                          height: 50,
                          width: 50,
                          child: FlatButton(
                            onPressed: () {
                              dynamic arrr = PreferencesUtil.getPreferences("favorite").compareTo("") == 0
                                  ? []
                                  : jsonDecode(PreferencesUtil.getPreferences("favorite"));
                              print(widget.manga);
                              for (int i = 0; i < arrr.length; i++) {
                                final a = arrr[i];
                                if (a["name"].compareTo(widget.manga["name"]) == 0) {
                                  arrr.removeAt(i);
                                  break;
                                }
                              }
                              if (arrr.length > 50) {
                                arrr.removeAt(arrr.length - 1);
                              }
                              arrr.insert(0, widget.manga);
                              PreferencesUtil.setPreferences("favorite", jsonEncode(arrr));
                              Toast.show("Saved", context,
                                  duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM, backgroundColor: Colors.black38);
                            },
                            child: Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 60,
                        left: 0,
                        child: Container(
                          height: 45,
                          width: width,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            detail["name"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 40,
                        left: 0,
                        child: Container(
                            height: 50,
                            width: width,
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SmoothStarRating(
                                    allowHalfRating: false,
                                    onRatingChanged: (v) {},
                                    starCount: 10,
                                    rating: detail["r"] == null ? 0 : double.parse(detail["r"]),
                                    size: 22.0,
                                    color: Colors.yellow,
                                    borderColor: Colors.yellow,
                                    spacing: 0.0),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    detail["r"] == null ? "0" : double.parse(detail["r"]).toString(),
                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                )
                              ],
                            )),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        child: Container(
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          width: width,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          // child: Text(
                          //   widget.storyItem.name,
                          //   maxLines: 1,
                          //   overflow: TextOverflow.ellipsis,
                          //   style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          // ),
                          child: Text(
                            this.detail["genres"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white),
                          ),
                          // child: ListView.builder(
                          //   padding: EdgeInsets.all(0),
                          //   scrollDirection: Axis.horizontal,
                          //   itemCount: this.detail["genres"] == null ? 0 : (this.detail["genres"].split(", ").length / 2).ceil(), //null
                          //   itemBuilder: (context, index) {
                          //     return Column(
                          //       children: <Widget>[
                          //         Container(
                          //           height: 20,
                          //           width: 80,
                          //           margin: EdgeInsets.only(right: 10, top: 2, bottom: 2),
                          //           // padding: EdgeInsets.only(left: 10, right: 10),
                          //           decoration: new BoxDecoration(
                          //             color: Colors.black12,
                          //             borderRadius: new BorderRadius.all(
                          //               Radius.circular(5.0),
                          //             ),
                          //           ),
                          //           child: Center(
                          //             child: Text(
                          //               this.detail["genres"].split(", ")[index],
                          //               maxLines: 1,
                          //               overflow: TextOverflow.ellipsis,
                          //               style: TextStyle(color: Colors.white),
                          //             ),
                          //           ),
                          //         ),
                          //         this.detail["genres"].split(", ").length > index + 3
                          //             ? Container(
                          //                 height: 20,
                          //                 width: 80,
                          //                 margin: EdgeInsets.only(right: 10, top: 2, bottom: 2),
                          //                 // padding: EdgeInsets.only(left: 10, right: 10),
                          //                 decoration: new BoxDecoration(
                          //                   color: Colors.white30,
                          //                   borderRadius: new BorderRadius.all(
                          //                     Radius.circular(5.0),
                          //                   ),
                          //                 ),
                          //                 child: Center(
                          //                   child: Text(
                          //                     this.detail["genres"].split(", ")[index + 3],
                          //                     style: TextStyle(color: Colors.white),
                          //                   ),
                          //                 ),
                          //               )
                          //             : Container(),
                          //       ],
                          //     );
                          //   },
                          // ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ExpandText(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      maxLength: 2,
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ),
                  ChapRow(
                    detail: detail,
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("lib/assets/gifs/getdata.gif"),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Load data...",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

class ChapRow extends StatefulWidget {
  ChapRow({@required this.detail});
  dynamic detail;
  @override
  _ChapRowState createState() => _ChapRowState();
}

class _ChapRowState extends State<ChapRow> {
  int selectedChapIndex = 0;
  bool isLoad = false;
  int length = 0;
  String folder = "";
  dynamic saveData = [];
  @override
  void initState() {
    folder = widget.detail["name"].replaceAll(" ", "_") + PreferencesUtil.getPreferences("server");

    super.initState();
    getChaps();
  }

  void getChaps() async {
    saveData = PreferencesUtil.getPreferences(folder).compareTo("") == 0 ? [] : jsonDecode(PreferencesUtil.getPreferences(folder));
    // Timer(
    //     Duration(
    //       milliseconds: 500,
    //     ), () {
    //   if (mounted) {
    //     setState(() {
    //       isLoad = false;
    //       length = widget.detail["chs"].length;
    //     });
    //   }
    // });
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final width = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Download chaps"),
          content: Container(
            color: Colors.transparent,
            child: Text("Download all chaps of this manga to read offline?\nAll download file will in download tab."),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: Colors.black54),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Download",
                style: TextStyle(color: HeaderColor),
              ),
              onPressed: () {
                Navigator.pop(context);
                _showDownloadDialog();
              },
            ),
          ],
        );
      },
    );
  }

  ProgressDialog pr;

  void _showDownloadDialog() async {
    int idx = 1;
    pr = new ProgressDialog(context, type: ProgressDialogType.Download);
    pr.style(
      message: 'Downloading file...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      progressWidget: CircularProgressIndicator(),
      maxProgress: widget.detail["chs"] != null ? widget.detail["chs"].length * 1.0 : 0.0,
      progressTextStyle: TextStyle(color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    pr.show();
    List arrSaveData = [];
    for (final c in widget.detail["chs"]) {
      dynamic arrImage = [];
      String name = c["cName"].toString().replaceAll(".", "_").replaceAll(" ", "_") + Random().nextInt(10000).toString();
      //download
      final chap = await DownLoad.DownloadManga(uri: c["cJLink"], folder: folder);

      if (chap != null) {
        for (final image in chap) {
          String strr = await DownLoad.DownloadImage(uri: image["pUrl"], folder: folder, chap: name);
          if (strr != null) {
            arrImage.add(strr);
          }
        }
      }
      c["cLocal"] = arrImage;
      arrSaveData.add(c);
      pr.update(progress: idx * 1.0);
      idx = idx + 1;
    }
    dynamic temp = widget.detail;
    temp["chs"] = arrSaveData;
    SaveDownloadJson.writeToFile(temp);
    await Future.delayed(const Duration(milliseconds: 1000), () => "1");
    pr.hide();
    // setState(() {
    //   isLoad = true;
    //   length = 0;
    // });
    // PreferencesUtil.getPreferences(folder).compareTo("") == 0 ? [] : jsonDecode(PreferencesUtil.getPreferences(folder));
  }

  bool compareInSave(String cName) {
    for (final f in saveData) {
      if (cName.toString().compareTo(f["cName"].toString()) == 0) {
        return true;
      }
    }

    return false;
  }

  void goToReadScreen(int idx) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ReadOnlineScreen(
                data: widget.detail["chs"],
                selectedChapIndex: idx,
              )),
    );
     MyApp.platform.invokeMethod("rate");
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 0, left: 10),
          child: isLoad
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Loadding chap...",
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Color(0xffE74C3C), fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(Icons.file_download, color: Colors.transparent),
                      onPressed: () {},
                    ),
                  ],
                )
              : widget.detail["chs"].length == 0
                  ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                      Text(
                        "No data.",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Color(0xffE74C3C), fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: Icon(Icons.file_download, color: Colors.transparent),
                        onPressed: () {},
                      ),
                    ])
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Total " + widget.detail["chs"].length.toString() + " part",
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Color(0xff999999)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.file_download, color: HeaderColor),
                              onPressed: () {
                                _showDialog();
                              },
                            ),
                           
                            Container(
                              width: 10,
                              height: 1,
                            ),
                             GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.detail["chs"] = widget.detail["chs"].reversed.toList();
                                });
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                padding: EdgeInsets.all(15),
                                color: Colors.transparent,
                                child: Image.asset(
                                  "lib/assets/images/ic_sort.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Container(
                              width: 10,
                              height: 1,
                            ),
                          ],
                        ),
                      ],
                    ),
        ),
        ListView.builder(
          itemCount: widget.detail["chs"].length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.all(0),
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                Container(
                  height: 1,
                  width: width,
                  color: chapBoderColor,
                ),
                FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    goToReadScreen(index);
                  },
                  child: Container(
                    height: 60,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    width: width,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${index + 1}. Chapter " + widget.detail["chs"][index]["cName"] == null
                                    ? "No name"
                                    : widget.detail["chs"][index]["cName"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: selectedChapIndex == index ? Color(0xffE74C3C) : Colors.black54),
                              ),
                              Text(
                                widget.detail["chs"][index]["cTitle"] == null ? "No title" : widget.detail["chs"][index]["cTitle"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Color(0xff999999)),
                              )
                            ],
                          ),
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(right: 16),
                        //   height: 15,
                        //   width: 15,
                        //   decoration: new BoxDecoration(
                        //     color: compareInSave(widget.detail["chs"][index]["cName"]) ? Colors.green : Colors.red,
                        //     borderRadius: new BorderRadius.all(
                        //       Radius.circular(3.0),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
    return ListView.builder(
      itemCount: length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            Container(
              height: 1,
              width: width,
              color: chapBoderColor,
            ),
            FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                // goToReadScreen(index);
              },
              child: Container(
                height: 60,
                padding: EdgeInsets.only(left: 10, right: 10),
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${index + 1}. Chapter " + widget.detail["chs"][index]["cName"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: selectedChapIndex == index ? Color(0xffE74C3C) : Colors.black54),
                    ),
                    Text(
                      widget.detail["chs"][index]["cTitle"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Color(0xff999999)),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
