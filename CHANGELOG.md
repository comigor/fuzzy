# CHANGELOG

## 0.4.1
- Update the CI

## 0.4.0-nullsafety.0
- Migrate to null safety

## 0.3.0
- Improve search results on weighted search to combine scores from all keys
- Improve search results on single-keyed search, making it consistent with non-weighted search
- Add parameter to ignore tokens smaller than a certain length when searching
- Add normalization of WeightedKey weights
- Fix bug where results returned from search all had arrayIndex = -1
- Fix bug where the token scores didn't count towards the result score

## 0.2.5
- Fix bug for search that started or ended with whitespace when tokenize option is true

## 0.2.4
- Bump dependencies, fix CI

## 0.2.3
- Fix some corner case bugs (empty search pattern, missing arguments)

## 0.2.2
- Fix bug for search in a list with some string that has leading or trailing whitespace when tokenize option is true

## 0.2.1
- Fix bug for search empty list

## 0.2.0+8
- Testing GitHub actions

## 0.2.0
- Make it generic (to use a List<T>), and perfrom weighted searches via predefined getters

## 0.1.1
- Add string normalization, from [latinize](https://github.com/lucasmafra/latinize)

## 0.1.0
- First usable version, fixing stupid bugs from conversion, and with tests

## 0.0.2
- Code ported from Fuse.js

## 0.0.1
- Initial commit