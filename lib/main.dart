import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/scan.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/breaking_version_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/favorites_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/ingredients_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/location_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/points_details_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/products_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/lifecyle_providers.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services_square.dart';
import 'package:jus_mobile_order_app/Views/force_app_update_page.dart';
import 'package:jus_mobile_order_app/Views/home_scaffold_mobile_app.dart';
import 'package:jus_mobile_order_app/Views/home_scaffold_web_desktop.dart';
import 'package:jus_mobile_order_app/firebase_options.dart';
import 'package:jus_mobile_order_app/theme_data.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (PlatformUtils.isIOS() || PlatformUtils.isAndroid()) {
    await SquarePaymentServices().setApplicationID();
    await [
      Permission.location,
      Permission.notification,
      Permission.appTrackingTransparency,
    ].request();
  }

  setUrlStrategy(null);

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('Montserrat/OFL.txt');
    yield LicenseEntryWithLineBreaks(['Montserrat'], license);
  });
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Transparent status bar
    statusBarIconBrightness: Brightness.dark,
    // Dark text for status bar
  ));

  setPreferredOrientations().then(
    (_) => runApp(
      const ProviderScope(
        child: JusMobileOrder(),
      ),
    ),
  );
}

class JusMobileOrder extends ConsumerWidget {
  const JusMobileOrder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(loadingProvider);
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    final ThemeData theme = ThemeManager().theme;
    ref.watch(selectedPaymentMethodProvider);
    ref.watch(appLifecycleProvider);
    final notifier = ref.read(appLifecycleProvider.notifier);
    notifier.setOnAppResumeCallback(() {
      // Define what should happen when the app resumes and is on the scan page
      ScanHelpers.handleScanAndPayPageInitializers(ref);
    });

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: AbsorbPointer(
        absorbing: loading,
        child: MaterialApp(
          navigatorKey: navigatorKey,
          color: Colors.white,
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: BreakingVersionProviderWidget(
            builder: (isBreakingChange) {
              if ((PlatformUtils.isIOS() || PlatformUtils.isAndroid()) &&
                  isBreakingChange) {
                return const ForceAppUpdatePage();
              }
              return LocationsProviderWidget(
                builder: (locations) => IngredientsProviderWidget(
                  builder: (ingredients) => FavoritesProviderWidget(
                    builder: (favorites) => PointsDetailsProviderWidget(
                      builder: (points) => ProductsProviderWidget(
                        builder: (products) {
                          // Update state with locations, products, and ingredients.
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ref.read(allLocationsProvider.notifier).state =
                                locations;
                            ref.read(allProductsProvider.notifier).state =
                                products;
                            ref.read(allIngredientsProvider.notifier).state =
                                ingredients;
                            ref.read(pointsInformationProvider.notifier).state =
                                points;
                            if (user.uid != null) {
                              ref.read(allFavoritesProvider.notifier).state =
                                  favorites;
                            }
                          });

                          if (PlatformUtils.isIOS() ||
                              PlatformUtils.isAndroid()) {
                            return const HomeScaffoldMobileApp();
                          } else {
                            return const HomeScaffoldWeb();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

Future<void> backgroundHandler(RemoteMessage message) async {
  return Future.value();
}

Future<void> setPreferredOrientations() async {
  final screenWidth = WidgetsBinding
          .instance.platformDispatcher.views.first.physicalSize.width /
      WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

  List<DeviceOrientation> orientations = screenWidth < 700
      ? [DeviceOrientation.portraitUp]
      : [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight];

  SystemChrome.setPreferredOrientations(orientations);
}
