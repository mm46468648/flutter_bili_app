import 'package:flutter/material.dart';
import 'package:flutter_bili_app/provider/theme_provider.dart';
import 'package:underline_indicator/underline_indicator.dart';

import 'package:hi_base/color.dart';
import 'package:provider/provider.dart';

class HiTab extends StatelessWidget {

  List<Widget> tabs;
  TabController? controller;
  double fontSize;
  double borderWidth;
  double insets;
  Color unselectedLabelColor;
  bool isScrollable;

  HiTab(this.tabs, {Key? key,this.controller, this.fontSize = 12, this.borderWidth = 3,
      this.insets = 15, this.unselectedLabelColor = Colors.black,this.isScrollable = true});

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var _unselectedLabelColor = themeProvider.isDark() ? Colors.white70 : unselectedLabelColor;


    return TabBar(
      tabs: tabs,
      controller: controller,
      isScrollable: true,
      unselectedLabelColor: _unselectedLabelColor,
      labelColor: primary,
      indicator: UnderlineIndicator(
          strokeCap: StrokeCap.round,
          borderSide: BorderSide(color: primary, width: borderWidth),
          insets: EdgeInsets.only(left: insets, right: insets)),
    );
  }
}
