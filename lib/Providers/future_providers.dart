import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/time.dart';

final deviceTimezoneProvider =
    FutureProvider<String>((ref) => Time().currentDevice());
