import 'dart:math' as math;

class CodeUtils {
  static String generateRandomId(int length) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = StringBuffer();
    for (int i = 0; i < length; i++) {
      random.write(
          characters[(characters.length * math.Random().nextDouble()).floor()]);
    }
    return random.toString();
  }
}
