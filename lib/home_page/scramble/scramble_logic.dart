import 'dart:math';

/// A list of example scrambles
final List<String> scrambleList = [
  "R U R' U R U2 R'",
  "F R U' R' U' R U R' F'",
  "L U2 L' U2 L F' L' U' L U L F L2",
  "B U B' U' B' R B2 U' B' U' B U B' R'",
  "R' U' F' U F R",
];

/// Returns a random scramble from the list
String getRandomScramble() {
  final random = Random();
  return scrambleList[random.nextInt(scrambleList.length)];
}
