import 'dart:typed_data';

import 'package:asn1/asn1parser/helpers/encode_to_hex.dart';
import 'package:asn1/asn1parser/helpers/object_identifiers_database.dart';
import 'package:pointycastle/pointycastle.dart';
import 'dart:convert';
import 'package:pointycastle/asn1.dart';

dynamic toDart(ASN1Object obj) {
  if (obj is ASN1Null) return null;
  if (obj is ASN1Sequence) return obj.elements?.map(toDart).toList();
  if (obj is ASN1Set) return obj.elements?.map(toDart).toSet();
  if (obj is ASN1Integer) return obj.integer;
  if (obj is ASN1ObjectIdentifier) return findOID(oid: obj.objectIdentifierAsString);
  if (obj is ASN1BitString) return Hex().encode(Uint8List.fromList(obj.stringValues ?? []));
  if (obj is ASN1Boolean) return obj.boolValue;
  if (obj is ASN1OctetString) return Hex().encode(obj.octets);
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
      return utf8.decode(obj.encodedBytes ?? []);
    case 0xa3: // 10 0 00110 => Class is Context-Specific, P/C is Primitive and Tag Number is 6
      var temp = ASN1Parser(obj.valueBytes).nextObject();

      return toDart(temp);
  }
  throw ArgumentError(
      'Cannot convert $obj (${obj.runtimeType}) to dart object.');
}

ASN1Object fromDart(dynamic obj) {
  if (obj == null) return ASN1Null();
  if (obj is List<int>) return ASN1BitString(stringValues: obj);
  if (obj is List) {
    var s = ASN1Sequence();
    for (var v in obj) {
      s.add(fromDart(v));
    }
    return s;
  }
  if (obj is Set) {
    var s = ASN1Set();
    for (var v in obj) {
      s.add(fromDart(v));
    }
    return s;
  }
  if (obj is BigInt) return ASN1Integer(obj);
  if (obj is int) return ASN1Integer(BigInt.from(obj));
  if (obj is ObjectIdentifier) return obj.toAsn1();
  if (obj is bool) return ASN1Boolean(obj);
  if (obj is String) return ASN1PrintableString(stringValue: obj);
  if (obj is DateTime) return ASN1UtcTime(obj);

  throw ArgumentError.value(obj, 'obj', 'cannot be encoded as ASN1Object');
}
