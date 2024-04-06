import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class Profile with _$Profile {
  const factory Profile({
    /// Unique ID of the user
    required String id,

    /// Name of the user
    required String name,

    /// Email of the user
    String? email,

    /// Photo URL of the user
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

  factory Profile.empty() => const Profile(
    id: '',
    name: '',
  );
}