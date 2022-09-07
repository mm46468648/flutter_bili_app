
import 'package:flutter/material.dart';
import 'package:flutter_bili_app/navigator/bottom_navigator.dart';
import 'package:flutter_bili_app/page/dark_mode_page.dart';
import 'package:flutter_bili_app/page/home_page.dart';
import 'package:flutter_bili_app/page/login_page.dart';
import 'package:flutter_bili_app/page/registration_page.dart';
import 'package:flutter_bili_app/page/video_detail_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../page/notice_page.dart';

typedef RouteChangeListener(RouteStatusInfo current,RouteStatusInfo? pre);

///创建页面包装类
pageWrap(Widget child){
  return MaterialPage(key: ValueKey(child.hashCode),child: child);
}

///获取routeStatus在页面栈中的位置
int getPageIndex(List<MaterialPage> pages,RouteStatus routeStatus){
  for(int i=0;i<pages.length;i++){
    MaterialPage page = pages[i];
    if(getStatus(page) == routeStatus){
      return i;
    }
  }

  return -1;

}

///自定义路由封装,路由状态
enum RouteStatus{ login,registration,home,detail,notice,darkMode,unknown}

///获取page对应的RouteStaus
RouteStatus getStatus(MaterialPage page){
  if(page.child is LoginPage){
    return RouteStatus.login;
  }else if(page.child is RegistrationPage){
    return RouteStatus.registration;
  }else if(page.child is BottomNavigator){
    return RouteStatus.home;
  }else if(page.child is VideoDetailPage){
    return RouteStatus.detail;
  }else if(page.child is NoticePage){
    return RouteStatus.notice;
  } else if(page.child is DarkModePage){
    return RouteStatus.darkMode;
  }else{
    return RouteStatus.unknown;
  }
}

class RouteStatusInfo{
  final RouteStatus routeStatus;
  final Widget page;

  RouteStatusInfo(this.routeStatus, this.page);
}

class HiNavigator extends _RouteJumpListener{

  HiNavigator._();
  static HiNavigator? _instance;
  static HiNavigator getInstance(){
    _instance ??= HiNavigator._();
    return _instance!;
  }

  RouteJumpListener? _routeJump;

  List<RouteChangeListener> _listeners = [];

  RouteStatusInfo? _current;

  //首页底部tab
  RouteStatusInfo? _bottomTab;

  void onBottomTabChange(int index,Widget page){
    _bottomTab = RouteStatusInfo(RouteStatus.home, page);
    _notify(_bottomTab!);
  }
  void registerRoutJump(RouteJumpListener routeJumpListener){
    _routeJump = routeJumpListener;
  }

  void addListener(RouteChangeListener listener){
    if(!_listeners.contains(listener)){
      _listeners.add(listener);
    }
  }

  void removeListener(RouteChangeListener listener){
    _listeners.remove(listener);
  }

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    if(_routeJump!=null && _routeJump?.onjumpTo!=null){
      _routeJump?.onjumpTo!(routeStatus,args: args ?? {});
    }
  }
  
  void notify(List<MaterialPage> currentPages,List<MaterialPage> prePages){
    if(currentPages == prePages) return;
    var current = RouteStatusInfo(getStatus(currentPages.last), currentPages.last.child);

    _notify(current);
  }

  void _notify(RouteStatusInfo current) {

    if( current.page is BottomNavigator && _bottomTab != null){
      //如果打开首页,则明确到首页具体的tab
      current = _bottomTab!;
    }
    print('hi_navigator:current:${current.page}');
    print('hi_navigator:pre:${_current?.page}');
    _listeners.forEach((listener) {
      listener(current,_current);
    });
    _current = current;
  }


  /// 打开 h5
  Future<bool> openH5(String url) async {
    var result = await canLaunchUrl(Uri.parse(url));
    if (result) {
      return await launchUrl(Uri.parse(url));
    } else {
      return Future.value(false);
    }
  }

}

abstract class _RouteJumpListener{
  void onJumpTo(RouteStatus routeStatus,{Map args});
}

typedef OnjumpTo = void Function(RouteStatus routeStatus,{Map args});

class RouteJumpListener{
  final OnjumpTo? onjumpTo;

  RouteJumpListener({this.onjumpTo});
}

