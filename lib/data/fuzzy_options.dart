import 'result.dart';

typedef SorterFn = int Function(Result a, Result b);

int _defaultSortFn(Result a, Result b) => a.score.compareTo(b.score);

class FuzzyOptions {
  FuzzyOptions({
    this.location = 0,
    this.distance = 100,
    this.threshold = 0.6,
    this.maxPatternLength = 32,
    this.isCaseSensitive = false,
    Pattern tokenSeparator,
    this.findAllMatches = false,
    this.minMatchCharLength = 1,
    this.shouldSort = true,
    SorterFn sortFn,
    this.tokenize = false,
    this.matchAllTokens = false,
    this.includeMatches = false,
    this.includeScore = false,
    this.verbose = false,
  })  : tokenSeparator =
            tokenSeparator ?? RegExp(r' +', caseSensitive: isCaseSensitive),
        sortFn = sortFn ?? _defaultSortFn;

  final int location;
  final int distance;
  final double threshold;
  final int maxPatternLength;
  final bool isCaseSensitive;
  final Pattern tokenSeparator;
  final bool findAllMatches;
  final int minMatchCharLength;
  final bool shouldSort;
  final SorterFn sortFn;
  final bool tokenize;
  final bool matchAllTokens;
  final bool includeMatches;
  final bool includeScore;
  final bool verbose;

  FuzzyOptions mergeWith(FuzzyOptions options) => FuzzyOptions(
        location: options?.location ?? location,
        distance: options?.distance ?? distance,
        threshold: options?.threshold ?? threshold,
        maxPatternLength: options?.maxPatternLength ?? maxPatternLength,
        isCaseSensitive: options?.isCaseSensitive ?? isCaseSensitive,
        tokenSeparator: options?.tokenSeparator ?? tokenSeparator,
        findAllMatches: options?.findAllMatches ?? findAllMatches,
        minMatchCharLength: options?.minMatchCharLength ?? minMatchCharLength,
        shouldSort: options?.shouldSort ?? shouldSort,
        sortFn: options?.sortFn ?? sortFn,
        tokenize: options?.tokenize ?? tokenize,
        matchAllTokens: options?.matchAllTokens ?? matchAllTokens,
        includeMatches: options?.includeMatches ?? includeMatches,
        includeScore: options?.includeScore ?? includeScore,
        verbose: options?.verbose ?? verbose,
      );
}
