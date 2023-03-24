import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class UserProviderWidget extends ConsumerWidget {
  final Widget Function(UserModel user) builder;
  final dynamic loading;
  final dynamic error;
  const UserProviderWidget(
      {required this.builder, this.loading, this.error, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    return currentUser.when(
      error: (e, _) =>
          error ??
          ShowError(
            error: e.toString(),
          ),
      loading: () => loading ?? const Loading(),
      data: (user) => builder(user),
    );
  }
}
