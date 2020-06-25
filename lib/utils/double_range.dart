import 'dart:math';

class DoubleRange {
  /// inclusive
  final double min;
  /// exclusive
  final double max;

  const DoubleRange(this.min, this.max);

  double get size => max - min;

  double random(Random random) => min + random.nextDouble() * size;

  @override
  String toString() {
    return "[$min, $max[";
  }
}
