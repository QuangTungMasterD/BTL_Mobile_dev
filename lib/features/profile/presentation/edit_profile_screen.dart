import 'package:btl_music_app/core/providers/user_provider.dart';
import 'package:btl_music_app/features/profile/presentation/widget/date_select.dart';
import 'package:btl_music_app/features/profile/presentation/widget/gender_select.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isLoading = true;
  bool _isSaving = false;

  late TextEditingController _displayNameController;
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;

  DateTime? _birthday;
  String _gender = "Khác";

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController();
    _fullNameController = TextEditingController();
    _phoneController = TextEditingController();
    _bioController = TextEditingController();

    // Load dữ liệu sau khi widget build xong
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    if (user != null) {
      setState(() {
        _displayNameController.text = user.displayName;
        _fullNameController.text = user.fullName;
        _phoneController.text = user.phone;
        _bioController.text = user.bio;
        _birthday = user.birthday;
        _gender = user.gender ? "Nam" : "Nữ";
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không tìm thấy thông tin người dùng")),
      );
    }
  }

  Future<void> _saveChanges() async {
    if (_displayNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tên hiển thị không được để trống")),
      );
      return;
    }

    setState(() => _isSaving = true);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.user;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không tìm thấy thông tin user")),
      );
      setState(() => _isSaving = false);
      return;
    }

    try {
      final updatedUser = currentUser.copyWith(
        displayName: _displayNameController.text.trim(),
        fullName: _fullNameController.text.trim(),
        phone: _phoneController.text.trim(),
        bio: _bioController.text.trim(),
        birthday: _birthday,
        gender: _gender == "Nam", // true = Nam
      );

      await userProvider.updateProfile(updatedUser);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cập nhật hồ sơ thành công!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // Quay về ProfileScreen
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi khi lưu: $e")));
    }

    setState(() => _isSaving = false);
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
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
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.save, color: Colors.blue),
              onPressed: _isSaving ? null : _saveChanges,
              tooltip: "Lưu thay đổi",
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildAvatar(),
                const SizedBox(height: 30),
                _sectionTitle("Giới thiệu về bạn"),
                const SizedBox(height: 10),
                _buildInfoCard([
                  _buildEditableItem(
                    title: "Tên hiển thị",
                    controller: _displayNameController,
                    hint: "Tên bạn muốn hiển thị",
                  ),
                  _buildReadonlyItem("ID", "42319406"), // ID không sửa
                  _buildEditableItem(
                    title: "Tiểu sử",
                    controller: _bioController,
                    hint: "Viết gì đó về bạn...",
                    maxLines: 3,
                  ),
                  DateSelector(
                    title: "Sinh nhật",
                    date: _birthday,
                    onDateSelected: (newDate) =>
                        setState(() => _birthday = newDate),
                  ),
                  GenderSelector(
                    gender: _gender,
                    onGenderChanged: (newGender) {
                      setState(() {
                        _gender = newGender;
                      });
                    },
                  )
                ]),
                const SizedBox(height: 25),
                _sectionTitle("Thông tin tài khoản"),
                const SizedBox(height: 10),
                _buildInfoCard([
                  _buildEditableItem(
                    title: "Tên đầy đủ",
                    controller: _fullNameController,
                    hint: "Họ và tên đầy đủ",
                  ),
                  _buildEditableItem(
                    title: "Số điện thoại",
                    controller: _phoneController,
                    hint: "Số điện thoại của bạn",
                    keyboardType: TextInputType.phone,
                  ),
                  _buildReadonlyItem(
                    "Email",
                    Provider.of<UserProvider>(context).user?.email ?? "Chưa có",
                  ),
                  // Không có mật khẩu nữa
                ]),
              ],
            ),
    );
  }

  Widget _buildAvatar() {
    return Center(
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.teal,
            child: Text(
              "T",
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Chức năng đổi ảnh đại diện đang phát triển"),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Đổi ảnh đại diện",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildEditableItem({
    required String title,
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: const TextStyle(color: Colors.white70)),
          subtitle: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint ?? "Chưa có",
              hintStyle: const TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
          ),
        ),
        const Divider(color: Colors.white12, height: 1),
      ],
    );
  }

  Widget _buildReadonlyItem(String title, String value) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: const TextStyle(color: Colors.white70)),
          trailing: Text(value, style: const TextStyle(color: Colors.white)),
        ),
        const Divider(color: Colors.white12, height: 1),
      ],
    );
  }

}
