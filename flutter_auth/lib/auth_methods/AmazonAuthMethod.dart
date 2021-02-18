import 'dart:io';
import 'package:auth_provider/AuthMethod.dart';
import 'package:auth_provider/AuthProviderUser.dart';
import 'package:auth_provider/UserInterface.dart';
import 'package:flutter/services.dart';
import 'package:fly_networking/Auth/AppException.dart';
import 'package:flutter_lwa/lwa.dart';

class AmazonAuthMethod implements AuthMethod {
  @override
  String serviceName;
  Map<String, String> creds;
  AuthUser user;
  static const platform = const MethodChannel('flutter/amazon');
  String postalCode;

  LoginWithAmazon _loginWithAmazon = LoginWithAmazon(
    scopes: <Scope>[ProfileScope.profile(), ProfileScope.postalCode()],
  );
  LwaAuthorizeResult _lwaAuth;

  AmazonAuthMethod() {
    _loginWithAmazon.onLwaAuthorizeChanged.listen((LwaAuthorizeResult auth) {
      _lwaAuth = auth;
    });
    _loginWithAmazon.signInSilently();

    this.serviceName = 'Amazon';
  }

  @override
  Future<AuthUser> auth() async {
    if (this.user != null) {
      return this.user;
    }
    if (Platform.isAndroid) {
      LwaUser lwaUser;
      try {
        _lwaAuth = await _loginWithAmazon.signIn();
        lwaUser = await _loginWithAmazon.fetchUserProfile();
      } catch (error) {
        if (error is PlatformException) {
          print(error.message);
        } else {
          print(error.toString());
        }
        return null;
      }
      postalCode = lwaUser.userPostalCode;
      creds = {
        "idToken": lwaUser.userId,
        "accessToken": _lwaAuth.accessToken
      };
      this.user = AuthProviderUser().fromJson(creds);
      this.user.postalCode = postalCode;
      return this.user;
    } else {
      try {
        Map returnedUser = await platform.invokeMethod('loginWithAmazon');
        dynamic user = returnedUser["user"];
        print("User is $user");
        if (user != null) {
          postalCode = user["postal_code"];
          creds = {
            "idToken": user["user_id"],
            "accessToken": returnedUser["token"]
          };
          this.user = AuthProviderUser().fromJson(creds);
          this.user.postalCode = postalCode;
          return this.user;
        } else {
          return null;
        }
      } on PlatformException catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Future<void> logout() async {
    if (Platform.isIOS) {
      await platform.invokeMethod('amazonLogout');
    } else {
      //Logout from amazon android
      _handleSignOut();
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _loginWithAmazon.signIn();
    } catch (error) {
      throw AppException(true, beautifulMsg: error.toString());
    }
  }

  Future<void> _handleSignOut() => _loginWithAmazon.signOut();
}
