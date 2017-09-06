import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'package:RSB/services/logger_service.dart';
import 'package:RSB/services/firebase_service.dart';

@Component(
  selector: 'login-view',
//  styleUrls: const ['login_view.css'],
  templateUrl: 'login_view.html',
  directives: const [materialDirectives],
  providers: const []
)
class LoginView {
  final LoggerService _log;
  final FirebaseService fbService;

  LoginView(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType()");
  }
}

