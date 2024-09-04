import 'Role.dart';

abstract class AuthUser {
  String? expire;
  String? id;
  String? token;
  List<Role>? role;
  String? type;
  String? postalCode;

  AuthUser fromJson(Map<String, dynamic> data);

  Map<String, dynamic> toJson();
}
