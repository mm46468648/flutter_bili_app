import 'dart:convert';

import '../request/hi_base_request.dart';

///网络请求抽象类
abstract class HiNetAdapter{
  Future<HiNetResponse<T>> send<T>(HiBaseRequest request);
}


///统一网络层返回格式
class HiNetResponse<T>{
  T? data;
  HiBaseRequest? request;
  int? statusCode;
  String? statusMessage;
  dynamic extra;


  HiNetResponse(
      {this.data, this.request, this.statusCode, this.statusMessage, this.extra});

  String toString(){
    if(data is Map){
      return json.encode(data);
    }
    return data.toString();
  }
}