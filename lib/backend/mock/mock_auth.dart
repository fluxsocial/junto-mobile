import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/mock/mock_data.dart';
import 'package:junto_beta_mobile/models/user_model.dart';

class MockAuth implements AuthenticationService {
  @override
  Future<UserData> loginUser(UserAuthLoginDetails details) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return kUserData;
  }

  @override
  Future<void> logoutUser() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  Future verifyEmail(String email) async {
    return ;
  }
  @override
  Future<UserData> registerUser(UserAuthRegistrationDetails details) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return kUserData;
  }
}
