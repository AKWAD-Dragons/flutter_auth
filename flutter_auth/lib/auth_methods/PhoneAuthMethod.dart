import 'package:auth_provider/AuthMethod.dart';
import 'package:auth_provider/AuthProviderUser.dart';
import 'package:auth_provider/UserInterface.dart';
import 'package:fly_networking/GraphQB/graph_qb.dart';
import 'package:fly_networking/fly.dart';

class PhoneAuthMethod implements AuthMethod {
  @override
  String serviceName = 'phone_auth';

  Fly _fly;
  Node phoneLoginNode;
  String phoneNumber;
  String language;
  String apiLink;

  PhoneAuthMethod({this.phoneLoginNode, this.apiLink, this.phoneNumber, this.language}) {
    _fly = Fly(this.apiLink);
  }

  @override
  Future<AuthUser> auth() async {
    _fly.addHeaders({'lang': language});
    Map result = await _fly.mutation([phoneLoginNode],
        parsers: {phoneLoginNode.name: AuthProviderUser()});
    AuthProviderUser user = result[phoneLoginNode.name];
    return user;
  }

  Future<void> sendSMS() async {
    await _fly.mutation([
      Node(name: "sendOTP", args: {"phone": phoneNumber})
    ]);
  }

  @override
  Future<void> logout() async {
    await _fly.query([Node(name: 'logout')]);
  }
}
