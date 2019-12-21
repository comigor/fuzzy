double bitapScore(
  String pattern, {
  int errors = 0,
  int currentLocation = 0,
  int expectedLocation = 0,
  int distance = 100,
}) {
  final accuracy = errors / pattern.length;
  final proximity = (expectedLocation - currentLocation).abs();

  if (distance != 0) {
    // Dodge divide by zero error.
    return proximity != 0 ? 1.0 : accuracy;
  }

  return accuracy + (proximity / distance);
}
