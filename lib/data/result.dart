import '../bitap/bitap.dart';
import '../bitap/data/match_index.dart';

/// Class to hold searchers
class Searchers {
  /// Instantiates it
  Searchers({
    required this.tokenSearchers,
    required this.fullSearcher,
  });

  /// All searchers, if tokenized
  final List<Bitap> tokenSearchers;

  /// The whole string searcher
  final Bitap fullSearcher;

  @override
  String toString() =>
      'tokenSearchers: $tokenSearchers, fullSearcher: $fullSearcher';
}

/// Class to hold results and weights
class ResultsAndWeights<T> {
  /// Instantiates it
  ResultsAndWeights({
    required this.results,
    required this.weights,
  });

  /// The list of results
  final List<Result<T>> results;

  /// The weights
  final Map<String, double> weights;
}

/// Holds the result (with score and index)
class Result<T> {
  /// Instantiates it
  Result({
    required this.item,
    this.matches = const [],
    this.score = 0,
  });

  /// Item in the original list
  final T item;

  /// Details of this result
  final List<ResultDetails<T>> matches;

  /// Score of this result
  double score;

  @override
  String toString() => 'item: $item, score: $score, matches: $matches';
}

/// Details of a result.
class ResultDetails<T> {
  /// Instantiates it
  ResultDetails({
    this.key = '',
    required this.arrayIndex,
    required this.value,
    required this.score,
    required this.matchedIndices,
    this.nScore = 0,
  });

  /// Key ([WeightedKey.name]) used to create this
  final String key;

  /// Index of result in the original list
  final int arrayIndex;

  /// Original value
  final String value;

  /// Score of this result
  final double score;

  /// nScore of this result (?)
  double nScore;

  /// Indexes of matched patterns on the value
  final List<MatchIndex> matchedIndices;

  @override
  String toString() =>
      'arrayIndex: $arrayIndex, value: $value, score: $score, nScore: $nScore, matchedIndices: $matchedIndices';
}
