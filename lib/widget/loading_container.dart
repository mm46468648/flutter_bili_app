import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingContainer extends StatelessWidget {

  final Widget? child;
  bool? isLoading;
  ///加载动画是否覆盖在原有界面上
  bool? cover;


  LoadingContainer({Key? key, this.child,this.isLoading, this.cover = false});

  get _loadingView {
    return Center(
      child: Lottie.asset("assets/json/loading.json"),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(cover == true){
      return Stack(
        children: [
          child ?? Container(),isLoading?? false ? _loadingView:Container()
        ],
      );
    }else{
      return isLoading?? false ? _loadingView:child;
    }
  }
}
