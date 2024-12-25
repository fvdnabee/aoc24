import 'dart:convert';
import 'dart:io';
import 'dart:math';

typedef Equation = (
  int testValue,
  List<int> operands,
);

Future<void> main() async {
  List<Equation> equations = [];
  // await File('day7/toyinput')
  await File('day7/input')
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .forEach((line) {
    var splits = line.split(':');
    int testValue = int.parse(splits[0]);
    var operands = splits[1].trim().split(' ').map(int.parse).toList();
    equations.add((testValue, operands));
  });

  var totalCalibration = 0;
  for (var eq in equations) {
    if (isTrue(eq)) {
      totalCalibration += eq.$1;
    }
  }
  print(totalCalibration);

  // part 2:
  totalCalibration = 0;
  for (var eq in equations) {
    if (isTrueP2(eq)) {
      totalCalibration += eq.$1;
    }
  }
  print(totalCalibration);
}

bool isTrue(Equation eq) {
  var (testValue, operands) = eq;
  var limit = pow(2, operands.length - 1);
  for (var i = 0; i < limit; i++) {
    var result = operands[0];
    for (var j = 0; j < operands.length - 1; j++) {
      if (((i >> j) % 2) == 0) {
        result += operands[j + 1];
      } else {
        result *= operands[j + 1];
      }
    }
    if (result == testValue) {
      return true;
    }
  }
  return false;
}

bool isTrueP2(Equation eq) {
  var (testValue, operands) = eq;
  var limit = pow(3, operands.length - 1);
  for (var i = 0; i < limit; i++) {
    var result = operands[0];
    for (var j = 0; j < operands.length - 1; j++) {
      // WIP:
      int div = pow(3, j).toInt();
      int comp = (i ~/ div) % 3;
      if (comp == 0) {
        result += operands[j + 1];
      } else if (comp == 1) {
        result *= operands[j + 1];
      } else {
        result = int.parse(result.toString() + operands[j + 1].toString());
      }
    }
    if (result == testValue) {
      return true;
    }
  }
  return false;
}
