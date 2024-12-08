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
    List<num> deltas = calcDeltas(report);
    if (isSafe(deltas)) {
      nSafe += 1;
    }

    if (isSafeDampening(report)) {
      nSafeDampening += 1;
    }
  }
  print('Number of safe reports: $nSafe');
  print('Number of safe reports with dampening: $nSafeDampening');
}

List<num> calcDeltas(List<num> report) {
  var deltas = <num>[];
  for (int i = 0; i < report.length - 1; i++) {
    deltas.add(report[i + 1] - report[i]);
  }
  return deltas;
}

bool isSafe(List<num> deltas) {
  fnc(num delta) => (deltas.first < 0) ? delta < 0 : delta > 0;
  bool pred1 = deltas.every(fnc);
  bool pred2 = deltas.every((delta) => delta.abs() > 0 && delta.abs() < 4);
  return pred1 && pred2;
}

bool isSafeDampening(List<num> report) {
  List<num> deltas = calcDeltas(report);
  if (isSafe(deltas)) return true;

  for (int index = 0; index < report.length; index++) {
    var newReport = new List<num>.from(report);
    newReport.removeAt(index);
    List<num> deltas = calcDeltas(newReport);
    if (isSafe(deltas)) return true;
  }

  return false;
}
