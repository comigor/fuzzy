import 'dart:math';

import 'package:fuzzy/bitap/bitap.dart';
import 'package:fuzzy/bitap/data/bitap_index.dart';
import 'package:fuzzy/bitap/data/bitap_match_score.dart';
import 'package:fuzzy/data/fuzzy_options.dart';
import 'package:fuzzy/data/result.dart';

/// Fuzzy search in Dart.
///
/// Import this library as follows:
///
/// ```
/// import 'package:fuzzy/fuzzy.dart';
/// ```

class Fuse {
  Fuse(
    this.list, {
    FuzzyOptions options,
  }) : options = options ?? FuzzyOptions();

  final List<String> list;
  final FuzzyOptions options;

  List<Result> search(String pattern, [int limit = -1]) {
    final searchers = _prepareSearchers(pattern);

    final results = _search(searchers.tokenSearchers, searchers.fullSearcher);

    _computeScore({}, results);

    if (options.shouldSort) {
      _sort(results);
    }

    if (limit > 0) {
      return results.sublist(0, limit);
    }

    return results;
  }

  Searchers _prepareSearchers(String pattern) {
    final tokenSearchers = <Bitap>[];

    if (options.tokenize) {
      // Tokenize on the separator
      final tokens = pattern.split(options.tokenSeparator);
      for (var i = 0, len = tokens.length; i < len; i += 1) {
        tokenSearchers.add(Bitap(tokens[i], options: options));
      }
    }

    final fullSearcher = Bitap(pattern, options: options);

    return Searchers(
      tokenSearchers: tokenSearchers,
      fullSearcher: fullSearcher,
    );
  }

  List<Result> _search(List<Bitap> tokenSearchers, Bitap fullSearcher) {
    final results = <Result>[];

    // Iterate over every item
    for (var i = 0, len = list.length; i < len; i += 1) {
      results.addAll(_analyze(
        key: '',
        value: list[i],
        record: i,
        index: i,
        tokenSearchers: tokenSearchers,
        fullSearcher: fullSearcher,
      ));
    }

    return results;
  }

  List<Result> _analyze({
    String key = '',
    int arrayIndex = -1,
    String value,
    int record,
    int index,
    List<Bitap> tokenSearchers = const [],
    Bitap fullSearcher,
  }) {
    final results = <Result>[];
    final resultMap = <int, Result>{};
    // Check if the texvaluet can be searched
    if (value == null) {
      return [];
    }

    var exists = false;
    var averageScore = -1;
    var numTextMatches = 0;

    _log('\nKey: ${key == '' ? '-' : key}');

    final mainSearchResult = fullSearcher.search(value);
    _log('Full text: "${value}", score: ${mainSearchResult.score}');

    if (options.tokenize) {
      final words = value.split(options.tokenSeparator);
      final scores = <double>[];

      for (var i = 0; i < tokenSearchers.length; i += 1) {
        final tokenSearcher = tokenSearchers[i];

        _log('\nPattern: "${tokenSearcher.pattern}"');

        // let tokenScores = []
        var hasMatchInText = false;

        for (var j = 0; j < words.length; j += 1) {
          final word = words[j];
          final tokenSearchResult = tokenSearcher.search(word);
          // final obj = {};
          if (tokenSearchResult.isMatch) {
            // obj[word] = tokenSearchResult.score;
            exists = true;
            hasMatchInText = true;
            scores.add(tokenSearchResult.score);
          } else {
            // obj[word] = 1;
            if (options.matchAllTokens) {
              scores.add(1);
            }
          }
          _log('Token: "${word}", score: ${tokenSearchResult.score}');
          // tokenScores.push(obj)
        }

        if (hasMatchInText) {
          numTextMatches += 1;
        }
      }

      final averageScore =
          scores.fold(0, (memo, score) => memo + score) / scores.length;

      _log('Token score average: $averageScore');
    }

    var finalScore = mainSearchResult.score;
    if (averageScore > -1) {
      finalScore = (finalScore + averageScore) / 2;
    }

    _log('Score average (final): $finalScore');

    final checkTextMatches = (options.tokenize && options.matchAllTokens)
        ? numTextMatches >= tokenSearchers.length
        : true;

    _log('\nCheck Matches: ${checkTextMatches}');

    // If a match is found, add the item to <rawResults>, including its score
    if ((exists || mainSearchResult.isMatch) && checkTextMatches) {
      // Check if the item already exists in our results
      final existingResult = resultMap[index];
      if (existingResult != null) {
        // Use the lowest score
        // existingResult.score, bitapResult.score
        existingResult.output.add(ResultDetails(
          key: key,
          arrayIndex: arrayIndex,
          value: value,
          score: finalScore,
          matchedIndices: mainSearchResult.matchedIndices,
        ));
      } else {
        // Add it to the raw result list
        final res = Result(
          item: record,
          output: [
            ResultDetails(
              key: key,
              arrayIndex: arrayIndex,
              value: value,
              score: finalScore,
              matchedIndices: mainSearchResult.matchedIndices,
            ),
          ],
        );

        resultMap.update(
          index,
          (_) => res,
          ifAbsent: () => res,
        );

        results.add(resultMap[index]);
      }
    }

    return results;
  }

  void _computeScore(Map<String, double> weights, List<Result> results) {
    _log('\n\nComputing score:\n');

    for (var i = 0, len = results.length; i < len; i += 1) {
      final output = results[i].output;
      final scoreLen = output.length;

      var currScore = 1.0;
      var bestScore = 1.0;

      for (var j = 0; j < scoreLen; j += 1) {
        final weight = weights[output[j].key] ?? 1;
        final score =
            weight == 1 ? output[j].score : (output[j].score ?? 0.001);
        final nScore = score * weight;

        if (weight != 1) {
          bestScore = min(bestScore, nScore);
        } else {
          output[j].nScore = nScore;
          currScore *= nScore;
        }
      }

      results[i].score = bestScore == 1 ? currScore : bestScore;

      _log('${results[i]}');
    }
  }

  void _sort(List<Result> results) {
    _log('\n\nSorting....');
    results.sort(options.sortFn);
  }

  void _log(String log) {
    if (options.verbose) {
      print(log);
    }
  }
}
