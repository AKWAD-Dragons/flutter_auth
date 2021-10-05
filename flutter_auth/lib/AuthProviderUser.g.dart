// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthProviderUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthProviderUser _$AuthProviderUserFromJson(Map<String, dynamic> json) {
  return AuthProviderUser()
    ..accessToken = json['accessToken'] as String?
    ..idToken = json['idToken'] as String?
    ..expire = json['expire'] as String?
    ..token = json['jwtToken'] as String?
    ..id = json['id'] as String?
    ..role = json['role'] as String?
    ..type = json['type'] as String?
    ..postalCode = json['postalCode'] as String?;
}

Map<String, dynamic> _$AuthProviderUserToJson(AuthProviderUser instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'idToken': instance.idToken,
      'expire': instance.expire,
      'jwtToken': instance.token,
      'id': instance.id,
      'role': instance.role,
      'type': instance.type,
      'querys': instance.querys,
    };
