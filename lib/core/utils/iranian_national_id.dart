/// Iranian National ID (کد ملی) checksum validation.
abstract final class IranianNationalId {
  static bool isValid(String raw) {
    final code = raw.trim();
    if (!RegExp(r'^\d{10}$').hasMatch(code)) return false;
    if (RegExp(r'^(\d)\1{9}$').hasMatch(code)) return false;
    var sum = 0;
    for (var i = 0; i < 9; i++) {
      sum += int.parse(code[i]) * (10 - i);
    }
    final r = sum % 11;
    final check = int.parse(code[9]);
    return (r < 2 && check == r) || (r >= 2 && check == 11 - r);
  }
}
