/*
 An Authentication utitlity provider that handles:
 TODO::
  - Logining with Google
  - Logining with LinkedIn
  - Logining with Facebook
  - email and password logining
  - Handeling user Authentication state
    * caching and refreshing tokens
    * checking for an authenticated user
    * unauthing a user
*/

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'AuthMethod.dart';

import 'UserInterface.dart';

class AuthProvider<T extends AuthUser> {
  AuthUser? _user;
  Type? _authMethodType;

  late SharedPreferences sharedPreferences;
  static const String USER_TAG = "__user__";

  T get user => _user as T;

  AuthProvider(AuthUser authUser) {
    this._user = authUser;
  }

  Future<void> init() async {
    // setup shared Pref
    this.sharedPreferences = await SharedPreferences.getInstance();

    // parse and store user
    _user = await this.getUser();

    if (isExpired(_user)) {
      _user = null;
    }
  }

  Future<bool> hasUser() async {
    await this.init();
    return _user != null ? true : false;
  }

  bool isExpired(AuthUser? user) {
    try {
      DateTime expireDate = DateTime.parse(user!.expire!);
      DateTime todayDate = DateTime.now();

      print("The expire date is $expireDate");

      final difference = expireDate.difference(todayDate).inDays;

      if (difference <= 0) {
        print("Your token is expired");
        return true;
      }

      print("You are ok to go");
      return false;
    } catch (e) {
      return true;
    }
  }

  Future<AuthUser?> signUpWithEmail({
    AuthMethod? method,
    Future<AuthUser> Function(AuthUser? authUser)? callType,
  }) async {
    _user = await method!.auth();

    // add the auth method type later use
    _authMethodType = method.runtimeType;

    if (callType != null) {
      _user = await callType.call(_user);
      saveUser(_user);
    }
    // cache the jwt token
    return _user;
  }

  Future<AuthUser?> loginWith({
    AuthMethod? method,
    Future<AuthUser> Function(AuthUser? authuser)? callType,
  }) async {
    _user = await method!.auth();

    // add the auth method type later use
    _authMethodType = method.runtimeType;

    // send it to the api
    if (callType != null && _user != null) {
      _user = await callType(_user);
      await saveUser(_user);
    }

    // cache the jwt token
    return _user;
  }

  Future<void>? logout({AuthMethod? from}) {
    if (from != null) {
      from.logout();
    }
    _user = null;
    deleteUser();
  }

  Future<void> saveUser(savedUser) async {
    this
        .sharedPreferences
        .setString(USER_TAG, jsonEncode(this._user!.toJson()));
  }

  Future<void> deleteUser() async {
    this.sharedPreferences.remove(USER_TAG);
  }

  Future<AuthUser?> getUser() async {
    return sharedPreferences.getString(USER_TAG) == null
        ? this._user
        : this
            ._user!
            .fromJson(jsonDecode(sharedPreferences.getString(USER_TAG)!));
  }
}
