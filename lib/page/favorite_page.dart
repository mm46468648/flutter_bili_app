import 'package:flutter/material.dart';
import 'package:flutter_bili_app/model/favorite_model.dart';
import 'package:flutter_bili_app/model/home_model.dart';
import 'package:flutter_bili_app/page/favorite_list_page.dart';
import 'package:flutter_bili_app/widget/hi_base_tab_state.dart';
import 'package:flutter_bili_app/widget/hi_tab.dart';
import 'package:flutter_bili_app/widget/status_bar.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          StatusBar(
            height: 50,
            color: Colors.white,
            statusStyle: StatusStyle.DARK_COMTENT,
            child: Center(
              child: Text('收藏',style: TextStyle(fontSize:16,color: Colors.black54 ),),
            ),
          ),
          FavoriteListPage()
        ],
      )
    );
  }
}
