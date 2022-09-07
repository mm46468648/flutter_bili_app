import 'package:flutter/material.dart';
import 'package:flutter_bili_app/model/home_model.dart';
import 'package:flutter_bili_app/navigator/hi_navigator.dart';
import 'package:hi_base/format_util.dart';
import 'package:flutter_bili_app/widget/view_util.dart';
import 'package:hi_base/view_util.dart';

class VideoLargeCard extends StatelessWidget {

  VideoModel? videoModel;
  VideoLargeCard({Key? key,this.videoModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        HiNavigator.getInstance().onJumpTo(RouteStatus.detail,args: {'videoModel':videoModel});
      },
      child: Container(
        height: 106,
        margin: EdgeInsets.only(left: 15,right: 15,bottom: 5),
        padding: EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          border: borderLine(context)
        ),
        child: Row(
          children: [
            _itemImage(context),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  _itemImage(BuildContext context) {
    double height = 90;
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Stack(
        children: [
          cachedImage(videoModel?.cover ?? "",width: height * (16/9),height: height),
          Positioned(
            bottom: 5,right: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(2)
                ),
            child: Text(durationTransform(videoModel?.duration??0),style: TextStyle(color: Colors.white,fontSize: 10),),
          ))
        ],
      ),
    );
  }

  _buildContent() {
    return Expanded(child: Container(
      height: 90,
      padding: EdgeInsets.only(left: 8,top: 5,bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(videoModel?.title??"",style: TextStyle(color: Colors.black87,fontSize: 12),),
          _buildBottom()
        ],
      ),
    ));
  }

  _buildBottom() {
    return Column(
      children: [
        _owner(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ...smallIconText(Icons.ondemand_video, videoModel?.view),
                hiSpace(width: 5),
                ...smallIconText(Icons.list_alt, videoModel?.reply)
              ],
            ),
            Icon(Icons.more_vert_rounded,color: Colors.grey,size: 15,)
          ],

        )
      ],
    );
  }

  _owner() {
    var owner = videoModel?.owner;
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: Colors.grey,width: 1)
          ),
          child: Text(
            "UP",style: TextStyle(fontSize: 8,fontWeight: FontWeight.bold))
        ),
        hiSpace(width: 8),
        Text(owner?.name??"",style: TextStyle(fontSize: 11,color: Colors.grey))
      ],
    );
  }
}
