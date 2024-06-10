import 'dart:convert';

import 'package:pointycastle/asn1.dart';

class X509 {
  final String base64String;
  X509(this.base64String);

  /// CertificateSerialNumber
  BigInt? serialNumber() {
    ASN1Sequence sn = parse(base64String);
    sn = sn.elements?.first as ASN1Sequence;
    var i = sn.elements?[1] as ASN1Integer;

    return i.integer;
  }

  /// AlgorithmIdentifier
  String? signature() {
    ASN1Sequence sn = parse(base64String);
    sn = sn.elements?.first as ASN1Sequence;
    sn = sn.elements?[2] as ASN1Sequence;
    var i = sn.elements?.first as ASN1ObjectIdentifier;

    return i.readableName;
  }

    /// Validity
   Map<String,DateTime?> validity() {
    ASN1Sequence sn = parse(base64String);
    sn = sn.elements?.first as ASN1Sequence;
    sn = sn.elements?[4] as ASN1Sequence;
    var i = sn.elements?.first as ASN1UtcTime;
    var i1 = sn.elements?[1] as ASN1UtcTime;

    return {"notBefore":i.time,"notAfter":i1.time};
  }

    /// subject
   Map<String,DateTime?> subject() {
    ASN1Sequence sn = parse(base64String);
    sn = sn.elements?.first as ASN1Sequence;
    sn = sn.elements?[5] as ASN1Sequence;
    var i = sn.elements?.first as ASN1UtcTime;
    var i1 = sn.elements?[1] as ASN1UtcTime;

    return {"notBefore":i.time,"notAfter":i1.time};
  }
}

ASN1Sequence parse(String base64String) {
  var bytes = base64.decode(base64String);
  var parser = ASN1Parser(bytes);
  return parser.nextObject() as ASN1Sequence;
}
