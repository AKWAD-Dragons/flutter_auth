import 'package:auth_provider/AuthMethod.dart';
import 'package:auth_provider/AuthProviderUser.dart';
import 'package:auth_provider/UserInterface.dart';
import 'package:fly_networking/GraphQB/graph_qb.dart';
import 'package:fly_networking/fly.dart';
import 'package:get_it/get_it.dart';

class PhoneAuthMethod implements AuthMethod {
  @override
  String serviceName = 'phone_auth';

  Fly _fly;
  Node phoneLoginNode;
  String? phoneNumber;

  String? apiLink;

  PhoneAuthMethod({required this.phoneLoginNode, this.phoneNumber})
      : _fly = GetIt.instance<Fly>();

  @override
  Future<AuthUser> auth() async {
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
