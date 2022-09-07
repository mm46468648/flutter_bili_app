import 'package:flutter/material.dart';
import 'package:flutter_bili_app/http/dao/favorite_dao.dart';
import 'package:flutter_bili_app/widget/video_large_card.dart';

import '../model/favorite_model.dart';
import '../model/home_model.dart';
import '../widget/hi_base_tab_state.dart';
import '../widget/status_bar.dart';

class FavoriteListPage extends StatefulWidget {
  FavoriteListPage({Key? key}) : super(key: key);

  @override
  _FavoriteListPageState createState() => _FavoriteListPageState();
}

class _FavoriteListPageState
    extends HiBaseTabState<FavoriteModel, VideoModel, FavoriteListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StatusBar(
            height: 50,
            color: Colors.white,
            statusStyle: StatusStyle.DARK_COMTENT,
            child: Center(
              child: Text(
                '收藏',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
          ),
          Expanded(child: super.build(context)),
        ],
      ),
    );
  }

  @override
  get contentChild => ListView.builder(
        padding: EdgeInsets.all(0),
        itemCount: dataList.length,
        itemBuilder: (context, index) {
            return VideoLargeCard(
              videoModel: dataList[index],
            );
        },
      );

  @override
  Future<FavoriteModel> getData(int pageIndex) async {
    return await FavoriteDao.getFavoriteList(pageIndex, 10);
  }

  @override
  List<VideoModel> parseList(FavoriteModel result) {
    return result.list ?? [];
  }
}
