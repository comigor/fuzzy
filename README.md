<p align="center">
  <h1>Fuzzy</h1>
</p>

<!-- Badges -->

[![Pub Package](https://img.shields.io/pub/v/fuzzy.svg)](https://pub.dartlang.org/packages/fuzzy)
[![CI](https://img.shields.io/github/workflow/status/comigor/fuzzy/CI)](https://github.com/comigor/fuzzy/actions?query=workflow%3ACI)

Fuzzy search in Dart.

This project is basically a code conversion, subset of [Fuse.js](https://github.com/krisk/Fuse).

## Installation
add the following to your `pubspec.yaml` file:
```shell
dependencies:
  fuzzy: <1.0.0
```
then run:
```shell
pub get
```
or with flutter:
```shell
flutter packages get
```

## Usage
```dart
import 'package:fuzzy/fuzzy.dart';

void main() {
  final fuse = Fuzzy(['apple', 'banana', 'orange']);

  final result = fuse.search('ran');

  result.map((r) => r.output.first.value).forEach(print);
}
```

Don't forget to take a look at [FuzzyOptions](https://pub.dev/documentation/fuzzy/latest/data_fuzzy_options/FuzzyOptions-class.html)!
