
import '../request/hi_base_request.dart';
import 'hi_net_adapter.dart';

class MockAdapter extends HiNetAdapter{
  @override
  Future<HiNetResponse<T>> send<T>(HiBaseRequest request) {
    var a = Future.delayed(const Duration(milliseconds: 1000), () {
      var d = {"code": 0, "message": 'success'} as T;
      HiNetResponse<T> response = HiNetResponse(data: d, statusCode: 403);
      return response;
    });
    // var a = Future.value(HiNetResponse(data: {"code": 0, "message": 'success'}, statusCode: 403));
    return a;
  }
}