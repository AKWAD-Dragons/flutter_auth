// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthProviderUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthProviderUser _$AuthProviderUserFromJson(Map<String, dynamic> json) =>
    AuthProviderUser()
      ..querys =
          (json['querys'] as List<dynamic>?)?.map((e) => e as String).toList()
      ..accessToken = json['accessToken'] as String?
      ..idToken = json['idToken'] as String?
      ..expire = json['expire'] as String?
      ..token = json['jwtToken'] as String?
      ..id = json['id'] as String?
      ..role = (json['roles'] as List<dynamic>?)
          ?.map((e) => Role.fromJson(e as Map<String, dynamic>))
          .toList()
      ..type = json['type'] as String?
      ..postalCode = json['postalCode'] as String?;

Map<String, dynamic> _$AuthProviderUserToJson(AuthProviderUser instance) =>
    <String, dynamic>{
      'querys': instance.querys,
      'accessToken': instance.accessToken,
      'idToken': instance.idToken,
      'expire': instance.expire,
      'jwtToken': instance.token,
      'id': instance.id,
      'roles': instance.role?.map((e) => e.toJson()).toList(),
      'type': instance.type,
      'postalCode': instance.postalCode,
    };
