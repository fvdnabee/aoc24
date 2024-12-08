import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  String memory = await File('day3/input').readAsString();
  print(calcMulsim(memory));

  String memoryAlt = preprocess(memory);
  print(calcMulsim(memoryAlt));
}

num calcMulsim(String memory) {
  const expectedChars = ['m', 'u', 'l', '(', '0123456789,', '0123456789)'];

  List<List<num>> numbers = [];
  num mulSum = 0;
  var index = 0;
  final num1 = StringBuffer(), num2 = StringBuffer();
  for (var rune in memory.runes) {
    var character = String.fromCharCode(rune);
    var expected = expectedChars[index];
    if (!expected.contains(character)) {
      if (index > 3) {
        num1.clear();
        num2.clear();
      }
      index = 0;
      continue;
    }
    if (index < 4) {
      index++;
    } else if (index == 4) {
      if (character == ',') {
        index++;
      } else {
        num1.write(character);
      }
    } else if (index == 5) {
      if (character == ')') {
        var op1 = num.parse(num1.toString());
        var op2 = num.parse(num2.toString());
        numbers.add([op1, op2]);
        mulSum += op1 * op2;
        num1.clear();
        num2.clear();
        index = 0;
      } else {
        num2.write(character);
      }
    }
  }
  return mulSum;
}

String preprocess(String memory) {
  const expectedChars = ['d', 'o', 'n', '\'', 't', '(', ')'];
  const expectedChars2 = ['d', 'o', '(', ')'];
  var result = StringBuffer();
  var enabled = true;
  var index = 0;
  for (var rune in memory.runes) {
    var character = String.fromCharCode(rune);

    if (enabled) {
      if (expectedChars[index] == character) {
        if (index == 6) {
          enabled = false;
          index = 0;
        } else {
          index += 1;
        }
      } else {
        result.write(character);
        index = 0;
      }
    } else {
      if (expectedChars2[index] == character) {
        if (index == 3) {
          enabled = true;
          index = 0;
        } else {
          index += 1;
        }
      } else {
        index = 0;
      }
    }
  }
  return result.toString();
}
