import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final bottomNavigationProvider = StateProvider<int>((ref) => 0);

final webNavigationProvider = StateProvider<int>((ref) => 0);

final drawerPageProvider = StateProvider<Widget>((ref) => Container());

final isInHamburgerMenuProvider = StateProvider<bool>((ref) => false);

final productCarouselCategoryIndexProvider = StateProvider<int>((ref) => 0);
