import 'package:flutter/material.dart';
import 'package:flutter_bili_app/provider/theme_provider.dart';
import 'package:hi_base/color.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
// import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:provider/provider.dart';

enum StatusStyle{
  LIGHT_COMTENT,DARK_COMTENT
}

class StatusBar extends StatefulWidget {
  StatusStyle? statusStyle;
  final Color? color;
  double height = 0;
  final Widget? child;


  StatusBar({Key? key,this.statusStyle, this.color, this.height = 0, this.child});

  @override
  State<StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> {

  var _color;
  late StatusStyle statusStyle;


  @override
  Widget build(BuildContext context) {

    var themeProvider = context.watch<ThemeProvider>();
    if(themeProvider.isDark()){
      _color = HiColor.dark_bg;
      statusStyle = StatusStyle.LIGHT_COMTENT;
    }else{
      _color = widget.color;
      statusStyle = widget.statusStyle ?? StatusStyle.LIGHT_COMTENT;
    }

    _statusBarInit();

    //状态栏高度
    var top = MediaQuery.of(context).padding.top;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: top + widget.height,
      child: widget.child,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: _color),
    );
  }

  void _statusBarInit(){
    // FlutterStatusbarManager.setColor(color,animated: false);
    // FlutterStatusbarManager.setStyle(statusStyle == StatusStyle.DARK_COMTENT?StatusBarStyle.DARK_CONTENT:StatusBarStyle.LIGHT_CONTENT);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(statusStyle == StatusStyle.LIGHT_COMTENT);
  }
}
