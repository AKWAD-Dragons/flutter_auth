import 'UserInterface.dart';

abstract class AuthMethod {
  late String serviceName; // ex. google, facebook, github

  Future<void> logout();
  Future<AuthUser?> auth();
}
