import 'package:flutter/material.dart';
import 'package:flutter_bili_app/http/dao/ranking_dao.dart';
import 'package:flutter_bili_app/model/ranking_model.dart';
import 'package:flutter_bili_app/widget/hi_base_tab_state.dart';
import 'package:flutter_bili_app/widget/video_large_card.dart';

import '../model/home_model.dart';

class RankingTabPage extends StatefulWidget {

  String sort;
  RankingTabPage({Key? key,required this.sort}) : super(key: key);

  @override
  _RankingTabPageState createState() => _RankingTabPageState();
}

class _RankingTabPageState extends HiBaseTabState<RankingModel,VideoModel,RankingTabPage> {
  @override
  get contentChild => ListView.builder(
    physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index){
    return VideoLargeCard(videoModel:dataList[index]);
  },itemCount:dataList.length,controller: scrollController,);

  @override
  Future<RankingModel> getData(int pageIndex) async{
    return await RankingDao.get(widget.sort,pageIndex: pageIndex,pageSize: 10);
  }

  @override
  List<VideoModel> parseList(RankingModel result) {
    return result.list;
  }
}