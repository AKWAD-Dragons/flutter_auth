import 'dart:io';
import 'package:auth_provider/AuthMethod.dart';
import 'package:auth_provider/AuthProviderUser.dart';
import 'package:auth_provider/UserInterface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lwa/lwa.dart';
import 'package:fly_networking/GraphQB/graph_qb.dart';
import 'package:fly_networking/fly.dart';

class AmazonAuthMethod implements AuthMethod {
  @override
  String serviceName;
  Map<String, String> creds;
  AuthUser user;
  static const platform = const MethodChannel('flutter/amazon');
  static const MethodChannel _androidChannel =
      const MethodChannel('android/amazon');
  String postalCode;
  String apiLink;
  Fly _fly;


  LoginWithAmazon _loginWithAmazon = LoginWithAmazon(
    scopes: <Scope>[ProfileScope.profile(), ProfileScope.postalCode()],
  );
  LwaAuthorizeResult _lwaAuth;

  AmazonAuthMethod({this.apiLink}) {
    this.serviceName = 'Amazon';
    _fly = Fly(this.apiLink);
  }

  @override
  Future<AuthUser> auth() async {
    if (this.user != null) {
      return this.user;
    }
    if (Platform.isAndroid) {
      Map<dynamic, dynamic> lwaAuthData =
          await _androidChannel.invokeMethod('signIn');
      try {
        postalCode = lwaAuthData['postalCode'];
        print('AMAZON TOKEN ===> ${lwaAuthData['accessToken']}');
        print('AMAZON USER ID ===> ${lwaAuthData['userId']}');
        print('AMAZON POSTAL CODE ===> ${lwaAuthData['postalCode']}');

        creds = {
          "idToken": lwaAuthData['accessToken'],
          "postalCode": postalCode
        };
        user = AuthProviderUser().fromJson(creds);
        return user;
      } catch (error) {
        if (error is PlatformException) {
          print('AMAZON PlatformException ERROR ===>${error.message}');
        } else {
          print('AMAZON AUTH ERROR ===>${error.toString()}');
        }
        return null;
      }
    } else {
      try {
        Map returnedUser = await platform.invokeMethod('loginWithAmazon');
        dynamic user = returnedUser["user"];
        print("User is $user");
        if (user != null) {
          postalCode = user["postal_code"];
          creds = {
            "idToken": user["user_id"],
            "accessToken": returnedUser["token"],
            "postalCode": user["postal_code"]
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
      bool loggedOut = false;
      loggedOut = await _androidChannel.invokeMethod('signOut');
      await _fly.mutation([Node(name: 'logout_user')]);
      if (!loggedOut) {
        throw 'Couldn\'t log out from Amazon';
      }
    }
    return null;
  }
}
