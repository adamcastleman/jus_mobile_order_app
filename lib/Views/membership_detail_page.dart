import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/membership_details_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Services/user_services.dart';
import 'package:jus_mobile_order_app/Sheets/membership_details_sheet_active.dart';
import 'package:jus_mobile_order_app/Sheets/membership_details_sheet_inactive.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';

class MembershipDetailPage extends ConsumerWidget {
  const MembershipDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final backgroundColor = ref.watch(backgroundColorProvider);
    return MembershipDetailsProviderWidget(
      builder: (membership) => Container(
        color: backgroundColor,
        child: ListView(
          primary: false,
          children: [
            Spacing.vertical(MediaQuery.of(context).size.height * 0.05),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  user.uid == null
                      ? const SizedBox()
                      : Row(
                          children: [
                            Text(user.isActiveMember! ? 'Active' : 'Inactive'),
                            Switch(
                              activeColor: Colors.black,
                              value: user.isActiveMember!,
                              onChanged: (value) {
                                UserServices(uid: user.uid)
                                    .updateMembership(user.isActiveMember!);
                              },
                            ),
                          ],
                        ),
                  Align(
                    alignment: Alignment.topRight,
                    child: JusCloseButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            user.uid == null || !user.isActiveMember!
                ? const InactiveMembershipDetailsSheet()
                : const ActiveMembershipDetailsSheet()
          ],
        ),
      ),
    );
  }
}
