import 'dart:convert';
import 'dart:typed_data';

import 'package:asn1/asn1parser/asn1_tree_node.dart';
import 'package:pointycastle/asn1.dart';

final oidMap = {
  '1.2.840.113549.1.7.2': 'pkcs7-signedData',
  '1.2.840.113549.1.7.1': 'pkcs7-data',
  '1.2.860.3.15.1.3.2.1.1': 'UZDST 1106:2009 II default digest parameters',
  '1.2.860.3.15.1.1.2.2.2.2':
      'UZDST 1092:2009 II/1106:2009 sign. alg. with digest',
  '1.2.860.3.15.1.1.2.1':'UZDST 1092:2009 II signature public key',
  '1.2.860.3.15.1.1.2.1.1':'UZDST 1092:2009 II signature parameters, UNICON.UZ paramset A',
  '2.5.4.41': 'name',
  '1.2.840.113549.1.9.3':'contentType',
  '1.2.860.3.16.1.2':'Personal Identification Number (PINFL)',
  '1.2.860.3.16.1.1':'Tax Identification Number (INN)',
  // Add more OIDs and their readable names here
};

Asn1TreeNode parseSequenceToTreeNode(String base64String) {
  var bytes = base64.decode(base64String);
  var parser = ASN1Parser(bytes);
  var sequence = parser.nextObject() as ASN1Sequence;
  Asn1TreeNode asn1Node = Asn1TreeNode();

  asn1Node = parseSequence(asn1Node, sequence);

  return asn1Node;
}

parseSequence(Asn1TreeNode node, ASN1Object obj) {
  if (obj.tag == ASN1Tags.SEQUENCE) {
    node.text =
        "(${obj.totalEncodedByteLength}, ${obj.valueByteLength})  SEQUENCE";
    var sequence = obj as ASN1Sequence;
    sequence.elements?.forEach((element) {
      node.children.add(parseSequence(Asn1TreeNode(), element));
    });
  } else if (obj.tag == ASN1Tags.SET) {
    node.text = "  SET";
    var sequence = obj as ASN1Set;
    sequence.elements?.forEach((element) {
      node.children.add(parseSequence(Asn1TreeNode(), element));
    });
  } else if (obj.tag == ASN1Tags.OBJECT_IDENTIFIER) {
    var i = obj as ASN1ObjectIdentifier;

    node.text =
        "  OBJECT_I:  ${i.readableName ?? oidMap[i.objectIdentifierAsString]} [${i.objectIdentifierAsString}]";
  } else if (obj.tag == ASN1Tags.PRINTABLE_STRING) {
    var i = obj as ASN1PrintableString;
    node.text = "  P_STRING:  ${i.stringValue} ";
  } else if (obj.tag == ASN1Tags.INTEGER) {
    var i = obj as ASN1Integer;
    node.text = "  INTEGER:  ${i.integer} ";
  } else if (obj.tag == ASN1Tags.BOOLEAN) {
    var i = obj as ASN1Boolean;
    node.text = "  BOOLEAN:  ${i.boolValue} ";
  } else if (obj.tag == ASN1Tags.NULL) {
    node.text = "  NULL";
  } else if (obj.tag == ASN1Tags.UTF8_STRING) {
    var i = obj as ASN1UTF8String;
    node.text = "  UTF8STRING: ${i.utf8StringValue} ";
  } else if (obj.tag == ASN1Tags.BIT_STRING) {
    var i = obj as ASN1BitString;
    node.text =
        "  BIT STRING:  [${i.unusedbits}] :${encodeToHex(Uint8List.fromList(i.stringValues ?? []))} ";
  } else if (obj.tag == ASN1Tags.IA5_STRING) {
    var i = obj as ASN1IA5String;
    node.text = "  IA5_STRING:  ${i.stringValue} ";
  } else if (obj.tag == ASN1Tags.UTC_TIME) {
    var i = obj as ASN1UtcTime;
    node.text = "  UTC_TIME:  ${i.time} ";
  } else if (obj.tag == ASN1Tags.OCTET_STRING) {
    var i = obj as ASN1OctetString;
    node.text = "  OCTET_STRING:  ${encodeToHex(i.octets)} ";
  } else if (obj.tag == ASN1Tags.OCTET_STRING_CONSTRUCTED) {
    var i = obj as ASN1OctetString;
    print("${i.elements}");
    node.text = "  OCTET_STRING_C";
  } else if (obj.tag != null) {
    /// CONTEXT SPECIFIC
    if (obj.tag! >= 0xA0 && obj.tag! <= 0xBF) {
      node.text = "  CONTEXT SPECIFIC";
      var content = ASN1Parser(obj.valueBytes).nextObject();
      node.children.add(parseSequence(Asn1TreeNode(), content));
    } else {
      print('The object is not a context-specific tag: ${obj.tag}');
    }
  }
  return node;
}

printTree(Asn1TreeNode root, int depth) {
  print("  " * depth + root.text);
  for (var node in root.children) {
    printTree(node, depth + 1);
  }
}

String encodeToHex(Uint8List? octets) {
  var hex = "";
  for (var v in octets ?? []) {
    var s = v.toRadixString(16);
    hex += (s.length == 1 ? "0$s" : s);
  }
  return hex;
}
