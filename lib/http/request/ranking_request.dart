
import 'base_request.dart';
import 'package:hi_net/request/hi_base_request.dart';

class RankingRequest extends BaseRequset {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return "uapi/fa/ranking";
  }
}
