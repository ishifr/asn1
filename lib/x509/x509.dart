import 'dart:convert';
import 'dart:typed_data';

import 'package:asn1/asn1parser/helpers/encode_to_hex.dart';
import 'package:asn1/asn1parser/helpers/object_identifiers_database.dart';
import 'package:asn1/x509/extensions.dart';
import 'package:asn1/x509/issuer_name.dart';
import 'package:asn1/x509/serial_number.dart';
import 'package:asn1/x509/signature.dart';
import 'package:asn1/x509/subject_public_key_info.dart';
import 'package:asn1/x509/util.dart';
import 'package:asn1/x509/validity.dart';
import 'package:asn1/x509/version.dart';
import 'package:pointycastle/asn1.dart';

class X509 {
  late String base64String;
  late Map<String, Object?> tBSCertificate;
  late Map<String, Object?> certificate;
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
    var subject = Name.fromAsn1(sn.elements?.elementAt(5) as ASN1Sequence);
    var subjectPublicKeyInfo = SubjectPublicKeyInfo.fromASN1(
        sn.elements?.elementAt(6) as ASN1Sequence);
    Extensions? extensions;
    if ((sn.elements?.length ?? 0) > 6) {
      for (ASN1Object i in sn.elements ?? []) {
        if (i.tag == 0xa1) {
          // TODO issuerUniqueID
          print("issuerUniqueID: 0xa1");
        } else if (i.tag == 0xa2) {
          // TODO subjectuniuq
          print("subjectUniqueID: 0xa2");
        } else if (i.tag == 0xa3) {
          extensions = Extensions.fromASN1(i);
          print("0xa3");
        } else {}
      }
    }

    tBSCertificate = {
      'version': version,
      'serialNumber': serialNumber,
      'signature': signature,
      'issuer': issuer.names,
      'validity': validity,
      'subject': subject.names,
      'subjectPublicKeyInfo':
          "${subjectPublicKeyInfo.subjectPublicKey} ${subjectPublicKeyInfo.algorithms}",
      'extensions': extensions
    };
  }

  makeTBSCertificate({
    required BigInt version,
    required BigInt serialNumber,
    required List<int> signature,
  }) {
    ASN1Object v = ASN1Integer(version);
    var temp = ASN1Object(tag: 0xa0);
    temp.valueBytes = v.encode();
    var tbsCert = ASN1Sequence(elements: [
      temp,
      ASN1Integer(serialNumber),
      ASN1Sequence(elements: [ASN1ObjectIdentifier(signature)]),
      ASN1Sequence(elements: [
        ASN1Set(elements: [
          ASN1Sequence(elements: [
            ASN1ObjectIdentifier([2, 5, 4, 6]),
            ASN1PrintableString(stringValue: 'GB'),
          ])
        ]),
        ASN1Set(elements: [
          ASN1Sequence(elements: [
            ASN1ObjectIdentifier([2, 5, 4, 8]),
            ASN1PrintableString(stringValue: 'Greater Manchester'),
          ])
        ]),
        ASN1Set(elements: [
          ASN1Sequence(elements: [
            ASN1ObjectIdentifier([2, 5, 4, 7]),
            ASN1PrintableString(stringValue: 'Salford'),
          ])
        ]),
        ASN1Set(elements: [
          ASN1Sequence(elements: [
            ASN1ObjectIdentifier([2, 5, 4, 10]),
            ASN1PrintableString(stringValue: 'Sectigo Limited'),
          ])
        ]),
        ASN1Set(elements: [
          ASN1Sequence(elements: [
            ASN1ObjectIdentifier([2, 5, 4, 3]),
            ASN1PrintableString(
                stringValue: 'Sectigo ECC Domain Validation Secure Server CA'),
          ])
        ]),
      ]),
      ASN1Sequence(elements: [
        ASN1UtcTime(DateTime.tryParse('2024-03-07 00:00:00.000Z')),
        ASN1UtcTime(DateTime.tryParse('2025-03-07 23:59:59.000Z')),
      ]),
      ASN1Sequence(elements: [
        ASN1Set(elements: [
          ASN1Sequence(elements: [
            ASN1ObjectIdentifier([2, 5, 4, 3]),
            ASN1PrintableString(stringValue: 'github.com')
          ])
        ])
      ]),
      ASN1Sequence(elements: [
        ASN1Sequence(elements: [
          ASN1ObjectIdentifier([1, 2, 840, 10045, 2, 1]),
          ASN1ObjectIdentifier([1, 2, 840, 10045, 3, 1, 7]),
        ]),
        ASN1BitString(stringValues: Hex().decode('04044efc7a3d5dd918d6a87d9808233949169974dbd398e046e94a72231506e281dd91dec6f09dca888244710c05f157a1985691054ca2034ba3f956db5e57de91'))
      ]),
    ]);
    return tbsCert.encode();
    // tBSCertificate = {
    //   'version': version,
    //   'serialNumber': serialNumber,
    //   'signature': signature,
    //   'issuer': issuer.names,
    //   'validity': validity,
    //   'subject': subject.names,
    //   'subjectPublicKeyInfo':
    //   'extensions': extensions
    // };
  }

  X509.certificate(this.base64String) {
    ASN1Sequence sn = parse(base64String);
    certificate = {
      "tbsCertificate": X509.getTBSCertificate(base64String).tBSCertificate,
      "signatureAlgorithm": toDart(sn.elements?[1] as ASN1Object),
      "signature": toDart(sn.elements?[2] as ASN1Object),
    };
  }
}

ASN1Sequence parse(String base64String) {
  var bytes = base64.decode(base64String);
  var parser = ASN1Parser(bytes);
  return parser.nextObject() as ASN1Sequence;
}

// ASN1Object encodeASN1ContextSpecific(int tag, ASN1Object child){
//   return encodeASN1ContextSpecific0(tag, child.encode());
// }

// ASN1Object encodeASN1ContextSpecific0(int tag, Uint8List valueBytes){
//   var v = ASN1Object(tag: tag);
//   v.valueBytes = valueBytes;
//   return v;
// }