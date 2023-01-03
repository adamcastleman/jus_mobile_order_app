import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

useGroupedItemScrollController() => use(_GroupedItemScrollController());

class _GroupedItemScrollController extends Hook<GroupedItemScrollController> {
  @override
  _GroupedItemScrollControllerState createState() =>
      _GroupedItemScrollControllerState();
}

class _GroupedItemScrollControllerState extends HookState<
    GroupedItemScrollController, _GroupedItemScrollController> {
  GroupedItemScrollController _controller = GroupedItemScrollController();
  @override
  void initHook() {
    _controller = GroupedItemScrollController();
    super.initHook();
  }

  @override
  GroupedItemScrollController build(BuildContext context) => _controller;
}
