import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/Validators/user_info_validators.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Sheets/delete_account_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium_loading.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outlined_button_medium.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/text_fields.dart';

class AccountInfoSheet extends ConsumerWidget {
  const AccountInfoSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final passwordError = ref.watch(passwordErrorProvider);
    final emailError = ref.watch(emailErrorProvider);
    final confirmPasswordError = ref.watch(confirmPasswordErrorProvider);
    final firstNameError = ref.watch(firstNameErrorProvider);
    final lastNameError = ref.watch(lastNameErrorProvider);
    final phoneError = ref.watch(phoneErrorProvider);
    final loading = ref.watch(loadingProvider);
    final firebaseError = ref.watch(firebaseErrorProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.08,
                bottom: 22.0,
                left: 22.0,
                right: 22.0,
              ),
              child: Text(
                'Account Info',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding:
                      EdgeInsets.only(left: 14.0, right: 14.0, bottom: 10.0),
                  child: CategoryWidget(text: 'Basic Info'),
                ),
                JusTextField(ref: ref).firstName(user: user),
                JusTextField(ref: ref).error(firstNameError),
                Spacing().vertical(15),
                JusTextField(ref: ref).lastName(user: user),
                JusTextField(ref: ref).error(lastNameError),
                Spacing().vertical(15),
                JusTextField(ref: ref).phone(user: user),
                JusTextField(ref: ref).error(phoneError),
                Spacing().vertical(15),
                JusTextField(ref: ref).email(user: user),
                JusTextField(ref: ref).error(emailError),
                Spacing().vertical(15),
                const Padding(
                  padding: EdgeInsets.only(
                      left: 14.0, right: 14.0, top: 5.0, bottom: 10.0),
                  child: CategoryWidget(text: 'Update Password (Optional)'),
                ),
                JusTextField(ref: ref).password(),
                Consumer(
                  builder: (context, ref, _) =>
                      JusTextField(ref: ref).error(passwordError),
                ),
                Spacing().vertical(15),
                Consumer(
                  builder: (context, ref, _) =>
                      JusTextField(ref: ref).confirmPassword(),
                ),
                JusTextField(ref: ref).error(confirmPasswordError),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: ShowError(error: firebaseError),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: JusDivider().thick(),
                ),
                Spacing().vertical(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MediumOutlineButton(
                      buttonText: 'Close',
                      onPressed: () {
                        Navigator.pop(context);
                        ref.invalidate(firstNameProvider);
                        ref.invalidate(lastNameProvider);
                        ref.invalidate(phoneProvider);
                        ref.invalidate(emailProvider);
                        ref.invalidate(passwordProvider);
                        ref.invalidate(confirmPasswordProvider);
                      },
                    ),
                    loading == true
                        ? const MediumElevatedLoadingButton()
                        : MediumElevatedButton(
                            buttonText: 'Save',
                            onPressed: () {
                              AccountInfoUpdater(ref: ref, user: user).update();
                            },
                          ),
                  ],
                ),
                Spacing().vertical(20),
                TextButton(
                  child: const Text(
                    'Delete Account',
                    style: TextStyle(
                        color: Colors.red,
                        decoration: TextDecoration.underline),
                  ),
                  onPressed: () {
                    ModalBottomSheet().fullScreen(
                      context: context,
                      builder: (context) => const DeleteAccountSheet(),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
