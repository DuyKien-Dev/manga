import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english/constants/ApiConstants.dart';
import 'package:english/screens/detail/DetailScreen.dart';
import 'package:english/screens/read/ReadOfflineScreen.dart';
import 'package:english/utils/DownLoad.dart';
import 'package:english/utils/PreferencesUtil.dart';
import 'package:english/utils/SaveDownloadJson.dart';

class DownloadScreen extends StatefulWidget {
  bool back = true;
  DownloadScreen({this.back});
  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  dynamic object = SaveDownloadJson.getIndexData()["save"] == null ? [] : SaveDownloadJson.getIndexData()["save"];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    print(object);
    return Scaffold(
      body: Container(
        color: HeaderColor,
        child: SafeArea(
          child: Container(
            color: BGColor,
            width: width,
            height: height,
            child: Column(
              children: <Widget>[
                Container(
                  width: width,
                  color: HeaderColor,
                  child: Row(
                    children: <Widget>[
                      widget.back
                          ? IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.transparent,
                                size: 30,
                              ),
                              onPressed: () {},
                            ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Download",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.transparent,
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                object.length == 0
                    ? Container()
                    : Expanded(
                        child: GridDownloadList(
                          object: object,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GridDownloadList extends StatefulWidget {
  dynamic object = {};
  GridDownloadList({@required this.object});
  @override
  _GridDownloadListState createState() => _GridDownloadListState();
}

class _GridDownloadListState extends State<GridDownloadList> {
  bool isLoadding = false;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        Expanded(
          child: GridView.count(
            shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 1 / 2,
            children: List.generate(
              widget.object.length,
              (index) {
                return FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReadOfflineScreen(
                          data: widget.object[index],
                          selectedChapIndex: 0,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(width: 1.0, color: Color(0xffEFE8E6)),
                        left: BorderSide(width: 1.0, color: Color(0xffEFE8E6)),
                        right: BorderSide(width: 1.0, color: Color(0xffEFE8E6)),
                        bottom: BorderSide(width: 1.0, color: Color(0xffEFE8E6)),
                      ),
                    ),
                    margin: EdgeInsets.all(5),
                    child: Column(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: new BorderRadius.circular(0),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'lib/assets/gifs/loading2.gif',
                            image: widget.object[index]["cover"].toString(),
                            height: width / 2 - 2,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          width: width / 2,
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          child: Text(
                            widget.object[index]["name"].toString(),
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          widget.object[index]["rn"] == null
                              ? "last: " + widget.object[index]["latest"].toString()
                              : "rate: " + widget.object[index]["rn"].toString(),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xff999999)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        isLoadding
            ? Container(
                height: 50,
                color: Colors.transparent,
                child: CupertinoActivityIndicator(
                  radius: 15,
                ),
              )
            : Container(
                height: 0,
              )
      ],
    );
  }
}
