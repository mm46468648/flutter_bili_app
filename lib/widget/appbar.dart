import 'package:flutter/material.dart';
import 'package:flutter_bili_app/widget/view_util.dart';
import 'package:hi_base/view_util.dart';

appBar(String title, String rightTitle, VoidCallback rightButtonClick, {key}) {
  return AppBar(
    centerTitle: false,
    titleSpacing: 0,
    leading: BackButton(),
    title: Text(
      title,
      style: TextStyle(fontSize: 18),
    ),
    actions: [
      InkWell(
        key: key,
        onTap: rightButtonClick,
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          alignment: Alignment.center,
          child: Text(
            rightTitle,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      )
    ],
  );
}

videoAppBar({VoidCallback? onBack}) {
  return Container(
    padding: const EdgeInsets.only(right: 8),
    decoration: BoxDecoration(gradient: blackLinearGradient(fromTop: true)),
    child: Row(
      children: [
        BackButton(
          color: Colors.white,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.live_tv_rounded,
              color: Colors.white,
              size: 20,
            ),
            Padding(
                padding: EdgeInsets.only(left: 12),
                child: Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white,
                  size: 20,
                )),
          ],
        )
      ],
    ),
  );
}
