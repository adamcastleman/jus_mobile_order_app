import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/scan_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeDisplay extends ConsumerWidget {
  const QrCodeDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final categoryIndex = ref.watch(scanCategoryProvider);

    return QrImageView(
      data: categoryIndex == 0 ? ref.watch(encryptedQrProvider) : user.uid!,
      version: QrVersions.auto,
      size: 200.0,
    );
  }
}
