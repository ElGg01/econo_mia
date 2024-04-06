import 'profile.dart';


abstract class ProfileRepository {
  /// Returns the [Profile] of the current user if connected to the internet else
  /// returns the [Profile]  from the local database
  Future<Profile> retrieve(String userId);

  /// Saves the [Profile] to the local and remote database
  Future<void> save(Profile profile);

  /// Deletes the [Profile] from the local and remote database
  Future<void> delete(String userId);

  /// Updates the [Profile] from the local and remote database
  Future<void> update(String userId);
}