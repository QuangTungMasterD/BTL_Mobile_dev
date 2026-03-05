import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:btl_music_app/core/providers/user_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Đã đăng nhập: load dữ liệu user trước khi vào home
      final userProvider = context.read<UserProvider>();
      await userProvider.initUser();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Chưa đăng nhập
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Music App", style: TextStyle(fontSize: 30)),
      ),
    );
  }
}