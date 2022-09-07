import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';

class LoginButton extends StatelessWidget {

  String? title;
  bool? enable;
  VoidCallback? voidCallback;


  LoginButton(this.title, {Key? key, this.enable = false, this.voidCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        height: 45,
        onPressed: enable?? false ?voidCallback:null,
        disabledColor:primary[50] ,
        color: primary,
        child: Text(title ?? "",style: TextStyle(color: Colors.white,fontSize: 16)),
      ),
    );
  }
}
