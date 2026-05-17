import 'package:core_app/core/providers.dart';
import 'package:core_app/features/profile/profile_repository.dart';
import 'package:core_app/models/profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_providers.g.dart';

@riverpod
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileRepository(ref.watch(dioProvider));
}

@riverpod
Future<Profile> profile(ProfileRef ref) {
  return ref.watch(profileRepositoryProvider).getProfile();
}
