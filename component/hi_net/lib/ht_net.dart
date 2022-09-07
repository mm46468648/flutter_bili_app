


import 'package:hi_net/request/hi_base_request.dart';

import 'core/dio_adapter.dart';
import 'core/hi_error.dart';
import 'core/hi_net_adapter.dart';

class HiNet {
  HiNet._();

  static HiNet? _instance;

  static HiNet getInstance() {
    _instance ??= HiNet._();
    return _instance!;
  }

  Future fire(HiBaseRequest request) async {
    HiNetResponse? response;
    var error;

    try {
      response = await send(request);

    } on HiNetError catch (e) {
      error = e;
      response = e.data;
      printLog(e.message);
    } catch (e) {
      error = e;
      printLog(e);
    }

    if (response == null) {
      printLog(error);
    }

    var result = response?.data;
    printLog(result);

    var status = response?.statusCode;
    switch (status) {
      case 200:
        break;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(result.toString(), data: result);
      default:
        throw HiNetError(status??-1, result.toString(),data: result);
    }

    return result;
  }

  Future<dynamic> send<T>(HiBaseRequest request) async {
    printLog('url:${request.url()}');
    HiNetAdapter adapter = DioAdapter();
    return adapter.send(request);
    // return Future.value(
    //     {"statusCode": 200, "data": {"code": 0, "message": "success"}});
  }

  void printLog(log) {
    print("hi_net:${log.toString()}");
  }
}