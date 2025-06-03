import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'character_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Character extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String status;

  @HiveField(3)
  final String species;

  @HiveField(4)
  final String image;

  @HiveField(5)
  @JsonKey(name: 'location')
  final LocationInfo? locationInfo;

  @HiveField(6)
  bool isFavorite;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    required this.locationInfo,
    this.isFavorite = false,
  });

  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterToJson(this);

  Character copyWith({
    int? id,
    String? name,
    String? status,
    String? species,
    String? image,
    LocationInfo? locationInfo,
    bool? isFavorite,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      image: image ?? this.image,
      locationInfo: locationInfo ?? this.locationInfo,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

@HiveType(typeId: 1)
@JsonSerializable()
class LocationInfo extends HiveObject {
  @HiveField(0)
  final String? name;

  @HiveField(1)
  final String? url;

  LocationInfo({
    required this.name,
    required this.url,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) => _$LocationInfoFromJson(json);
  Map<String, dynamic> toJson() => _$LocationInfoToJson(this);
}