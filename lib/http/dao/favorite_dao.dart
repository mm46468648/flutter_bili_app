import 'package:hi_net/ht_net.dart';
import 'package:hi_net/request/hi_base_request.dart';
import 'package:flutter_bili_app/http/request/cancel_favorite_request.dart';
import 'package:flutter_bili_app/http/request/favorite_list_request.dart';
import 'package:flutter_bili_app/http/request/favorite_request.dart';

import '../../model/favorite_model.dart';

class FavoriteDao{
  static favorite(String vid,bool favorite) async {
    HiBaseRequest request = favorite? FavoriteRequest() : CancelFavoriteRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    return result;
  }

  static getFavoriteList(int pageIndex,int pageSize) async{
    FavoriteListRequest favoriteListRequest = FavoriteListRequest();
    favoriteListRequest.add("pageIndex", pageIndex);
    favoriteListRequest.add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(favoriteListRequest);
    return FavoriteModel.fromJson(result['data']);
  }
}