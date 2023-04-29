import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/member_stats_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/membership_providers.dart';
import 'package:jus_mobile_order_app/Services/user_services.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';

class CancelMembershipConfirmationSheet extends ConsumerWidget {
  const CancelMembershipConfirmationSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UserProviderWidget(
      builder: (user) => MemberStatsProviderWidget(
        builder: (stats) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Wrap(
            children: [
              const SheetNotch(),
              Spacing().vertical(35),
              const Text(
                'Cancel Membership?',
                style: TextStyle(fontSize: 23),
              ),
              Spacing().vertical(
                60,
              ),
              Text(
                'You\'ve saved \$${(stats.totalSaved! / 100).toStringAsFixed(2)}, and earned an extra ${stats.bonusPoints} bonus points since you\'ve joined.',
                style: const TextStyle(fontSize: 16),
              ),
              Spacing().vertical(
                60,
              ),
              JusDivider().thin(),
              Column(
                children: [
                  ListTile(
                    title: const Text('No, I\'d like to remain a member'),
                    trailing: ref.watch(cancelMembershipLoadingProvider) == true
                        ? const SizedBox(
                            height: 50,
                            width: 50,
                            child: Loading(),
                          )
                        : const SizedBox(),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  JusDivider().thin(),
                  ListTile(
                    title: const Text(
                      'Yes, I\'d like to cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      ref.read(cancelMembershipLoadingProvider.notifier).state =
                          true;
                      updateMembershipStatus(user);
                      Navigator.pop(context);
                      ref.invalidate(cancelMembershipLoadingProvider);
                    },
                  ),
                ],
              ),
              Spacing().vertical(
                160,
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateMembershipStatus(UserModel user) async {
    await UserServices(uid: user.uid).updateMembership(user.isActiveMember!);
  }
}
