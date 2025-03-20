import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

import 'app.dart';

void main() {
  runApp(App());
  
  doWhenWindowReady(() {
    final win = appWindow;
    win.size = Size(400, 560);
    win.maxSize = win.size;
    win.minSize = win.size;
    win.alignment = Alignment.center;

    win.show();
  });
}


