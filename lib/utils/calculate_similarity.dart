import 'dart:math';

double calculateSimilarity(String s1, String s2) {
  if (s1.isEmpty && s2.isEmpty) return 1.0;
  if (s1.isEmpty || s2.isEmpty) return 0.0;

  final m = List.generate(
    s1.length + 1,
    (i) => List<int>.filled(s2.length + 1, 0),
  );

  for (int i = 0; i <= s1.length; i++) {
    for (int j = 0; j <= s2.length; j++) {
      if (i == 0) {
        m[i][j] = j;
      } else if (j == 0) {
        m[i][j] = i;
      } else {
        m[i][j] = min(
          min(m[i - 1][j] + 1, m[i][j - 1] + 1),
          m[i - 1][j - 1] + (s1[i - 1] == s2[j - 1] ? 0 : 1),
        );
      }
    }
  }

  final distance = m[s1.length][s2.length];
  final maxLen = s1.length > s2.length ? s1.length : s2.length;
  return 1.0 - (distance / maxLen);
}
