import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final locationListControllerProvider =
    Provider.autoDispose<ScrollController>((ref) => ScrollController());

final modifyIngredientsListScrollControllerProvider =
    Provider.autoDispose<ScrollController>((ref) => ScrollController());
