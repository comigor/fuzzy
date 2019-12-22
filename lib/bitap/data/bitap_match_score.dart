import 'bitap_index.dart';

class MatchScore {
  MatchScore({
    this.score,
    this.isMatch,
    this.matchedIndices = const [],
  });

  final double score;
  final bool isMatch;
  final List<MatchIndex> matchedIndices;

  @override
  String toString() =>
      'score: $score, isMatch: $isMatch, matchedIndices: $matchedIndices';
}
