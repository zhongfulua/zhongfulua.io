import 'package:flutter/material.dart';
import 'main.dart'; // 假设你的导航容器放在这个文件

// --- 全局模拟数据库 ---
Map<String, String> _userDatabase = {
  'Lucian': '123',
  'User1': '123',
  'admin': '123',
};

// --- 1. 登录页面 ---
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  void _handleLogin() {
    String inputUser = _userController.text.trim();
    String inputPass = _passController.text.trim();

    if (_userDatabase.containsKey(inputUser) && _userDatabase[inputUser] == inputPass) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainNavigation(username: inputUser)),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Login Failed"),
          content: const Text("Invalid username or password."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Login", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 50),
              _buildBlackTextField("Username", controller: _userController),
              const SizedBox(height: 30),
              _buildBlackTextField("Password", controller: _passController, isObscure: true, onFieldSubmitted: (_) => _handleLogin()),
              
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordPage())),
                  child: const Text("Forgot password?", style: TextStyle(color: Colors.grey)),
                ),
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Sign In", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage())),
                    child: const Text("Sign Up", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlackTextField(String hint, {required TextEditingController controller, bool isObscure = false, Function(String)? onFieldSubmitted}) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      onSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        hintText: hint,
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 0.5)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
      ),
    );
  }
}

// --- 2. 注册页面 ---
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  void _handleSignUp() {
    String user = _userController.text.trim();
    String pass = _passController.text.trim();
    if (user.isEmpty || pass.isEmpty) return;
    _userDatabase[user] = pass;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            TextField(controller: _userController, decoration: const InputDecoration(labelText: "Username")),
            TextField(controller: _passController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 40),
            ElevatedButton(onPressed: _handleSignUp, child: const Text("Create Account")),
          ],
        ),
      ),
    );
  }
}

// --- 3. 忘记密码页面 (优化后的布局) ---
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _userController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  void _resetPassword() {
    String user = _userController.text.trim();
    String newP = _newPassController.text.trim();
    String confP = _confirmPassController.text.trim();

    if (!_userDatabase.containsKey(user)) {
      _showMessage("User does not exist!");
      return;
    }
    if (newP.isEmpty || newP != confP) {
      _showMessage("Passwords do not match or are empty!");
      return;
    }

    _userDatabase[user] = newP;
    _showMessage("Password updated successfully!");
    Navigator.pop(context);
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 确保背景纯白
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        // 使用和登录页一样的左右大边距 (40)
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Reset\nPassword",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),
              ),
              const SizedBox(height: 40),
              
              // 使用统一的输入框样式
              _buildResetField("Username", controller: _userController),
              const SizedBox(height: 20),
              _buildResetField("New Password", controller: _newPassController, isObscure: true),
              const SizedBox(height: 20),
              _buildResetField("Confirm New Password", controller: _confirmPassController, isObscure: true),
              
              const SizedBox(height: 60),
              
              // 统一的大按钮
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text("Update Password", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 这里的样式要和登录页的 _buildBlackTextField 保持一致
  Widget _buildResetField(String hint, {required TextEditingController controller, bool isObscure = false}) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 0.5),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
      ),
    );
  }
}