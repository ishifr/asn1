import 'dart:typed_data';

import 'package:pointycastle/asn1.dart';

class Signature extends ASN1Object {
   List<int> node = [];

  Signature.fromASN1Signature(ASN1Sequence sequence) {
    try {
      var oid = ((sequence.elements?.elementAt(2) as ASN1Sequence)
              .elements
              ?.first as ASN1ObjectIdentifier)
          .objectIdentifierAsString!;
      oid.split('.').forEach((element) {
        node.add(int.parse(element));
      });
    } catch (e) {
      print("Signature.fromASN1Signature: $e");
    }
  }

  @override
  Uint8List encode(
      {ASN1EncodingRule encodingRule = ASN1EncodingRule.ENCODING_DER}) {
    ASN1ObjectIdentifier encode = ASN1ObjectIdentifier(node);
    return encode.encode();
  }
}
