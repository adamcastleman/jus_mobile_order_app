import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';

final updateMembershipLoadingProvider = StateProvider<bool>((ref) => false);

final selectedMembershipPlanProvider =
    StateProvider<MembershipPlan>((ref) => MembershipPlan.annual);

final selectedMembershipPlanPriceProvider =
    StateProvider<double?>((ref) => null);

final membershipDisclaimerCheckboxValueProvider =
    StateProvider<bool>((ref) => false);
