import 'package:flutter_bili_app/http/request/home_request.dart';
import 'package:flutter_bili_app/model/home_model.dart';

import 'package:hi_net/ht_net.dart';

class HomeDao{
  static get(String category,{int pageIndex=1,int pageSize=10}) async{
    HomeRequest request = HomeRequest();
    request.pathParams = category;
    request.add("pageIndex", pageIndex);
    request.add("pageSize", pageSize);
    var result =await HiNet.getInstance().fire(request);
    print(result);
    return HomeModel.fromJson(result['data']);
  }
}