import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// 引入导出 Excel 需要的包
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

// --- 核心模型 ---
class CaseRecord {
  final String policyNumber, anp, submissionDate, inForceDate;
  CaseRecord(this.policyNumber, this.anp, this.submissionDate, this.inForceDate);
}

class CaseSubmissionPage extends StatefulWidget {
  // 接收从 main.dart 传过来的全局列表
  final List<CaseRecord> history; 
  const CaseSubmissionPage({super.key, required this.history});

  @override
  State<CaseSubmissionPage> createState() => _CaseSubmissionPageState();
}

class _CaseSubmissionPageState extends State<CaseSubmissionPage> {

  // --- 核心功能：导出 Excel ---
  Future<void> _exportToExcel() async {
    // 1. 创建 Excel 文件
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    // 2. 写入表头
    sheetObject.appendRow([
      TextCellValue("Policy Number"),
      TextCellValue("ANP (RM)"),
      TextCellValue("Submission Date"),
      TextCellValue("In Force Date"),
    ]);

    // 3. 遍历数据并写入
    for (var rec in widget.history) {
      sheetObject.appendRow([
        TextCellValue(rec.policyNumber),
        TextCellValue(rec.anp),
        TextCellValue(rec.submissionDate),
        TextCellValue(rec.inForceDate),
      ]);
    }

    // 4. 保存文件到手机临时目录
    var fileBytes = excel.save();
    final directory = await getTemporaryDirectory();
    final String filePath = "${directory.path}/Case_History_${DateTime.now().millisecondsSinceEpoch}.xlsx";
    
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);

    // 5. 弹出分享框，让用户选择发送到 WhatsApp、邮件等
    await Share.shareXFiles([XFile(filePath)], text: 'My Insurance Case History');
  }

  void _openForm() => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        builder: (_) => CreateCaseForm(onSubmitted: (rec) {
          setState(() {
            widget.history.insert(0, rec);
          });
        }),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text("Case Submission", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white, // 粉色已换成白色
        foregroundColor: Colors.black, // 文字颜色设为黑色
        elevation: 0,
        // --- 这里就是你要加的导出按钮 ---
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: Colors.black),
            onPressed: widget.history.isEmpty ? null : _exportToExcel, // 如果没数据就禁用按钮
            tooltip: "Export to Excel",
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 25, 20, 10),
            child: Row(children: [
              Icon(Icons.history, color: Colors.black54), 
              SizedBox(width: 8), 
              Text("Case History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
            ]),
          ),
          Expanded(
            child: widget.history.isEmpty 
              ? const Center(child: Text("No records yet", style: TextStyle(color: Colors.grey))) 
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: widget.history.length,
                  itemBuilder: (context, i) => _buildCaseCard(widget.history[i]),
                ),
          ),
        ],
      ),
    );
  }

  // 顶部操作区 (Create New Case 按钮区)
  Widget _buildHeader() => Container(
        width: double.infinity, 
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: const BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]
        ),
        child: Column(children: [
          const Icon(Icons.note_add_outlined, size: 70, color: Colors.black),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _openForm,
            icon: const Icon(Icons.add), 
            label: const Text("Create New Case"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white, 
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              elevation: 5,
            ),
          ),
        ]),
      );

  // 历史记录卡片
  Widget _buildCaseCard(CaseRecord item) => Card(
        margin: const EdgeInsets.only(bottom: 12), 
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.grey[200]!)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(15),
          title: Text("Policy: ${item.policyNumber}", style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Submission: ${item.submissionDate}\nIn Force: ${item.inForceDate}", style: const TextStyle(height: 1.5)),
          trailing: Text("RM ${item.anp}", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      );
}

// --- 提交表单 ---
class CreateCaseForm extends StatefulWidget {
  final Function(CaseRecord) onSubmitted;
  const CreateCaseForm({super.key, required this.onSubmitted});
  @override
  State<CreateCaseForm> createState() => _CreateCaseFormState();
}

class _CreateCaseFormState extends State<CreateCaseForm> {
  final _pCtrl = TextEditingController(), _aCtrl = TextEditingController();
  DateTime? _subDate, _infDate;

  Future<void> _pickDate(bool isSub) async {
    final date = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2020), 
      lastDate: DateTime(2030),
    );
    if (date != null) setState(() => isSub ? _subDate = date : _infDate = date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 25, right: 25, top: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: Text("New Case Submission", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          const SizedBox(height: 10),
          _inputLabel("Policy Number"), _field("Enter Policy Number", _pCtrl),
          _inputLabel("Annual Premium (ANP)"), _field("0.00", _aCtrl, isNum: true),
          _inputLabel("Date of Submission"), _dateTile(_subDate, () => _pickDate(true)),
          _inputLabel("In Force Date"), _dateTile(_infDate, () => _pickDate(false)),
          const SizedBox(height: 35),
          ElevatedButton(
            onPressed: () {
              if (_pCtrl.text.isEmpty) return;
              widget.onSubmitted(CaseRecord(_pCtrl.text, _aCtrl.text, _fmt(_subDate), _fmt(_infDate)));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black, minimumSize: const Size(double.infinity, 55)),
            child: const Text("Submit Case", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  String _fmt(DateTime? d) => d != null ? DateFormat('yyyy-MM-dd').format(d) : "Select Date";
  Widget _inputLabel(String l) => Padding(padding: const EdgeInsets.only(top: 15, bottom: 5), child: Text(l, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)));
  
  Widget _field(String h, TextEditingController c, {bool isNum = false}) => TextField(
    controller: c, keyboardType: isNum ? TextInputType.number : TextInputType.text,
    inputFormatters: isNum ? [FilteringTextInputFormatter.digitsOnly] : [],
    decoration: InputDecoration(hintText: h, filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
  );

  Widget _dateTile(DateTime? d, VoidCallback t) => InkWell(
    onTap: t,
    child: Container(
      padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(_fmt(d), style: const TextStyle(fontSize: 15)), const Icon(Icons.calendar_today, size: 18, color: Colors.black54)]),
    ),
  );
}