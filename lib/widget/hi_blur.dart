import 'dart:ui';

import 'package:flutter/material.dart';

class HiBlur extends StatelessWidget {

  Widget? child;
  double sigma;


  HiBlur({Key? key, this.child, this.sigma = 10});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(filter: ImageFilter.blur(sigmaX: sigma,sigmaY: sigma),child: Container(
      color: Colors.white10,
      child: child,
    ),);
  }
}
