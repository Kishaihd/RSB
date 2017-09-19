import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'package:newRSB/services/logger_service.dart';
import 'package:newRSB/services/firebase_service.dart';

@Component(
  selector: 'login-view',
  templateUrl: 'login_view.html',
  directives: const [materialDirectives],

)
class LoginView {
  final LoggerService _log;
  final FirebaseService fbService;

  LoginView(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType");
  }


}