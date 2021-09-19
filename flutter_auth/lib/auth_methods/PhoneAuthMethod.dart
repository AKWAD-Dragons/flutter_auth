import 'package:auth_provider/AuthMethod.dart';
import 'package:auth_provider/AuthProviderUser.dart';
import 'package:auth_provider/UserInterface.dart';
import 'package:flutter/cupertino.dart';
import 'package:fly_networking/GraphQB/graph_qb.dart';
import 'package:fly_networking/fly.dart';

class PhoneAuthMethod implements AuthMethod {
  @override
  String serviceName = 'phone_auth';

  Fly fly;
  Node phoneLoginNode;
  String phoneNumber;
  String apiLink;

  PhoneAuthMethod(
      {this.phoneLoginNode,
      this.apiLink,
      this.phoneNumber,
      @required this.fly});

  @override
  Future<AuthUser> auth() async {
    Map result = await fly.mutation([phoneLoginNode],
        parsers: {phoneLoginNode.name: AuthProviderUser()});
    AuthProviderUser user = result[phoneLoginNode.name];
    return user;
  }

  Future<void> sendSMS() async {
    await fly.mutation([
      Node(name: "sendOTP", args: {"phone": phoneNumber})
    ]);
  }

  @override
  Future<void> logout() async {
    await fly.query([Node(name: 'logout')]);
  }
}
