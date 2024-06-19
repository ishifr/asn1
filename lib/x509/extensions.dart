import 'package:asn1/x509/util.dart';
import 'package:pointycastle/asn1.dart';

class Extensions extends ASN1Object {
  late ASN1Object obj;
  dynamic extensions;

  Extensions.fromASN1(this.obj) {
    extensions = toDart(obj);
  }
}
