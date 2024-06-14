  import 'package:asn1/x509/to_dart.dart';
import 'package:pointycastle/asn1.dart';

class Name {
  final List<Map<dynamic, dynamic>> names;

  const Name(this.names);

  /// Name ::= CHOICE { -- only one possibility for now --
  ///   rdnSequence  RDNSequence }
  ///
  /// RDNSequence ::= SEQUENCE OF RelativeDistinguishedName
  ///
  /// RelativeDistinguishedName ::=
  ///   SET SIZE (1..MAX) OF AttributeTypeAndValue
  ///
  /// AttributeTypeAndValue ::= SEQUENCE {
  ///   type     AttributeType,
  ///   value    AttributeValue }
  ///
  /// AttributeType ::= OBJECT IDENTIFIER
  ///
  /// AttributeValue ::= ANY -- DEFINED BY AttributeType
  factory Name.fromAsn1(ASN1Sequence sequence) {
    return Name(sequence.elements!.map((ASN1Object set) {
      return <dynamic, dynamic>{
        for (var p in (set as ASN1Set).elements??[])
          toDart((p as ASN1Sequence).elements![0]): toDart(p.elements![1])
      };
    }).toList());
  }

  // ASN1Sequence toAsn1() {
  //   var seq = ASN1Sequence();
  //   for (var n in names) {
  //     var set = ASN1Set();
  //     n.forEach((k, v) {
  //       set.add(ASN1Sequence()
  //         ..add(fromDart(k))
  //         ..add(fromDart(v)));
  //     });
  //     seq.add(set);
  //   }
  //   return seq;
  // }

  @override
  String toString() =>
      names.map((m) => m.keys.map((k) => '$k=${m[k]}').join(', ')).join(', ');
}




// ASN1Object encodeASN1ContextSpecific(int tag, ASN1Object child){
//   return encodeASN1ContextSpecific0(tag, child.encode());
// }

// ASN1Object encodeASN1ContextSpecific0(int tag, Uint8List valueBytes){
//   var v = ASN1Object(tag: tag);
//   v.valueBytes = valueBytes;
//   return v;
// }