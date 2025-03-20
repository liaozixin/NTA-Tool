
import 'dart:io';

class Matchs {
  final String _path;
  List<String> _matchsValue = [];

  Matchs(this._path) {
    final file = File(_path);
    _matchsValue = file.readAsLinesSync();
  }

  List<String> GetMatchsValues() {
    return _matchsValue;
  }
}