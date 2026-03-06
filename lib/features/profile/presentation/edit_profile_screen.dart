import 'package:btl_music_app/features/profile/bloc/profile/profile_bloc.dart';
import 'package:btl_music_app/features/profile/bloc/profile/profile_event.dart';
import 'package:btl_music_app/features/profile/bloc/profile/profile_state.dart';
import 'package:btl_music_app/features/profile/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/features/profile/presentation/widget/edit_field.dart';
import 'package:btl_music_app/features/profile/presentation/widget/date_select.dart';
import 'package:btl_music_app/features/profile/presentation/widget/gender_select.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isSaving = false;

  late TextEditingController _displayNameController;
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _avatarController;

  DateTime? _birthday;
  String _gender = "Khác";

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController();
    _fullNameController = TextEditingController();
    _phoneController = TextEditingController();
    _bioController = TextEditingController();
    _avatarController = TextEditingController();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  // Cập nhật controllers từ user loaded
  void _updateControllers(UserModel user) {
    _displayNameController.text = user.displayName;
    _fullNameController.text = user.fullName;
    _phoneController.text = user.phone;
    _bioController.text = user.bio;
    _avatarController.text = user.avatar;
    _birthday = user.birthday;
    _gender = user.gender ? "Nam" : "Nữ";
  }

  Future<void> _saveChanges(BuildContext context, UserModel currentUser) async {
    if (_displayNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tên hiển thị không được để trống")),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final updatedUser = currentUser.copyWith(
        displayName: _displayNameController.text.trim(),
        fullName: _fullNameController.text.trim(),
        phone: _phoneController.text.trim(),
        bio: _bioController.text.trim(),
        birthday: _birthday,
        gender: _gender == "Nam",
        avatar: _avatarController.text.trim(),
      );

      // Gửi event UpdateProfile
      context.read<ProfileBloc>().add(UpdateProfile(updatedUser));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cập nhật hồ sơ thành công!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi lưu: $e")),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Thông tin cá nhân"),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.save, color: Colors.blue),
              onPressed: () {
                final state = context.read<ProfileBloc>().state;
                if (state is ProfileLoaded) {
                  _saveChanges(context, state.user);
                }
              },
              tooltip: "Lưu thay đổi",
            ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProfileError) {
            return Center(child: Text('Lỗi: ${state.message}'));
          }
          if (state is ProfileLoaded) {
            final user = state.user;
            // Cập nhật controllers nếu chưa có dữ liệu (lần đầu)
            if (_displayNameController.text.isEmpty) {
              _updateControllers(user);
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AvatarSection(avatarUrl: _avatarController.text),
                const SizedBox(height: 30),
                const SectionTitle(title: "Giới thiệu về bạn"),
                const SizedBox(height: 10),
                InfoCard(children: [
                  EditableField(
                    title: "Tên hiển thị",
                    controller: _displayNameController,
                    hint: "Tên bạn muốn hiển thị",
                  ),
                  EditableField(
                    title: "Tiểu sử",
                    controller: _bioController,
                    hint: "Viết gì đó về bạn...",
                    maxLines: 3,
                  ),
                  DateSelector(
                    title: "Sinh nhật",
                    date: _birthday,
                    onDateSelected: (newDate) => setState(() => _birthday = newDate),
                  ),
                  GenderSelector(
                    gender: _gender,
                    onGenderChanged: (newGender) => setState(() => _gender = newGender),
                  ),
                ]),
                const SizedBox(height: 25),
                const SectionTitle(title: "Thông tin tài khoản"),
                const SizedBox(height: 10),
                InfoCard(children: [
                  EditableField(
                    title: "Tên đầy đủ",
                    controller: _fullNameController,
                    hint: "Họ và tên đầy đủ",
                  ),
                  EditableField(
                    title: "Số điện thoại",
                    controller: _phoneController,
                    hint: "Số điện thoại của bạn",
                    keyboardType: TextInputType.phone,
                  ),
                  ReadonlyField(
                    title: "Email",
                    value: user.email,
                  ),
                ]),
              ],
            );
          }
          // ProfileInitial: tự động load
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<ProfileBloc>().add(LoadProfile());
          });
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}