import 'package:flutter/material.dart';
///页面状态异常管理
abstract class HiState<T extends StatefulWidget> extends State<T>{
  @override
  void setState(VoidCallback fn) {
    if(mounted){    //页面是否被装载
      super.setState(fn);
    }else{
      print("HiState:页面已销毁,setState不执行 ${toString()}");
    }
  }
}