import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hi_barrage/barrage/hi_barrage.dart';
import 'package:hi_net/core/hi_error.dart';
import 'package:flutter_bili_app/http/dao/favorite_dao.dart';
import 'package:flutter_bili_app/http/dao/video_detail_dao.dart';
import 'package:flutter_bili_app/util/toast.dart';
import 'package:flutter_bili_app/widget/appbar.dart';
import 'package:flutter_bili_app/widget/hi_tab.dart';
import 'package:flutter_bili_app/widget/video_large_card.dart';
import 'package:flutter_overlay/flutter_overlay.dart';

import '../http/dao/login_dao.dart';
import '../model/home_model.dart';
import '../model/video_detail_model.dart';
import '../util/hi_constants.dart';
import '../widget/barrage_input.dart';
import '../widget/expandable_content.dart';
import '../widget/status_bar.dart';
import '../widget/video_card.dart';
import '../widget/video_header.dart';
import '../widget/video_toolbar.dart';
import '../widget/video_view.dart';

class VideoDetailPage extends StatefulWidget {
  VideoModel videoModel;

  VideoDetailPage({Key? key, required this.videoModel}) : super(key: key);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  List tabs = ['简介', '评论288'];
  late TabController _controller;
  VideoDetailModel? videoDetailModel;
  VideoModel? videoModel;
  List<VideoModel> videoList = [];

  // HiSocket? _hiSocket;
  var _barrageKey = GlobalKey<HiBarrageState>();

  @override
  void initState() {
    super.initState();
    // _initSocket();
    videoModel = widget.videoModel;
    _controller = TabController(length: tabs.length, vsync: this);
    _loadDetail();
  }

  @override
  void dispose() {
    _controller.dispose();
    // _hiSocket?.close();
    super.dispose();
  }

  _buildVideoView() {
    return VideoView(
      videoModel?.url ?? "",
      cover: videoModel?.cover,
      overlayUI: videoAppBar(),
      barrageUI: HiBarrage(
        key: _barrageKey,
        vid: videoModel?.vid ?? "",
        autoPlay: true,
        headers: HiConstants.headers(),
      ),
    );
  }

  _buildTabNavigation() {
    return Material(
      elevation: 5,
      shadowColor: Colors.grey[100],
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        height: 39,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_tabBar(), _buildBarrageBtn()],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: videoModel?.url != null
          ? Column(
              children: [
                StatusBar(
                  color: Colors.black,
                  statusStyle: StatusStyle.LIGHT_COMTENT,
                ),
                _buildVideoView(),
                _buildTabNavigation(),
                Flexible(
                    child: TabBarView(
                  controller: _controller,
                  children: [
                    _buildDetailList(),
                    Container(
                      child: Text('敬请期待'),
                    )
                  ],
                ))
              ],
            )
          : Container(),
    );
  }

  _tabBar() {
    return HiTab(
      tabs.map((e) {
        return Tab(
          text: e,
        );
      }).toList(),
      controller: _controller,
    );
  }

  _buildDetailList() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: [...buildContent(), ..._buildVideoList()],
    );
  }

  buildContent() {
    return [
      Container(
        child: VideoHeader(
          owner: videoModel?.owner,
        ),
      ),
      ExpandableContent(
        videoInfo: videoModel,
      ),
      VideoToolBar(
        detailInfo: videoDetailModel,
        videoInfo: videoModel,
        onLike: _doLike,
        onUnLike: _doUnLike,
        onCoin: _doOnCoin,
        onFavorite: _doOnFavorite,
        onShare: _doOnShare,
      )
    ];
  }

  Future<void> _loadDetail() async {
    try {
      VideoDetailModel detail = await VideoDetailDao.get(videoModel?.vid ?? "");
      setState(() {
        videoDetailModel = detail;
        videoModel = detail.videoInfo;
        videoList = detail.videoList;
      });
    } on HiNetError catch (e) {
      print(e);
    }
  }

  _doLike() {}

  _doUnLike() {}

  _doOnCoin() {}

  _doOnFavorite() async {
    try {
      var result = await FavoriteDao.favorite(
          videoModel?.vid ?? "", !(videoDetailModel?.isFavorite ?? false));
      print(result);
      videoDetailModel?.isFavorite = !(videoDetailModel?.isFavorite ?? false);
      if (videoDetailModel?.isFavorite == true) {
        videoModel?.favorite = videoModel?.favorite ?? 0 + 1;
      } else {
        videoModel?.favorite = videoModel?.favorite ?? 1 - 1;
      }
      setState(() {
        videoModel = videoModel;
        videoDetailModel = videoDetailModel;
      });

      showToast(result['msg']);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  _doOnShare() {}

  _buildVideoList() {
    return videoList.map((e) => VideoLargeCard(videoModel: e)).toList();
  }

  _buildBarrageBtn() {
    return InkWell(
      onTap: () {
        HiOverlay.show(context,
            child: BarrageInput(
              onTabClose: () {},
            )).then((value) {
          print("input-------$value");
          _barrageKey.currentState?.send(value);
        });
      },
      child: Padding(
        padding: EdgeInsets.only(right: 20),
        child: Icon(
          Icons.live_tv_rounded,
          color: Colors.grey,
        ),
      ),
    );
  }
}
