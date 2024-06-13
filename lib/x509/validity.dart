// ignore_for_file: avoid_print
import 'dart:typed_data';
import 'package:pointycastle/asn1.dart';

/// Validity ::= SEQUENCE {
///  notBefore      Time,
///   notAfter       Time
/// }

/// Time ::= CHOICE {
///   utcTime        UTCTime,
///   generalTime    GeneralizedTime
/// }
class Validity extends ASN1Object {
  late DateTime notBefore;
  late DateTime notAfter;
  late Map<String, DateTime?> validity;

  Validity(
    this.notBefore,
    this.notAfter,
  );
  Validity.fromSequence(ASN1Sequence? sequence) {
    try {
      DateTime? notBeforeSeq;
      DateTime? notAfterSeq;
      ASN1Object? notBeforeObj = sequence?.elements?.first;
      ASN1Object? notAfterObj = sequence?.elements?[1];
      if (notBeforeObj is ASN1UtcTime) {
        notBeforeSeq = notBeforeObj.time;
      } else if (notBeforeObj is ASN1GeneralizedTime) {
        notBeforeSeq = notBeforeObj.dateTimeValue;
      } else {
        throw ArgumentError(
            'Element at index 0 has to be ASN1GeneralizedTime, ASN1UtcTime');
      }
      if (notAfterObj is ASN1UtcTime) {
        notAfterSeq = notAfterObj.time;
      } else if (notAfterObj is ASN1GeneralizedTime) {
        notAfterSeq = notAfterObj.dateTimeValue;
      } else {
        throw ArgumentError(
            'Element at index 1 has to be ASN1GeneralizedTime, ASN1UtcTime');
      }
      validity = {
        'notBefore': notBeforeSeq,
        'notAfter': notAfterSeq,
      };
    } catch (e) {
      print("Validity.fromSequence: $e");
    }
  }

  @override
  Uint8List encode(
      {ASN1EncodingRule encodingRule = ASN1EncodingRule.ENCODING_DER}) {
    ASN1Sequence encode =
        ASN1Sequence(elements: [ASN1UtcTime(notBefore), ASN1UtcTime(notAfter)]);

    return encode.encode();
  }
}
