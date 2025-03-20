import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nta_tool/model/Checker.dart';
import 'package:nta_tool/model/LogSheet.dart';
import 'package:nta_tool/model/Matchs.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NTATool",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TestDataForm(), // 使用 MyForm 替代 Form
    );
  }
}

class TestDataForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestDataFormState();
}

class _TestDataFormState extends State<TestDataForm> {
  final TextEditingController _logPathTextController = TextEditingController();
  String? _logPath;

  final TextEditingController _keywordPathTextController = TextEditingController();
  String? _keywordPath;

  final TextEditingController _outputPathTextController = TextEditingController();
  String? _outputPath;

  final TextEditingController _logTextController = TextEditingController();

  void _handleUploadLog() async {
    try {
      FilePickerResult? res = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['xlsx']
      );
      if (res != null) {
        setState(() {
          _logPath = res.files.single.path;
          _logPathTextController.text = _logPath!;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _handleUploadKeyword() async {
    try {
      FilePickerResult? res = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt']
      );
      if (res != null) {
        setState(() {
          _keywordPath = res.files.single.path;
          _keywordPathTextController.text = _keywordPath!;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _handleSetOutputPath() async {
    try {
      String formattedDate = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
      String? outputFile = await FilePicker.platform.saveFile(
        fileName: '$formattedDate.xlsx',
      );
      setState(() {
        _outputPath = outputFile;
        _outputPathTextController.text = _outputPath!;
      });
    } catch (e) {
      print(e);
    }
  }

  void _handleClean() {
    setState(() {
      _outputPath = null;
      _keywordPath = null;
      _logPath = null;
      _outputPathTextController.text = '';
      _keywordPathTextController.text = '';
      _logPathTextController.text = '';
    });
  }

  void _handleStart() {
    if (_logPath != null && _logPath!.isNotEmpty &&
        _keywordPath != null && _keywordPath!.isNotEmpty &&
        _outputPath != null && _outputPath!.isNotEmpty) {
      _logTextController.text = "[info] 开始检测...";

      LogSheet log = LogSheet(_logPath!);
      _logTextController.text += "\n[info] 加载${log.GetRowNum()}条日志数据.";
      Matchs m = Matchs(_keywordPath!);
      Checker c = Checker("data", log.GetSheetTittle(), log.GetSheetData());

      if (!c.CanCheck()) {
        _logTextController.text += "\n[err] 未包含检测项data";
        _logTextController.text += "\n[err] 检测结束.";
        _handleClean();
        return;
      }
      _logTextController.text += "\n[info] 包含检测项data.";
      _logTextController.text += "\n[info] 检测出${c.BeginCheck(m.GetMatchsValues())}条可疑流量.";
      c.GenCheckReport(_outputPath!);
      _logTextController.text += "\n[info] 检测完成，结果已写入指定文件.";
    } else {
      _logTextController.text = "[err] 参数不完全.";
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("NTA流量辅助分析工具")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //Row 上传日志文件
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: _logPathTextController,
                    decoration: InputDecoration(
                      labelText: "点击右侧按钮上传日志",
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                  )
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  child: Text("上传日志"),
                  onPressed: _handleUploadLog
                ),
              ],
            ),

            SizedBox(height: 10),

            //Row 上传关键字文件
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: _keywordPathTextController,
                      decoration: InputDecoration(
                        labelText: "点击右侧按钮上传关键字",
                          labelStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                    )
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  child: Text("上传关键字"),
                  onPressed: _handleUploadKeyword
                ),
              ],
            ),

            SizedBox(height: 10),

            //Row 设置结果输出目录
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: _outputPathTextController,
                      decoration: InputDecoration(
                        labelText: "点击右侧按钮设置导出日志",
                        labelStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    )
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  child: Text("设置导出日志"),
                  onPressed: _handleSetOutputPath
                ),
              ],
            ),

            SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  child: Text("清空设置"),
                  onPressed: _handleClean,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  child: Text("开始检测"),
                  onPressed: _handleStart,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            //检测日志输出
            TextField(
              readOnly: true,
              minLines: 6,
              maxLines: 6,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              controller: _logTextController,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 13),
            Text("Copyaright@aqjs1")
          ],
        ),
      ),
    );
  }
}




