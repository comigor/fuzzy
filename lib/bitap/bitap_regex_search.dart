import 'data/bitap_index.dart';
import 'data/bitap_match_score.dart';

final SPECIAL_CHARS_REGEX = RegExp(r'\[-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]');

MatchScore bitapRegexSearch(
    String text, String pattern, Pattern tokenSeparator) {
  tokenSeparator ??= RegExp(r' +');

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
