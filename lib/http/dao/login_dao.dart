import 'package:hi_net/ht_net.dart';
import 'package:hi_net/request/hi_base_request.dart';
import 'package:flutter_bili_app/http/request/login_request.dart';
import 'package:flutter_bili_app/http/request/registration_request.dart';

import '../../db/hi_cache.dart';

class LoginDao{

  static const BOARDING_PASS = "boarding-pass";

  static login(String userName,String password){
    return _send(userName, password);
  }

  static registration(String userName,String password,imoocId,orderId){
    return _send(userName, password,imoocId:imoocId,orderId:orderId);
  }

  static _send(String userName,String password,{String? imoocId,String? orderId}) async {
    HiBaseRequest request;

    if(imoocId!=null && orderId!=null){
      request = RegistrationRequest();
      request.add("imoocId", imoocId);
      request.add("orderId", orderId);
    }else{
      request = LoginRequest();
    }

    request.add("userName", userName);
    request.add("password", password);


    var result = await HiNet.getInstance().fire(request);
    print(result);

    if(result['code'] == 0 && result['data']!=null){
      // 保存登录令牌
      HiCache.getInstance().setString(BOARDING_PASS, result['data']);
    }
    return result;
  }

  static getBoardingPass(){
    return HiCache.getInstance().get(BOARDING_PASS) ?? "";
  }
}
