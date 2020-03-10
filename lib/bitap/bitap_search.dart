import 'dart:math';

import 'bitap_matched_indices.dart';
import 'bitap_score.dart';
import 'data/match_score.dart';

/// Executes a bitap search
MatchScore bitapSearch(
  String text,
  String pattern,
  Map<String, int> patternAlphabet, {
  int location = 0,
  int distance = 100,
  double threshold = 0.6,
  bool findAllMatches = false,
  int minMatchCharLength = 1,
}) {
  // Set starting location at beginning text and initialize the alphabet.
  final textLen = text.length;
  // Highest score beyond which we give up.
  var currentThreshold = threshold;
  // Is there a nearby exact match? (speedup)
  var bestLocation = text.indexOf(pattern, location);

  final patternLen = pattern.length;

  // a mask of the matches
  final matchMask = List.filled(textLen, 0);

  if (bestLocation != -1) {
    final score = bitapScore(
      pattern,
      errors: 0,
      currentLocation: bestLocation,
      expectedLocation: location,
      distance: distance,
    );
    currentThreshold = min(score, currentThreshold);

    // What about in the other direction? (speed up)
    bestLocation = text.lastIndexOf(pattern, location + patternLen);

    if (bestLocation != -1) {
      final score = bitapScore(
        pattern,
        errors: 0,
        currentLocation: bestLocation,
        expectedLocation: location,
        distance: distance,
      );
      currentThreshold = min(score, currentThreshold);
    }
  }

  // Reset the best location
  bestLocation = -1;

  var lastBitArr = <int>[];
  var finalScore = 1.0;
  var binMax = patternLen + textLen;

  final mask = 1 << (patternLen <= 31 ? patternLen - 1 : 30);

  for (var i = 0; i < patternLen; i += 1) {
    // Scan for the best match; each iteration allows for one more error.
    // Run a binary search to determine how far from the match location we can stray
    // at this error level.
    var binMin = 0;
    var binMid = binMax;

    while (binMin < binMid) {
      final score = bitapScore(
        pattern,
        errors: i,
        currentLocation: location + binMid,
        expectedLocation: location,
        distance: distance,
      );

      if (score <= currentThreshold) {
        binMin = binMid;
      } else {
        binMax = binMid;
      }

      binMid = ((binMax - binMin) / 2 + binMin).floor();
    }

    // Use the result from this iteration as the maximum for the next.
    binMax = binMid;

    var start = max(1, location - binMid + 1);
    final finish =
        findAllMatches ? textLen : min(location + binMid, textLen) + patternLen;

    // Initialize the bit array
    final bitArr = List<int>.filled(finish + 2, 0, growable: true);

    bitArr.setRange(finish + 1, finish + 2, [(1 << i) - 1]);

    for (var j = finish; j >= start; j -= 1) {
      final currentLocation = j - 1;
      final currentChar =
          currentLocation >= text.length ? '' : text[currentLocation];
      final charMatch = patternAlphabet[currentChar];

      if (charMatch != null && currentLocation < textLen) {
        matchMask[currentLocation] = 1;
      }

      // First pass: exact match
      bitArr[j] = ((bitArr[j + 1] << 1) | 1) & (charMatch ?? 0);

      // Subsequent passes: fuzzy match
      if (i != 0) {
        bitArr.replaceRange(j, j + 1, [
          bitArr[j] |
              (((lastBitArr[j + 1] | lastBitArr[j]) << 1) | 1) |
              lastBitArr[j + 1]
        ]);
      }

      if (bitArr[j] & mask != 0) {
        finalScore = bitapScore(
          pattern,
          errors: i,
          currentLocation: currentLocation,
          expectedLocation: location,
          distance: distance,
        );

        // This match will almost certainly be better than any existing match.
        // But check anyway.
        if (finalScore <= currentThreshold) {
          // Indeed it is
          currentThreshold = finalScore;
          bestLocation = currentLocation;

          // Already passed `loc`, downhill from here on in.
          if (bestLocation <= location) {
            break;
          }

          // When passing `bestLocation`, don't exceed our current distance from `location`.
          start = max(1, 2 * location - bestLocation);
        }
      }
    }

    // No hope for a (better) match at greater error levels.
    final score = bitapScore(
      pattern,
      errors: i + 1,
      currentLocation: location,
      expectedLocation: location,
      distance: distance,
    );

    //console.log('score', score, finalScore)

    if (score > currentThreshold) {
      break;
    }

    lastBitArr = bitArr;
  }

  //console.log('FINAL SCORE', finalScore)

  // Count exact matches (those with a score of 0) to be "almost" exact
  return MatchScore(
    isMatch: bestLocation >= 0,
    score: finalScore == 0 ? 0.001 : finalScore,
    matchedIndices: matchedIndices(matchMask, minMatchCharLength),
  );
}
