import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fly_networking/GraphQB/graph_qb.dart';
import 'package:fly_networking/fly.dart';

import '../AuthMethod.dart';
import '../AuthProviderUser.dart';
import '../UserInterface.dart';

class OTPAuthMethod implements AuthMethod {
  ///Connect to firebase and sends SMS with an OTP

  @override
  String serviceName = 'otp';

  /// `Map` that gets called in `GraphQL` case
  Node graphSignupNode;

  String apiLink;

  /// How you expect to find the token in responce `Map`, to be `String`, `Map`, `dynamic`, ...
  Object tokenKey;

  /// How you expect to find the error in responce `Map`, to be `String`, `Map`, `dynamic`, ...
  Object errorKey;
  Function(Object error) errorFunction;

  Fly fly;

  OTPAuthMethod({
    @required this.graphSignupNode,
    @required this.apiLink,
  }) {
    fly = Fly(this.apiLink);
  }

  @override
  Future<AuthUser> auth() async {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "01008536916",
      verificationCompleted: (PhoneAuthCredential phone) => print(phone),
      verificationFailed: (FirebaseAuthException ex) => print(ex),
      codeSent: (String s, int t) {
        print(s);
        print(t);
      },
      codeAutoRetrievalTimeout: (String s) => print(s),
      timeout: Duration(seconds: 60),
    );

    await fly.mutation([this.graphSignupNode]);
    return AuthProviderUser();
  }

  @override
  Future<void> logout() async {
    await fly.query([
      Node(
        name: 'logout',
        args: {},
        cols: [],
      )
    ]);
  }
}
