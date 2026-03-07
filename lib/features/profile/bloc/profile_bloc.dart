import 'package:btl_music_app/features/profile/bloc/profile_event.dart';
import 'package:btl_music_app/features/profile/bloc/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/features/profile/data/repo/user_repo.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _repository;

  ProfileBloc({required UserRepository repository})
      : _repository = repository,
        super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      await _repository.createUserIfNotExists(); // đảm bảo có user
      final user = await _repository.getUser();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    try {
      await _repository.updateUser(event.user);
      add(LoadProfile());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}