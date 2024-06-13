import 'dart:convert';
import 'dart:typed_data';

import 'package:asn1/asn1parser/helpers/asn1_tree_node.dart';
import 'package:asn1/asn1parser/helpers/encode_to_hex.dart';
import 'package:asn1/asn1parser/helpers/object_identifiers_database.dart';
import 'package:pointycastle/asn1.dart';

Asn1TreeNode parseSequenceToTreeNode(String base64String) {
  var bytes = base64.decode(base64String);
  var parser = ASN1Parser(bytes);
  var sequence = parser.nextObject() as ASN1Sequence;
  Asn1TreeNode asn1Node = Asn1TreeNode();

  asn1Node = parseSequence(asn1Node, sequence);

  return asn1Node;
}

parseSequence(Asn1TreeNode node, ASN1Object obj) {
  var toHex = EncodeToHex();


  if (obj.tag == ASN1Tags.SEQUENCE) {
    node.text = "  SEQUENCE: {${obj.valueByteLength}}";
    var sequence = obj as ASN1Sequence;
    sequence.elements?.forEach((element) {
      node.children.add(parseSequence(Asn1TreeNode(), element));
    });
  } else if (obj.tag == ASN1Tags.SET) {
    node.text = "  SET  {${obj.valueByteLength}}";
    var sequence = obj as ASN1Set;
    sequence.elements?.forEach((element) {
      node.children.add(parseSequence(Asn1TreeNode(), element));
    });
  } else if (obj.tag == ASN1Tags.OBJECT_IDENTIFIER) {
    var i = obj as ASN1ObjectIdentifier;
    Map oid = findOID(oid:i.objectIdentifierAsString ?? '');
    node.text =
        "  OBJECT_I  {${obj.valueByteLength}}:  ${oid['readableName']} [${oid['identifierString']}]";
  } else if (obj.tag == ASN1Tags.PRINTABLE_STRING) {
    var i = obj as ASN1PrintableString;
    node.text = "  P_STRING  {${obj.valueByteLength}}:  ${i.stringValue} ";
  } else if (obj.tag == ASN1Tags.INTEGER) {
    var i = obj as ASN1Integer;
    node.text = "  INTEGER  {${obj.valueByteLength}}:  ${i.integer} ";
  } else if (obj.tag == ASN1Tags.BOOLEAN) {
    var i = obj as ASN1Boolean;
    node.text = "  BOOLEAN  {${obj.valueByteLength}}:  ${i.boolValue} ";
  } else if (obj.tag == ASN1Tags.NULL) {
    node.text = "  NULL  {${obj.valueByteLength}}";
  } else if (obj.tag == ASN1Tags.UTF8_STRING) {
    var i = obj as ASN1UTF8String;
    node.text = "  UTF8STRING  {${obj.valueByteLength}}: ${i.utf8StringValue} ";
  } else if (obj.tag == ASN1Tags.BIT_STRING) {
    var i = obj as ASN1BitString;
    node.text =
        "  BIT STRING  {${obj.valueByteLength}}:  [${i.unusedbits}] :[HEX] ${toHex.encode(Uint8List.fromList(i.stringValues ?? []))} ";
  } else if (obj.tag == ASN1Tags.IA5_STRING) {
    var i = obj as ASN1IA5String;
    node.text = "  IA5_STRING  {${obj.valueByteLength}}:  ${i.stringValue} ";
  } else if (obj.tag == ASN1Tags.UTC_TIME) {
    var i = obj as ASN1UtcTime;
    node.text = "  UTC_TIME  {${obj.valueByteLength}}:  ${i.time} ";
  } else if (obj.tag == ASN1Tags.OCTET_STRING) {
    var i = obj as ASN1OctetString;
    node.text =
        "  OCTET_STRING  {${obj.valueByteLength}}:  [HEX] ${toHex.encode(i.octets)} ";
  } else if (obj.tag == ASN1Tags.OCTET_STRING_CONSTRUCTED) {
    var i = obj as ASN1OctetString;
    node.text =
        "  OCTET_STRING_C  {${i.valueByteLength}}: [HEX] ${toHex.encode(i.octets)}";
  } else if (obj.tag != null) {
    /// CONTEXT SPECIFIC
    if (obj.tag! >= 0xA0 && obj.tag! <= 0xBF) {
      node.text = "  CONTEXT SPECIFIC  {${obj.valueByteLength}}";
      var content = ASN1Parser(obj.valueBytes).nextObject();
      node.children.add(parseSequence(Asn1TreeNode(), content));
    } else {
      print('The object is not a context-specific tag: ${obj.tag}');
    }
  }
  var a = Asn1TreeNode();
  if (handleIndefiniteLength(obj.encodedBytes?.toList() ?? [])) {
    a.text = "  EOC";
    node.children.add(a);
  }
  return node;
}

bool handleIndefiniteLength(List<int> bytes) {
  for (int i = 0; i < bytes.length - 1; i++) {
    if (bytes[i] == 0x00 && bytes[i + 1] == 0x00) {
      print('End-of-Content (EOC) marker found within sequence');
      return true;
    }
  }
  return false;
}
