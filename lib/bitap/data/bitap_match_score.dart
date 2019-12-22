import 'bitap_index.dart';

/// Holds match with its score
class MatchScore {
  /// Instantiates a match with score and matched locations
  MatchScore({
    this.score,
    this.isMatch,
    this.matchedIndices = const [],
  });

  /// The score
  final double score;

  /// If it's really a match
  final bool isMatch;

  /// A list of indexes (matched locations)
  final List<MatchIndex> matchedIndices;

  @override
  String toString() =>
      'score: $score, isMatch: $isMatch, matchedIndices: $matchedIndices';
}
