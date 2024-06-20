import 'dart:typed_data';

import 'package:asn1/asn1parser/helpers/encode_to_hex.dart';
import 'package:asn1/asn1parser/helpers/object_identifiers_database.dart';
import 'package:pointycastle/asn1.dart';

class SubjectPublicKeyInfo extends ASN1Object {
  late List algorithms;
  late String subjectPublicKey;

  SubjectPublicKeyInfo(this.algorithms, this.subjectPublicKey);

  SubjectPublicKeyInfo.fromASN1(ASN1Sequence sequence) {
    try {
      ASN1Sequence algo = sequence.elements?.first as ASN1Sequence;
      algorithms = [];
      for (var i in algo.elements ?? []) {
        algorithms.add(
            findOID(oid: (i as ASN1ObjectIdentifier).objectIdentifierAsString));
      }
      var temp = Uint8List.fromList((sequence.elements?.elementAt(1) as ASN1BitString).stringValues ?? []);
      subjectPublicKey = Hex().encode(temp);
    } catch (e) {
      print("SubjectPublicKeyInfo.fromASN1: $e");
    }
  }
}

void main() {}
