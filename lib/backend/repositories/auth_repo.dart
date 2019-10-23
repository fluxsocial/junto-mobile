import 'package:junto_beta_mobile/backend/services.dart';
import 'package:junto_beta_mobile/models/models.dart';

class AuthRepo {
  AuthRepo(this._authService, this._userService);

  final AuthenticationService _authService;
  final UserService _userService;

  String _authKey;
  bool _isLoggedIn;

  String get authKey => _authKey;
  bool get isLoggedIn => _isLoggedIn;

  /// Registers a user on the server and creates their profile.
  Future<UserData> registerUser(UserAuthRegistrationDetails details){
    return _authService.registerUser(details);
  }

  /// Authenticates a registered user. Returns the [UserProfile]  for the
  /// given user. Their cookie is stored locally on device and is used for
  /// all future request.
  Future<UserProfile> loginUser(UserAuthLoginDetails details){
    return _authService.loginUser(details);
  }

  /// Logs out a user and removes their auth token from the device.
  Future<void> logoutUser(){
    return _authService.logoutUser();
  }
}
