/// Holds match location in a single results
class MatchIndex {
  /// Instantiates a match location
  MatchIndex(this.start, this.end);

  /// Index of the beginning of match
  final int start;

  /// Index of the end of match
  final int end;

  @override
  String toString() => '[$start, $end]';
}
