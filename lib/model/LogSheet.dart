import 'dart:io';

import 'package:excel/excel.dart';

class LogSheet {
  final String _logPath;
  List<List<String>> _sheetData = [];

  LogSheet(this._logPath) {
    var bytes = File(this._logPath).readAsBytesSync();
    var xlsx = Excel.decodeBytes(bytes);
    if (xlsx.tables.isNotEmpty) {
      var first = xlsx.tables.keys.first;
      var sheet = xlsx.tables[first];

      if (sheet != null) {
        for (var row in sheet.rows) {
          _sheetData.add(row.map((cell) => cell?.value.toString() ?? "").toList());
        }
      }
    }
  }

  int GetRowNum() {
    return _sheetData.length - 1;
  }

  List<String> GetSheetTittle() {
    return _sheetData[0];
  }

  List<List<String>> GetSheetData() {
    List<List<String>> res = [];
    for (var row in _sheetData.skip(1)) {
      res.add(row);
    }
    return res;
  }
}