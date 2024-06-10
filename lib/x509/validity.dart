import 'dart:convert';

import 'package:pointycastle/asn1.dart';

class Validity {
  final DateTime notBefore;
  final DateTime notAfter;

  Validity({required this.notBefore, required this.notAfter});

  factory Validity.fromAsn1(ASN1Sequence sequence) => Validity(
        notBefore: toDart(sequence.elements![0]),
        notAfter: toDart(sequence.elements![1]),
      );


  @override
  String toString([String prefix = '']) {
    var buffer = StringBuffer();
    buffer.writeln('${prefix}Not Before: $notBefore');
    buffer.writeln('${prefix}Not After: $notAfter');
    return buffer.toString();
  }
}

dynamic toDart(ASN1Object obj) {
  if (obj is ASN1Null) return null;
  if (obj is ASN1Sequence) return obj.elements?.map(toDart).toList();
  if (obj is ASN1Set) return obj.elements?.map(toDart).toSet();
  if (obj is ASN1Integer) return obj.integer;
  if (obj is ASN1ObjectIdentifier) return obj.objectIdentifier;
  if (obj is ASN1BitString) return obj.stringValues;
  if (obj is ASN1Boolean) return obj.boolValue;
  if (obj is ASN1OctetString) return obj.elements;
  if (obj is ASN1PrintableString) return obj.stringValue;
  if (obj is ASN1UtcTime) return obj.time;
  if (obj is ASN1GeneralizedTime) return obj.dateTimeValue;
  if (obj is ASN1IA5String) return obj.stringValue;
  if (obj is ASN1UTF8String) return obj.utf8StringValue;

  // ASN.1 Identifier format is below:
  // | 7 | 6 |  5  | 4| 3| 2|1|0|
  // | Class | P/C | Tag number |
  //
  // The Class type is below:
  // 0 0(0): Universal
  // 0 1(1): Applicaation
  // 1 0(2): Context-Specific
  // 1 1(3): Private
  //
  // The P/C is below:
  // 0: Primitive
  // 1: Constructed
  switch (obj.tag) {
    case 0xa0: // 10 1 00000 => Class is Context-Specific, P/C is Constructed and Tag Number is 0
      return toDart(ASN1Parser(obj.encodedBytes).nextObject());
    case 0x86: // 10 0 00110 => Class is Context-Specific, P/C is Primitive and Tag Number is 6
      return utf8.decode(obj.valueBytes?.toList()??[]);
  }
  throw ArgumentError(
      'Cannot convert $obj (${obj.runtimeType}) to dart object.');
}