import 'package:chewie/chewie.dart' hide MaterialControls;
import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:flutter_bili_app/widget/view_util.dart';
import 'package:hi_base/view_util.dart';
import 'package:video_player/video_player.dart';

import 'appbar.dart';
import 'hi_video_controls.dart';

class VideoView extends StatefulWidget {
  String url;
  String? cover;
  bool autoPlay;
  bool looping;
  double aspectRatio;
  Widget? overlayUI;
  Widget? barrageUI;
  VideoView(this.url,
      {Key? key,
      this.cover,
      this.autoPlay = false,
      this.looping = false,
      this.aspectRatio = 16 / 9,this.overlayUI,this.barrageUI});

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  //播放器封面
  get _placeHolder => FractionallySizedBox(
    widthFactor: 1,
    child: cachedImage(widget.cover??""),
  );

  //进度条颜色
  get _progressColors => ChewieProgressColors(
    playedColor: primary,
    handleColor: primary,
    backgroundColor: Colors.grey,
    bufferedColor: primary[50] ?? Colors.white
  );
  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(widget.url);
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: widget.aspectRatio,
        autoPlay: widget.autoPlay,
        looping: widget.looping,
        placeholder: _placeHolder,
        materialProgressColors: _progressColors,
        customControls: MaterialControls(
          overlayUI: widget.overlayUI,
          showBigPlayIcon: false,
          showLoadingOnInitialize: false,
          bottomGradient: blackLinearGradient(),
          barrageUI: widget.barrageUI,
        )
    );
  }

  @override
  void dispose() {
    super.dispose();

    _videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double playerHeight = screenWidth / widget.aspectRatio;

    return Container(
      width: screenWidth,
      height: playerHeight,
      color: Colors.grey,
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }
}
