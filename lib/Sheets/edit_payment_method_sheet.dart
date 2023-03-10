import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outline_button_medium.dart';

class EditPaymentMethodSheet extends ConsumerWidget {
  final PaymentsModel card;
  const EditPaymentMethodSheet({required this.card, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    return currentUser.when(
      error: (e, _) => ShowError(error: e.toString()),
      loading: () => const Loading(),
      data: (user) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Edit Card',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Card Number',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextFormField(
                        initialValue:
                            '**** **** **** **** ${card.lastFourDigits}',
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Exp.',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextFormField(
                            readOnly: true,
                            initialValue:
                                '${card.expirationMonth}/${card.expirationYear}',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CVV',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextFormField(
                            readOnly: true,
                            initialValue: '***',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Spacing().vertical(20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nickname',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextFormField(
                    initialValue: card.cardNickname,
                    onChanged: (value) {
                      ref.read(cardNicknameProvider.notifier).state = value;
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Nickname must not be empty' : null,
                  ),
                  card.defaultPayment
                      ? Spacing().vertical(40)
                      : Spacing().vertical(20),
                  card.defaultPayment
                      ? const SizedBox()
                      : CheckboxListTile(
                          title: const AutoSizeText(
                            'Set as default payment method',
                            maxLines: 1,
                          ),
                          activeColor: Colors.black,
                          value: ref.watch(defaultPaymentSelectedProvider),
                          onChanged: (value) => ref
                              .read(defaultPaymentSelectedProvider.notifier)
                              .state = value!),
                  card.defaultPayment
                      ? const SizedBox()
                      : Spacing().vertical(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MediumOutlineButton(
                          buttonText: 'Delete Card', onPressed: () {}),
                      MediumElevatedButton(
                        buttonText: 'Save',
                        onPressed: () {
                          ref.watch(cardNicknameProvider).isEmpty
                              ? ref.read(cardNicknameProvider.notifier).state =
                                  card.cardNickname
                              : ref.read(cardNicknameProvider.notifier).state =
                                  ref.read(cardNicknameProvider);
                          PaymentsServices(ref: ref, uid: user.uid)
                              .updateCardNickname(card.uid);

                          Navigator.pop(context);
                          ref.read(defaultPaymentSelectedProvider) == true
                              ? PaymentsServices(ref: ref, uid: user.uid)
                                  .updateDefaultPayment(card.uid)
                              : null;
                        },
                      ),
                    ],
                  ),
                  Spacing().vertical(60),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
