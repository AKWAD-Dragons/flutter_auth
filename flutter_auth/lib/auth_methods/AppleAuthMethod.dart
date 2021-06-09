import 'package:fly_networking/GraphQB/graph_qb.dart';
import 'package:fly_networking/fly.dart';
import 'package:get_it/get_it.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../AuthMethod.dart';
import '../AuthProviderUser.dart';
import '../UserInterface.dart';

class AppleAuthMethod implements AuthMethod {
  @override
  String serviceName = 'Apple';
  late Map<String, String> creds;
  AuthUser? user;
  String? apiLink;
  Fly _fly;

  AppleAuthMethod()
      : _fly = GetIt.instance<Fly>(),
        this.serviceName = 'Apple';

  @override
  Future<AuthUser?> auth() async {
    if (this.user != null) {
      return this.user;
    }

    final AuthorizationCredentialAppleID result =
        await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    if (result.identityToken != null && result.userIdentifier != null) {
      print("The identitiy token is ${result.identityToken}");
      print("The user token is ${result.userIdentifier}");
      creds = {
        "idToken": result.identityToken!,
      };
      this.user = AuthProviderUser().fromJson(creds);
      return this.user;
    }
  }

  @override
  Future<void> logout() async {
    await _fly.mutation([Node(name: 'logout_user')]);
  }
}
