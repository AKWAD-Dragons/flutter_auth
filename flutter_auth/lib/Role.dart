import 'package:json_annotation/json_annotation.dart';
part 'Role.g.dart';


@JsonSerializable(explicitToJson: true)
class Role {
  String? name;
  String? id;

  Role(this.name, this.id);

  Map<String, dynamic> toJson() {
    return _$RoleToJson(this);
  }

  factory Role.fromJson(Map<String, dynamic> json) {
    return _$RoleFromJson(json);
  }
}