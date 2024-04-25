import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Services/auth_services.dart';
import 'package:jus_mobile_order_app/Sheets/account_info_sheet.dart';
import 'package:jus_mobile_order_app/Sheets/favorites_sheet.dart';
import 'package:jus_mobile_order_app/Sheets/offers_sheet.dart';
import 'package:jus_mobile_order_app/Sheets/payments_sheet.dart';
import 'package:jus_mobile_order_app/Sheets/points_activity_sheet.dart';
import 'package:jus_mobile_order_app/Sheets/transaction_history_sheet.dart';
import 'package:jus_mobile_order_app/Views/signed_out_profile_page.dart';
import 'package:jus_mobile_order_app/Widgets/General/version_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/member_icon.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/profile_page_tile.dart';
import 'package:jus_mobile_order_app/constants.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = AppConstants.scaffoldKey;
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    return user.uid == null
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
                    onTap: () => _handleAccountInfoOnTap(
                        context, ref, user, scaffoldKey),
                  ),
                  ProfilePageTile(
                    icon: const Icon(CupertinoIcons.creditcard),
                    title: 'Payment Methods',
                    onTap: () => _handlePaymentMethodsOnTap(
                        context, ref, user, scaffoldKey),
                  ),
                  ProfilePageTile(
                    icon: const MemberIcon(iconSize: 16),
                    title: 'Membership',
                    onTap: () => NavigationHelpers.handleMembershipNavigation(
                      context,
                      ref,
                      user,
                    ),
                  ),
                  ProfilePageTile(
                    icon: const Icon(CupertinoIcons.arrow_2_squarepath),
                    title: 'Transaction History',
                    onTap: () => _handleTransactionHistoryOnTap(
                        context, ref, scaffoldKey),
                  ),
                  ProfilePageTile(
                    icon: const Icon(CupertinoIcons.gift_alt_fill),
                    title: 'Points Activity',
                    onTap: () =>
                        _handlePointsActivityOnTap(context, ref, scaffoldKey),
                  ),
                  ProfilePageTile(
                    icon: const Icon(CupertinoIcons.heart),
                    title: 'Favorites',
                    onTap: () =>
                        _handleFavoritesOnTap(context, ref, scaffoldKey),
                  ),
                  ProfilePageTile(
                    icon: const Icon(CupertinoIcons.tag),
                    title: 'Offers',
                    onTap: () => _handleOffersOnTap(context, ref, scaffoldKey),
                    isLastTile: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 22.0, horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            ref.invalidate(selectedPaymentMethodProvider);
                            ref.invalidate(firstNameProvider);
                            ref.invalidate(lastNameProvider);
                            ref.invalidate(phoneProvider);
                            ref.invalidate(bottomNavigationProvider);
                            AuthServices().signOut();
                          },
                          child: const Text('Sign Out'),
                        ),
                        const VersionDisplayWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  void _handleAccountInfoOnTap(BuildContext context, WidgetRef ref,
      UserModel user, GlobalKey<ScaffoldState> scaffoldKey) {
    ref.read(emailProvider.notifier).state = user.email ?? '';
    ref.read(phoneProvider.notifier).state = user.phone ?? '';
    ref.read(firstNameProvider.notifier).state = user.firstName ?? '';
    ref.read(lastNameProvider.notifier).state = user.lastName ?? '';
    NavigationHelpers.navigateToFullScreenSheetOrEndDrawer(
      context,
      ref,
      scaffoldKey,
      const AccountInfoSheet(),
    );
  }

  void _handlePaymentMethodsOnTap(BuildContext context, WidgetRef ref,
      UserModel user, GlobalKey<ScaffoldState> scaffoldKey) {
    ref.read(firstNameProvider.notifier).state = user.firstName!;
    ref.read(lastNameProvider.notifier).state = user.lastName!;
    ref.read(phoneProvider.notifier).state = user.phone!;
    ref.read(pageTypeProvider.notifier).state = PageType.editPaymentMethod;
    NavigationHelpers.navigateToFullScreenSheetOrEndDrawer(
      context,
      ref,
      scaffoldKey,
      const PaymentSettingsSheet(),
    );
  }

  void _handleTransactionHistoryOnTap(BuildContext context, WidgetRef ref,
      GlobalKey<ScaffoldState> scaffoldKey) {
    NavigationHelpers.navigateToFullScreenSheetOrEndDrawer(
      context,
      ref,
      scaffoldKey,
      const TransactionHistorySheet(),
    );
  }

  void _handlePointsActivityOnTap(BuildContext context, WidgetRef ref,
      GlobalKey<ScaffoldState> scaffoldKey) {
    NavigationHelpers.navigateToFullScreenSheetOrEndDrawer(
      context,
      ref,
      scaffoldKey,
      const PointsActivitySheet(),
    );
  }

  void _handleFavoritesOnTap(BuildContext context, WidgetRef ref,
      GlobalKey<ScaffoldState> scaffoldKey) {
    ref.read(isFavoritesSheetProvider.notifier).state = true;
    NavigationHelpers.navigateToFullScreenSheetOrEndDrawer(
      context,
      ref,
      scaffoldKey,
      const FavoritesSheet(),
    );
  }

  void _handleOffersOnTap(BuildContext context, WidgetRef ref,
      GlobalKey<ScaffoldState> scaffoldKey) {
    NavigationHelpers.navigateToFullScreenSheetOrEndDrawer(
      context,
      ref,
      scaffoldKey,
      const OffersSheet(),
    );
  }
}
