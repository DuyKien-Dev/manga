import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Color headerColor = Color(0xffE74B6F);
Color bgColor = Color(0xffFFF8FA);
Color selectColor = Color(0xffE42D58);
Color chapColor = Color(0xffFFF8F6);
Color chapBoderColor = Color(0xffEFE8E6);

class ReadOfflineScreen extends StatefulWidget {
  ReadOfflineScreen({@required this.data, @required this.selectedChapIndex});
  dynamic data;
  int selectedChapIndex = 0;

  @override
  _ReadOfflineScreenState createState() => _ReadOfflineScreenState();
}

final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

class _ReadOfflineScreenState extends State<ReadOfflineScreen> {
  ScrollController controller;

  bool isLoadding = false;
  bool end = true;

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);

    super.initState();
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

  @override
  void dispose() {
    super.dispose();
  }

  void changeChap(chapNumber, index) async {
    if (mounted) {
      setState(() {
        widget.selectedChapIndex = index;
      });
    }
  }

  void nextChap() async {
    int next = widget.selectedChapIndex + 1;
    if (mounted) {
      setState(() {
        widget.selectedChapIndex = next;
      });
    }
    // downloadTrap(next);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
                    controller: controller,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 50),
                    itemCount: widget.data["chs"][widget.selectedChapIndex]["cLocal"].length,
                    itemBuilder: (context, index) {
                      print(widget.data["chs"][widget.selectedChapIndex]["cLocal"][index]);
                      return Container(
                        child: Image.file(
                          new File(widget.data["chs"][widget.selectedChapIndex]["cLocal"][index]),
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
                                      "Chap " + this.widget.data["chs"][this.widget.selectedChapIndex]["cName"],
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
                                child: widget.selectedChapIndex + 1 == this.widget.data["chs"].length
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
                                              "Chap " + this.widget.data["chs"][this.widget.selectedChapIndex + 1]["cName"],
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
            itemCount: this.widget.data["chs"].length,
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
                      itemClieck(widget.data[index], index);
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
                            "${index + 1}. Chapter " + this.widget.data["chs"][index]["cName"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: widget.selectedChapIndex == index ? Color(0xffE74C3C) : Colors.black54),
                          ),
                          Text(
                            this.widget.data["chs"][index]["cTitle"] == null
                                ? "No title"
                                : this.widget.data["chs"][index]["cTitle"].toString(),
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
