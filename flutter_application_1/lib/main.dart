import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'case_page.dart';
import 'profile_page.dart';
import 'course_page.dart'; // 以后加了文件再取消这一行的注释

void main() => runApp(const InsuranceApp());

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
      home: const LoginPage(), // 入口依然是登录页
    );
  }
}

// --- 底部导航栏容器 ---
class MainNavigation extends StatefulWidget {
  final String username;
  const MainNavigation({super.key, required this.username});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final List<CaseRecord> _globalcaseHistory = []; 
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // 这里的页面现在都来自不同的文件了！
    _pages = [
      const HomePage(),
      const CoursePage(),
      CaseSubmissionPage(history: _globalcaseHistory),
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
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Course"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Case'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}