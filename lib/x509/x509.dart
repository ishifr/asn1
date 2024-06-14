import 'dart:convert';

import 'package:asn1/asn1parser/helpers/object_identifiers_database.dart';
import 'package:asn1/x509/issuer_name.dart';
import 'package:asn1/x509/serial_number.dart';
import 'package:asn1/x509/signature.dart';
import 'package:asn1/x509/validity.dart';
import 'package:asn1/x509/version.dart';
import 'package:pointycastle/asn1.dart';

class X509 {
  late String base64String;
  late Map<String, Object?> tBSCertificate;
  X509(this.base64String);

  X509.getTBSCertificate(this.base64String) {
    ASN1Sequence sn = parse(base64String);
    sn = sn.elements?.first as ASN1Sequence;

    BigInt? version = Version.fromASN1Integer(sn).version;
    BigInt? serialNumber = SerialNumber.fromASN1Integer(sn).serialNumber;
    var signature = findOID(identifier: Signature.fromASN1Signature(sn).node);
    var issuer = Name.fromAsn1(sn.elements?.elementAt(3) as ASN1Sequence);
    var validity =
        Validity.fromSequence(sn.elements?.elementAt(4) as ASN1Sequence)
            .validity;

    tBSCertificate = {
      'version': version,
      'serialNumber': serialNumber,
      'signature': signature,
      'issuer': issuer.names,
      'validity': validity,
      'subject': '',
      'subjectPublicKeyInfo': '',
      'issuerUniqueID': '',
    };
  }
}

ASN1Sequence parse(String base64String) {
  var bytes = base64.decode(base64String);
  var parser = ASN1Parser(bytes);
  return parser.nextObject() as ASN1Sequence;
}
