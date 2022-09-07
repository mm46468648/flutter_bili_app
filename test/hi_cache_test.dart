import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

///单元测试

void main(){
  test('测试hiCache',() async{
    //防止报错
    TestWidgetsFlutterBinding.ensureInitialized();
    //模拟磁盘环境
    SharedPreferences.setMockInitialValues({});



  });
}