import 'dart:typed_data';

import 'package:pointycastle/asn1.dart';

class Version extends ASN1Object {
  late BigInt version;

  Version(this.version);

  Version.fromASN1Integer(ASN1Sequence sequence) {
    try {
      version = (ASN1Parser(sequence.elements?.elementAt(0).valueBytes)
              .nextObject() as ASN1Integer)
          .integer!;
    } catch (e) {
      print("Version.fromASN1Integer: $e");
    }
  }

  @override
  Uint8List encode(
      {ASN1EncodingRule encodingRule = ASN1EncodingRule.ENCODING_DER}) {
    ASN1Integer encode = ASN1Integer(version);

    return encode.encode();
  }
}
