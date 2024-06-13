import 'dart:typed_data';

import 'package:pointycastle/asn1.dart';

/// CertificateSerialNumber
class SerialNumber extends ASN1Object {
  late BigInt serialNumber;
  SerialNumber(this.serialNumber);

  SerialNumber.fromASN1Integer(ASN1Sequence sequence) {
    try {
      var sq = (sequence.elements?.elementAt(1) as ASN1Integer);
      serialNumber = sq.integer!;
    } catch (e) {
      print("SerialNumber.fromASN1Integer: $e");
    }
  }

  @override
  Uint8List encode(
      {ASN1EncodingRule encodingRule = ASN1EncodingRule.ENCODING_DER}) {
    ASN1Integer encode = ASN1Integer(serialNumber);
    return encode.encode();
  }
}
