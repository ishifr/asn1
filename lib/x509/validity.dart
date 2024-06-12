// ignore_for_file: avoid_print

import 'dart:convert';
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
  DateTime? notBefore;
  DateTime? notAfter;

  Validity({this.notBefore, this.notAfter});

  Validity.fromSequence(ASN1Sequence sequence) {
    try {
      ASN1Object? notBeforeObj = sequence.elements?.first;
      ASN1Object? notAfterObj = sequence.elements?[1];
      if (notBeforeObj is ASN1UtcTime) {
        notBefore = notBeforeObj.time;
      } else if (notBeforeObj is ASN1GeneralizedTime) {
        notBefore = notBeforeObj.dateTimeValue;
      } else {
        throw ArgumentError(
            'Element at index 0 has to be ASN1GeneralizedTime, ASN1UtcTime');
      }
      if (notAfterObj is ASN1UtcTime) {
        notAfter = notAfterObj.time;
      } else if (notAfterObj is ASN1GeneralizedTime) {
        notAfter = notAfterObj.dateTimeValue;
      } else {
        throw ArgumentError(
            'Element at index 1 has to be ASN1GeneralizedTime, ASN1UtcTime');
      }
    } catch (e) {
      print("Validity.fromSequence: $e");
    }
  }
}
