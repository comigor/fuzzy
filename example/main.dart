import 'package:fuzzy/data/advanced_options.dart';
import 'package:fuzzy/data/fuzzy_options.dart';
import 'package:fuzzy/fuzzy.dart';

void main() {
  final fuse = Fuse(
    [
      'igor da silva borges',
      'igor borges',
      'ivo borges',
      'roger borges',
      'roger silva',
    ],
    options: FuzzyOptions(
      minMatchCharLength: 3,
      findAllMatches: true,
    ),
    advancedOptions: AdvancedOptions(
      includeMatches: true,
      includeScore: true,
      tokenize: true,
    ),
  );

  print(fuse.search('igor').map((r) {
    final outs = r.output.map((o) => o.value).toList();
    return '${r.score} $outs';
  }).toList());
}
