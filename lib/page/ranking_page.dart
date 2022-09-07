import 'package:flutter/material.dart';
import 'package:flutter_bili_app/page/ranking_tab_page.dart';
import 'package:flutter_bili_app/widget/hi_tab.dart';

import '../widget/status_bar.dart';
import '../widget/view_util.dart';

class RankingPage extends StatefulWidget {
  RankingPage({Key? key}) : super(key: key);

  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> with TickerProviderStateMixin{

  // List tabs = ['最热','最新','收藏'];
  static const TABS = [{'key':'like','name':'最热'},{'key':'pubdate','name':'最新'},{'key':'favorite','name':'收藏'}];
  TabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: TABS.length,vsync: this);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildNavigationBar(context),
          _buildTabView()
        ],
      ),
    );
  }

  _buildNavigationBar(BuildContext context){
    return StatusBar(
      height: 50,
      color: Colors.white,
      statusStyle: StatusStyle.DARK_COMTENT,
      child: Container(
        child: _hiTab(),
        alignment: Alignment.center,
        decoration: bottomBoxShadow(context),
      ),
    );

  }

  _hiTab() {
    return HiTab(TABS.map((e) => Tab(
      text: e['name'],
    )).toList(),controller: _controller,fontSize: 16,borderWidth: 3,unselectedLabelColor: Colors.black54,);
  }

  _buildTabView() {
    return Flexible(child: TabBarView(
      controller: _controller,
      children: TABS.map((e){
        return RankingTabPage(sort: e['key']??"",);
      }).toList()
    ));
  }
}