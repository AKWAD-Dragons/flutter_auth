import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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

  String _verificationId;
  String _smsCode;
  String idToken;

  /// `Map` that gets called in `GraphQL` case
  Node otpAuthNode;

  String apiLink;

  /// How you expect to find the token in responce `Map`, to be `String`, `Map`, `dynamic`, ...
  Object tokenKey;

  /// How you expect to find the error in responce `Map`, to be `String`, `Map`, `dynamic`, ...
  Object errorKey;
  Function(Object error) errorFunction;

  Fly fly;

  OTPAuthMethod({
    @required this.otpAuthNode,
    @required this.apiLink,
  }) {
    fly = Fly(this.apiLink);
  }

  @override

  ///Make sure you Sent the sms first, and you have the sms code.
  Future<AuthUser> auth() async {
    AuthCredential credentials = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: _smsCode);

    FirebaseAuth.instance.signInWithCredential(credentials).then(sendIdToken);

    Map result = await fly.mutation([otpAuthNode],
        parsers: {otpAuthNode.name: AuthProviderUser()});
    AuthProviderUser user = result[otpAuthNode.name];
    return user;
  }

  void sendIdToken(UserCredential userCredentials) async {
    //Firebase user
    User user = userCredentials.user;

    if (user == null) return;

    idToken = await user.getIdToken();
    print(idToken);
  }

  void sendSMS(String phoneNumber) async {
    await Firebase.initializeApp();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: onRetrievalTimeout,
      timeout: Duration(seconds: 60),
    );
  }

  void verificationCompleted(PhoneAuthCredential credentials) {
    FirebaseAuth.instance.signInWithCredential(credentials);
  }

  void verificationFailed(FirebaseAuthException exception) {
    throw exception;
  }

  void smsCodeSent(String verificationId, int forceCodeResend) {
    this._verificationId = verificationId;
  }

  void onRetrievalTimeout(String verificationId) {
    this._verificationId = verificationId;
  }

  set setSMSCode(String smsCode) {
    this._smsCode = smsCode;
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
