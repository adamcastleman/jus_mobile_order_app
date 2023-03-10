import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class ProfilePageTile extends ConsumerWidget {
  final Widget icon;
  final String title;
  final Widget page;
  final bool? isLastTile;
  const ProfilePageTile(
      {required this.icon,
      required this.title,
      required this.page,
      this.isLastTile,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    return currentUser.when(
      error: (e, _) => ShowError(error: e.toString()),
      loading: () => const Loading(),
      data: (user) => Column(
        children: [
          ListTile(
            leading: icon,
            title: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              ref.read(firstNameProvider.notifier).state = user.firstName!;
              ref.read(lastNameProvider.notifier).state = user.lastName!;
              ref.read(phoneProvider.notifier).state = user.phone!;
              ModalBottomSheet()
                  .fullScreen(context: context, builder: (context) => page);
            },
          ),
          isLastTile == null || isLastTile != true
              ? JusDivider().thin()
              : JusDivider().thick(),
        ],
      ),
    );
  }
}
