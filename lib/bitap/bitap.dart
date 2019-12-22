import '../data/fuzzy_options.dart';
import 'bitap_pattern_alphabet.dart' as pa;
import 'bitap_search.dart';
import 'bitap_regex_search.dart';
import 'data/bitap_match_score.dart';
import 'data/bitap_index.dart';

class Bitap {
  Bitap(String pattern, {FuzzyOptions options}) : this.options = options {
    this.pattern = options.isCaseSensitive ? pattern : pattern.toLowerCase();
    if (pattern.length <= options.maxPatternLength) {
      patternAlphabet = pa.patternAlphabet(this.pattern);
    }
  }

  final FuzzyOptions options;
  String pattern;
  Map<String, int> patternAlphabet = {};

  MatchScore search(String text) {
    if (!options.isCaseSensitive) {
      text = text.toLowerCase();
    }

    // Exact match
    if (pattern == text) {
      return MatchScore(
        isMatch: true,
        score: 0,
        matchedIndices: [MatchIndex(0, text.length - 1)],
      );
    }

    // When pattern length is greater than the machine word length, just do a a regex comparison
    if (pattern.length > options.maxPatternLength) {
      return bitapRegexSearch(text, pattern, options.tokenSeparator);
    }

    // Otherwise, use Bitap algorithm
    return bitapSearch(
      text,
      pattern,
      patternAlphabet,
      location: options.location,
      distance: options.distance,
      threshold: options.threshold,
      findAllMatches: options.findAllMatches,
      minMatchCharLength: options.minMatchCharLength,
    );
  }

  @override
  String toString() => 'Bitap: $pattern, $patternAlphabet\noptions: $options';
}
