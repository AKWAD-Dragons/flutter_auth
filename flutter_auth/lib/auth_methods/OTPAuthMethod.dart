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
  String phoneNumber;
  String _idToken;

  /// `Map` that gets called in `GraphQL` case

  String apiLink;

  /// How you expect to find the token in responce `Map`, to be `String`, `Map`, `dynamic`, ...
  Object tokenKey;

  /// How you expect to find the error in responce `Map`, to be `String`, `Map`, `dynamic`, ...
  Object errorKey;
  Function(Object error) errorFunction;

  Fly fly;

  OTPAuthMethod({
    @required this.phoneNumber,
    @required this.apiLink,
  }) {
    fly = Fly(this.apiLink);
  }

  @override

  ///Make sure you Sent the sms first, and you have the sms code.
  Future<AuthUser> auth() async {
    return AuthProviderUser()..idToken = _idToken;
  }

  Future<String> getIdToken(String smsCode) async {
    // Authentication with Firebase
    if (FirebaseAuth.instance.currentUser != null)
      return FirebaseAuth.instance.currentUser.getIdToken();

    AuthCredential credentials = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: smsCode);

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credentials);

    if (userCredential == null) return null;

    _idToken = await userCredential.user.getIdToken();

    return _idToken;
  }

  void sendSMS() async {
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

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
