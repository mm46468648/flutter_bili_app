import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
class LoginInput extends StatefulWidget {
  final String? title;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? focusChanged;
  final bool? lineStretch;
  final bool? obscureText;
  final TextInputType? keyboardType;

  const LoginInput(this.title, this.hint,{Key? key,  this.onChanged, this.focusChanged, this.lineStretch = false, this.obscureText = false, this.keyboardType}) : super(key: key);

  @override
  State<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {

  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      print("has focus:${focusNode.hasFocus}");
      if(widget.focusChanged!=null){
        widget.focusChanged!(focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    focusNode.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Row(children: [
            Container(
              padding: EdgeInsets.only(left: 15),
              width: 100,
              child: Text(
                widget.title ?? "",
                style: TextStyle(fontSize: 16),
              ),
            ),
            _input()
          ],),
          Padding(padding: EdgeInsets.only(left: widget.lineStretch ?? false ? 0 : 15),child: Divider(height: 1,thickness: 0.5,),)
        ],
      );
  }

  _input() {
    return Expanded(child: TextField(
      focusNode: focusNode,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText ?? false,
      keyboardType: widget.keyboardType,
      autofocus: !(widget.obscureText ?? false),
      cursorColor: primary,
      style: const TextStyle(
        fontSize: 16,fontWeight: FontWeight.w300
      ),
      //输入框样式
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 20,right: 20),
            border: InputBorder.none,
        hintText: widget.hint,
        hintStyle: TextStyle(fontSize: 15,color: Colors.grey)
      ),
    ));
  }
}
