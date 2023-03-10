import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class Launcher {
  launchMaps(
      {required double latitude, required double longitude, required label}) {
    return MapsLauncher.launchCoordinates(latitude, longitude, 'jüs - $label');
  }

  launchPhone({required int number}) async {
    Uri url = Uri.parse('tel:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not call $url. Please try again.';
    }
  }
}
