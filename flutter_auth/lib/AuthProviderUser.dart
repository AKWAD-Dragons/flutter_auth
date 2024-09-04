import 'package:auth_provider/Role.dart';
import 'package:fly_networking/fly.dart';
import 'package:json_annotation/json_annotation.dart';

import 'UserInterface.dart';

part 'AuthProviderUser.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthProviderUser with AuthUser, Parser<AuthProviderUser> {
  String? accessToken;
  String? idToken;
  String? expire;
  @JsonKey(name: 'jwtToken')
  String? token;
  String? id;
  @JsonKey(name: 'roles')
  List<Role>? role;
  String? type;
  String? postalCode;

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
  dynamicParse(data) {
    // TODO: implement dynamicParse
    return null;
  }

  @override
  AuthProviderUser parse(data) {
    return AuthProviderUser.fromJson(data);
  }
}
