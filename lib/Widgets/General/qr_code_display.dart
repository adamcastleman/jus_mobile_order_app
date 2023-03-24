import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/scan_providers.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeDisplay extends ConsumerWidget {
  const QrCodeDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryIndex = ref.watch(scanCategoryProvider);

    return UserProviderWidget(
      builder: (user) => QrImage(
        data: categoryIndex == 0 ? ref.watch(encryptedQrProvider) : user.uid!,
        version: QrVersions.auto,
        size: 200.0,
      ),
    );
  }
}
