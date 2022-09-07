import 'package:hi_net/request/hi_base_request.dart';
import 'package:flutter_bili_app/http/request/ranking_request.dart';
import 'package:flutter_bili_app/model/ranking_model.dart';

import 'package:hi_net/ht_net.dart';

class RankingDao{
  static get(String sort,{int pageIndex = 1,int pageSize = 10}) async{
    RankingRequest request = RankingRequest();
    request.add("sort", sort);
    request.add("pageIndex", pageIndex);
    request.add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    return RankingModel.fromJson(result['data']);
  }
}