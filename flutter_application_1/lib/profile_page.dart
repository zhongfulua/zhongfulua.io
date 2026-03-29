import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'login_page.dart'; // 导入以便退出登录时跳转

class ProfilePage extends StatefulWidget {
  final String initialName;
  const ProfilePage({super.key, required this.initialName});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _name;
  String _birthday = "Add Birthday";
  final String _lastYearProduction = "0";

  @override
  void initState() {
    super.initState();
    _name = widget.initialName;
  }

  void _editName() {
    final ctrl = TextEditingController(text: _name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Name"),
        content: TextField(controller: ctrl, decoration: const InputDecoration(hintText: "Enter your name")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(onPressed: () {
            setState(() => _name = ctrl.text);
            Navigator.pop(context);
          }, child: const Text("Save")),
        ],
      ),
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account", style: TextStyle(color: Colors.red)),
        content: const Text("Are you sure you want to delete your account? This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            child: const Text("Confirm", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Profile"), backgroundColor: Colors.white, elevation: 0, centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                child: const Icon(Icons.person, size: 60, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 40),
            
            _buildInfoRow(Icons.person_outline, "Name", _name, _editName),
            
            _buildInfoRow(Icons.cake_outlined, "Birthday", _birthday, () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() => _birthday = DateFormat('yyyy-MM-dd').format(picked));
              }
            }),
            
            _buildInfoRow(Icons.trending_up, "Last Year Production", _lastYearProduction, null),

            _buildInfoRow(Icons.vpn_key_outlined, "Change Password", null, () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordPage()));
            }),

            _buildInfoRow(Icons.logout, "Log Out", null, () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
            }, textColor: Colors.red),

            _buildInfoRow(Icons.delete, "Delete Account", null, _confirmDeleteAccount, textColor: Colors.red),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value, VoidCallback? onTap, {Color textColor = Colors.black}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Row(
          children: [
            Icon(icon, color: textColor == Colors.red ? Colors.red : Colors.black87, size: 24),
            const SizedBox(width: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor)),
                if (value != null) ...[
                  const SizedBox(height: 4),
                  Text(value, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}