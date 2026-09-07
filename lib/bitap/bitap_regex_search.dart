import 'data/match_index.dart';
import 'data/match_score.dart';

/// Pattern matching the regex metacharacters that have to be escaped before a
/// search pattern can safely be compiled as a [RegExp].
final Pattern SPECIAL_CHARS_REGEX = RegExp(r'[-\[\]/{}()*+?.\\^$|]');

/// Escapes every regex metacharacter in [pattern] so that it is matched
/// literally.
String _escapeSpecialChars(String pattern) =>
    pattern.replaceAllMapped(SPECIAL_CHARS_REGEX, (match) => '\\${match[0]}');

/// Execute a bitap regex search
MatchScore bitapRegexSearch(
    String text, String pattern, Pattern tokenSeparator) {
  final regex =
      RegExp(_escapeSpecialChars(pattern).replaceAll(tokenSeparator, '|'));
  final matches = regex.allMatches(text);
  final isMatch = matches.isNotEmpty;

  return MatchScore(
    score: isMatch ? 0.5 : 1,
    isMatch: isMatch,
    matchedIndices: matches.map((m) => MatchIndex(m.start, m.end)).toList(),
  );
}
