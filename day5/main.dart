import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  List<String> rulesLines = [];
  List<String> updatesLines = [];
  await File('day5/input')
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .forEach((line) {
    if (line.isEmpty) return;
    if (line.contains('|')) {
      rulesLines.add(line);
    } else {
      updatesLines.add(line);
    }
  });

  Map<int, List<int>> rules = {};
  for (final ruleLine in rulesLines) {
    var splits = ruleLine.split('|');
    int left = int.parse(splits[0]);
    int right = int.parse(splits[1]);
    if (!rules.containsKey(left)) {
      rules[left] = [];
    }
    rules[left]?.add(right);
  }

  var totalValid = 0, totalInvalid = 0;
  for (final update in updatesLines) {
    final pages =
        update.split(',').map((element) => int.parse(element)).toList();
    if (isValidUpdate(rules, pages)) {
      // print("${update} is valid");
      var middlePage = pages[pages.length ~/ 2];
      totalValid += middlePage;
    } else {
      var reshuffledPages = fixPages(rules, pages);
      print(reshuffledPages);
      var middlePage = reshuffledPages[reshuffledPages.length ~/ 2];
      totalInvalid += middlePage;
    }
  }
  print(totalValid);
  print(totalInvalid);
}

bool isValidUpdate(Map<int, List<int>> rules, List<int> pages) {
  for (int i = 0; i < pages.length; i++) {
    var rulesForPage = rules[pages[i]];
    for (int j = i + 1; j < pages.length; j++) {
      if (!(rulesForPage?.contains(pages[j]) ?? false)) {
        return false;
      }
    }
  }
  return true;
}

List<int> fixPages(Map<int, List<int>> rules, List<int> pages) {
  List<int> fixedPages = [];
  var nrPages = pages.length;
  for (int i = 0; i < nrPages; i++) {
    for (final candidatePage in pages) {
      var validCandidate = true;

      for (final otherPage in pages) {
        if (otherPage == candidatePage) {
          continue;
        }
        if (!rules.containsKey(candidatePage)) {
          // should probably be last page.
          if (i < nrPages - 1) {
            validCandidate = false;
          }
          break;
        }
        if (!rules[candidatePage]!.contains(otherPage)) {
          validCandidate = false;
          break;
        }
      }
      if (validCandidate) {
        fixedPages.add(candidatePage);
        pages.remove(candidatePage);
        break;
      }
    }
  }

  return fixedPages;
}
