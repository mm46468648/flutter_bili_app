import 'package:flutter/material.dart';

class LoginEffect extends StatefulWidget {

  final bool protect;
  LoginEffect({Key? key, required this.protect}) : super(key: key);

  @override
  _LoginEffectState createState() => _LoginEffectState();
}

class _LoginEffectState extends State<LoginEffect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(bottom: BorderSide(color: Colors.grey[100] ?? Colors.grey))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _image(true),
          Image.asset('assets/images/logo.png',height: 90,width: 90,),
          _image(false)
        ],
      ),
    );
  }

  _image(bool left) {
    var headLeft = widget.protect
        ? 'assets/images/head_left_protect.png'
        : 'assets/images/head_left.png';
    var headRight = widget.protect
        ? 'assets/images/head_right_protect.png'
        : 'assets/images/head_right.png';
    return Image(
      image: AssetImage(left ? headLeft : headRight),
      height: 90,
    );
  }
}