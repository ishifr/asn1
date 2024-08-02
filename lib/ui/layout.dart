import 'dart:convert';
import 'dart:developer';

import 'package:asn1/asn1parser/helpers/asn1_tree_node.dart';
import 'package:asn1/asn1parser/parse_sequence_to_tree_node.dart';
import 'package:asn1/bloc/control/control_bloc.dart';
import 'package:asn1/ui/widgets/body.dart';
import 'package:asn1/ui/widgets/top_bar.dart';
import 'package:asn1/util/pick_file.dart';
import 'package:asn1/util/tabs_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

List<TabsInfo> tabs = [];
TextEditingController textController = TextEditingController();
final PageController controller = PageController();

class Layout extends StatelessWidget {
  const Layout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Row(
        children: [
          NavigationRail(
            minWidth: 55,
            groupAlignment: -.95,
            indicatorColor: Colors.transparent,
            labelType: NavigationRailLabelType.all,
            onDestinationSelected: (value) async {
              if (value == 1) {
                var res = await filePicker();
                if (res.isNotEmpty) {
                  tabs.add(TabsInfo(
                      name: res[0],
                      body: TreeController<Asn1TreeNode>(
                        roots: [parseSequenceToTreeNode(res[1])],
                        childrenProvider: (Asn1TreeNode node) => node.children,
                      ),
                      isCurrent: tabs.isEmpty));
                  BlocProvider.of<ControlBloc>(context)
                      .add(CurrentTab(tabs: tabs, index: tabs.length - 1));
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: TextFormField(
                        onSaved: (newValue) {
                          print(newValue);
                        },
                        maxLines: 10,
                        controller: textController,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                      ),
                    );
                  },
                );
                print(textController.text);
                if (textController.text.isNotEmpty) {
                  tabs.add(TabsInfo(
                      name: 'temp',
                      body: TreeController<Asn1TreeNode>(
                        roots: [
                          parseSequenceToTreeNode(
                              base64Decode(textController.text))
                        ],
                        childrenProvider: (Asn1TreeNode node) => node.children,
                      ),
                      isCurrent: tabs.isEmpty));
                  BlocProvider.of<ControlBloc>(context)
                      .add(CurrentTab(tabs: tabs, index: tabs.length - 1));
                  textController.clear();
                }
              }
            },
            destinations: <NavigationRailDestination>[
              _rail(Icons.data_array_rounded, 'Bytes'),
              _rail(Icons.file_open_outlined, 'File'),
            ],
            selectedIndex: 0,
          ),
          const VerticalDivider(width: 8),
          Expanded(
            child: BlocBuilder<ControlBloc, ControlState>(
              builder: (context, state) {
                if (state is ControlInitial) {
                  return const Center(child: Text('Empty'));
                } else if (state is ControlSuccess) {
                  tabs = state.tabs;
                  return Column(
                    children: [
                      TopBarWidget(state.tabs, controller),
                      Expanded(
                          child:
                              BodyWidget(state.tabs, state.index, controller)),
                    ],
                  );
                }
                return const Center();
              },
            ),
          ),
        ],
      ),
    ));
  }

  NavigationRailDestination _rail(IconData icon, String text) {
    return NavigationRailDestination(
        padding: const EdgeInsets.only(left: 4),
        icon: Icon(icon),
        label: Text(
          text,
          style: const TextStyle(color: Colors.black),
        ));
  }
}
