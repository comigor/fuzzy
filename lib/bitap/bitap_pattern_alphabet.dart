Map<String, int> patternAlphabet(String pattern) {
  final mask = <String, int>{};
  final len = pattern.length;

  for (var i = 0; i < len; i += 1) {
    mask.update(pattern[i], (_) => 0, ifAbsent: () => 0);
  }

  for (var i = 0; i < len; i += 1) {
    mask.update(pattern[i], (old) => old | 1 << (len - i - 1));
  }

  return mask;
}
