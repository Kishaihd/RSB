// Copyright (c) 2017, MrPin. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

//import 'package:firebase/firebase.dart' as firebase;
//import 'package:firebase/src/assets/assets.dart';
import 'package:angular/angular.dart';
//import 'dart:html';
//import 'dart:convert';
//import 'package:angular_components/angular_components.dart';
import 'package:RSB/main_app.dart';
import 'package:RSB/services/logger_service.dart';
import 'package:RSB/services/firebase_service.dart';

const String APP_NAME = "RSB";
final LoggerService _log = new LoggerService(appName: APP_NAME);

main() {
  bootstrap(MainApp, [
    provide(LoggerService, useValue: _log),
    provide(FirebaseService)
  ]);
}