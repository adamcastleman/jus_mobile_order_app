import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Services/auth_services.dart';
import 'package:jus_mobile_order_app/Sheets/account_info_sheet.dart';
import 'package:jus_mobile_order_app/Sheets/favorites_sheet.dart';
import 'package:jus_mobile_order_app/Sheets/offers_sheet.dart';
import 'package:jus_mobile_order_app/Sheets/payments_settings_sheet.dart';
import 'package:jus_mobile_order_app/Views/signed_out_profile_page.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/member_icon.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/profile_page_tile.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    return currentUser.when(
      error: (e, _) => ShowError(error: e.toString()),
      loading: () => const Loading(),
      data: (user) => user.uid == null
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
                    const ProfilePageTile(
                      icon: Icon(CupertinoIcons.person),
                      title: 'Account Info',
                      page: AccountInfoSheet(),
                    ),
                    const ProfilePageTile(
                      icon: Icon(CupertinoIcons.creditcard),
                      title: 'Payments',
                      page: PaymentSettingsSheet(),
                    ),
                    !user.isActiveMember!
                        ? const SizedBox()
                        : const ProfilePageTile(
                            icon: MemberIcon(iconSize: 16),
                            title: 'Membership',
                            page: PaymentSettingsSheet(),
                          ),
                    const ProfilePageTile(
                      icon: Icon(CupertinoIcons.gift),
                      title: 'Points',
                      page: PaymentSettingsSheet(),
                    ),
                    const ProfilePageTile(
                      icon: Icon(FontAwesomeIcons.bottleDroplet),
                      title: 'Orders',
                      page: PaymentSettingsSheet(),
                    ),
                    const ProfilePageTile(
                      icon: Icon(CupertinoIcons.heart),
                      title: 'Favorites',
                      page: FavoritesSheet(),
                    ),
                    const ProfilePageTile(
                      icon: Icon(CupertinoIcons.tag),
                      title: 'Offers',
                      page: OffersSheet(),
                      isLastTile: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 22.0, horizontal: 22.0),
                      child: InkWell(
                        onTap: () {
                          ref.invalidate(savedCreditCardsProvider);
                          ref.invalidate(selectedCreditCardProvider);
                          ref.invalidate(guestCreditCardNonceProvider);
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
                      child: Text('v2023.2.17'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
