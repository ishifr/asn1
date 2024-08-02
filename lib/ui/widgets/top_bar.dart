import 'package:asn1/bloc/control/control_bloc.dart';
import 'package:asn1/util/tabs_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopBarWidget extends StatelessWidget {
  final List<TabsInfo> tabs;
  final PageController controller;
  const TopBarWidget(this.tabs, this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey.shade100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              BlocProvider.of<ControlBloc>(context)
                  .add(CurrentTab(tabs: tabs, index: index));
              controller.jumpToPage(index);
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(right: 2),
              color: tabs[index].isCurrent
                  ? ThemeData.light().scaffoldBackgroundColor
                  : Colors.grey.shade200,
              child: Row(
                children: [
                  Text(tabs[index].name),
                  const SizedBox(width: 8),
                  MaterialButton(
                    padding: EdgeInsets.zero,
                    minWidth: 30,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(CupertinoIcons.clear_thick, size: 16),
                    onPressed: () {
                      BlocProvider.of<ControlBloc>(context)
                          .add(DeleteTab(tabs: tabs, index: index));
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
