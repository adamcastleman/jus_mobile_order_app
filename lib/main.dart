import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services_square.dart';
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

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('Montserrat/OFL.txt');
    yield LicenseEntryWithLineBreaks(['Montserrat'], license);
  });
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
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
    final ThemeData theme = ThemeManager().theme;
    return AbsorbPointer(
      absorbing: loading,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: PlatformUtils.isIOS() || PlatformUtils.isAndroid()
            ? const HomeScaffoldMobileApp()
            : const HomeScaffoldWeb(),
      ),
    );
  }
}

Future<void> backgroundHandler(RemoteMessage message) async {
  return Future.value();
}

//open -a /Applications/Android\ Studio.app
