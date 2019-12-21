import 'package:meta/meta.dart';
import 'bitap_index.dart';

class MatchScore {
  MatchScore({
    @required this.score,
    @required this.isMatch,
    this.matchedIndices = const [],
  });

  final double score;
  final bool isMatch;
  final List<MatchIndex> matchedIndices;
}
