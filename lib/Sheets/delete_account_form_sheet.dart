import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/Validators/address_validators.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium_loading.dart';
import 'package:jus_mobile_order_app/Widgets/Dialogs/toast.dart';
import 'package:jus_mobile_order_app/Widgets/General/text_fields.dart';

class DeleteAccountFormSheet extends HookConsumerWidget {
  const DeleteAccountFormSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(loadingProvider);
    final addressLine1Error = ref.watch(addressLine1ErrorProvider);
    final addressLine2Error = ref.watch(addressLine2ErrorProvider);
    final cityError = ref.watch(cityErrorProvider);
    final stateError = ref.watch(stateNameErrorProvider);
    final zipCodeError = ref.watch(zipCodeErrorProvider);

    final stateNameAbbreviationController = useTextEditingController();

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Wrap(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: JusCloseButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  ref.invalidate(addressLine1Provider);
                  ref.invalidate(addressLine2Provider);
                  ref.invalidate(cityProvider);
                  ref.invalidate(usStateNameProvider);
                  ref.invalidate(zipCodeProvider);
                  Navigator.pop(context);
                },
              ),
            ),
            Center(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(
                    top: 15.0, bottom: 40.0, left: 22.0, right: 22.0),
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  JusTextField(ref: ref).addressLine1(),
                  JusTextField(ref: ref).error(addressLine1Error),
                  Spacing.vertical(15),
                  JusTextField(ref: ref).addressLine2(),
                  JusTextField(ref: ref).error(addressLine2Error),
                  Spacing.vertical(15),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            JusTextField(ref: ref).city(),
                            JusTextField(ref: ref).error(cityError),
                          ],
                        ),
                      ),
                      Spacing.horizontal(20),
                      SizedBox(
                        width: 100,
                        child: Column(
                          children: [
                            JusTextField(ref: ref).state(
                                context, stateNameAbbreviationController),
                            JusTextField(ref: ref).error(stateError),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Spacing.vertical(15),
                  JusTextField(ref: ref).zipCode(),
                  JusTextField(ref: ref).error(zipCodeError),
                  Spacing.vertical(40),
                  loading
                      ? const MediumElevatedLoadingButton()
                      : MediumElevatedButton(
                          buttonText: 'Send Deletion Request',
                          onPressed: () {
                            final validate = AddressValidators(ref: ref);
                            ref.read(loadingProvider.notifier).state = true;
                            if (validate.validateAddressLine1() &&
                                validate.validateCity() &&
                                validate.validateStateName() &&
                                validate.validateZipCode()) {
                              handleAccountDeletionRequest(context, ref,
                                  onCompleted: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                ToastHelper.showToast(
                                    message: 'We have received your request');
                              }, onError: (error) {
                                ErrorHelpers.showSinglePopError(context,
                                    error:
                                        'There was an error sending this request. Please try again.');

                                ref.read(loadingProvider.notifier).state =
                                    false;
                              });
                              ref.read(loadingProvider.notifier).state = false;
                            } else {
                              ref.read(loadingProvider.notifier).state = false;
                              return;
                            }
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleAccountDeletionRequest(BuildContext context, WidgetRef ref,
      {required VoidCallback onCompleted,
      required Function(String) onError}) async {
    try {
      await callDeleteAccountRequest(ref);
      ref.read(loadingProvider.notifier).state = false;
      onCompleted();
      ref.invalidate(addressLine1Provider);
      ref.invalidate(addressLine2Provider);
      ref.invalidate(cityProvider);
      ref.invalidate(usStateNameProvider);
      ref.invalidate(zipCodeProvider);
    } catch (error) {
      onError(error.toString());
    }
  }

  Future<void> callDeleteAccountRequest(WidgetRef ref) {
    return FirebaseFunctions.instance
        .httpsCallable('deleteAccountRequest')
        .call({
      'addressLine1': ref.watch(addressLine1Provider),
      'addressLine2': ref.watch(addressLine2Provider),
      'city': ref.watch(cityProvider),
      'state': ref.watch(usStateNameProvider),
      'zipCode': ref.watch(zipCodeProvider),
    });
  }
}
