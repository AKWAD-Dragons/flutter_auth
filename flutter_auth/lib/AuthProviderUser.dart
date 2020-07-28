import 'package:fly_networking/fly.dart';
import 'package:json_annotation/json_annotation.dart';

import 'UserInterface.dart';

part 'AuthProviderUser.g.dart';

@JsonSerializable()
class AuthProviderUser implements AuthUser, Parser<AuthProviderUser> {
  String accessToken;
  String idToken;
  String expire;
  String jwtToken;
  String id;
  String role;
  String type;

  AuthProviderUser();

  Map<String, dynamic> toJson() {
    return _$AuthProviderUserToJson(this);
  }

  factory AuthProviderUser.fromJson(Map<String, dynamic> json) {
    return _$AuthProviderUserFromJson(json);
  }

  @override
  AuthProviderUser fromJson(Map<String, dynamic> data) {
    return AuthProviderUser.fromJson(data);
  }

  @override
  List<String> querys;

  @override
  dynamicParse(data) {
    // TODO: implement dynamicParse
    return null;
  }

  @override
  AuthProviderUser parse(data) {
    return AuthProviderUser.fromJson(data);
  }
}
