import 'package:hi_net/request/hi_base_request.dart';

import '../../util/hi_constants.dart';
import '../dao/login_dao.dart';

abstract class BaseRequset extends HiBaseRequest{

  Map<String, dynamic> header = {
    HiConstants.authTokenK:HiConstants.authTokenV,
    HiConstants.courseFlagK:HiConstants.courseFlagV
    // 'boarding-pass': '登录成功返回的boarding-pass'
  };

  @override
  String url() {
    if(needLogin()){
      //给需要登录的设置登录令牌
      addHeader(LoginDao.BOARDING_PASS,LoginDao.getBoardingPass());
    }
    return super.url();
  }
}