import 'package:flutter/material.dart';

class FixedLengthParser {
  FixedLengthParser(String value) : _characters = value.characters;

  Characters _characters;
  var _index = 0;

  String getByLength(int length) {
    var value = _characters.getRange(_index, _index + length);
    _index += length;
    return value.string.trim();
  }
}