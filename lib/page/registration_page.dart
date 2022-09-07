import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bili_app/navigator/hi_navigator.dart';
import 'package:hi_base/string_util.dart';
import 'package:flutter_bili_app/widget/login_effect.dart';
import 'package:flutter_bili_app/widget/login_input.dart';

import 'package:hi_net/core/hi_error.dart';
import '../http/dao/login_dao.dart';
import '../util/toast.dart';
import '../widget/appbar.dart';
import '../widget/login_button.dart';

class RegistrationPage extends StatefulWidget {

  RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  var protect = false;
  var loginEnable = false;
  String userName = "";
  String password = "";
  String rePassword = "";
  String imoocId = "";
  String orderId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("注册","登录",(){
        HiNavigator.getInstance().onJumpTo(RouteStatus.login);
      }),
      body: Container(
        child: ListView(
          // 自适应键盘弹起 防止遮挡
          children: [
          LoginEffect(
          protect: protect,
        ),
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
        LoginInput(
          "确认密码",
          "请重新输入密码",
          onChanged: (text) {
            rePassword = text;
            checkInput();
          },
          focusChanged: (focus) {
            this.setState(() {
              protect = focus;
            });
          },
          obscureText: true,
          lineStretch: true,
        ),
        LoginInput(
          "慕课网ID",
          "请输入你的慕课网用户ID",
          keyboardType: TextInputType.number,
          onChanged: (text) {
            imoocId = text;
            checkInput();
          },
        ),
        LoginInput(
          "订单号",
          "请输入你的订单号后四位",
          keyboardType: TextInputType.number,
          onChanged: (text) {
            orderId = text;
            checkInput();
          },
          lineStretch: true,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: LoginButton("注册", enable: loginEnable, voidCallback: checkParams)
        )
          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enable = false;
    if(isNotEmpty(userName)
        && isNotEmpty(password)
        && isNotEmpty(rePassword)
        && isNotEmpty(orderId)
        && isNotEmpty(imoocId)
    ){
      enable = true;
    }

    setState(() {
      this.loginEnable = enable;
    });
  }

  checkParams(){
    String? tips;
    if(password != rePassword){
      tips = "两次输入密码不一致";
    }else if(orderId.length != 4){
      tips = "请输入订单号后4位";
    }
    if(isNotEmpty(tips)){
      showWarnToast(tips ?? "");
      return;
    }

    send();


  }

  _loginButton(String s, {required enable, required onPressed}) {
    return InkWell(
      onTap: (){
        if(loginEnable){
          checkParams();
        }else{
          print("params error");
        }
      },
      child: Text(s),
    );
  }

  Future<void> send() async {
    try{
      //     await LoginDao.registration('lyq', 'lyq990515', '10344277', '2557');
      var result =  await LoginDao.registration(userName, password, imoocId, orderId);
      // var result = LoginDao.login("lyq", "lyq990515");
      print(result);
    }on NeedAuth catch(e){
      print(e);
    }on HiNetError catch(e){
      print(e);
    }catch(e){
      print(e);
    }
  }
}