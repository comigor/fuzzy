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
    this.verbose = false,
  })  : tokenSeparator =
            tokenSeparator ?? RegExp(r' +', caseSensitive: isCaseSensitive),
        sortFn = sortFn ?? _defaultSortFn;

  /// Approximately where in the text is the pattern expected to be found?
  final int location;

  /// Determines how close the match must be to the fuzzy location (specified above).
  /// An exact letter match which is 'distance' characters away from the fuzzy location
  /// would score as a complete mismatch. A distance of '0' requires the match be at
  /// the exact location specified, a threshold of '1000' would require a perfect match
  /// to be within 800 characters of the fuzzy location to be found using a 0.8 threshold.
  final int distance;

  /// At what point does the match algorithm give up. A threshold of '0.0' requires a perfect match
  /// (of both letters and location), a threshold of '1.0' would match anything.
  final double threshold;

  /// Machine word size
  final int maxPatternLength;

  /// Indicates whether comparisons should be case sensitive.
  final bool isCaseSensitive;

  /// Regex used to separate words when searching. Only applicable when `tokenize` is `true`.
  final Pattern tokenSeparator;

  /// When true, the algorithm continues searching to the end of the input even if a perfect
  /// match is found before the end of the same input.
  final bool findAllMatches;

  /// Minimum number of characters that must be matched before a result is considered a match
  final int minMatchCharLength;

  /// Whether to sort the result list, by score
  final bool shouldSort;

  /// Default sort function
  final SorterFn sortFn;

  /// When true, the search algorithm will search individual words **and** the full string,
  /// computing the final score as a function of both. Note that when `tokenize` is `true`,
  /// the `threshold`, `distance`, and `location` are inconsequential for individual tokens.
  final bool tokenize;

  /// When true, the result set will only include records that match all tokens. Will only work
  /// if `tokenize` is also true.
  final bool matchAllTokens;

  /// Will print to the console. Useful for debugging.
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
        verbose: options?.verbose ?? verbose,
      );
}
