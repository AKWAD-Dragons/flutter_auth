import 'AuthUser.dart';

abstract class AuthMethod {
  String serviceName; // ex. google, facebook, github

  Future<void> logout();
  Future<AuthUser> auth();
}
