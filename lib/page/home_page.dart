import 'package:flutter/material.dart';
import 'package:hi_base/hi_state.dart';
import 'package:flutter_bili_app/http/dao/home_dao.dart';
import 'package:flutter_bili_app/model/home_model.dart';
import 'package:flutter_bili_app/navigator/hi_navigator.dart';
import 'package:flutter_bili_app/page/home_tab_page.dart';
import 'package:flutter_bili_app/provider/theme_provider.dart';
import 'package:hi_base/color.dart';
import 'package:flutter_bili_app/widget/loading_container.dart';
import 'package:flutter_bili_app/widget/status_bar.dart';
import 'package:flutter_bili_app/widget/view_util.dart';
import 'package:hi_net/core/hi_error.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../widget/hi_tab.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  ValueChanged<int>? onJumpTo;

  HomePage({Key? key, this.onJumpTo}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage>
    with
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin,
        WidgetsBindingObserver {
  var listener;
  TabController? _controller;

  // List<String> tags = ["推荐","专题","专栏","双方","撒旦"];
  List<CategoryModel> categoryList = [];
  List<BannerModel> bannerList = [];

  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = TabController(length: categoryList.length, vsync: this);
    HiNavigator.getInstance().addListener(this.listener = (current, pre) {
      print('current: ${current.page}');
      print('pre: ${pre.page}');

      if ((widget == current.page || current.page is HomePage)) {
        print('打开了首页:onResume');
      } else if (widget == pre?.page || pre?.page is HomePage) {
        print('首页onPause');
      }
    });

    loadData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    print("didChangeAppLifecycleState: ${state}");
    switch (state) {
      case AppLifecycleState.inactive: //非激活状态,即将进入pause
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    HiNavigator.getInstance().removeListener(this.listener);
  }

  @override
  void didChangePlatformBrightness() {
    context.read<ThemeProvider>().darModeChange();
    super.didChangePlatformBrightness();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingContainer(
        child: Column(
          children: [
            StatusBar(
              height: 50,
              color: Colors.white,
              statusStyle: StatusStyle.DARK_COMTENT,
              child: _appBar(),
            ),
            Container(
              child: _tabBar(),
              decoration: bottomBoxShadow(context),
            ),
            Expanded(
                child: TabBarView(
              controller: _controller,
              children: categoryList.map((e) {
                return HomeTabPage(
                  categoryName: e.name,
                  bannerList: e.name == "推荐" ? bannerList : null,
                );
              }).toList(),
            ))
          ],
        ),
        isLoading: _isLoading,
      ),
    );
  }

  _tabBar() {
    return HiTab(
      categoryList.map((tab) {
        return Tab(
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Text(
              tab.name,
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      }).toList(),
      controller: _controller,
      unselectedLabelColor: Colors.black54,
    );
  }

  void loadData() async {
    try {
      HomeModel homeModel = await HomeDao.get("推荐");
      print("homeModel: ${homeModel}");

      if (homeModel.categoryList != null) {
        _controller =
            TabController(length: homeModel.categoryList!.length, vsync: this);
      }

      setState(() {
        categoryList = homeModel.categoryList ?? [];
        bannerList = homeModel.bannerList ?? [];
        _isLoading = false;
      });
    } on NeedAuth catch (e) {
      print(e);
      _isLoading = false;
    } on NeedLogin catch (e) {
      print(e);
      _isLoading = false;
    } on HiNetError catch (e) {
      print(e);
      _isLoading = false;
    }
  }

  @override
  bool get wantKeepAlive => true;

  _appBar() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (widget.onJumpTo != null) {
                widget.onJumpTo!(3);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: Image(
                height: 46,
                width: 46,
                image: AssetImage("assets/images/avatar.png"),
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 32,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                decoration: BoxDecoration(color: Colors.grey[100]),
              ),
            ),
          )),
          Icon(
            Icons.explore_outlined,
            color: Colors.grey,
          ),
          Padding(
              padding: EdgeInsets.only(left: 12),
              child: InkWell(
                onTap: () {
                  HiNavigator.getInstance().onJumpTo(RouteStatus.notice);
                },
                child: Icon(
                  Icons.mail_outlined,
                  color: Colors.grey,
                ),
              ))
        ],
      ),
    );
  }
}
