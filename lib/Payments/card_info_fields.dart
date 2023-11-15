import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';

class CardInfoFields extends ConsumerWidget {
  final PaymentsModel card;
  const CardInfoFields({required this.card, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Card Number',
            style: TextStyle(fontSize: 16),
          ),
          card.isWallet
              ? TextFormField(
                  initialValue: '${card.gan}',
                  readOnly: true,
                  decoration: const InputDecoration(
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                )
              : TextFormField(
                  initialValue: '**** **** **** **** ${card.lastFourDigits}',
                  readOnly: true,
                  decoration: const InputDecoration(
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
          Spacing().vertical(10),
          card.isWallet
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Balance',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextFormField(
                      readOnly: true,
                      initialValue:
                          '\$${(card.balance! / 100).toStringAsFixed(2)}',
                      decoration: const InputDecoration(
                        enabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
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
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacing().horizontal(10),
                    Expanded(
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
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          Spacing().vertical(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nickname',
                style: TextStyle(fontSize: 16),
              ),
              TextFormField(
                initialValue: card.cardNickname,
                textCapitalization: TextCapitalization.words,
                onChanged: (value) {
                  ref.read(cardNicknameProvider.notifier).state = value;
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
