import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/core/providers/auth_provider.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthUserProvider _authProvider;

  LoginBloc({required AuthUserProvider authProvider})
      : _authProvider = authProvider,
        super(LoginInitial()) {
    on<LoginWithEmail>(_onLoginWithEmail);
    on<LoginWithGoogle>(_onLoginWithGoogle);
  }

  Future<void> _onLoginWithEmail(
    LoginWithEmail event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      await _authProvider.login(event.email, event.password);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> _onLoginWithGoogle(
    LoginWithGoogle event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      await _authProvider.loginWithGoogle();
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
