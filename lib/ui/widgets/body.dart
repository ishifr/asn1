import 'package:asn1/asn1parser/helpers/asn1_tree_node.dart';
import 'package:asn1/util/tabs_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

class BodyWidget extends StatelessWidget {
  final List<TabsInfo> tabs;
  final int current;
  final PageController controller;

  const BodyWidget(this.tabs, this.current, this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: tabs.length,
      physics: const NeverScrollableScrollPhysics(),
      controller: controller,
      itemBuilder: (context, index) {
        tabs[index].body.expandAll();
        return AnimatedTreeView<Asn1TreeNode>(
          padding: const EdgeInsets.all(6),
          treeController: tabs[index].body,
          nodeBuilder: (BuildContext context, TreeEntry<Asn1TreeNode> entry) {
            return InkWell(
              onTap: () => tabs[index].body.toggleExpansion(entry.node),
              child: TreeIndentation(
                entry: entry,
                child: SelectableText(entry.node.text),
              ),
            );
          },
        );
      },
    );
  }
}
