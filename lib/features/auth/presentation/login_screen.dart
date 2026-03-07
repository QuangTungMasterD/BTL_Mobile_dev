import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/core/providers/auth_provider.dart';
import 'package:btl_music_app/features/auth/bloc/login/login_bloc.dart';
import 'package:btl_music_app/features/auth/bloc/login/login_event.dart';
import 'package:btl_music_app/features/auth/bloc/login/login_state.dart';
import 'package:btl_music_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:btl_music_app/features/home/presentation/home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        authProvider: context.read<AuthUserProvider>(),
      ),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFF0D1B2A),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            "https://images.unsplash.com/photo-1507874457470-272b3c8d8ee2",
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Color(0xFF0D1B2A)],
                              ),
                            ),
                          ),
                          const Positioned(
                            bottom: 30,
                            left: 20,
                            child: Text(
                              "My music",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _emailController,
                            hint: "Email",
                            icon: Icons.email_outlined,
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            controller: _passwordController,
                            hint: "Mật khẩu",
                            icon: Icons.lock_outline,
                            isPassword: true,
                            obscureText: _obscurePassword,
                            onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: state is LoginLoading
                                  ? null
                                  : () {
                                      final email = _emailController.text.trim();
                                      final password = _passwordController.text.trim();
                                      context.read<LoginBloc>().add(
                                        LoginWithEmail(email: email, password: password),
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E88E5),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text("Đăng nhập", style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text("OR", style: TextStyle(color: Colors.white54)),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: state is LoginLoading
                                  ? null
                                  : () => context.read<LoginBloc>().add(LoginWithGoogle()),
                              icon: const Icon(Icons.login),
                              label: const Text("Đăng nhập bằng Google"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white24),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const RegisterScreen()),
                              );
                            },
                            child: const Text(
                              "Chưa có tài khoản? Đăng ký",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (state is LoginLoading) const Center(child: CircularProgressIndicator()),
            ],
          ),
        );
      },
    );
  }
}
