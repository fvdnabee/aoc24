import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  List<List<num>> reports = [];
  await File('day2/input')
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .forEach((line) {
    var splits = line.split(' ');
    reports.add(splits.map(int.parse).toList());
  });

  var nSafe = 0;
  var nSafeDampening = 0;

  for (var report in reports) {
    var deltas = <num>[];
    for (int i = 0; i < report.length - 1; i++) {
      deltas.add(report[i + 1] - report[i]);
    }
    if (isSafe(deltas)) {
      nSafe += 1;
    }
    if (isSafeDampening(deltas)) {
      nSafeDampening += 1;
    }
  }
  print('Number of safe reports: $nSafe');
  print('Number of safe reports with dampening: $nSafeDampening');
}

bool isSafe(List<num> deltas) {
  fnc(num delta) => (deltas.first < 0) ? delta < 0 : delta > 0;
  bool pred1 = deltas.every(fnc);
  bool pred2 = deltas.every((delta) => delta.abs() > 0 && delta.abs() < 4);
  return pred1 && pred2;
}

bool isSafeDampening(List<num> deltas) {
  num nIncreasing = 0, nDecreasing =0;
  for (var delta in deltas) {
    if (delta > 0) {
      nIncreasing +=1;
    } else if(delta < 0) {
      nDecreasing +=1;
    }
  }
  bool decreasing = nDecreasing > nIncreasing;

  fnc(num delta) => (decreasing) ? delta < 0 : delta > 0;
  fnc2(num delta) => delta.abs() > 0 && delta.abs() < 4;


  var skipped = false;
  for (int i = 0; i < deltas.length; i++) {
    num delta = deltas[i];
    bool isSafe = fnc(delta) && fnc2(delta);
    if (!isSafe) {
      if (skipped) {
        return false;
      } else {
        skipped = true;
        if (i > 0 && i < deltas.length) { deltas[i] += deltas[i-1]; }
        // deltas.removeAt(i);
        // i--;
      }
    }
  }

  return true;
}
