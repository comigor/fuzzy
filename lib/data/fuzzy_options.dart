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
}
