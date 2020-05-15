import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english/main.dart';
import 'package:english/models/Source.dart';
import 'package:english/constants/ApiConstants.dart';
import 'package:english/screens/detail/DetailScreen.dart';
import 'package:english/screens/download/DownloadScreen.dart';
import 'package:english/screens/favorite/FavoriteScreen.dart';
import 'package:english/screens/genre/GenreScreen.dart';
import 'package:english/screens/history/HistoryScreen.dart';
import 'package:english/screens/search/SearchScreen.dart';
import 'package:english/screens/splash/SplashScreen.dart';
import 'package:english/utils/DownLoad.dart';
import 'package:english/utils/PreferencesUtil.dart';

GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

class MainScreen extends StatefulWidget {
  dynamic recommends;
  List<dynamic> categoryList;
  dynamic searchList;

  MainScreen({@required this.recommends, @required this.categoryList, @required this.searchList});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  TabController tabController;
  List<Source> listSource = getSource();
  @override
  void initState() {
    tabController = new TabController(vsync: this, length: 3);
    // MyApp.platform.invokeMethod("rate");
    super.initState();
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("object....");
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final statusHeigh = MediaQuery.of(context).padding.top;

    return Scaffold(
      key: _drawerKey, // assign key to Scaffold

      drawer: MyDrawer(
        listSource: listSource,
      ),
      body: Container(
        color: HeaderColor,
        width: width,
        height: height,
        child: SafeArea(
          child: Container(
            width: width,
            height: height - statusHeigh,
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 30,
                        child: GestureDetector(
                          child: Image.asset("lib/assets/images/ic_world.png", width: 50),
                          onTap: () {
                            _drawerKey.currentState.openDrawer();
                          },
                        ),
                      ),
                      Expanded(
                          child: Center(
                        child: Text(
                          "Manga Reader",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      )),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SearchScreen(searchList: widget.searchList)),
                          );
                        },
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 35,
                        ),
                      )
                    ],
                  ),
                ),
                // Expanded(
                //   child: Container(
                //     color: HeaderColor,
                //     child: Category(
                //       categoryList: widget.categoryList,
                //     ),
                //   ),
                // ),
                Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: tabController,
                    children: <Widget>[
                      // Container(),
                      // Container(),
                      // Container(),
                      HomeView(recommends: widget.recommends),
                      CategoryView(
                        categoryList: widget.categoryList,
                      ),
                      MoreScreen(),
                      //
                      // Container(),
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  child: BottomTabCustom(tabController: tabController),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  MyDrawer({@required this.listSource});
  List<Source> listSource;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final statusHeigh = MediaQuery.of(context).padding.top;

    return Container(
      color: HeaderColor,
      child: SafeArea(
        child: Container(
          width: width * 0.8,
          height: height,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                color: HeaderColor,
                height: 50,
                width: width,
                child: Center(
                  child: Text(
                    "Select server",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemCount: listSource.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: width,
                          height: 40,
                          color: Color(0xffAAAAAA),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  listSource[index].country,
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                            padding: EdgeInsets.all(0),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: listSource[index].server.length,
                            itemBuilder: (ctx, idx) {
                              return GestureDetector(
                                onTap: () {
                                  PreferencesUtil.setPreferences("server", listSource[index].server[idx].keyword);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => SplashScreen()),
                                  );
                                },
                                child: Container(
                                  height: 50,
                                  width: width,
                                  color: Colors.transparent,
                                  margin: EdgeInsets.only(left: 20, top: 3, bottom: 3),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: Image.asset(
                                              PreferencesUtil.getPreferences("server").compareTo(listSource[index].server[idx].keyword) == 0
                                                  ? "lib/assets/images/ic_check.png"
                                                  : "lib/assets/images/ic_uncheck.png",
                                              height: 25,
                                            ),
                                          ),
                                          Text(
                                            listSource[index].server[idx].keyword,
                                            style: TextStyle(
                                                color: PreferencesUtil.getPreferences("server")
                                                            .compareTo(listSource[index].server[idx].keyword) ==
                                                        0
                                                    ? Color(0xff83c9e2)
                                                    : Color(0xff5f5f5f),
                                                fontSize: 16),
                                          )
                                        ],
                                      ),
                                      Container(
                                        height: 1,
                                        width: width,
                                        margin: EdgeInsets.only(top: 5, bottom: 5),
                                        color: ChapBoderColor,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            })
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomTabCustom extends StatefulWidget {
  TabController tabController;
  BottomTabCustom({@required this.tabController});
  @override
  _BottomTabCustomState createState() => _BottomTabCustomState();
}

class _BottomTabCustomState extends State<BottomTabCustom> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final statusHeigh = MediaQuery.of(context).padding.top;

    return Container(
      color: TabColor,
      width: width,
      child: TabBar(
        controller: widget.tabController,
        onTap: (i) {
          if (mounted) {
            setState(() {});
          }
        },

        indicatorColor: Color(0xffE74C3C), //Color(0xffFDCF32),
        indicatorWeight: 2,
        labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.black26,
        tabs: <Widget>[
          Container(
            width: width / 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  widget.tabController.index == 0 ? "lib/assets/images/ic_tab_home_hl.png" : "lib/assets/images/ic_tab_home_dark.png",
                  height: 37,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Text(
                    "Home",
                    style: TextStyle(fontSize: 10, color: widget.tabController.index == 0 ? Color(0xffE74C3C) : Color(0xff989898)),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: width / 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  widget.tabController.index == 1 ? "lib/assets/images/ic_tab_genre_hl.png" : "lib/assets/images/ic_tab_genre_dark.png",
                  height: 37,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Text(
                    "Categories",
                    style: TextStyle(fontSize: 10, color: widget.tabController.index == 1 ? Color(0xffE74C3C) : Color(0xff989898)),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: width / 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  widget.tabController.index == 2
                      ? "lib/assets/images/ic_tab_discover_hl.png"
                      : "lib/assets/images/ic_tab_discover_dark.png",
                  height: 37,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Text(
                    "More",
                    style: TextStyle(fontSize: 10, color: widget.tabController.index == 2 ? Color(0xffE74C3C) : Color(0xff989898)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  List<dynamic> recommends;
  HomeView({@required this.recommends});
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  TabController recommendController;
  dynamic listPopular = [];
  dynamic listUpdate = [];
  dynamic listComplete = [];

  @override
  void dispose() {
    recommendController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    listPopular = {"nextLink": widget.recommends[0]["nextLink"], "mangas": widget.recommends[0]["mangas"]};
    listUpdate = {"nextLink": widget.recommends[1]["nextLink"], "mangas": widget.recommends[1]["mangas"]};
    listComplete = {"nextLink": widget.recommends[2]["nextLink"], "mangas": widget.recommends[2]["mangas"]};
    recommendController = new TabController(vsync: this, length: 3);
    super.initState();
  }

  int selectTab = 0;
  @override
  Widget build(BuildContext context) {
    // print(widget.recommends[0]);
    // print(widget.recommends);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final statusHeigh = MediaQuery.of(context).padding.top;
    return Container(
      width: width,
      height: height,
      color: BGColor,
      child: Column(
        children: <Widget>[
          Container(
            color: BGColor,
            width: width,
            child: TabBar(
              controller: recommendController,
              onTap: (i) {
                setState(() {
                  selectTab = i;
                });
              },
              indicatorColor: Color(0xffE74C3C), //Color(0xffFDCF32),
              indicatorWeight: 3,
              labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              labelColor: Color(0xffE74C3C),
              unselectedLabelColor: Colors.black26,
              labelPadding: EdgeInsets.only(bottom: 0),
              tabs: widget.recommends.map((f) {
                return Tab(
                  text: f["tagName"],
                );
              }).toList(),
            ),
          ),
          Expanded(
              child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: recommendController,
            children: <Widget>[
              GridMangaList(
                object: listPopular,
              ),
              GridMangaList(
                object: listUpdate,
              ),
              GridMangaList(
                object: listComplete,
              )
            ],
          ))
        ],
      ),
    );
  }
}

class CategoryView extends StatefulWidget {
  dynamic categoryList;

  CategoryView({@required this.categoryList});

  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final statusHeigh = MediaQuery.of(context).padding.top;

    return Container(
      width: width,
      height: height,
      color: BGColor,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10),
            height: 50,
            width: width,
            color: HeaderColor,
            child: Row(
              children: <Widget>[
                Text(
                  "Categories",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.categoryList.length,
            itemBuilder: (context, index) {
              return Container(
                height: 50,
                margin: EdgeInsets.only(top: 5),
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GenreScreen(
                                genre: widget.categoryList[index],
                              )),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        widget.categoryList[index]["tagName"],
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.navigate_next,
                        color: Colors.black38,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class GridMangaList extends StatefulWidget {
  dynamic object = {};
  GridMangaList({@required this.object});
  @override
  _GridMangaListState createState() => _GridMangaListState();
}

class _GridMangaListState extends State<GridMangaList> with AutomaticKeepAliveClientMixin {
  bool isLoadding = false;
  ScrollController controller;
  @override
  void dispose() {
    controller?.removeListener(listener);
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller = new ScrollController()..addListener(listener);
    super.initState();
  }

  void listener() async {
    if (controller.position.extentAfter < 20 && !isLoadding && widget.object["nextLink"].compareTo("end") != 0) {
      if (mounted) {
        setState(() {
          isLoadding = true;
        });
      }
      await loadMore(widget.object["nextLink"]);
      Timer(Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            isLoadding = false;
          });
        }
      });
    }
  }

  Future<void> loadMore(String uri) async {
    print(uri);

    final res = await DownLoad.DownloadManga(uri: uri, folder: "taglist");
    widget.object["mangas"].addAll(res["mangas"]);
    widget.object["nextLink"] = res["nextLink"];
  }

  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        Expanded(
          child: GridView.count(
            shrinkWrap: true,
            controller: controller,
            // physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 1 / 2,
            children: List.generate(
              widget.object["mangas"].length,
              (index) {
                return FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InforScreen(
                                manga: widget.object["mangas"][index],
                              )),
                    );
                    dynamic arrr = PreferencesUtil.getPreferences("history").compareTo("") == 0
                        ? []
                        : jsonDecode(PreferencesUtil.getPreferences("history"));
                    for (int i = 0; i < arrr.length; i++) {
                      final a = arrr[i];
                      if (a["name"].compareTo(widget.object["mangas"][index]["name"] == 0)) {
                        arrr.removeAt(i);
                        break;
                      }
                    }
                    if (arrr.length > 50) {
                      arrr.removeAt(arrr.length - 1);
                    }
                    arrr.insert(0, widget.object["mangas"][index]);
                    PreferencesUtil.setPreferences("history", jsonEncode(arrr));
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
                            image: widget.object["mangas"][index]["cover"].toString(),
                            height: width / 2 - 2,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          width: width / 2,
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          child: Text(
                            widget.object["mangas"][index]["name"].toString(),
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          widget.object["mangas"][index]["rn"] == null
                              ? "last: " + widget.object["mangas"][index]["latest"].toString()
                              : "rate: " + widget.object["mangas"][index]["rn"].toString(),
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class MoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      color: BGColor,
      width: width,
      height: height,
      child: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.only(top: 30),
            elevation: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: 180,
                width: width - 40,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HistoryScreen()),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 15, top: 15, bottom: 10),
                            child: Icon(
                              Icons.history,
                              size: 30,
                              color: HeaderColor,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "History",
                              style: TextStyle(fontSize: 16, color: Color(0xffE74C3C)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(Icons.navigate_next, color: Colors.black38),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: width - 60,
                      height: 1,
                      color: ChapBoderColor,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FavoriteScreen()),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 15, top: 15, bottom: 10),
                            child: Icon(
                              Icons.favorite_border,
                              size: 30,
                              color: HeaderColor,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Favorite",
                              style: TextStyle(fontSize: 16, color: Color(0xffE74C3C)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(Icons.navigate_next, color: Colors.black38),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: width - 60,
                      height: 1,
                      color: ChapBoderColor,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DownloadScreen(
                                    back: true,
                                  )),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 15, top: 15, bottom: 10),
                            child: Icon(
                              Icons.arrow_downward,
                              size: 30,
                              color: HeaderColor,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Download",
                              style: TextStyle(fontSize: 16, color: Color(0xffE74C3C)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(Icons.navigate_next, color: Colors.black38),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.only(top: 30),
            elevation: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: 60,
                width: width - 40,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        MyApp.platform.invokeMethod("rate");
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 10, top: 10, bottom: 10),
                            child: Icon(
                              Icons.comment,
                              size: 30,
                              color: HeaderColor,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Feedback",
                              style: TextStyle(fontSize: 16, color: Color(0xffE74C3C)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(Icons.navigate_next, color: Colors.black38),
                          )
                        ],
                      ),
                    ),
                    // Container(
                    //   width: width - 60,
                    //   height: 1,
                    //   color: ChapBoderColor,
                    // ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: <Widget>[
                    //     Padding(
                    //       padding: const EdgeInsets.only(right: 20, left: 10, top: 10, bottom: 10),
                    //       child: Icon(
                    //         Icons.favorite_border,
                    //         size: 30,
                    //         color: HeaderColor,
                    //       ),
                    //     ),
                    //     Expanded(
                    //       child: Text(
                    //         "Favorite",
                    //         style: TextStyle(fontSize: 16, color: Color(0xffE74C3C)),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(right: 10),
                    //       child: Icon(Icons.navigate_next, color: Colors.black38),
                    //     )
                    //   ],
                    // ),
                    // Container(
                    //   width: width - 60,
                    //   height: 1,
                    //   color: ChapBoderColor,
                    // ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: <Widget>[
                    //     Padding(
                    //       padding: const EdgeInsets.only(right: 20, left: 10, top: 10, bottom: 10),
                    //       child: Icon(
                    //         Icons.arrow_downward,
                    //         size: 30,
                    //         color: HeaderColor,
                    //       ),
                    //     ),
                    //     Expanded(
                    //       child: Text(
                    //         "Download",
                    //         style: TextStyle(fontSize: 16, color: Color(0xffE74C3C)),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.only(right: 10),
                    //       child: Icon(Icons.navigate_next, color: Colors.black38),
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
