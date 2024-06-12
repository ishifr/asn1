import 'dart:convert';

import 'package:asn1/asn1parser/helpers/object_identifiers_database.dart';
import 'package:asn1/x509/validity.dart';
import 'package:pointycastle/asn1.dart';

class X509 {
  late String base64String;
  Map<String, Object?>? tBSCertificate;
  X509(this.base64String);

  X509.getTBSCertificate(this.base64String) {
    ASN1Sequence sn = parse(base64String);
    sn = sn.elements?.first as ASN1Sequence;
    var signature = findOID(((sn.elements?.elementAt(2) as ASN1Sequence)
            .elements
            ?.first as ASN1ObjectIdentifier)
        .objectIdentifierAsString!);

    tBSCertificate = {
      'version': (ASN1Parser(sn.elements?.elementAt(0).valueBytes).nextObject()
              as ASN1Integer)
          .integer,
      'serialNumber': (sn.elements?.elementAt(1) as ASN1Integer).integer,
      'signature':
          "[${signature['identifierString']}] ${signature['readableName']}",
      'issuer': '',
      'validity':
          Validity.fromSequence(sn.elements?.elementAt(4) as ASN1Sequence)
              .validity,
      'subject': '',
      'subjectPublicKeyInfo': '',
      'issuerUniqueID': '',
    };
  }

  /// subject
  Map<String, DateTime?> subject() {
    ASN1Sequence sn = parse(base64String);
    sn = sn.elements?.first as ASN1Sequence;
    sn = sn.elements?[5] as ASN1Sequence;
    var i = sn.elements?.first as ASN1UtcTime;
    var i1 = sn.elements?[1] as ASN1UtcTime;

    return {"notBefore": i.time, "notAfter": i1.time};
  }
}

ASN1Sequence parse(String base64String) {
  var bytes = base64.decode(base64String);
  var parser = ASN1Parser(bytes);
  return parser.nextObject() as ASN1Sequence;
}
