import 'data/match_index.dart';
import 'data/match_score.dart';

/// Pattern to exclude special characters
final Pattern SPECIAL_CHARS_REGEX =
    RegExp(r'\[-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]');

/// Execute a bitap regex search
MatchScore bitapRegexSearch(
    String text, String pattern, Pattern tokenSeparator) {
  final regex = RegExp(pattern
      .replaceAll(SPECIAL_CHARS_REGEX, r'\$&')
      .replaceAll(tokenSeparator, '|'));
  final matches = regex.allMatches(text);
  final isMatch = matches.isNotEmpty;

  return MatchScore(
    score: isMatch ? 0.5 : 1,
    isMatch: isMatch,
    matchedIndices: matches.map((m) => MatchIndex(m.start, m.end)).toList(),
  );
}
