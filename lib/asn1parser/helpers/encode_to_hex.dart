import 'dart:typed_data';

class Hex {
  /// This method gets Uint8List? octets and returns String Hex value
  String encode(Uint8List? octets) {
    var hex = "";
    for (var v in octets ?? []) {
      var s = v.toRadixString(16);
      hex += (s.length == 1 ? "0$s" : s);
    }
    return hex;
  }
 // ignore: non_constant_identifier_names
 final String _ALPHABET = "0123456789abcdef";
  List<int> decode(String hex) {
    String str = hex.replaceAll(" ", "");
    str = str.toLowerCase();
    if(str.length % 2 != 0) {
      str = "0$str";
    }
    Uint8List result =   Uint8List(str.length ~/ 2);
    for(int i = 0 ; i < result.length ; i++) {
      int firstDigit = _ALPHABET.indexOf(str[i*2]);
      int secondDigit = _ALPHABET.indexOf(str[i*2+1]);
      if (firstDigit == -1 || secondDigit == -1) {
        throw   FormatException("Non-hex character detected in $hex");
      }
      result[i] = (firstDigit << 4) + secondDigit;
    }
    return result;
  }
}
