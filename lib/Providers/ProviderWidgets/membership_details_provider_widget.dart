import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/membership_details_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/error_icon.dart';

class MembershipDetailsProviderWidget extends ConsumerWidget {
  final Widget Function(MembershipDetailsModel membership) builder;
  final dynamic loading;
  final dynamic error;
  const MembershipDetailsProviderWidget(
      {required this.builder, this.loading, this.error, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membership = ref.watch(membershipDetailsProvider);
    return membership.when(
        error: (e, _) => error ?? const ErrorIcon(),
        loading: () => loading ?? const Loading(),
        data: (membership) {
          return builder(membership);
        });
  }
}
