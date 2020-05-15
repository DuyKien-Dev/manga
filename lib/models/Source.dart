class Source {
  String country;
  List<Server> server;

  Source({this.country, this.server});

  Source.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    if (json['server'] != null) {
      server = new List<Server>();
      json['server'].forEach((v) {
        server.add(new Server.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    if (this.server != null) {
      data['server'] = this.server.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Server {
  String popular;
  String index;
  String taglist;
  String keyword;
  bool istick = false;
  Server({this.popular, this.index, this.taglist, this.keyword});

  Server.fromJson(Map<String, dynamic> json) {
    popular = json['popular'];
    index = json['index'];
    taglist = json['taglist'];
    keyword = json['keyword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['popular'] = this.popular;
    data['index'] = this.index;
    data['taglist'] = this.taglist;
    data['keyword'] = this.keyword;
    return data;
  }
  
}
List arr = [
  {
    "country": "English",
    "server": [
      {
        "popular": "http://k.imanga.co/mangakakalot/tags/Most%20Popular/p0.gz",
        "index": "http://k.imanga.co/mangakakalot/indexs.gz",
        "taglist": "http://k.imanga.co/mangakakalot/taglist.gz",
        "keyword": "Mangakakalot"
      },
      {
        "popular": "http://kmanga.oss-us-west-1.aliyuncs.com/mangapark/tags/Most%20Popular/p0.gz",
        "index": "http://kmanga.oss-us-west-1.aliyuncs.com/mangapark/indexs.gz",
        "taglist": "http://kmanga.oss-us-west-1.aliyuncs.com/mangapark/taglist.gz",
        "keyword": "Mangapark"
      },
      {
        "popular": "http://hmanga.oss-cn-hongkong.aliyuncs.com/mangafox/tags/Most%20Popular/p0.gz",
        "index": "http://hmanga.oss-cn-hongkong.aliyuncs.com/mangafox/indexs.gz",
        "taglist": "http://hmanga.oss-cn-hongkong.aliyuncs.com/mangafox/taglist.gz",
        "keyword": "Mangafox"
      },
    ]
  },
  {
    "country": "China",
    "server": [
      {
        "popular": "http://imanga.oss-cn-qingdao.aliyuncs.com/dmzj/tags/2d267dd812de2b93/p0.gz",
        "index": "http://imanga.oss-cn-qingdao.aliyuncs.com/dmzj/indexs.gz",
        "taglist": "http://imanga.oss-cn-qingdao.aliyuncs.com/dmzj/taglist.gz",
        "keyword": "dmzj"
      },
      {
        "popular": "http://imanga.oss-cn-qingdao.aliyuncs.com/733dm/tags/2d267dd812de2b93/p0.gz",
        "index": "http://imanga.oss-cn-qingdao.aliyuncs.com/733dm/indexs.gz",
        "taglist": "http://imanga.oss-cn-qingdao.aliyuncs.com/733dm/taglist.gz",
        "keyword": "733dm"
      }
    ]
  },
  {
    "country": "pyccknn",
    "server": [
      {
        "popular": "http://kmanga.oss-us-west-1.aliyuncs.com/mangachan/tags/930ff42f54efb301/p0.gz",
        "index": "http://kmanga.oss-us-west-1.aliyuncs.com/mangachan/indexs.gz",
        "taglist": "http://kmanga.oss-us-west-1.aliyuncs.com/mangachan/taglist.gz",
        "keyword": "Mangachan"
      },
      {
        "popular": "http://imanga.oss-cn-qingdao.aliyuncs.com/readmanga/tags/930ff42f54efb301/p0.gz",
        "index": "http://imanga.oss-cn-qingdao.aliyuncs.com/readmanga/indexs.gz",
        "taglist": "http://imanga.oss-cn-qingdao.aliyuncs.com/readmanga/taglist.gz",
        "keyword": "Readmanga"
      },
      {
        "popular": "http://imanga.oss-cn-qingdao.aliyuncs.com/admanga/tags/930ff42f54efb301/p0.gz",
        "index": "http://imanga.oss-cn-qingdao.aliyuncs.com/admanga/indexs.gz",
        "taglist": "http://imanga.oss-cn-qingdao.aliyuncs.com/admanga/taglist.gz",
        "keyword": "Admanga"
      },
      {
        "popular": "http://imanga.oss-cn-qingdao.aliyuncs.com/yagami/tags/930ff42f54efb301/p0.gz",
        "index": "http://imanga.oss-cn-qingdao.aliyuncs.com/yagami/indexs.gz",
        "taglist": "http://imanga.oss-cn-qingdao.aliyuncs.com/yagami/taglist.gz",
        "keyword": "yagami"
      }
    ]
  },
  {
    "country": "India",
    "server": [
      {
        "popular": "http://imanga.oss-cn-qingdao.aliyuncs.com/mangaae/tags/17d07bcbb0ea7ca6/p0.gz",
        "index": "http://imanga.oss-cn-qingdao.aliyuncs.com/mangaae/indexs.gz",
        "taglist": "http://imanga.oss-cn-qingdao.aliyuncs.com/mangaae/taglist.gz",
        "keyword": "Mangaae"
      },
    ]
  },
  {
    "country": "indonesia",
    "server": [
      {
        "popular": "http://hmanga.oss-cn-hongkong.aliyuncs.com/komikid/tags/e97738e110fd7b19/p0.gz",
        "index": "http://hmanga.oss-cn-hongkong.aliyuncs.com/komikid/indexs.gz",
        "taglist": "http://hmanga.oss-cn-hongkong.aliyuncs.com/komikid/taglist.gz",
        "keyword": "Komikid"
      }
      // {
      //   "popular": "http://hmanga.oss-cn-hongkong.aliyuncs.com/pecintakomik/tags/e97738e110fd7b19/p0.gz",
      //   "index": "http://hmanga.oss-cn-hongkong.aliyuncs.com/pecintakomik/indexs.gz",
      //   "taglist": "http://hmanga.oss-cn-hongkong.aliyuncs.com/pecintakomik/taglist.gz",
      //   "keyword": "Pecintakomik"
      // }
    ]
  },
  {
    "country": "espa",
    "server": [
      {
        "popular": "http://hmanga.oss-cn-hongkong.aliyuncs.com/9manga_es/tags/0a88abe4772dbc5e/p0.gz",
        "index": "http://hmanga.oss-cn-hongkong.aliyuncs.com/9manga_es/indexs.gz",
        "taglist": "http://hmanga.oss-cn-hongkong.aliyuncs.com/9manga_es/taglist.gz",
        "keyword": "9manga_es"
      },
    ]
  },
  {
    "country": "italiano",
    "server": [
      {
        "popular": "http://hmanga.oss-cn-hongkong.aliyuncs.com/9manga_it/tags/0a88abe4772dbc5e/p0.gz",
        "index": "http://hmanga.oss-cn-hongkong.aliyuncs.com/9manga_it/indexs.gz",
        "taglist": "http://hmanga.oss-cn-hongkong.aliyuncs.com/9manga_it/taglist.gz",
        "keyword": "9manga_it"
      }
    ]
  },
  {
    "country": "Tieng viet",
    "server": [
      {
        "popular": "http://hmanga.oss-cn-hongkong.aliyuncs.com/blogtruyen/tags/151bbb319023baf7/p0.gz",
        "index": "http://hmanga.oss-cn-hongkong.aliyuncs.com/blogtruyen/indexs.gz",
        "taglist": "http://hmanga.oss-cn-hongkong.aliyuncs.com/blogtruyen/taglist.gz",
        "keyword": "Blogtruyen"
      },
      {
        "popular": "http://hmanga.oss-cn-hongkong.aliyuncs.com/manga24h/tags/151bbb319023baf7/p0.gz",
        "index": "http://hmanga.oss-cn-hongkong.aliyuncs.com/manga24h/indexs.gz",
        "taglist": "http://hmanga.oss-cn-hongkong.aliyuncs.com/manga24h/taglist.gz",
        "keyword": "Manga24h"
      },
      {
        "popular": "http://hmanga.oss-cn-hongkong.aliyuncs.com/truyentranhtuan/tags/e97738e110fd7b19/p0.gz",
        "index": "http://hmanga.oss-cn-hongkong.aliyuncs.com/truyentranhtuan/indexs.gz",
        "taglist": "http://hmanga.oss-cn-hongkong.aliyuncs.com/truyentranhtuan/taglist.gz",
        "keyword": "Truyentranhtuan"
      },
    ]
  },
  {
    "country": "Potugus",
    "server": [
      {
        "popular": "http://k.imanga.co/mangahost/tags/Most%20Popular/p0.gz",
        "index": "http://k.imanga.co/mangahost/indexs.gz",
        "taglist": "http://k.imanga.co/mangahost/taglist.gz",
        "keyword": "Mangahost"
      },
      {
        "popular": "http://hmanga.oss-cn-hongkong.aliyuncs.com/9manga_prc/tags/b8186fb02fa0dfc1/p0.gz",
        "index": "http://hmanga.oss-cn-hongkong.aliyuncs.com/9manga_prc/indexs.gz",
        "taglist": "http://hmanga.oss-cn-hongkong.aliyuncs.com/9manga_prc/taglist.gz",
        "keyword": "9manga_prc"
      }
    ]
  },
  {
    "country": "Deutsch",
    "server": [
      {
        "popular": "http://imanga.oss-cn-qingdao.aliyuncs.com/9manga_ge/tags/a58d4f16a25c416b/p0.gz",
        "index": "http://imanga.oss-cn-qingdao.aliyuncs.com/9manga_ge/indexs.gz",
        "taglist": "http://imanga.oss-cn-qingdao.aliyuncs.com/9manga_ge/taglist.gz",
        "keyword": "9manga_ge"
      }
    ]
  }
];
List<Source> getSource() {
  List<Source> list = new List<Source>();
  for (final json in arr) {
    list.add(Source.fromJson(json));
  }
  return list;
}
