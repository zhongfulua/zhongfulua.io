import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'login_page.dart'; // 导入登录页以便注销跳转

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取当前月份
    String currentMonth = DateFormat('MMMM').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const LoginPage())),
            icon: const Icon(Icons.logout, color: Colors.red), // 登出保留红色警示
          )
        ],
      ),
      body: Column(
        children: [
          // 1. 标题区域：黑白配
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                currentMonth,
                style: const TextStyle(
                  fontSize: 32, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.black, // 纯黑标题
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // 2. 领奖台区域 (Top 3) - 金属质感配色
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _podiumItem("Agent B", "2", 100, const Color(0xFFC0C0C0)), // 银色
              _podiumItem("Agent A", "1", 145, const Color(0xFFFFD700)), // 金色
              _podiumItem("Agent C", "3", 85, const Color(0xFFCD7F32)),  // 铜色
            ],
          ),
          const SizedBox(height: 30),

          // 3. 滚动排行榜区域 (4名及以后) - 极简灰白
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                int rank = index + 4;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[100], // 浅灰圆圈
                    child: Text("$rank", 
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  title: Text("Agent $rank", style: const TextStyle(fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.trending_up, color: Colors.grey), // 灰色趋势图标
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- 领奖台组件 ---
  Widget _podiumItem(String name, String rank, double height, Color podiumColor) {
    return Column(
      children: [
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        const Icon(Icons.person, size: 35, color: Colors.black87), // 黑色人物剪影
        const SizedBox(height: 4),
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            color: podiumColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1), 
                blurRadius: 10, 
                offset: const Offset(0, -2)
              )
            ],
          ),
          child: Center(
            child: Text(
              rank,
              style: const TextStyle(
                fontSize: 28, 
                color: Colors.white, 
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.black26, blurRadius: 2, offset: Offset(1, 1))]
              ),
            ),
          ),
        ),
      ],
    );
  }
}