import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
//import 'package:jus_mobile_order_app/providers.dart';

class JusAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const JusAppBar({super.key});

  static final _appBar = AppBar();

  @override
  Size get preferredSize => _appBar.preferredSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
//    final auth = ref.watch(authProvider);
    return AppBar(
      toolbarHeight: 120,
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: determineActionsBasedOnLogin(),
          ),
        ),
      ],
    );
  }

  dayPartGreeting() {
    final now = DateTime.now();
    if (now.hour >= 4 && now.hour < 12) {
      return 'Good morning';
    } else if (now.hour >= 12 && now.hour < 16) {
      return 'Good afternoon';
    } else if (now.hour >= 16 && now.hour < 20) {
      return 'Good evening';
    } else if (now.hour >= 20 && now.hour <= 24 ||
        now.hour >= 0 && now.hour < 4) {
      return 'Good night';
    } else {
      return 'Hello';
    }
  }

  determineNameForGreeting(final auth) {
    if (auth.value == null) {
      return 'Friend';
    } else {
      return 'Adam';
    }
  }

  determineActionsBasedOnLogin() {
    return Row(
      children: [
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.user),
          onPressed: () {},
        )
      ],
    );
  }
}
