import 'package:auth_provider/AuthMethod.dart';
import 'package:auth_provider/AuthProviderUser.dart';
import 'package:auth_provider/UserInterface.dart';
import 'package:fly_networking/GraphQB/graph_qb.dart';
import 'package:fly_networking/fly.dart';

class TwilioOTPAuthMethod implements AuthMethod {
  @override
  String serviceName = 'twilio_otp';

  Fly _fly;
  Node twilioLoginNode;
  String phoneNumber;

  String apiLink;

  TwilioOTPAuthMethod({this.twilioLoginNode, this.apiLink, this.phoneNumber}) {
    _fly = Fly(this.apiLink);
  }

  @override
  Future<AuthUser> auth() async {
    Map result = await _fly.mutation([twilioLoginNode],
        parsers: {twilioLoginNode.name: AuthProviderUser()});
    AuthProviderUser user = result[twilioLoginNode.name];
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
