import 'package:fuzzy/fuzzy.dart';
import 'package:test/test.dart';

final defaultList = ['Apple', 'Orange', 'Banana'];
final defaultOptions = FuzzyOptions(
  location: 0,
  distance: 100,
  threshold: 0.6,
  maxPatternLength: 32,
  isCaseSensitive: false,
  tokenSeparator: RegExp(r' +'),
  findAllMatches: false,
  minMatchCharLength: 1,
  shouldSort: true,
  sortFn: (a, b) => a.score.compareTo(b.score),
  tokenize: false,
  matchAllTokens: false,
  verbose: false,
);

Fuse setup({
  List<String> itemList,
  FuzzyOptions overwriteOptions,
}) {
  return Fuse(
    itemList ?? defaultList,
    options: defaultOptions.mergeWith(overwriteOptions),
  );
}

void main() {
  group('Flat list of strings: ["Apple", "Orange", "Banana"]', () {
    Fuse fuse;
    setUp(() {
      fuse = setup();
    });

    test('When searching for the term "Apple"', () {
      final result = fuse.search('Apple');

      expect(result.length, 1, reason: 'we get a list of exactly 1 item');
      expect(result[0].item, 0,
          reason: 'whose value is the index 0, representing ["Apple"]');
    });
  });

  group('Flat list of strings: ["Apple", "Orange", "Banana"]', () {
    Fuse fuse;
    setUp(() {
      fuse = setup();
    });

    test('When performing a fuzzy search for the term "ran"', () {
      final result = fuse.search('ran');

      expect(result.length, 2, reason: 'we get a list of containing 2 items');
      expect(result[0].item, 1,
          reason: 'whose values represent the indices of ["Orange", "Banana"]');
      expect(result[1].item, 2,
          reason: 'whose values represent the indices of ["Orange", "Banana"]');
    });

    test(
        'When performing a fuzzy search for the term "nan" with a limit of 1 result',
        () {
      final result = fuse.search('nan', 1);

      expect(result.length, 1,
          reason: 'we get a list of containing 1 item: [2]');
      expect(result[0].item, 2,
          reason: 'whose value is the index 2, representing ["Banana"]');
    });
  });

  group('Include score in result list: ["Apple", "Orange", "Banana"]', () {
    Fuse fuse;
    setUp(() {
      fuse = setup();
    });

    test('When searching for the term "Apple"', () {
      final result = fuse.search('Apple');

      expect(result.length, 1, reason: 'we get a list of exactly 1 item');
      expect(result[0].item, 0,
          reason: 'whose value is the index 0, representing ["Apple"]');
      expect(result[0].score, 0, reason: 'and the score is a perfect match');
    });

    test('When performing a fuzzy search for the term "ran"', () {
      final result = fuse.search('ran');

      expect(result.length, 2, reason: 'we get a list of containing 2 items');

      expect(result[0].item, equals(1), reason: 'representing Orange');
      expect(result[0].score, isNot(0), reason: 'score is not zero');

      expect(result[1].item, equals(2), reason: 'representing Banana');
      expect(result[1].score, isNot(0), reason: 'score is not zero');
    });
  });

  group('Weighted search', () {
    Fuse fuse;
    setUp(() {
      fuse = setup();
    });
  }, skip: true);

  group('Search with match all tokens', () {
    Fuse fuse;
    setUp(() {
      final customList = [
        'AustralianSuper - Corporate Division',
        'Aon Master Trust - Corporate Super',
        'Promina Corporate Superannuation Fund',
        'Workforce Superannuation Corporate',
        'IGT (Australia) Pty Ltd Superannuation Fund',
      ];
      fuse = setup(
        itemList: customList,
        overwriteOptions: FuzzyOptions(tokenize: true),
      );
    });

    test('When searching for the term "Australia"', () {
      final result = fuse.search('Australia');

      expect(result.length, equals(2),
          reason: 'We get a list containing exactly 2 items');
      expect(result[0].item, equals(0),
          reason:
              'represent the indice of "AustralianSuper - Corporate Division"');
      expect(result[1].item, equals(4),
          reason:
              'represent the indice of "IGT (Australia) Pty Ltd Superannuation Fund"');
    });

    test('When searching for the term "corporate"', () {
      final result = fuse.search('corporate');

      expect(result.length, equals(4),
          reason: 'We get a list containing exactly 2 items');

      expect(result[0].item, equals(2),
          reason:
              'represent the indice of "Promina Corporate Superannuation Fund"');
      expect(result[1].item, equals(0),
          reason:
              'represent the indice of "AustralianSuper - Corporate Division"');
      expect(result[2].item, equals(1),
          reason:
              'represent the indice of "Aon Master Trust - Corporate Super"');
      expect(result[3].item, equals(3),
          reason:
              'represent the indice of "Workforce Superannuation Corporate"');
    });
  });

  group('Searching with default options', () {
    Fuse fuse;
    setUp(() {
      final customList = ['t te tes test tes te t'];
      fuse = setup(itemList: customList);
    });

    test('When searching for the term "test"', () {
      final result = fuse.search('test');

      expect(result[0].output[0].matchedIndices.length, equals(4),
          reason: 'We get a match containing 4 indices');

      expect(result[0].output[0].matchedIndices[0].start, equals(0),
          reason: 'and the first index is a single character');
      expect(result[0].output[0].matchedIndices[0].end, equals(0),
          reason: 'and the first index is a single character');
    });

    test(
        'When the seach pattern is longer than maxPatternLength and contains RegExp special characters',
        () {
      final result = fuse.search(
          r'searching with a sufficiently long string sprinkled with ([ )] *+^$ etc.');
    }, skip: true);
  });

  group('Searching with findAllMatches', () {
    Fuse fuse;
    setUp(() {
      final customList = ['t te tes test tes te t'];
      fuse = setup(
        itemList: customList,
        overwriteOptions: FuzzyOptions(
          findAllMatches: true,
        ),
      );
    });

    test('When searching for the term "test"', () {
      final result = fuse.search('test');

      expect(result[0].output[0].matchedIndices.length, equals(7),
          reason: 'We get a match containing 7 indices');

      expect(result[0].output[0].matchedIndices[0].start, equals(0),
          reason: 'and the first index is a single character');
      expect(result[0].output[0].matchedIndices[0].end, equals(0),
          reason: 'and the first index is a single character');
    });
  });

  group('Searching with minCharLength', () {
    Fuse fuse;
    setUp(() {
      final customList = ['t te tes test tes te t'];
      fuse = setup(
        itemList: customList,
        overwriteOptions: FuzzyOptions(
          minMatchCharLength: 2,
        ),
      );
    });

    test('When searching for the term "test"', () {
      final result = fuse.search('test');

      expect(result[0].output[0].matchedIndices.length, equals(3),
          reason: 'We get a match containing 3 indices');

      expect(result[0].output[0].matchedIndices[0].start, equals(2),
          reason: 'and the first index is a 2 character word');
      expect(result[0].output[0].matchedIndices[0].end, equals(3),
          reason: 'and the first index is a 2 character word');
    });

    test('When searching for a string shorter than minMatchCharLength', () {
      final result = fuse.search('t');

      expect(result.length, equals(1),
          reason: 'We get a result with no matches');
      expect(result[0].output[0].matchedIndices.length, equals(0),
          reason: 'We get a result with no matches');
    });
  });

  group('Sorted search results', () {
    Fuse fuse;
  }, skip: true);

  group('Searching using string large strings', () {
    Fuse fuse;
    setUp(() {
      final customList = [
        'pizza',
        'feast',
        'super+large+much+unique+36+very+wow+',
      ];
      fuse = setup(
        itemList: customList,
        overwriteOptions: FuzzyOptions(
          threshold: 0.5,
          location: 0,
          distance: 0,
          maxPatternLength: 50,
          minMatchCharLength: 4,
          shouldSort: true,
        ),
      );
    });

    test('finds delicious pizza', () {
      final result = fuse.search('pizza');
      expect(result[0].output[0].value, equals('pizza'));
    });

    test('finds pizza when clumbsy', () {
      final result = fuse.search('pizze');
      expect(result[0].output[0].value, equals('pizza'));
    });

    test('finds no matches when string is exactly 31 characters', () {
      final result = fuse.search('this-string-is-exactly-31-chars');
      expect(result.isEmpty, isTrue);
    });

    test('finds no matches when string is exactly 32 characters', () {
      final result = fuse.search('this-string-is-exactly-32-chars-');
      expect(result.isEmpty, isTrue);
    });

    test('finds no matches when string is larger than 32 characters', () {
      final result = fuse.search('this-string-is-more-than-32-chars');
      expect(result.isEmpty, isTrue);
    });

    test('should find one match that is larger than 32 characters', () {
      final result = fuse.search('super+large+much+unique+36+very+wow+');
      expect(result[0].output[0].value,
          equals('super+large+much+unique+36+very+wow+'));
    });
  });
}
