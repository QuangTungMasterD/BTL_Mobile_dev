import 'package:btl_music_app/features/profile/bloc/profile/profile_bloc.dart';
import 'package:btl_music_app/features/profile/bloc/profile/profile_state.dart';
import 'package:btl_music_app/features/profile/bloc/profile/profile_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/core/widgets/bottom.dart';
import 'package:btl_music_app/core/widgets/header.dart';
import 'package:btl_music_app/core/widgets/mini_player.dart';
import 'package:btl_music_app/features/profile/presentation/widget/menu_list.dart';
import 'package:btl_music_app/features/profile/presentation/widget/premium_card.dart';
import 'package:btl_music_app/features/profile/presentation/widget/profile_user_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Lỗi: ${state.message}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(LoadProfile());
                      },
                      child: const Text("Tải lại"),
                    ),
                  ],
                ),
              );
            }
            if (state is ProfileLoaded) {
              final user = state.user;
              return ListView(
                children: [
                  ProfileHeader(title: 'Hồ sơ'),
                  ProfileUserHeader(user: user),
                  const SizedBox(height: 20),
                  if (!user.isPremium) PremiumCard(user: user),
                  const SizedBox(height: 20),
                  const ProfileMenu(),
                ],
              );
            }
            // ProfileInitial: tự động load
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ProfileBloc>().add(LoadProfile());
            });
            return const SizedBox.shrink();
          },
        ),
      ),
      bottomNavigationBar: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [MiniPlayer(), AppBottomNav(currentIndex: 3)],
      ),
    );
  }
}