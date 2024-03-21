import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/modal_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/scan.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Navigation/web_naviagation_drawer.dart';
import 'package:jus_mobile_order_app/Providers/controller_providers.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Sheets/membership_account_page.dart';
import 'package:jus_mobile_order_app/Sheets/us_states_picker.dart';
import 'package:jus_mobile_order_app/Views/checkout_page_membership.dart';
import 'package:jus_mobile_order_app/Views/forgot_password_page.dart';
import 'package:jus_mobile_order_app/Views/login_page.dart';
import 'package:jus_mobile_order_app/Views/membership_information_page.dart';
import 'package:jus_mobile_order_app/Views/membership_terms_of_service_page.dart';
import 'package:jus_mobile_order_app/Views/points_information_page.dart';
import 'package:jus_mobile_order_app/Views/profile_page.dart';
import 'package:jus_mobile_order_app/Views/register_page.dart';
import 'package:jus_mobile_order_app/Views/review_order_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/constants.dart';

class NavigationHelpers {
  static popEndDrawer(BuildContext context) {
    AppConstants.scaffoldKey.currentState!.isEndDrawerOpen
        ? Navigator.pop(context)
        : null;
  }

  static showDialogWeb(BuildContext context, Widget page,
      {double? height, double? width}) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
            height: height,
            width: width ?? AppConstants.dialogWidth,
            child: page),
      ),
    );
  }

  static navigateToFullScreenSheet(BuildContext context, Widget page) {
    return ModalBottomSheet().fullScreen(
      context: context,
      builder: (context) => page,
    );
  }

  static navigateToPartScreenSheet(BuildContext context, Widget page) {
    return ModalBottomSheet().partScreen(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      builder: (context) => page,
    );
  }

  static navigateToFullScreenSheetOrEndDrawer(BuildContext context,
      WidgetRef ref, GlobalKey<ScaffoldState> scaffoldKey, Widget page) {
    if (PlatformUtils.isWeb()) {
      ref.read(drawerPageProvider.notifier).state = page;
      scaffoldKey.currentState?.openEndDrawer();
    } else {
      navigateToFullScreenSheet(
        context,
        page,
      );
    }
  }

  static navigateToPartScreenSheetOrEndDrawer(BuildContext context,
      WidgetRef ref, GlobalKey<ScaffoldState> scaffoldKey, Widget page) {
    if (PlatformUtils.isWeb()) {
      ref.read(drawerPageProvider.notifier).state = page;
      scaffoldKey.currentState?.openEndDrawer();
    } else {
      navigateToPartScreenSheet(
        context,
        page,
      );
    }
  }

  static navigateToFullScreenSheetOrDialog(BuildContext context, Widget page) {
    if (PlatformUtils.isWeb()) {
      showDialogWeb(
        context,
        page,
      );
    } else {
      navigateToFullScreenSheet(
        context,
        page,
      );
    }
  }

  static navigateToPartScreenSheetOrDialog(BuildContext context, Widget page) {
    if (PlatformUtils.isWeb()) {
      showDialogWeb(
        context,
        page,
      );
    } else {
      navigateToPartScreenSheet(
        context,
        page,
      );
    }
  }

  static navigateToHamburgerMenu(
      WidgetRef ref, UserModel user, GlobalKey<ScaffoldState> scaffoldKey) {
    ref.read(drawerPageProvider.notifier).state =
        WebNavigationDrawer(user: user);
    scaffoldKey.currentState?.openEndDrawer();
  }

  static navigateToHomePageWeb(WidgetRef ref) {
    ref.read(webNavigationProvider.notifier).state = AppConstants.homePage;
    ref
        .read(webNavigationPageControllerProvider)
        .jumpToPage(AppConstants.homePage);
  }

  static navigateToCleansePageWeb(WidgetRef ref) {
    ref.read(webNavigationProvider.notifier).state =
        AppConstants.cleansePageWeb;
    ref
        .read(webNavigationPageControllerProvider)
        .jumpToPage(AppConstants.cleansePageWeb);
  }

  static handleMembershipNavigation(
      BuildContext context, WidgetRef ref, UserModel user,
      {showCloseButton = false}) {
    if (user.uid == null ||
        user.subscriptionStatus == SubscriptionStatus.none) {
      navigateToMembershipInformationPage(context, ref,
          showCloseButton: showCloseButton);
    } else {
      navigateToFullScreenSheetOrEndDrawer(
        context,
        ref,
        AppConstants.scaffoldKey,
        MembershipAccountPage(scaffoldKey: AppConstants.scaffoldKey),
      );
    }
  }

  static navigateToMembershipInformationPage(
      BuildContext context, WidgetRef ref,
      {bool showCloseButton = false}) {
    if (PlatformUtils.isWeb()) {
      ref.read(webNavigationProvider.notifier).state =
          AppConstants.membershipPageWeb;
      ref
          .read(webNavigationPageControllerProvider)
          .jumpToPage(AppConstants.membershipPageWeb);
      popEndDrawer(context);
    } else {
      navigateToFullScreenSheet(
        context,
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0.0,
              scrolledUnderElevation: 0.0,
              backgroundColor: Colors.transparent,
              leading: const SizedBox(),
              actions: const [
                JusCloseButton(
                  color: Colors.grey,
                ),
              ],
            ),
            body: const MembershipInformationPage(),
          ),
        ),
      );
    }
  }

  static navigateToMembershipCheckoutPage(
      WidgetRef ref, GlobalKey<ScaffoldState> scaffoldKey) {
    ref.read(drawerPageProvider.notifier).state =
        const MembershipCheckoutPage();
    scaffoldKey.currentState?.openEndDrawer();
  }

  static navigateToScanPage(BuildContext context, WidgetRef ref) {
    ScanHelpers.handleScanPageInitializers(ref);
    if (PlatformUtils.isWeb()) {
      ref.read(webNavigationProvider.notifier).state = AppConstants.scanPageWeb;
      ref
          .read(webNavigationPageControllerProvider)
          .jumpToPage(AppConstants.scanPageWeb);
    } else {
      final pageController = ref.watch(bottomNavigationPageControllerProvider);
      ref.read(bottomNavigationProvider.notifier).state =
          AppConstants.scanPageMobile;
      pageController.jumpToPage(AppConstants.scanPageMobile);
    }
  }

  static navigateToPointsInformationPage(
    BuildContext context,
    WidgetRef ref,
  ) {
    if (PlatformUtils.isWeb()) {
      ref.read(webNavigationProvider.notifier).state =
          AppConstants.pointsInformationPageWeb;
      ref
          .read(webNavigationPageControllerProvider)
          .jumpToPage(AppConstants.pointsInformationPageWeb);
      ref.invalidate(isCheckOutPageProvider);
      popEndDrawer(context);

      return;
    }
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    if (user.uid == null) {
      final pageController = ref.watch(bottomNavigationPageControllerProvider);
      ref.read(bottomNavigationProvider.notifier).state =
          AppConstants.scanPageMobile;
      pageController.jumpToPage(AppConstants.scanPageMobile);
    } else {
      navigateToFullScreenSheet(
        context,
        Container(
          padding: const EdgeInsets.only(top: 40.0),
          height: double.infinity,
          child: const PointsInformationPage(
            showCloseButton: true,
          ),
        ),
      );
    }
  }

  void navigateToMenuPage(BuildContext context, WidgetRef ref) {
    bool isMobilePlatform = PlatformUtils.isIOS() || PlatformUtils.isAndroid();

    if (isMobilePlatform && ref.read(selectedLocationProvider).uid.isEmpty) {
      navigateToLocationPage(context, ref);
      _navigateToMenuPageMobile(ref);
      return; // Return early to prevent further navigation actions.
    }
    if (isMobilePlatform) {
      _navigateToMenuPageMobile(ref);
    } else {
      _navigateToMenuPageWeb(context, ref);
    }
  }

  static void _navigateToMenuPageWeb(BuildContext context, WidgetRef ref) {
    ref.read(webNavigationProvider.notifier).state = AppConstants.menuPageWeb;
    ref
        .read(webNavigationPageControllerProvider)
        .jumpToPage(AppConstants.menuPageWeb);
    popEndDrawer(context);
  }

  static void _navigateToMenuPageMobile(WidgetRef ref) {
    final pageController = ref.watch(bottomNavigationPageControllerProvider);
    ref.read(bottomNavigationProvider.notifier).state =
        AppConstants.menuPageMobile;
    pageController.jumpToPage(AppConstants.menuPageMobile);
  }

  static navigateToBagPage(
      WidgetRef ref, GlobalKey<ScaffoldState> scaffoldKey) {
    ref.read(drawerPageProvider.notifier).state = const ReviewOrderPage();
    scaffoldKey.currentState?.openEndDrawer();
  }

  static navigateToProfilePage(
      WidgetRef ref, GlobalKey<ScaffoldState> scaffoldKey) {
    ref.read(drawerPageProvider.notifier).state = const ProfilePage();
    scaffoldKey.currentState?.openEndDrawer();
  }

  static navigateToRegisterPage(BuildContext context) {
    if (PlatformUtils.isWeb()) {
      NavigationHelpers.showDialogWeb(
        context,
        const RegisterPage(),
      );
    } else {
      NavigationHelpers.navigateToFullScreenSheet(
        context,
        const Padding(
          padding: EdgeInsets.only(top: 28.0),
          child: SafeArea(
            child: RegisterPage(),
          ),
        ),
      );
    }
  }

  static navigateToLoginPage(BuildContext context) {
    if (PlatformUtils.isWeb()) {
      NavigationHelpers.showDialogWeb(
        context,
        height: AppConstants.loginDialogHeight,
        const LoginPage(),
      );
    } else {
      NavigationHelpers.navigateToFullScreenSheet(
        context,
        const SafeArea(
          child: LoginPage(),
        ),
      );
    }
  }

  static navigateToForgotPasswordPage(BuildContext context) {
    if (PlatformUtils.isWeb()) {
      NavigationHelpers.showDialogWeb(
        context,
        const ForgotPasswordPage(),
      );
    } else {
      ModalBottomSheet().partScreen(
        isDismissible: true,
        isScrollControlled: true,
        enableDrag: true,
        context: context,
        builder: (context) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: const ForgotPasswordPage(),
        ),
      );
    }
  }

  static authNavigation(BuildContext context) {
    if (PlatformUtils.isIOS() || PlatformUtils.isAndroid()) {
      navigateToRegisterPage(context);
    } else {
      navigateToLoginPage(context);
    }
  }

  static navigateToUSStatePicker(
      BuildContext context, TextEditingController controller) {
    if (PlatformUtils.isWeb()) {
      showDialogWeb(
        context,
        USStatesPicker(controller: controller),
      );
    } else {
      navigateToPartScreenSheet(
        context,
        USStatesPicker(controller: controller),
      );
    }
  }

  void navigateToLocationPage(BuildContext context, WidgetRef ref) async {
    ref.read(locationLoadingProvider.notifier).state = true;

    LocationHelper().handleLocationPermissionsWeb().then(
      (position) {
        _processLocation(position, context, ref);
        ref.read(locationLoadingProvider.notifier).state = false;
      },
    );
  }

  void _processLocation(
      Position? position, BuildContext context, WidgetRef ref) {
    if (position == null) {
      if (PlatformUtils.isIOS() || PlatformUtils.isAndroid()) {
        LocationHelper().chooseLocation(context, ref);
      } else {
        _navigateToLocationPageWeb(context, ref);
      }
      return;
    } else {
      ref.read(currentLocationLatLongProvider.notifier).state =
          LatLng(position.latitude, position.longitude);

      if (PlatformUtils.isIOS() || PlatformUtils.isAndroid()) {
        LocationHelper().chooseLocation(context, ref);
      } else {
        _navigateToLocationPageWeb(context, ref);
      }
    }
  }

  void _navigateToLocationPageWeb(BuildContext context, WidgetRef ref) {
    ref.read(webNavigationProvider.notifier).state =
        AppConstants.locationPageWeb;
    ref
        .read(webNavigationPageControllerProvider)
        .jumpToPage(AppConstants.locationPageWeb);
    _handleLocationNavigationPagePopping(context, ref);
  }

  _handleLocationNavigationPagePopping(BuildContext context, WidgetRef ref) {
    ref.read(isInHamburgerMenuProvider) == true ? Navigator.pop(context) : null;
    NavigationHelpers.popEndDrawer(context);
    ref.read(isInHamburgerMenuProvider.notifier).state = false;
  }

  static handleMembershipNavigationOnWeb(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        NavigationHelpers.navigateToMembershipInformationPage(
          context,
          ref,
          showCloseButton:
              PlatformUtils.isIOS() || PlatformUtils.isAndroid() ? true : false,
        );
        ref.invalidate(isCheckOutPageProvider);
      },
    );
  }

  static navigateToMembershipTermsOfService(BuildContext context) {
    NavigationHelpers.showDialogWeb(
      context,
      width: 600,
      const MembershipTermsOfServicePage(),
    );
  }
}