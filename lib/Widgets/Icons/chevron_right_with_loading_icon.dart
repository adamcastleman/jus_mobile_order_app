import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';

class ChevronRightWithLoadingIcon extends ConsumerWidget {
  final UniqueKey? tileKey;
  const ChevronRightWithLoadingIcon({this.tileKey, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = ref.watch(tileKeyProvider);
    final loading = ref.watch(squarePaymentSkdLoadingProvider);
    if (tileKey == key && loading) {
      return const Align(
        alignment: Alignment.centerRight,
        child: Loading(),
      );
    } else {
      return const Icon(
        CupertinoIcons.chevron_right,
        size: 15,
      );
    }
  }
}
