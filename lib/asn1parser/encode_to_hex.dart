import 'dart:typed_data';

class EncodeToHex {
  /// This method gets Uint8List? octets and returns String Hex value
  String encode(Uint8List? octets) {
    var hex = "";
    for (var v in octets ?? []) {
      var s = v.toRadixString(16);
      hex += (s.length == 1 ? "0$s" : s);
    }
    return hex;
  }
}
