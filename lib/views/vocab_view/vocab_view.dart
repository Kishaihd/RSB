
//import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:RSB/services/logger_service.dart';
import 'package:RSB/services/firebase_service.dart';
import '../vocab_list_component/vocab_list_component.dart';
//import 'package:angular_components/src/components/material_tab/material_tab_panel.dart';
//import 'package:angular_components/src/components/material_tab/material_tab.dart';
//import 'vocab_list_service.dart';

@Component(
  selector: 'vocab-view',
  styleUrls: const ['vocab_view.css'],
  templateUrl: 'vocab_view.html',
  directives: const [
    CORE_DIRECTIVES,
    VocabListComponent,
    materialDirectives
  ],
  providers: const [materialProviders],
)

class VocabView {
  final LoggerService _log;
  final FirebaseService fbService;

  VocabView(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType()");
  }
}
