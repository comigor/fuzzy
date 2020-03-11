import 'data/match_index.dart';

/// Retrieve all matched indexes given a mask and minimum length
List<MatchIndex> matchedIndices(List<int> matchmask, int minMatchCharLength) {
  matchmask ??= [];
  minMatchCharLength ??= 1;

  final matchedIndices = <MatchIndex>[];
  var start = -1;
  var end = -1;
  var i = 0;

  // Abort if [matchmask] is empty
  if (matchmask.isEmpty) return matchedIndices;

  for (var len = matchmask.length; i < len; i += 1) {
    var match = matchmask[i];
    if (match != 0 && start == -1) {
      start = i;
    } else if (match == 0 && start != -1) {
      end = i - 1;
      if ((end - start) + 1 >= minMatchCharLength) {
        matchedIndices.add(MatchIndex(start, end));
      }
      start = -1;
    }
  }

  if (matchmask[i - 1] != 0 && (i - start) >= minMatchCharLength) {
    matchedIndices.add(MatchIndex(start, i - 1));
  }

  return matchedIndices;
}
