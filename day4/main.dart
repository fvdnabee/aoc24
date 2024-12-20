import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  List<List<String>> wordSearch = [];
  await File('day4/input')
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .forEach((line) {
    var runes = line.split('');
    wordSearch.add(runes);
  });
  print(wordSearch);

  List<String> combinations = getAllCombinations(wordSearch);
  print(combinations);

  RegExp exp = RegExp(r'(XMAS)');
  int nMatches = 0;
  for (final combo in combinations) {
    nMatches += exp.allMatches(combo).length;
  }
  print(nMatches);

  int n = countXMAS(wordSearch);
  print(n);
}

List<String> getAllCombinations(List<List<String>> wordSearch) {
  var nrRows = wordSearch.length;
  var nrCols = wordSearch[0].length;

  // horizontal:
  List<String> combinationsHorizontal = [];
  for (var i = 0; i < nrRows; i++) {
    combinationsHorizontal.add(wordSearch[i].join(''));
  }
  print('horizontal');
  print(combinationsHorizontal);

  // vertical:
  List<String> combinationsVertical = [];
  final sb = StringBuffer();
  for (var j = 0; j < nrCols; j++) {
    for (var i = 0; i < nrRows; i++) {
      sb.write(wordSearch[i][j]);
    }
    combinationsVertical.add(sb.toString());
    sb.clear();
  }
  print('vertical');
  print(combinationsVertical);

  // South East diagonal
  List<String> combinationsSEDiag = [];
  List<List<int>> indices = [];
  for (var i = 0; i < nrRows; i++) {
    indices.add([i, 0]);
  }
  for (var j = 1; j < nrCols; j++) {
    indices.add([0, j]);
  }
  for (final startIdx in indices) {
    final sum = startIdx[0] + startIdx[1];
    for (int i = 0; i < nrRows - sum; i++) {
      sb.write(wordSearch[startIdx[0] + i][startIdx[1] + i]);
    }
    combinationsSEDiag.add(sb.toString());
    sb.clear();
  }
  print('SE diagonal');
  print(combinationsSEDiag);

  // South West diagonal
  List<String> combinationsSWDiag = [];
  indices.clear();
  for (var j = 0; j < nrCols; j++) {
    indices.add([0, j]);
  }
  for (var i = 1; i < nrRows; i++) {
    indices.add([i, nrCols - 1]);
  }
  for (final startIdx in indices) {
    final nDiag = startIdx[1] - startIdx[0] + 1;
    for (int i = 0; i < nDiag; i++) {
      sb.write(wordSearch[startIdx[0] + i][startIdx[1] - i]);
    }
    combinationsSWDiag.add(sb.toString());
    sb.clear();
  }
  print('SW diagonal');
  print(combinationsSWDiag);

  List<String> combinations = [];
  combinations.addAll(combinationsHorizontal);
  combinations.addAll(combinationsVertical);
  combinations.addAll(combinationsSEDiag);
  combinations.addAll(combinationsSWDiag);

  List<String> combinationsReversed = combinations
      .map((elem) => new String.fromCharCodes(elem.runes.toList().reversed))
      .toList();
  combinations.addAll(combinationsReversed);

  return combinations;
}

int countXMAS(List<List<String>> wordSearch) {
  int nrXMAS = 0;
  var nrRows = wordSearch.length;
  var nrCols = wordSearch[0].length;
  String idx(int i, int j) => wordSearch[i][j];
  const patterns = ['MAS', 'SAM'];

  for (int i = 0; i < nrRows; i++) {
    for (int j = 0; j < nrCols; j++) {
      if (idx(i, j) != 'A') {
        continue;
      }
      if (i - 1 < 0 || j - 1 < 0 || i + 1 == nrRows || j + 1 == nrCols) {
        continue;
      }

      String diag1 = idx(i - 1, j - 1) + idx(i, j) + idx(i + 1, j + 1);
      String diag2 = idx(i + 1, j - 1) + idx(i, j) + idx(i - 1, j + 1);
      if (patterns.contains(diag1) && patterns.contains(diag2)) {
        nrXMAS += 1;
      }
    }
  }
  return nrXMAS;
}
