import 'package:ai_movie_app/features/profile/domain/entities/profile_entity.dart';


sealed class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileEntity data;

  ProfileLoaded(this.data);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
