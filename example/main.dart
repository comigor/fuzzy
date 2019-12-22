import 'package:fuzzy/fuzzy.dart';

void main() {
  final bookList = [
    'Old Man\'s War',
    'The Lock Artist',
    'HTML5',
    'Right Ho Jeeves',
    'The Code of the Wooster',
    'Thank You Jeeves',
    'The DaVinci Code',
    'Angels & Demons',
    'The Silmarillion',
    'Syrup',
    'The Lost Symbol',
    'The Book of Lies',
    'Lamb',
    'Fool',
    'Incompetence',
    'Fat',
    'Colony',
    'Backwards, Red Dwarf',
    'The Grand Design',
    'The Book of Samson',
    'The Preservationist',
    'Fallen',
    'Monster 1959',
  ];
  final fuse = Fuzzy(
    bookList,
    options: FuzzyOptions(
      findAllMatches: true,
      tokenize: true,
      threshold: 0.5,
    ),
  );

  final result = fuse.search('book');

  print(
      'A score of 0 indicates a perfect match, while a score of 1 indicates a complete mismatch.');

  result.forEach((r) {
    print('\nScore: ${r.score}\nTitle: ${bookList[r.item]}');
  });
}
