

import 'package:shared_preferences/shared_preferences.dart';

import '../util/model_util.dart';

class HiCache{

  SharedPreferences? pref;

  HiCache._(){
    init();
  }
  static HiCache? _instance;

  HiCache._pre(SharedPreferences pref) {
    this.pref = pref;
  }


  static HiCache getInstance(){
    _instance ??= HiCache._();
    return _instance!;
  }

  static Future<HiCache> preInit() async {
    if(_instance == null){
      var pref = await SharedPreferences.getInstance();
      _instance = HiCache._pre(pref);
    }
    return _instance!;
  }

  Future<void> init() async {
    if(pref == null){
      pref = await SharedPreferences.getInstance();
    }
  }

  setString(String key, String value){
    pref?.setString(key, value);
  }

  setDouble(String key, double value){
    pref?.setDouble(key, value);
  }

  setInt(String key, int value){
    pref?.setInt(key, value);
  }

  setBool(String key, bool value){
    pref?.setBool(key, value);
  }

  T? get<T>(String key){
    return asT(pref?.get(key));
  }
}