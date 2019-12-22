import 'package:fuzzy/bitap/bitap.dart';
import 'package:fuzzy/bitap/data/bitap_index.dart';

class Searchers {
  Searchers({
    this.tokenSearchers,
    this.fullSearcher,
  });

  final List<Bitap> tokenSearchers;
  final Bitap fullSearcher;

  @override
  String toString() =>
      'tokenSearchers: $tokenSearchers, fullSearcher: $fullSearcher';
}

class Result {
  Result({
    this.item,
    this.output,
    this.score,
  });

  final int item;
  final List<ResultDetails> output;
  double score;

  @override
  String toString() => 'item: $item, score: $score, output: $output';
}

class ResultDetails {
  ResultDetails({
    this.key,
    this.arrayIndex,
    this.value,
    this.score,
    this.matchedIndices,
    this.nScore,
  });

  final String key;
  final int arrayIndex;
  final String value;
  final double score;
  double nScore;
  final List<MatchIndex> matchedIndices;

  @override
  String toString() =>
      'key: $key, arrayIndex: $arrayIndex, value: $value, score: $score, nScore: $nScore, matchedIndices: $matchedIndices';
}
