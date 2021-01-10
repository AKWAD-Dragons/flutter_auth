import 'dart:io';

import 'package:auth_provider/AuthMethod.dart';
import 'package:auth_provider/AuthProviderUser.dart';
import 'package:auth_provider/UserInterface.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:login_with_amazon/login_with_amazon.dart';

class AmazonAuthMethod implements AuthMethod {
  @override
  String serviceName;
  Map<String, String> creds;
  AuthUser user;
  static const platform = const MethodChannel('flutter/amazon');
  String postalCode;



  AmazonAuthMethod() {
    this.serviceName = 'Amazon';
  }

  @override
  Future<AuthUser> auth() async {
    if (this.user != null) {
      return this.user;
    }
    Map _lwaUser;
    if (!Platform.isIOS) {
      try {
        _lwaUser =
            await LoginWithAmazon.login({"profile": null, "postal_code": null});
      } catch (error) {
        if (error is PlatformException) {
          print(error.message);
        } else {
          print(error.toString());
        }
        return null;
      }
      postalCode = _lwaUser["user"]["userPostalCode"];
      creds = {
        "idToken": _lwaUser["user"]["userId"],
        "accessToken": _lwaUser["accessToken"]
      };
      this.user = AuthProviderUser().fromJson(creds);
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
      LoginWithAmazon.logout();
    }
    return null;
  }
}
