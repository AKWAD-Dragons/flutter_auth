import 'dart:convert';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:fly_networking/GraphQB/graph_qb.dart';
import 'package:fly_networking/fly.dart';

import '../AuthMethod.dart';
import '../AuthProviderUser.dart';
import '../UserInterface.dart';

class AppleAuthMethod implements AuthMethod {
  @override
  String serviceName;
  Map<String, String> creds;
  AuthUser user;
  String apiLink;
  Fly fly;

  AppleAuthMethod({this.apiLink, @required this.fly}) {
    this.serviceName = 'Apple';
  }

  @override
  Future<AuthUser> auth() async {
    if (this.user != null) {
      return this.user;
    }

    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

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
  Future<void> logout() async {
    await fly.mutation([Node(name: 'logout_user')]);
  }
}
