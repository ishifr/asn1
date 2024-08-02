import 'package:asn1/asn1parser/helpers/asn1_tree_node.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

class TabsInfo {
  String name;
  TreeController<Asn1TreeNode> body;
  bool isCurrent;
  TabsInfo({
    required this.name,
    required this.body,
    this.isCurrent = false,
  });

  @override
  String toString() =>
      'TabsInfo(name: $name, body: $body, isCurrent: $isCurrent)';

  @override
  bool operator ==(covariant TabsInfo other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.body == body &&
        other.isCurrent == isCurrent;
  }

  @override
  int get hashCode => name.hashCode ^ body.hashCode ^ isCurrent.hashCode;
}
