import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  var locationIDsLeft = <num>[];
  var locationIDsRight = <num>[];
  await File('day1/input')
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .forEach((line) {
    var splits = line.split(' ');
    locationIDsLeft.add(int.parse(splits.first));
    locationIDsRight.add(int.parse(splits.last));
  });

  var sum = calcDistance(locationIDsLeft, locationIDsRight);
  print('Sum of distances: $sum');

  var similarity = calcSimilarity(locationIDsLeft, locationIDsRight);
  print('Similarity: $similarity');
}

num calcDistance(List<num> locationIDsLeft, List<num> locationIDsRight) {
  locationIDsLeft.sort((a, b) => a.compareTo(b));
  locationIDsRight.sort((a, b) => a.compareTo(b));

  var distances = <num>[];
  locationIDsLeft.asMap().forEach((index, value) {
    var distance = (value - locationIDsRight[index]).abs();
    distances.add(distance);
  });

  var sum = distances.reduce((value, element) => value + element);
  return sum;
}

num calcSimilarity(List<num> locationIDsLeft, List<num> locationIDsRight) {
  var counts = <num, num>{};
  for (var id in locationIDsRight) {
    counts[id] = (counts[id] ?? 0) + 1;
  }
  var scores = locationIDsLeft.map((id) => id * (counts[id] ?? 0));
  var similarity = scores.reduce((value, element) => value + element);
  return similarity;
}
