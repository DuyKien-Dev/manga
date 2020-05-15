import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english/utils/DownLoad.dart';

Color headerColor = Color(0xffE74B6F);
Color bgColor = Color(0xffFFF8FA);
Color selectColor = Color(0xffE42D58);
Color chapColor = Color(0xffFFF8F6);
Color chapBoderColor = Color(0xffEFE8E6);

class ReadOnlineScreen extends StatefulWidget {
  // List<ChapItem> chapList;
  dynamic data;
  int selectedChapIndex;

  ReadOnlineScreen({
    @required this.data,
    @required this.selectedChapIndex,
  });
  @override
  _ReadOnlineScreenState createState() => _ReadOnlineScreenState();
}

final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

class _ReadOnlineScreenState extends State<ReadOnlineScreen> {
  List chapList = new List(); // list image
  ScrollController controller;
  bool isLoadding = false;
  bool end = true;
  void downloadTrap(int index) async {
    chapList.clear();
    DownLoad.DownloadManga(uri: widget.data[index]["cJLink"], folder: "online").then((onValue) {
      if (mounted) {
        setState(() {
          chapList = onValue;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    downloadTrap(this.widget.selectedChapIndex);
    controller = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    controller.dispose();
    super.dispose();
  }

  void _scrollListener() async {
    if (controller.position.maxScrollExtent == controller.position.pixels ||
        controller.position.minScrollExtent == controller.position.pixels) {
      if (mounted && !end) {
        setState(() {
          end = true;
        });
      }
    } else {
      if (mounted && end) {
        setState(() {
          end = false;
        });
      }
    }
  }

  void changeChap(chapNumber, index) async {
    if (mounted) {
      setState(() {
        widget.selectedChapIndex = index;
      });
    }
    for (int i = 0; i < widget.data.length; i++) {
      final chap = widget.data[i];
      if (chap["cName"].compareTo(chapNumber) == 0) {
        downloadTrap(i);
        break;
      }
    }
  }

  void nextChap() async {
    int next = widget.selectedChapIndex + 1;
    if (mounted) {
      setState(() {
        widget.selectedChapIndex = next;
      });
    }
    downloadTrap(next);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    print(this.widget.data);
    return Scaffold(
      key: scaffoldKey,
      drawer: ChapDrawer(data: widget.data, changeChap: this.changeChap, selectedChapIndex: widget.selectedChapIndex),
      body: Container(
        child: SafeArea(
          top: false,
          bottom: false,
          left: false,
          right: false,
          child: Container(
            width: width,
            height: height,
            color: Colors.black,
            child: Stack(
              children: <Widget>[
                Container(
                  width: width,
                  height: height,
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 50),
                    controller: controller,
                    itemCount: chapList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: FadeInImage(
                          // here `bytes` is a Uint8List containing the bytes for the in-memory image
                          placeholder: AssetImage("lib/assets/gifs/loading2.gif"),

                          image: NetworkImage(chapList[index]["pUrl"]),
                          fit: BoxFit.fitWidth,
                        ),
                      );
                    },
                  ),
                ),
                end
                    ? Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            padding: EdgeInsets.only(top: 30),
                            height: 80,
                            width: width,
                            color: Colors.black26,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: 50,
                                  height: 50,
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
                                Container(
                                  width: 200,
                                  height: 50,
                                  margin: EdgeInsets.only(right: 10),
                                  child: Center(
                                    child: Text(
                                      "Chap " + this.widget.data[widget.selectedChapIndex]["cName"].toString(),
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  margin: EdgeInsets.only(right: 10),
                                  child: FlatButton(
                                    onPressed: () {
                                      scaffoldKey.currentState.openDrawer();
                                    },
                                    child: Icon(
                                      Icons.menu,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      )
                    : Container(
                        height: 0,
                      ),
                end
                    ? Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          height: 50,
                          width: width,
                          color: Colors.black26,
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40.0),
                              child: Container(
                                height: 50,
                                width: 300,
                                color: Colors.transparent,
                                child: widget.selectedChapIndex + 1 == this.widget.data.length
                                    ? Center(
                                        child: Text(
                                          "End",
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
                                        ),
                                      )
                                    : FlatButton(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "Chap " + this.widget.data[widget.selectedChapIndex + 1]["cName"],
                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
                                            ),
                                            Icon(
                                              Icons.navigate_next,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ],
                                        ), //Text("read next chap"),
                                        onPressed: () {
                                          nextChap();
                                        },
                                      ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: 0,
                      ),
                isLoadding
                    ? Positioned(
                        child: Container(
                          color: Colors.white24,
                          width: width,
                          height: height,
                          child: Center(
                            child: CupertinoActivityIndicator(
                              radius: 15,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: 0,
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChapDrawer extends StatefulWidget {
  dynamic data;
  Function changeChap;
  int selectedChapIndex;
  ChapDrawer({@required this.data, @required this.changeChap, @required this.selectedChapIndex});
  @override
  _ChapDrawerState createState() => _ChapDrawerState();
}

class _ChapDrawerState extends State<ChapDrawer> {
  void itemClieck(chapNumber, int index) {
    widget.changeChap(chapNumber, index);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: width - 50,
      height: height,
      color: chapColor,
      child: SafeArea(
        child: Container(
          width: width - 50,
          height: height,
          color: chapColor,
          child: ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: widget.data.length,
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
                      itemClieck(widget.data[index]["cName"], index);
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
                            "${index + 1}. Chapter " + widget.data[index]["cName"].toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: widget.selectedChapIndex == index ? Color(0xffE74C3C) : Colors.black54),
                          ),
                          Text(
                            widget.data[index]["cTitle"] == null ? "No title" : widget.data[index]["cTitle"].toString(),
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
          ),
        ),
      ),
    );
  }
}
