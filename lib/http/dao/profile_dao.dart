import '../../model/profile_model.dart';
import 'package:hi_net/ht_net.dart';
import '../request/profile_request.dart';

class ProfileDao {
  //https://api.devio.org/uapi/fa/profile
  static get() async {
    ProfileRequest request = ProfileRequest();
    var result = await HiNet.getInstance().fire(request);
    return ProfileModel.fromJson(result['data']);
  }
}
