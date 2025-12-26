import 'package:json_annotation/json_annotation.dart';
import '../domain/entities.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String email;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? token;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? refreshToken;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    this.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? token,
    String? refreshToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  UserEntity toEntity() => UserEntity(
        id: id,
        name: name,
        email: email,
        token: token,
        refreshToken: refreshToken,
      );
}
