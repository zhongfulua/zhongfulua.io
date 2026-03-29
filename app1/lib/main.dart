import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const InsuranceApp());
}

// --- 全局模拟数据库 ---
Map<String, String> _userDatabase = {
  'Lucian': '123',
  'User1': '123',
  'admin': '123',
};

class InsuranceApp extends StatelessWidget {
  const InsuranceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Insurance Staff App',
      theme: ThemeData(
        primaryColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black, primary: Colors.black),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

// --- 数据模型：Case 记录 ---
class CaseRecord {
  final String policyNumber;
  final String anp;
  final String submissionDate;
  final String inForceDate;

  CaseRecord({
    required this.policyNumber,
    required this.anp,
    required this.submissionDate,
    required this.inForceDate,
  });
}

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

// --- 3. 忘记密码页面 (已实装真实逻辑) ---
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
      _showMessage("User not found!");
      return;
    }
    if (newP != confP || newP.isEmpty) {
      _showMessage("Passwords do not match or empty!");
      return;
    }

    // 更新全局数据库
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
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(controller: _userController, decoration: const InputDecoration(labelText: "Your Username")),
              TextField(controller: _newPassController, obscureText: true, decoration: const InputDecoration(labelText: "New Password")),
              TextField(controller: _confirmPassController, obscureText: true, decoration: const InputDecoration(labelText: "Confirm New Password")),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _resetPassword,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                  child: const Text("Update Password"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 4. 底部导航栏容器 ---
class MainNavigation extends StatefulWidget {
  final String username;
  const MainNavigation({super.key, required this.username});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const CaseSubmissionPage(),
      ProfilePage(initialName: widget.username),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Case'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// --- 5. 首页：排行榜 ---
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String currentMonth = DateFormat('MMMM').format(DateTime.now());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())),
            icon: const Icon(Icons.logout, color: Colors.red),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(currentMonth, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildPodiumItem("Agent B", "2", 100, Colors.grey[400]!),
              _buildPodiumItem("Agent A", "1", 140, Colors.black87),
              _buildPodiumItem("Agent C", "3", 80, Colors.grey[600]!),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(backgroundColor: Colors.black12, child: Text("${index + 4}")),
                title: Text("Agent ${index + 4}"),
                trailing: const Icon(Icons.trending_up, color: Colors.green),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(String name, String rank, double height, Color color) {
    return Column(
      children: [
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        const Icon(Icons.person, size: 30, color: Colors.grey),
        Container(
          width: 70,
          height: height,
          decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.vertical(top: Radius.circular(10))),
          child: Center(child: Text(rank, style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold))),
        ),
      ],
    );
  }
}

// --- 6. Case 提交页面 ---
class CaseSubmissionPage extends StatefulWidget {
  const CaseSubmissionPage({super.key});

  @override
  State<CaseSubmissionPage> createState() => _CaseSubmissionPageState();
}

class _CaseSubmissionPageState extends State<CaseSubmissionPage> {
  final List<CaseRecord> _caseHistory = [];

  void _showCreateDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => CreateCaseForm(onSubmitted: (newCase) {
        setState(() => _caseHistory.insert(0, newCase));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(title: const Text("Case Submission")),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            color: Colors.white,
            child: Column(
              children: [
                const Icon(Icons.assignment_add, size: 50, color: Colors.black),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _showCreateDialog,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text("Create new case"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: _caseHistory.isEmpty
                ? const Center(child: Text("No records yet"))
                : ListView.builder(
                    itemCount: _caseHistory.length,
                    itemBuilder: (context, index) {
                      final item = _caseHistory[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        child: ListTile(
                          title: Text("Policy: ${item.policyNumber}"),
                          trailing: Text("RM ${item.anp}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// --- 7. 创建 Case 表单 ---
class CreateCaseForm extends StatefulWidget {
  final Function(CaseRecord) onSubmitted;
  const CreateCaseForm({super.key, required this.onSubmitted});

  @override
  State<CreateCaseForm> createState() => _CreateCaseFormState();
}

class _CreateCaseFormState extends State<CreateCaseForm> {
  final _policyController = TextEditingController();
  final _anpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("New Case", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextField(controller: _policyController, decoration: const InputDecoration(labelText: "Policy Number")),
          TextField(controller: _anpController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "ANP (RM)")),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              widget.onSubmitted(CaseRecord(
                policyNumber: _policyController.text,
                anp: _anpController.text,
                submissionDate: "2024-01-01",
                inForceDate: "2024-01-01",
              ));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
            child: const Text("Submit"),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// --- 8. 个人资料页面 ---
class ProfilePage extends StatefulWidget {
  final String initialName;
  const ProfilePage({super.key, required this.initialName});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _name;
  String _birthday = "Add Birthday";
  String _lastYearProduction = "0";

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

            // --- 修改项: Change Password (现在联动到真实重置页面) ---
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