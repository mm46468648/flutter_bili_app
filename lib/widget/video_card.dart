import 'package:flutter/material.dart';
import 'package:flutter_bili_app/model/home_model.dart';
import 'package:flutter_bili_app/navigator/hi_navigator.dart';
import 'package:hi_base/format_util.dart';
import 'package:flutter_bili_app/widget/view_util.dart';
import 'package:hi_base/view_util.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';

class VideoCard extends StatelessWidget {
  VideoModel? videoModel;

  VideoCard({Key? key, this.videoModel});

  @override
  Widget build(BuildContext context) {

    var themeProvider = context.watch<ThemeProvider>();
    var textColor = themeProvider.isDark() ? Colors.white70 : Colors.black87;

    return InkWell(
      onTap: () {
        print(videoModel?.url);
        HiNavigator.getInstance().onJumpTo(RouteStatus.detail,args: {'videoModel':videoModel});
      },
      child: SizedBox(
        height: 200,
        child: Card(
          margin: EdgeInsets.only(left: 4, right: 4, bottom: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_itemImage(context),_infoText(textColor)],
            ),
          ),
        ),
      ),
    );
  }

  _itemImage(context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Stack(
      children: [
        cachedImage(
          videoModel?.cover ?? "",
          height: 120,
          width: size.width / 2 - 20,
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 5),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black54, Colors.transparent])),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconText(Icons.ondemand_video, videoModel?.view ?? 0),
                  _iconText(Icons.favorite_border, videoModel?.favorite ?? 0),
                  _iconText(null, videoModel?.duration ?? 0),
                ],
              ),
            ))
      ],
    );
  }

  _iconText(IconData? iconData, int count) {
    String views = "";
    if (iconData != null) {
      views = countFormat(count);
    } else {
      views = durationTransform(videoModel?.duration ?? 0);
    }

    return Row(
      children: [
        if(iconData != null)
          Icon(iconData, color: Colors.white, size: 12,),
        Padding(padding: EdgeInsets.only(left: 3),
          child: Text(
            views, style: TextStyle(color: Colors.white, fontSize: 10),),)
      ],
    );
  }

  _infoText(Color textColor){
    return Expanded(child: Container(
      padding: EdgeInsets.only(top: 5,right: 8,bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(videoModel?.title??"",maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12,color: textColor),),
          _owner(textColor)
        ],
      ),
    ));
  }

  _owner(Color textColor) {
    var owner = videoModel?.owner;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:cachedImage(owner?.face??"",width: 24,height: 24,),
            ),
            Padding(padding: EdgeInsets.only(left: 8),child: Text(owner?.name ?? "",style: TextStyle(color: textColor,fontSize: 11),),)
          ],
        ),
        Icon(Icons.more_vert_sharp,size: 15,color: Colors.grey,)
      ],
    );
  }
}
