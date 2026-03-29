import 'package:flutter/material.dart';

// --- 数据模型：课程信息 ---
class Course {
  final String title;
  final String dueDate;
  bool isCompleted; // 是否完成，这个状态会随用户点击改变

  Course({
    required this.title,
    required this.dueDate,
    this.isCompleted = false, // 默认没完成
  });
}

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  // 模拟一些初始课程数据
  final List<Course> _courses = [
    Course(title: "Investment Link Products 101", dueDate: "2024-06-01"),
    Course(title: "Ethics & Compliance 2024", dueDate: "2024-06-15"),
    Course(title: "Medical Rider Updates", dueDate: "2024-07-10"),
    Course(title: "Customer Relationship Management", dueDate: "2024-08-01"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), // 浅灰色背景，更有质感
      appBar: AppBar(
        title: const Text("Learning Courses", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          final course = _courses[index];
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                // 左侧图标：根据是否完成显示不同颜色
                leading: CircleAvatar(
                  backgroundColor: course.isCompleted ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                  child: Icon(
                    course.isCompleted ? Icons.menu_book : Icons.library_books,
                    color: course.isCompleted ? Colors.green : Colors.orange,
                  ),
                ),
                // 课程标题
                title: Text(
                  course.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: course.isCompleted ? TextDecoration.lineThrough : null, // 完成后加删除线
                    color: course.isCompleted ? Colors.grey : Colors.black,
                  ),
                ),
                // 截止日期
                subtitle: Text("Due: ${course.dueDate}", style: const TextStyle(color: Colors.grey)),
                // 右侧打勾/打叉复选框
                trailing: Transform.scale(
                  scale: 1.2, // 让复选框大一点好点
                  child: Checkbox(
                    value: course.isCompleted,
                    activeColor: Colors.black, // 选中时的颜色
                    checkColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    onChanged: (bool? value) {
                      // 当用户点击时，更新状态并重新渲染 UI
                      setState(() {
                        course.isCompleted = value ?? false;
                      });
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}