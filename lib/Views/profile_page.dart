import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Payments/payments_sheet.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Services/auth_services.dart';
import 'package:jus_mobile_order_app/Sheets/account_info_sheet.dart';
import 'package:jus_mobile_order_app/Sheets/favorites_sheet.dart';
import 'package:jus_mobile_order_app/Sheets/offers_sheet.dart';
import 'package:jus_mobile_order_app/Sheets/transaction_history_sheet.dart';
import 'package:jus_mobile_order_app/Views/membership_detail_page.dart';
import 'package:jus_mobile_order_app/Views/signed_out_profile_page.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/member_icon.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/profile_page_tile.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UserProviderWidget(
      builder: (user) => user.uid == null
          ? const SignedOutProfilePage()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 22.0, horizontal: 8.0),
                      child: Text(
                        '${user.firstName} ${user.lastName}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    ProfilePageTile(
                      icon: const Icon(CupertinoIcons.person),
                      title: 'Account Info',
                      onTap: () {
                        ref.read(emailProvider.notifier).state =
                            user.email ?? '';
                        ref.read(phoneProvider.notifier).state =
                            user.phone ?? '';
                        ref.read(firstNameProvider.notifier).state =
                            user.firstName ?? '';
                        ref.read(lastNameProvider.notifier).state =
                            user.lastName ?? '';
                        ModalBottomSheet().fullScreen(
                            context: context,
                            builder: (context) => const AccountInfoSheet());
                      },
                    ),
                    ProfilePageTile(
                      icon: const Icon(CupertinoIcons.creditcard),
                      title: 'Payment Methods',
                      onTap: () {
                        ref.read(firstNameProvider.notifier).state =
                            user.firstName!;
                        ref.read(lastNameProvider.notifier).state =
                            user.lastName!;
                        ref.read(phoneProvider.notifier).state = user.phone!;
                        ref.read(pageTypeProvider.notifier).state =
                            PageType.editPaymentMethod;
                        ModalBottomSheet().fullScreen(
                          context: context,
                          builder: (context) => const PaymentSettingsSheet(),
                        );
                      },
                    ),
                    ProfilePageTile(
                      icon: const MemberIcon(iconSize: 16),
                      title: 'Membership',
                      onTap: () {
                        ModalBottomSheet().fullScreen(
                            context: context,
                            builder: (context) => const MembershipDetailPage());
                      },
                    ),
                    ProfilePageTile(
                        icon: const Icon(CupertinoIcons.arrow_2_squarepath),
                        title: 'Transaction History',
                        onTap: () {
                          ModalBottomSheet().fullScreen(
                              context: context,
                              builder: (context) =>
                                  const TransactionHistorySheet());
                        }),
                    ProfilePageTile(
                      icon: const Icon(CupertinoIcons.heart),
                      title: 'Favorites',
                      onTap: () {
                        ref.read(isFavoritesSheetProvider.notifier).state =
                            true;
                        ModalBottomSheet().fullScreen(
                          context: context,
                          builder: (context) => const FavoritesSheet(),
                        );
                      },
                    ),
                    ProfilePageTile(
                      icon: const Icon(CupertinoIcons.tag),
                      title: 'Offers',
                      onTap: () {
                        ModalBottomSheet().fullScreen(
                          context: context,
                          builder: (context) => const OffersSheet(),
                        );
                      },
                      isLastTile: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 22.0, horizontal: 22.0),
                      child: InkWell(
                        onTap: () {
                          ref.invalidate(selectedPaymentMethodProvider);
                          ref.invalidate(firstNameProvider);
                          ref.invalidate(lastNameProvider);
                          ref.invalidate(phoneProvider);
                          AuthServices().signOut();
                        },
                        child: const Text('Sign Out'),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.0),
                      child: Text('v2023.3.28'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
