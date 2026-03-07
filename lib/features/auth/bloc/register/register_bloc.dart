import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/core/providers/auth_provider.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthUserProvider _authProvider;

  RegisterBloc({required AuthUserProvider authProvider})
      : _authProvider = authProvider,
        super(RegisterInitial()) {
    on<RegisterWithEmail>(_onRegisterWithEmail);
  }

  Future<void> _onRegisterWithEmail(
    RegisterWithEmail event,
    Emitter<RegisterState> emit,
  ) async {
    // Kiểm tra mật khẩu khớp nhau
    if (event.password != event.confirmPassword) {
      emit(RegisterPasswordsMismatch("Mật khẩu không khớp"));
      return;
    }

    emit(RegisterLoading());
    try {
      await _authProvider.register(event.email, event.password);
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
