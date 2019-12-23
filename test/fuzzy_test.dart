import 'package:fuzzy/fuzzy.dart';
import 'package:test/test.dart';

import 'fixtures/books.dart';

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

Fuzzy setup({
  List itemList,
  FuzzyOptions overwriteOptions,
}) {
  return Fuzzy(
    itemList ?? defaultList,
    options: defaultOptions.mergeWith(overwriteOptions),
  );
}

void main() {
  group('Flat list of strings: ["Apple", "Orange", "Banana"]', () {
    Fuzzy fuse;
    setUp(() {
      fuse = setup();
    });

    test('When searching for the term "Apple"', () {
      final result = fuse.search('Apple');

      expect(result.length, 1, reason: 'we get a list of exactly 1 item');
      expect(result[0].item, equals('Apple'),
          reason: 'whose value is the index 0, representing ["Apple"]');
    });
  });

  group('Flat list of strings: ["Apple", "Orange", "Banana"]', () {
    Fuzzy fuse;
    setUp(() {
      fuse = setup();
    });

    test('When performing a fuzzy search for the term "ran"', () {
      final result = fuse.search('ran');

      expect(result.length, 2, reason: 'we get a list of containing 2 items');
      expect(result[0].item, equals('Orange'),
          reason: 'whose values represent the indices of ["Orange", "Banana"]');
      expect(result[1].item, equals('Banana'),
          reason: 'whose values represent the indices of ["Orange", "Banana"]');
    });

    test(
        'When performing a fuzzy search for the term "nan" with a limit of 1 result',
        () {
      final result = fuse.search('nan', 1);

      expect(result.length, 1,
          reason: 'we get a list of containing 1 item: [2]');
      expect(result[0].item, equals('Banana'),
          reason: 'whose value is the index 2, representing ["Banana"]');
    });
  });

  group('Include score in result list: ["Apple", "Orange", "Banana"]', () {
    Fuzzy fuse;
    setUp(() {
      fuse = setup();
    });

    test('When searching for the term "Apple"', () {
      final result = fuse.search('Apple');

      expect(result.length, equals(1),
          reason: 'we get a list of exactly 1 item');
      expect(result[0].item, equals('Apple'),
          reason: 'whose value is the index 0, representing ["Apple"]');
      expect(result[0].score, equals(0),
          reason: 'and the score is a perfect match');
    });

    test('When performing a fuzzy search for the term "ran"', () {
      final result = fuse.search('ran');

      expect(result.length, 2, reason: 'we get a list of containing 2 items');

      expect(result[0].item, equals('Orange'));
      expect(result[0].score, isNot(0), reason: 'score is not zero');

      expect(result[1].item, equals('Banana'));
      expect(result[1].score, isNot(0), reason: 'score is not zero');
    });
  });

  group('Weighted search on typed list', () {
    test('When searching for the term "John Smith" with author weighted higher',
        () {
      final fuse = Fuzzy<Book>(
        customBookList,
        options: FuzzyOptions(keys: [
          WeightedKey(getter: (i) => i.title, weight: 0.3, name: 'title'),
          WeightedKey(getter: (i) => i.author, weight: 0.7, name: 'author'),
        ]),
      );
      final result = fuse.search('John Smith');

      expect(result[0].item, customBookList[2],
          reason: 'We get the the exactly matching object');
    });

    test('When searching for the term "John Smith" with title weighted higher',
        () {
      final fuse = Fuzzy<Book>(
        customBookList,
        options: FuzzyOptions(keys: [
          WeightedKey(getter: (i) => i.title, weight: 0.7, name: 'title'),
          WeightedKey(getter: (i) => i.author, weight: 0.3, name: 'author'),
        ]),
      );
      final result = fuse.search('John Smith');

      expect(result[0].item, customBookList[3],
          reason: 'We get the the exactly matching object');
    });

    test(
        'When searching for the term "Man", where the author is weighted higher than title',
        () {
      final fuse = Fuzzy<Book>(
        customBookList,
        options: FuzzyOptions(keys: [
          WeightedKey(getter: (i) => i.title, weight: 0.3, name: 'title'),
          WeightedKey(getter: (i) => i.author, weight: 0.7, name: 'author'),
        ]),
      );
      final result = fuse.search('Man');

      expect(result[0].item, customBookList[1],
          reason: 'We get the the exactly matching object');
    });

    test(
        'When searching for the term "Man", where the title is weighted higher than author',
        () {
      final fuse = Fuzzy<Book>(
        customBookList,
        options: FuzzyOptions(keys: [
          WeightedKey(getter: (i) => i.title, weight: 0.7, name: 'title'),
          WeightedKey(getter: (i) => i.author, weight: 0.3, name: 'author'),
        ]),
      );
      final result = fuse.search('Man');

      expect(result[0].item, customBookList[0],
          reason: 'We get the the exactly matching object');
    });

    test(
        'When searching for the term "War", where tags are weighted higher than all other keys',
        () {
      final fuse = Fuzzy<Book>(
        customBookList,
        options: FuzzyOptions(keys: [
          WeightedKey(getter: (i) => i.title, weight: 0.8, name: 'title'),
          WeightedKey(getter: (i) => i.author, weight: 0.3, name: 'author'),
          WeightedKey(
              getter: (i) => i.tags.join(' '), weight: 0.9, name: 'tags'),
        ]),
      );
      final result = fuse.search('War');

      expect(result[0].item, customBookList[0],
          reason: 'We get the the exactly matching object');
    });
  });

  group('Search with match all tokens', () {
    Fuzzy fuse;
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
      expect(result[0].item, equals('AustralianSuper - Corporate Division'));
      expect(result[1].item,
          equals('IGT (Australia) Pty Ltd Superannuation Fund'));
    });

    test('When searching for the term "corporate"', () {
      final result = fuse.search('corporate');

      expect(result.length, equals(4),
          reason: 'We get a list containing exactly 2 items');

      expect(result[0].item, equals('Promina Corporate Superannuation Fund'));
      expect(result[1].item, equals('AustralianSuper - Corporate Division'));
      expect(result[2].item, equals('Aon Master Trust - Corporate Super'));
      expect(result[3].item, equals('Workforce Superannuation Corporate'));
    });
  });

  group('Searching with default options', () {
    Fuzzy fuse;
    setUp(() {
      final customList = ['t te tes test tes te t'];
      fuse = setup(itemList: customList);
    });

    test('When searching for the term "test"', () {
      final result = fuse.search('test');

      expect(result[0].matches[0].matchedIndices.length, equals(4),
          reason: 'We get a match containing 4 indices');

      expect(result[0].matches[0].matchedIndices[0].start, equals(0),
          reason: 'and the first index is a single character');
      expect(result[0].matches[0].matchedIndices[0].end, equals(0),
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
    Fuzzy fuse;
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

      expect(result[0].matches[0].matchedIndices.length, equals(7),
          reason: 'We get a match containing 7 indices');

      expect(result[0].matches[0].matchedIndices[0].start, equals(0),
          reason: 'and the first index is a single character');
      expect(result[0].matches[0].matchedIndices[0].end, equals(0),
          reason: 'and the first index is a single character');
    });
  });

  group('Searching with minCharLength', () {
    Fuzzy fuse;
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

      expect(result[0].matches[0].matchedIndices.length, equals(3),
          reason: 'We get a match containing 3 indices');

      expect(result[0].matches[0].matchedIndices[0].start, equals(2),
          reason: 'and the first index is a 2 character word');
      expect(result[0].matches[0].matchedIndices[0].end, equals(3),
          reason: 'and the first index is a 2 character word');
    });

    test('When searching for a string shorter than minMatchCharLength', () {
      final result = fuse.search('t');

      expect(result.length, equals(1),
          reason: 'We get a result with no matches');
      expect(result[0].matches[0].matchedIndices.length, equals(0),
          reason: 'We get a result with no matches');
    });
  });

  group('Sorted search results', () {
    Fuzzy fuse;
  }, skip: true);

  group('Searching using string large strings', () {
    Fuzzy fuse;
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
      expect(result[0].matches[0].value, equals('pizza'));
    });

    test('finds pizza when clumbsy', () {
      final result = fuse.search('pizze');
      expect(result[0].matches[0].value, equals('pizza'));
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
      expect(result[0].matches[0].value,
          equals('super+large+much+unique+36+very+wow+'));
    });
  });

  group('On string normalization', () {
    final diacriticList = ['Ápplé', 'Öřângè', 'Bánànã'];
    Fuzzy fuse;
    setUp(() {
      fuse = setup(
        itemList: diacriticList,
        overwriteOptions: FuzzyOptions(shouldNormalize: true),
      );
    });

    test('When searching for the term "rän"', () {
      final result = fuse.search('rän');

      expect(result.length, equals(2),
          reason: 'we get a list of containing 2 items');
      expect(result[0].item, equals('Öřângè'));
      expect(result[1].item, equals('Bánànã'));
    });
  });

  group('Without string normalization', () {
    final diacriticList = ['Ápplé', 'Öřângè', 'Bánànã'];
    Fuzzy fuse;
    setUp(() {
      fuse = setup(itemList: diacriticList);
    });

    test('Nothing is found without normalization', () {
      final result = fuse.search('ran');

      expect(result.length, equals(0));
    });
  });
}
