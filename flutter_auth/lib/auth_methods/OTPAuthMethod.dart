import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fly_networking/GraphQB/graph_qb.dart';
import 'package:fly_networking/fly.dart';

import '../AuthMethod.dart';
import '../UserInterface.dart';

class OTPAuthMethod implements AuthMethod {
  ///Connect to firebase and sends SMS with an OTP

  @override
  String serviceName = 'otp';

  String _verificationId;
  String _smsCode;
  String _idToken;

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

  ///Make sure you Sent the sms first, and you have the sms code.
  Future<AuthUser> auth() async {
    AuthCredential credentials = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: _smsCode);

    FirebaseAuth.instance.signInWithCredential(credentials).then(sendIdToken);
  }

  void sendSMS(String phoneNumber) async {
    await Firebase.initializeApp();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: null,
      timeout: Duration(seconds: 60),
    );
  }

  void verificationCompleted(PhoneAuthCredential credentials) {
    FirebaseAuth.instance.signInWithCredential(credentials);
  }

  void verificationFailed(FirebaseAuthException exception) {
    print(exception.message);
  }

  void smsCodeSent(String verificationId, int forceCodeResend) {
    this._verificationId = verificationId;
  }

  void sendIdToken(UserCredential userCredentials) async {
    //Firebase user
    User user = userCredentials.user;

    if (user == null) return;

    _idToken = await user.getIdToken();
    print(_idToken);
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
