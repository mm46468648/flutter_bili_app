import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bili_app/db/hi_cache.dart';
import 'package:flutter_bili_app/http/dao/login_dao.dart';
import 'package:flutter_bili_app/http/request/notice_request.dart';
import 'package:flutter_bili_app/page/dark_mode_page.dart';
import 'package:flutter_bili_app/page/home_page.dart';
import 'package:flutter_bili_app/page/login_page.dart';
import 'package:flutter_bili_app/page/notice_page.dart';
import 'package:flutter_bili_app/page/registration_page.dart';
import 'package:flutter_bili_app/page/video_detail_page.dart';
import 'package:flutter_bili_app/provider/hi_provider.dart';
import 'package:flutter_bili_app/provider/theme_provider.dart';
import 'package:flutter_bili_app/util/hi_defend.dart';
import 'package:hi_base/color.dart';
import 'package:flutter_bili_app/util/toast.dart';
import 'package:provider/provider.dart';
import 'model/home_model.dart';
import 'navigator/bottom_navigator.dart';
import 'navigator/hi_navigator.dart';

void main() {
  HiDefend().run(const BiliApp());
}

class BiliApp extends StatefulWidget {
  const BiliApp({Key? key}) : super(key: key);

  @override
  State<BiliApp> createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  BiliRouteDelegate _routeDelegate = BiliRouteDelegate();

  // BiliRouteInformationParser _routeInformationParser = BiliRouteInformationParser();

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<HiCache>(
        future: HiCache.preInit(),
        builder: (BuildContext context, AsyncSnapshot<HiCache> snapshot) {
          var widget = snapshot.connectionState == ConnectionState.done
              ? Router(routerDelegate: _routeDelegate)
              : Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );

          return MultiProvider(providers: topProviders,child:Consumer<ThemeProvider>(builder:( BuildContext context,
              ThemeProvider themeProvider,
              Widget? child,){
            return MaterialApp(
              home: widget,
              theme: themeProvider.getTheme(),
              darkTheme: themeProvider.getTheme(isDarkMode: true),
              themeMode: themeProvider.getThemeMode(),
            );
          } ,));
        });
  }
}

class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRoutePath> {
  GlobalKey<NavigatorState> navigatorKey;

  BiliRouteDelegate() : navigatorKey = GlobalKey() {
    HiNavigator.getInstance().registerRoutJump(
        RouteJumpListener(onjumpTo: (RouteStatus routeStatus, {Map? args}) {
      _routeStatus = routeStatus;
      if (routeStatus == RouteStatus.detail) {
        this.videoModel = args?['videoModel'];
      }
      notifyListeners();
    }));
  }

  List<MaterialPage> pages = [];

  VideoModel? videoModel;

  BiliRoutePath? path;

  RouteStatus _routeStatus = RouteStatus.home;

  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    } else {
      return _routeStatus;
    }
  }

  bool get hasLogin => LoginDao.getBoardingPass() != "";

  @override
  Widget build(BuildContext context) {
    //管理路由堆栈
    var index = getPageIndex(pages, routeStatus);
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      //要打开的页面在栈中已经存在,则将该页面和它上面的所有页面进行出栈
      //tips 具体规则可以根据需要进行调整,这里要求栈中只允许有一个同样的页面的实例
      tempPages = tempPages.sublist(0, index);
    }

    var page;
    if (routeStatus == RouteStatus.home) {
      //跳转首页的时候将栈中其他页面进行出栈,因为首页不可回退
      pages.clear();
      page = pageWrap(BottomNavigator());
    } else if (routeStatus == RouteStatus.detail && videoModel != null) {
      page = pageWrap(VideoDetailPage(videoModel: videoModel!));
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWrap(RegistrationPage());
    } else if (routeStatus == RouteStatus.notice) {
      page = pageWrap(NoticePage());
    } else if (routeStatus == RouteStatus.darkMode) {
      page = pageWrap(DarkModePage());
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrap(LoginPage());
    }

    //重新创建一个新的数组
    tempPages = [...tempPages, page];

    HiNavigator.getInstance().notify(tempPages, pages);

    pages = tempPages;

    return WillPopScope(
      //fix Andorid物理返回键,无法返回上一页的问题
      onWillPop: () async =>
          !(await navigatorKey.currentState?.maybePop() ?? false),
      child: Navigator(
        key: navigatorKey,
        pages: pages,
        onPopPage: (route, result) {
          if (route.settings is MaterialPage) {
            //登录页未登录返回拦截
            if ((route.settings as MaterialPage).child is LoginPage) {
              if (!hasLogin) {
                showWarnToast("请先登录");
              }
            }
          }

          var tempages = [...pages];
          pages.removeLast();
          HiNavigator.getInstance().notify(pages, tempages);

          if (!route.didPop(result)) {
            return false;
          }
          return true;
        },
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(BiliRoutePath configuration) async {}
}

class BiliRouteInformationParser extends RouteInformationParser<BiliRoutePath> {
  @override
  Future<BiliRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    var uri = Uri.parse(routeInformation.location ?? "");
    if (uri.pathSegments.length == 0) {
      return BiliRoutePath.home();
    }

    return BiliRoutePath.detail();
  }
}

///定义路由数据,path
class BiliRoutePath {
  String? location;

  BiliRoutePath.home() : location = "/";

  BiliRoutePath.detail() : location = "/detail";
}
