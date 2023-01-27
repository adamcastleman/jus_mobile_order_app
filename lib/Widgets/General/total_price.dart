import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Views/membership_detail_page.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';

import '../../Providers/stream_providers.dart';

class TotalPrice extends ConsumerWidget {
  const TotalPrice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    TextStyle lineThroughStyle = const TextStyle(
        fontSize: 14,
        decoration: TextDecoration.lineThrough,
        color: Colors.grey);
    TextStyle normalStyle = const TextStyle(fontSize: 17);
    return currentUser.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (user) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subtotal',
                    style: TextStyle(fontSize: 16),
                  ),
                  user.uid == null || !user.isActiveMember!
                      ? Text(
                          '\$${Pricing(ref: ref).orderSubtotal(ref).toStringAsFixed(2)}',
                          style: normalStyle,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${Pricing(ref: ref).orderSubtotal(ref).toStringAsFixed(2)}',
                              style: lineThroughStyle,
                            ),
                            Spacing().horizontal(10),
                            Text(
                              '\$${Pricing(ref: ref).orderSubtotalMember(ref).toStringAsFixed(2)}',
                              style: normalStyle,
                            ),
                          ],
                        ),
                ],
              ),
              Spacing().vertical(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Taxes',
                    style: TextStyle(fontSize: 16),
                  ),
                  user.uid == null || !user.isActiveMember!
                      ? Text(
                          '\$${Pricing(ref: ref).orderTax(ref).toStringAsFixed(2)}',
                          style: normalStyle,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                                '\$${Pricing(ref: ref).orderTax(ref).toStringAsFixed(2)}',
                                style: lineThroughStyle),
                            Spacing().horizontal(5),
                            Text(
                              '\$${Pricing(ref: ref).orderTaxMember(ref).toStringAsFixed(2)}',
                              style: normalStyle,
                            )
                          ],
                        ),
                ],
              ),
              Spacing().vertical(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  user.uid == null || !user.isActiveMember!
                      ? Text(
                          '\$${Pricing(ref: ref).orderTotal(ref).toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${Pricing(ref: ref).orderTotal(ref).toStringAsFixed(2)}',
                              style: lineThroughStyle,
                            ),
                            Spacing().horizontal(5),
                            Text(
                              '\$${Pricing(ref: ref).orderTotalMember(ref).toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                ],
              ),
              Spacing().vertical(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'You ${user.uid == null || !user.isActiveMember! ? 'could have ' : ''}saved \$${Pricing(ref: ref).totalSavings(ref).toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  user.uid == null || !user.isActiveMember!
                      ? Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: InkWell(
                            onTap: () {
                              ModalBottomSheet().fullScreen(
                                  context: context,
                                  builder: (context) =>
                                      const MembershipDetailPage());
                            },
                            child: const Icon(
                              CupertinoIcons.info,
                              size: 18,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
