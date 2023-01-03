import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/favorite_button.dart';

class CleanseDetailPage extends ConsumerWidget {
  const CleanseDetailPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(themeColorProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const JusCloseButton(),
        actions: const [
          FavoriteButton(),
        ],
      ),
      body: const Center(
        child: Text('Cleanse Detail Page'),
      ),
    );
  }
}
