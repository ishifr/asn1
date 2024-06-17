import 'package:asn1/asn1parser/helpers/object_identifiers_database.dart';
import 'package:asn1/x509/util.dart';
import 'package:pointycastle/asn1.dart';

class AlgorithmIdentifier {
  final ObjectIdentifier algorithm;
  final dynamic parameters;

  AlgorithmIdentifier(this.algorithm, this.parameters);

  /// AlgorithmIdentifier  ::=  SEQUENCE  {
  ///   algorithm               OBJECT IDENTIFIER,
  ///   parameters              ANY DEFINED BY algorithm OPTIONAL  }
  ///                             -- contains a value of the type
  ///                             -- registered for use with the
  ///                             -- algorithm object identifier value
  factory AlgorithmIdentifier.fromAsn1(ASN1Sequence sequence) {
    var algorithm = toDart(sequence.elements![0]);
    var parameters = (sequence.elements?.length ?? 0) > 1
        ? toDart(sequence.elements![1])
        : null;
    return AlgorithmIdentifier(algorithm, parameters);
  }

  // ASN1Sequence toAsn1() {
  //   var seq = ASN1Sequence()..add(fromDart(algorithm));
  //   seq.add(fromDart(parameters));
  //   return seq;
  // }

  @override
  String toString() => "$algorithm${parameters == null ? "" : "($parameters)"}";
}
