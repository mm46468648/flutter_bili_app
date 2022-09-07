import 'package:dio/dio.dart';

import '../request/hi_base_request.dart';
import 'hi_error.dart';
import 'hi_net_adapter.dart';


class DioAdapter extends HiNetAdapter{
  @override
  Future<HiNetResponse<T>> send<T>(HiBaseRequest request) async {
    var response;
    var option = Options(headers: request.header);
    var error;
    try{
      if(request.httpMethod() == HttpMethod.GET){
        response = await Dio().get(request.url(),options: option);
      }else if(request.httpMethod() == HttpMethod.POST){
        response = await Dio().post(request.url(),data: request.params,options: option);
      }else if(request.httpMethod() == HttpMethod.DELETE){
        response = await Dio().delete(request.url(),data: request.params,options: option);
      }
    }on DioError catch(e){
      error = e;
      response = e.response;
    }

    if(error != null){
      throw HiNetError(response?.statusCode??-1, error.toString(),data: buildRes(response,request));
    }

    print("hi_net: ${response}");
    return buildRes(response, request);
  }

  buildRes(response, HiBaseRequest request) {
    return HiNetResponse(data: response.data,request: request,statusCode: response.statusCode,statusMessage: response.statusMessage,extra: response);
  }

}