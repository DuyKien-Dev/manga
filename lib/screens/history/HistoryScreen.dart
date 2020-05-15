import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english/constants/ApiConstants.dart';
import 'package:english/screens/detail/DetailScreen.dart';
import 'package:english/screens/favorite/FavoriteScreen.dart';
import 'package:english/utils/DownLoad.dart';
import 'package:english/utils/PreferencesUtil.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  dynamic object =
      PreferencesUtil.getPreferences("history").compareTo("") == 0 ? [] : jsonDecode(PreferencesUtil.getPreferences("history"));
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Histories",
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
                    : GridCustomList(
                        object: object,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
