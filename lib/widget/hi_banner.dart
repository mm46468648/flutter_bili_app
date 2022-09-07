import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili_app/model/home_model.dart';
import 'package:flutter_bili_app/navigator/hi_navigator.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';


class HiBanner extends StatelessWidget {
  final List<BannerModel>? bannerList;
  final double? bannerHeight;
  final EdgeInsetsGeometry? padding;

  HiBanner({Key? key, this.bannerList, this.bannerHeight = 160, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: bannerHeight,
      child: _banner(),
    );
  }

  _banner() {
    var right = 10 + (padding?.horizontal ?? 0) / 2;
    return Swiper(
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return _image(bannerList?[index]);
        },
        itemCount: bannerList?.length ?? 0,
      pagination: SwiperPagination(
        alignment: Alignment.bottomRight,
        margin: EdgeInsets.only(right: right,bottom: 10),
        builder: DotSwiperPaginationBuilder(
          color: Colors.white60,size: 6,activeSize: 6
        )
      ),
    );
  }

  _image(BannerModel? bannerModel) {
    return InkWell(
      onTap: (){
        _handleClick(bannerModel);
      },
      child: Container(
        padding: padding,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          child: Image.network(
            bannerModel?.cover ?? "",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  _handleClick(BannerModel? bannerModel) {
    if(bannerModel?.type == "video"){
      HiNavigator.getInstance().onJumpTo(RouteStatus.detail,args: {"videoModel":VideoModel(vid: bannerModel?.url??"")});
      print("bannerType:${bannerModel?.type}----videModel:${bannerModel?.url}");
    }else{
      print("type:${bannerModel?.type} -----url:${bannerModel?.url}");
    }
  }
}
