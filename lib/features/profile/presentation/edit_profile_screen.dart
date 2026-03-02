import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String displayName = "gp.music.tranquangtung2606";
  String userId = "42319406";
  String bio = "";
  DateTime birthday = DateTime(1970, 1, 1);
  String gender = "Khác";

  String fullName = "";
  String phone = "";
  String email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Thông tin cá nhân"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAvatar(),
          const SizedBox(height: 30),
          _sectionTitle("Giới thiệu về bạn"),
          const SizedBox(height: 10),
          _buildInfoCard([
            _buildItem("Tên hiển thị", displayName, () {
              _showEditDialog("Tên hiển thị", displayName, (value) {
                setState(() => displayName = value);
              });
            }),
            _buildItem("ID", userId, null),
            _buildItem("Tiểu sử", bio.isEmpty ? "Thêm tiểu sử" : bio, () {
              _showEditDialog("Tiểu sử", bio, (value) {
                setState(() => bio = value);
              });
            }),
            _buildItem(
                "Sinh nhật", DateFormat("dd/MM/yyyy").format(birthday), () {
              _pickDate();
            }),
            _buildItem("Giới tính", gender, () {
              _showGenderSheet();
            }),
          ]),
          const SizedBox(height: 25),
          _sectionTitle("Thông tin tài khoản"),
          const SizedBox(height: 10),
          _buildInfoCard([
            _buildItem("Tên đầy đủ", fullName.isEmpty ? "Thêm" : fullName,
                () {
              _showEditDialog("Tên đầy đủ", fullName, (value) {
                setState(() => fullName = value);
              });
            }),
            _buildItem("Số điện thoại", phone.isEmpty ? "Thêm" : phone, () {
              _showEditDialog("Số điện thoại", phone, (value) {
                setState(() => phone = value);
              });
            }),
            _buildItem("Email", email.isEmpty ? "Thêm" : email, () {
              _showEditDialog("Email", email, (value) {
                setState(() => email = value);
              });
            }),
            _buildItem("Mật khẩu", "Thêm", () {
              _showEditDialog("Mật khẩu", "", (value) {});
            }),
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
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Đổi ảnh đại diện",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(color: Colors.white70, fontSize: 16),
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

  Widget _buildItem(
      String title, String value, VoidCallback? onTap) {
    return Column(
      children: [
        ListTile(
          title: Text(title,
              style: const TextStyle(color: Colors.white70)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value,
                  style: const TextStyle(color: Colors.white)),
              if (onTap != null) ...[
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios,
                    size: 14, color: Colors.white54),
              ]
            ],
          ),
          onTap: onTap,
        ),
        const Divider(color: Colors.white12, height: 1)
      ],
    );
  }

  void _showEditDialog(
      String title, String initialValue, Function(String) onSave) {
    TextEditingController controller =
        TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
            },
            child:
                const Text("Hủy", style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              onSave(controller.text);
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
            },
            child:
                const Text("Lưu", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthday,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null && mounted) {
      setState(() => birthday = picked);
    }
  }

  void _showGenderSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: ["Nam", "Nữ", "Khác"].map((g) {
          return ListTile(
            title: Text(g,
                style: const TextStyle(color: Colors.white)),
            onTap: () {
              setState(() => gender = g);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}