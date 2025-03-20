
import 'dart:io';

import 'package:excel/excel.dart';

class Checker {
  String _checkColValue;
  List<String> _titleCol;
  List<List<String>> _data;
  List<List<String>>? _res;

  Checker(this._checkColValue, this._titleCol, this._data);

  bool CanCheck() {
    return _titleCol.contains(_checkColValue);
  }

  int? BeginCheck(List<String> checkValues) {
    _res = [];
    int index = _titleCol.indexOf(_checkColValue);
    for (var row in _data) {
      for (var value in checkValues) {
        if (row[index].contains(value)) {
          _res?.add(row);
          break;
        }
      }
    }
    return _res?.length;
  }

  void GenCheckReport(String path) {
    var res = Excel.createExcel();
    var sheet = res["Sheet1"];

    List<TextCellValue> title = [];
    for(var cell in _titleCol) {
      title.add(TextCellValue(cell));
    }
    sheet.appendRow(title);

    for (var row in _res!) {
      List<TextCellValue> data = [];
      for(var cell in row) {
        data.add(TextCellValue(cell));
      }
      sheet.appendRow(data);
    }

    var bytes = res.encode();
    File(path)
      ..createSync(recursive: true)
      ..writeAsBytes(bytes!);
  }
}