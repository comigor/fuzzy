import 'result.dart';

/// Represents a weighted getter of an item
class WeightedKey<T> {
  /// Instantiates it
  WeightedKey({
    required this.name,
    required this.getter,
    required this.weight,
  }) : assert(weight > 0, 'Weight should be positive and non-zero');

  /// Name of this getter
  final String name;

  /// Getter to a specifc string inside item
  final String Function(T obj) getter;

  /// Weight of this getter. When passing a list of WeightedKey to FuzzyOptions,
  /// the weight can be any positive number; FuzzyOptions normalizes it on
  /// construction.
  final double weight;
}

/// Function used to sort results.
typedef SorterFn<T> = int Function(Result<T> a, Result<T> b);

int _defaultSortFn<T>(Result<T> a, Result<T> b) => a.score.compareTo(b.score);

/// Options for performing a fuzzy search
class FuzzyOptions<T> {
  /// Instantiate an options object.
  /// The `keys` list requires a positive number (they'll be normalized upon
  /// instantiation). If any weight is not positive, throws an ArgumentError.
  FuzzyOptions({
    this.location = 0,
    this.distance = 100,
    this.threshold = 0.6,
    this.maxPatternLength = 32,
    this.isCaseSensitive = false,
    Pattern? tokenSeparator,
    this.findAllMatches = false,
    this.minTokenCharLength = 1,
    this.minMatchCharLength = 1,
    List<WeightedKey<T>> keys = const [],
    this.shouldSort = true,
    SorterFn<T>? sortFn,
    this.tokenize = false,
    this.matchAllTokens = false,
    this.verbose = false,
    this.shouldNormalize = false,
  })  : tokenSeparator =
            tokenSeparator ?? RegExp(r' +', caseSensitive: isCaseSensitive),
        keys = _normalizeWeights(keys),
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

  /// Ignore tokens with length smaller than this. Only applicable when `tokenize` is `true`.
  final int minTokenCharLength;

  /// When true, the algorithm continues searching to the end of the input even if a perfect
  /// match is found before the end of the same input.
  final bool findAllMatches;

  /// Minimum number of characters that must be matched before a result is considered a match
  final int minMatchCharLength;

  /// List of weighted getters to properties that will be searched
  final List<WeightedKey<T>> keys;

  /// Whether to sort the result list, by score
  final bool shouldSort;

  /// Default sort function
  final SorterFn<T> sortFn;

  /// When true, the search algorithm will search individual words **and** the full string,
  /// computing the final score as a function of both. Note that when `tokenize` is `true`,
  /// the `threshold`, `distance`, and `location` are inconsequential for individual tokens.
  final bool tokenize;

  /// When true, the result set will only include records that match all tokens. Will only work
  /// if `tokenize` is also true.
  final bool matchAllTokens;

  /// Will print to the console. Useful for debugging.
  final bool verbose;

  /// Wether it should convert accents (diacritics) from strings to latin
  /// characters before searching.
  final bool shouldNormalize;

  /// Copy these options with some modifications.
  FuzzyOptions<T> copyWith({
    int? location,
    int? distance,
    double? threshold,
    int? maxPatternLength,
    bool? isCaseSensitive,
    Pattern? tokenSeparator,
    bool? findAllMatches,
    int? minTokenCharLength,
    int? minMatchCharLength,
    List<WeightedKey<T>>? keys,
    bool? shouldSort,
    SorterFn<T>? sortFn,
    bool? tokenize,
    bool? matchAllTokens,
    bool? verbose,
    bool? shouldNormalize,
  }) =>
      FuzzyOptions(
        location: location ?? this.location,
        distance: distance ?? this.distance,
        threshold: threshold ?? this.threshold,
        maxPatternLength: maxPatternLength ?? this.maxPatternLength,
        isCaseSensitive: isCaseSensitive ?? this.isCaseSensitive,
        tokenSeparator: tokenSeparator ?? this.tokenSeparator,
        findAllMatches: findAllMatches ?? this.findAllMatches,
        minTokenCharLength: minTokenCharLength ?? this.minTokenCharLength,
        minMatchCharLength: minMatchCharLength ?? this.minMatchCharLength,
        keys: keys ?? this.keys,
        shouldSort: shouldSort ?? this.shouldSort,
        sortFn: sortFn ?? this.sortFn,
        tokenize: tokenize ?? this.tokenize,
        matchAllTokens: matchAllTokens ?? this.matchAllTokens,
        verbose: verbose ?? this.verbose,
        shouldNormalize: shouldNormalize ?? this.shouldNormalize,
      );

  static List<WeightedKey<T>> _normalizeWeights<T>(List<WeightedKey<T>> keys) {
    if (keys.isEmpty) {
      return [];
    }

    var weightSum = keys
        .map((key) => key.weight)
        .fold<double>(0, (previousValue, element) => previousValue + element);

    return keys
        .map((key) => WeightedKey<T>(
              name: key.name,
              getter: key.getter,
              weight: key.weight / weightSum,
            ))
        .toList();
  }
}
