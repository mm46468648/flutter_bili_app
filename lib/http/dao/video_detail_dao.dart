import 'package:flutter_bili_app/http/request/video_detail_request.dart';
import 'package:flutter_bili_app/model/video_detail_model.dart';

import 'package:hi_net/ht_net.dart';

class VideoDetailDao{

  static get(String vid) async{
    VideoDetailRequest videoDetailRequest = VideoDetailRequest();
    videoDetailRequest.pathParams = vid;
    var result = await HiNet.getInstance().fire(videoDetailRequest);
    print(result);
    return VideoDetailModel.fromJson(result['data']);
  }
}