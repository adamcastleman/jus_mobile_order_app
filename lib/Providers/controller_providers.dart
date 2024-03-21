import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final locationListControllerProvider =
    Provider.autoDispose<ScrollController>((ref) => ScrollController());

final modifyIngredientsListScrollControllerProvider =
    Provider.autoDispose<ScrollController>((ref) => ScrollController());

final bottomNavigationPageControllerProvider =
    Provider.autoDispose<PageController>((ref) => PageController());

final webNavigationPageControllerProvider =
    Provider.autoDispose<PageController>((ref) => PageController());

final googleMapControllerProvider =
    StateProvider.autoDispose<GoogleMapController?>((ref) => null);
