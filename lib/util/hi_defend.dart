import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class HiDefend{
  run(Widget app){
    //框架异常
    FlutterError.onError = (FlutterErrorDetails details){
      if(kReleaseMode){
        Zone.current.handleUncaughtError(details.exception, details.stack ?? StackTrace.empty);
      }else{
        FlutterError.dumpErrorToConsole(details);
      }
    };
    runZonedGuarded((){
      runApp(app);
    }, (e,s) => _reportError(e));
  }

  _reportError(Object e) {
    print("kReleaseMode:${kReleaseMode}");
    print("catch error: ${e.toString()}");
  }
}