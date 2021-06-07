import 'dart:convert';

import 'package:fly_networking/GraphQB/graph_qb.dart';
import 'package:fly_networking/fly.dart';
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

  AppleAuthMethod({this.apiLink}) {
    this.serviceName = 'Apple';
    _fly = Fly(this.apiLink);
  }

  @override
  Future<AuthUser?> auth() async {
    if (this.user != null) {
      return this.user;
    }

    // final AuthorizationResult result = await AppleSignIn.performRequests([
    //   AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    // ]);

    final AuthorizationCredentialAppleID result = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    switch (result.status) {
      case AuthorizationStatus.authorized:
        print(
            "The identitiy token is ${base64Encode(result.credential.identityToken)}");
        print("The user token is ${result.credential.user}");
        creds = {
          "idToken": result.credential.user,
        };
        this.user = AuthProviderUser().fromJson(creds);
        return this.user;
        break;

      case AuthorizationStatus.error:
        print("Sign in failed: ${result.error.localizedDescription}");
        return null;
        break;

      case AuthorizationStatus.cancelled:
        print('User cancelled');
        break;
    }
  }

  @override
  Future<void> logout() async{
    await _fly.mutation([Node(name: 'logout_user')]);
  }
}
