import 'package:json_annotation/json_annotation.dart';
import '../domain/entities.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String email;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  // fromJson
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // toJson
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // map sang Entity
  UserEntity toEntity() => UserEntity(id: id, name: name, email: email);
}
