import 'package:flutter/material.dart';
import 'package:flutter_bili_app/navigator/hi_navigator.dart';
import 'package:flutter_bili_app/widget/appbar.dart';
import 'package:flutter_bili_app/widget/login_effect.dart';
import 'package:flutter_bili_app/widget/login_input.dart';
import 'package:hi_base/string_util.dart';

import 'package:hi_net/core/hi_error.dart';
import '../http/dao/login_dao.dart';
import '../util/toast.dart';
import '../widget/login_button.dart';

class LoginPage extends StatefulWidget {

  // final VoidCallback onJumpRestration;
  // final VoidCallback onSuccess;

  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool protect = false;
  var loginEnable = false;
  String userName = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("密码登录", "注册",(){
        HiNavigator.getInstance().onJumpTo(RouteStatus.registration);
      }),
      body: ListView(
        children: [
          LoginEffect(protect: protect),
          LoginInput(
            "用户名",
            "请输入用户名",
            onChanged: (text) {
              userName = text;
              // print(text);
              checkInput();
            },
          ),
          LoginInput(
            "密码",
            "请输入密码",
            onChanged: (text) {
              password = text;
              checkInput();
            },
            focusChanged: (focus) {
              this.setState(() {
                protect = focus;
              });
            },
            obscureText: true,
          ),
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child:
                  LoginButton("登录", enable: loginEnable, voidCallback: _send))
        ],
      ),
    );
  }

  void checkInput() {
    bool enable = false;
    if (isNotEmpty(userName) && isNotEmpty(password)) {
      enable = true;
    }

    setState(() {
      this.loginEnable = enable;
    });
  }

  _send() async {
    try {
      //     await LoginDao.registration('lyq', 'lyq990515', '10344277', '2557');
      // var result = LoginDao.login("lyq", "lyq990515");
      var result = await LoginDao.login(userName, password);
      print("result msg: ${result}");
      showWarnToast(result['msg']);

      if(result['code'] == 0){
         HiNavigator.getInstance().onJumpTo(RouteStatus.home);
      }
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    } catch (e) {
      print(e);
      showWarnToast(e.toString());
    }
  }
}
