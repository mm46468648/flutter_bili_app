import 'package:flutter/material.dart';
import 'package:flutter_bili_app/model/home_model.dart';
import 'package:flutter_nested/flutter_nested.dart';
import 'package:hi_base/color.dart';
import 'package:flutter_bili_app/widget/hi_banner.dart';
import 'package:flutter_bili_app/widget/video_card.dart';
import 'package:hi_net/core/hi_error.dart';
import '../http/dao/home_dao.dart';
import '../widget/hi_base_tab_state.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  List<BannerModel>? bannerList;

  HomeTabPage({Key? key, required this.categoryName, this.bannerList})
      : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState
    extends HiBaseTabState<HomeModel, VideoModel, HomeTabPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _banner() {
    return Container(
      child: HiBanner(
          bannerList: widget.bannerList,
      )
    );
  }

  // @override
  // get contentChild => MasonryGridView.count(
  //       physics: const AlwaysScrollableScrollPhysics(),
  //       controller: scrollController,
  //       padding: EdgeInsets.only(left: 10, right: 10, top: 10),
  //       crossAxisCount: 2,
  //       itemCount: dataList.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         return VideoCard(
  //           videoModel: dataList[index],
  //         );
  //       },
  //     );

  @override
  get contentChild =>
      HiNestedScrollView(
          controller: scrollController,
          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
          headers: [
            if(widget.bannerList!=null)
              Padding(padding: EdgeInsets.only(bottom: 8),child:  _banner(),)
          ],
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.95),
          itemCount: dataList.length,
          itemBuilder: (BuildContext context, int index) {
            return VideoCard(videoModel: dataList[index]);
          }
  );

  @override
  Future<HomeModel> getData(int pageIndex) async {
    return await HomeDao.get(widget.categoryName,
        pageIndex: pageIndex, pageSize: 10);
  }

  @override
  List<VideoModel> parseList(HomeModel result) {
    return result.videoList;
  }
}
