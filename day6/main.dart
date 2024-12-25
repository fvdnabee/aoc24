import 'dart:convert';
import 'dart:io';

enum Direction { N, E, S, W }

typedef Dir = Direction;
const Map<Direction, List<int>> directions = {
  Direction.N: [-1, 0],
  Direction.E: [0, 1],
  Direction.S: [1, 0],
  Direction.W: [0, -1]
};
const nextDirection = {Dir.N: Dir.E, Dir.E: Dir.S, Dir.S: Dir.W, Dir.W: Dir.N};

Future<void> main() async {
  List<String> map = [];
  var startingPosition = [-1, -1];
  // await File('day6/toyinput')
  await File('day6/input')
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .forEach((line) {
    var idx = line.indexOf('^');
    if (idx > -1) {
      startingPosition = [map.length, idx];
    }
    map.add(line);
  });

  var direction = Dir.N;
  var r = calcRoute(List.unmodifiable(map),
      [startingPosition[0], startingPosition[1]], direction);
  print(r.nrPositions);

  // part2: loop over all possible positions for an obstacle and count positions that don't lead to a loop
  var nrPositions = 0;
  for (var row = 0; row < map.length; row++) {
    for (var col = 0; col < map[0].length; col++) {
      var mapCopy = List.from(map);
      mapCopy[row] = mapCopy[row].replaceRange(col, col + 1, '#');
      r = calcRoute(List.unmodifiable(mapCopy),
          [startingPosition[0], startingPosition[1]], direction);
      if (r.loop) {
        nrPositions += 1;
      }
    }
  }
  print(nrPositions);
  // map[6] = map[6].replaceRange(3, 4, '#');
  // r = calcRoute(List.unmodifiable(map),
  //     [startingPosition[0], startingPosition[1]], direction);

  // print(r.nrPositions);
  // print(r.loop);
}

typedef Result = ({
  int nrPositions,
  bool loop,
});

Result calcRoute(List<String> map, List<int> position, Dir direction) {
  Set<String> visitedPositions = {};
  Set<String> visitedPositionsDirection = {};
  var stop = false;
  var loop = false;
  while (!stop) {
    var candidatePosition = [
      position[0] + directions[direction]![0],
      position[1] + directions[direction]![1]
    ];
    if (outOfBounds(candidatePosition, map.length)) {
      stop = true;
    } else if (map[candidatePosition[0]][candidatePosition[1]] != '#') {
      position = candidatePosition;
      visitedPositions.add('${position[0]},${position[1]}');
      var posDir = '${position[0]},${position[1]},$direction';
      if (visitedPositionsDirection.contains(posDir)) {
        loop = true;
        stop = true;
      } else {
        visitedPositionsDirection.add(posDir);
      }
    } else {
      direction = nextDirection[direction]!;
    }
  }
  final ret = (nrPositions: visitedPositions.length, loop: loop);
  return ret;
}

bool outOfBounds(List<int> position, int size) {
  if (position[0] < 0 || position[0] >= size) {
    return true;
  }
  if (position[1] < 0 || position[1] >= size) {
    return true;
  }
  return false;
}
