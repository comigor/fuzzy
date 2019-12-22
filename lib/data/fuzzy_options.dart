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
  }) : tokenSeparator =
            tokenSeparator ?? RegExp(r' +', caseSensitive: isCaseSensitive);

  final int location;
  final int distance;
  final double threshold;
  final int maxPatternLength;
  final bool isCaseSensitive;
  final Pattern tokenSeparator;
  final bool findAllMatches;
  final int minMatchCharLength;

  FuzzyOptions mergeWith(FuzzyOptions options) => FuzzyOptions(
        location: options?.location ?? location,
        distance: options?.distance ?? distance,
        threshold: options?.threshold ?? threshold,
        maxPatternLength: options?.maxPatternLength ?? maxPatternLength,
        isCaseSensitive: options?.isCaseSensitive ?? isCaseSensitive,
        tokenSeparator: options?.tokenSeparator ?? tokenSeparator,
        findAllMatches: options?.findAllMatches ?? findAllMatches,
        minMatchCharLength: options?.minMatchCharLength ?? minMatchCharLength,
      );

  @override
  String toString() =>
      'location: $location, distance: $distance, threshold: $threshold, maxPatternLength: $maxPatternLength, isCaseSensitive: $isCaseSensitive, tokenSeparator: $tokenSeparator, findAllMatches: $findAllMatches, minMatchCharLength: $minMatchCharLength';
}
