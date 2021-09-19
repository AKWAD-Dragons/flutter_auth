import 'package:auth_provider/AuthMethod.dart';
import 'package:auth_provider/AuthProviderUser.dart';
import 'package:auth_provider/UserInterface.dart';
import 'package:flutter/cupertino.dart';
import 'package:fly_networking/GraphQB/graph_qb.dart';
import 'package:fly_networking/fly.dart';

class TwilioOTPAuthMethod implements AuthMethod {
  @override
  String serviceName = 'twilio_otp';

  Fly fly;
  Node twilioLoginNode;
  String phoneNumber;
  String apiLink;

  TwilioOTPAuthMethod(
      {this.twilioLoginNode,
      this.apiLink,
      this.phoneNumber,
      @required this.fly});

  @override
  Future<AuthUser> auth() async {
    Map result = await fly.mutation([twilioLoginNode],
        parsers: {twilioLoginNode.name: AuthProviderUser()});
    AuthProviderUser user = result[twilioLoginNode.name];
    return user;
  }

  Future<void> sendSMS({String to}) async {
    await fly.mutation([
      Node(name: "sendOTP", args: {"phone": phoneNumber})
    ]);
  }

  @override
  Future<void> logout() async {
    await fly.mutation([Node(name: 'logout_user')]);
  }
}
