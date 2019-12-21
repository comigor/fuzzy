import 'package:fuzzy/data/result.dart';

typedef SorterFn = int Function(Result a, Result b);

int _defaultSortFn(Result a, Result b) => a.score.compareTo(b.score);

class AdvancedOptions {
  AdvancedOptions({
    this.shouldSort = true,
    SorterFn sortFn,
    this.tokenize = false,
    this.matchAllTokens = false,
    this.includeMatches = false,
    this.includeScore = false,
    this.verbose = false,
  }) : sortFn = sortFn ?? _defaultSortFn;

  final bool shouldSort;
  final SorterFn sortFn;
  final bool tokenize;
  final bool matchAllTokens;
  final bool includeMatches;
  final bool includeScore;
  final bool verbose;
}
