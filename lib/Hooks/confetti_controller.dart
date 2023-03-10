import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

useConfettiController() => use(_ConfettiController());

class _ConfettiController extends Hook<ConfettiController> {
  @override
  _ConfettiControllerState createState() => _ConfettiControllerState();
}

class _ConfettiControllerState
    extends HookState<ConfettiController, _ConfettiController> {
  late ConfettiController _controller;
  @override
  void initHook() {
    _controller = ConfettiController(
      duration: const Duration(milliseconds: 500),
    );

    super.initHook();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  ConfettiController build(BuildContext context) => _controller;
}
