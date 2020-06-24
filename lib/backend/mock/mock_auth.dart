//ignore_for_file:missing_return
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/auth_result.dart';

class MockAuth implements AuthenticationService {
  @override
  Future<SignInResult> loginUser(SignInData details) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return null;
  }

  @override
  Future<SignOutResult> logOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<ResetPasswordResult> requestPasswordReset(String email) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 500),
    );
    return null;
  }

  @override
  Future<void> resetPassword(ResetPasswordData details) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 500),
    );
  }

  Future<void> deleteUserAccount(String userAddress, String password) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 500),
    );
  }

  @override
  Future<SignInResult> isLoggedIn() {
    throw UnimplementedError();
  }

  @override
  Future<SignUpResult> signUp(SignUpData data) {
    throw UnimplementedError();
  }

  @override
  Future<ResendVerifyResult> resendVerifyCode(String data) {
    throw UnimplementedError();
  }

  @override
  Future<VerifyResult> verifySignUp(VerifyData data) {
    throw UnimplementedError();
  }

  @override
  Future<String> getIdToken() async {
    return '';
  }
}
