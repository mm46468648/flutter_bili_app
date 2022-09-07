import 'package:flutter/material.dart';
import 'package:flutter_bili_app/http/dao/profile_dao.dart';
import 'package:flutter_bili_app/model/profile_model.dart';
import 'package:flutter_bili_app/widget/benefit_card.dart';
import 'package:flutter_bili_app/widget/hi_blur.dart';
import 'package:flutter_bili_app/widget/view_util.dart';
import 'package:hi_base/view_util.dart';

import 'package:hi_net/core/hi_error.dart';
import '../widget/course_card.dart';
import '../widget/dark_mode_item.dart';
import '../widget/hi_banner.dart';
import '../widget/hi_flexible_header.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  ProfileModel? profileModel;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            controller: _controller,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[_buildAppBar()];
            },
            body: ListView(
              padding: EdgeInsets.only(top: 5),
                children: [
                  ...buildContentList()
                ]
            )
        )
    );
  }

  void _loadData() async {
    try {
      ProfileModel result = await ProfileDao.get();

      setState(() {
        profileModel = result;
      });
      print(result);
    } on NeedAuth catch (e) {
      print(e);
    } on HiNetError catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      //定义滚动空间
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        titlePadding: EdgeInsets.only(left: 0),
        background: Stack(
          children: [
            Positioned.fill(child: cachedImage(profileModel?.face ?? "")),
            Positioned.fill(
                child: HiBlur(
              sigma: 20,
            )),
            Positioned(child: _buildProfileTab(),bottom: 0,left: 0,right: 0,)
          ],
        ),
        title: _buildHeader(),
      ),
    );
  }

  _buildHeader() {
    if (profileModel == null) return Container();
    return HiFlexibleHeader(
      name: profileModel?.name ?? "",
      face: profileModel?.face ?? "",
      controller: _controller,
    );
  }

  @override
  bool get wantKeepAlive => true;

  buildContentList() {
    if (profileModel == null) return [];
    return [
      _buildBanner(),
      CourseCard(courseList: profileModel?.courseList ?? []),
      BenefitCard(benefitList: profileModel?.benefitList ?? []),
      DarkModeItem()
    ];
  }

  _buildProfileTab(){
    if (profileModel == null) return Container();
    return Container(
      padding: EdgeInsets.only(top: 5,bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white54
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconText('收藏',profileModel?.favorite ?? 0),
          _buildIconText('点赞',profileModel?.like ?? 0),
          _buildIconText('浏览',profileModel?.browsing ?? 0),
          _buildIconText('金币',profileModel?.coin ?? 0),
          _buildIconText('粉丝',profileModel?.fans ?? 0),
        ],
      ),
    );

  }

  _buildBanner() {
    return HiBanner(
      bannerList: profileModel?.bannerList ?? [],
      bannerHeight: 120,
      padding: EdgeInsets.only(left: 10,right: 10)
    );
  }

  _buildIconText(String s, int favorite) {
    return Column(
      children: [
        Text('$favorite',style: TextStyle(fontSize: 15,color: Colors.black87),),
        Text(s,style: TextStyle(fontSize: 12,color: Colors.grey[600]),),
      ],
    );
  }
}
