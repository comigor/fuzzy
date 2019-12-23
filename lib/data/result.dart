import '../bitap/bitap.dart';
import '../bitap/data/match_index.dart';

/// Class to hold searchers
class Searchers {
  /// Instantiates it
  Searchers({
    this.tokenSearchers,
    this.fullSearcher,
  });

  /// All searchers, if tokenized
  final List<Bitap> tokenSearchers;

  /// The whole string searcher
  final Bitap fullSearcher;

  @override
  String toString() =>
      'tokenSearchers: $tokenSearchers, fullSearcher: $fullSearcher';
}

/// Holds the result (with score and index)
class Result<T> {
  /// Instantiates it
  Result({
    this.item,
    this.output,
    this.score = 0,
  });

  /// Index of result in the original list
  final int item;

  /// Details of this result
  final List<ResultDetails<T>> output;

  /// Score of this result
  double score;

  @override
  String toString() => 'item: $item, score: $score, output: $output';
}

/// Details of a result.
class ResultDetails<T> {
  /// Instantiates it
  ResultDetails({
    this.key,
    this.arrayIndex,
    this.value,
    this.score,
    this.matchedIndices,
    this.nScore,
  });

  /// Key (not used, I think)
  final String key;

  /// Index of result in the original list
  final int arrayIndex;

  /// Original value
  final T value;

  /// Score of this result
  final double score;

  /// nScore of this result (?)
  double nScore;

  /// Indexes of matched patterns on the value
  final List<MatchIndex> matchedIndices;

  @override
  String toString() =>
      'key: $key, arrayIndex: $arrayIndex, value: $value, score: $score, nScore: $nScore, matchedIndices: $matchedIndices';
}
