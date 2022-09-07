import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/io.dart';

import 'barrage_model.dart';

class HiSocket implements ISocket{

  static const _URL = 'wss://api.devio.org/uapi/fa/barrage/';
  IOWebSocketChannel? _channel;

  Map<String,dynamic> _header = {};


  HiSocket(this._header);

  ///心跳间隔秒数
  int _intervalSeconds = 50;

  ValueChanged<List<BarrageModel>>? callBack;
  @override
  void close() {
    if(_channel!=null){
      _channel?.sink.close();
    }
  }

  @override
  ISocket listen(ValueChanged<List<BarrageModel>> valueChanged) {
    callBack = valueChanged;
    return this;
  }

  @override
  ISocket onen(String vid) {
     _channel = IOWebSocketChannel.connect(_URL + vid,headers: _header,pingInterval: Duration(seconds: _intervalSeconds));
    _channel?.stream.handleError((error){
      print("链接发生错误:${error}");
    }).listen((event) {
      _handleMessage(event);
    });
    return this;
  }

  @override
  ISocket send(String message) {
    _channel?.sink.add(message);
    return this;
  }

  // _headers() {
  //    Map<String,dynamic> header = {
  //      HiConstants.authTokenK:HiConstants.authTokenV,
  //      HiConstants.courseFlagK:HiConstants.courseFlagV
  //    };
  //    header[LoginDao.BOARDING_PASS] = LoginDao.getBoardingPass();
  //    return header;
  // }

  void _handleMessage(event) {
    print("received:${event}");

    var result =  BarrageModel.fromJsonString(event);
    if(result!=null && callBack!=null){
      callBack!(result);
    }
  }

}

abstract class ISocket{
  ///和服务器建立链接
  ISocket onen(String vid);

  ///发送弹幕
  ISocket send(String message);

  ///关闭链接
  void close();

  ISocket listen(ValueChanged<List<BarrageModel>> valueChanged);

}