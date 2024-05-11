import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/future_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/error_icon.dart';
import 'package:tuple/tuple.dart';

class CardDetailsFromSquareCardIdProviderWidget extends ConsumerWidget {
  final String cardId;
  final Widget Function(PaymentsModel card) builder;
  final dynamic loading;
  final dynamic error;
  const CardDetailsFromSquareCardIdProviderWidget(
      {required this.cardId,
      required this.builder,
      this.loading,
      this.error,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    final cardData = ref
        .watch(cardDetailsFromSquareCardIdProvider(Tuple2(user.uid, cardId)));
    return cardData.when(
      error: (e, _) => error ?? const ErrorIcon(),
      loading: () => loading ?? const Loading(),
      data: (card) => builder(card),
    );
  }
}
