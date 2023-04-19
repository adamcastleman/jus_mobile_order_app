import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';

class AddressValidators {
  final WidgetRef ref;

  AddressValidators({required this.ref});
  bool validateAddressLine1() {
    final addressLine1 = ref.watch(addressLine1Provider);
    final addressLine1Error = ref.watch(addressLine1ErrorProvider.notifier);
    if (addressLine1.isEmpty) {
      addressLine1Error.state = 'Please enter your street number and name.';
      return false;
    } else {
      addressLine1Error.state = null;
      return true;
    }
  }

  bool validateCity() {
    final city = ref.watch(cityProvider);
    final cityError = ref.watch(cityErrorProvider.notifier);
    if (city.isEmpty) {
      cityError.state = 'Please enter your city.';
      return false;
    } else {
      cityError.state = null;
      return true;
    }
  }

  bool validateStateName() {
    final stateName = ref.watch(usStateNameProvider);
    final stateNameError = ref.watch(stateNameErrorProvider.notifier);
    if (stateName.isEmpty) {
      stateNameError.state = 'Select';
      return false;
    } else {
      stateNameError.state = null;
      return true;
    }
  }

  bool validateZipCode() {
    final zipCode = ref.watch(zipCodeProvider);
    final zipCodeError = ref.watch(zipCodeErrorProvider.notifier);
    if (zipCode.isEmpty) {
      zipCodeError.state = 'Please enter your mailing zip code.';
      return false;
    } else {
      zipCodeError.state = null;
      return true;
    }
  }
}
