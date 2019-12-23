class Book {
  Book({
    this.title,
    this.author,
    this.tags = const [],
  });

  final String title;
  final String author;
  final List<String> tags;

  @override
  String toString() => '$title, $author';
}

final customBookList = [
  Book(
    title: 'Old Man\'s War fiction',
    author: 'John X',
    tags: ['war'],
  ),
  Book(
    title: 'Right Ho Jeeves',
    author: 'P.D. Mans',
    tags: ['fiction', 'war'],
  ),
  Book(
    title: 'The life of Jane',
    author: 'John Smith',
    tags: ['john', 'smith'],
  ),
  Book(
    title: 'John Smith',
    author: 'Steve Pearson',
    tags: ['steve', 'pearson'],
  ),
];
