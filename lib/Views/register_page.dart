import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/Validators/registration_validators.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Services/auth_services.dart';
import 'package:jus_mobile_order_app/Services/payments_services_square.dart';
import 'package:jus_mobile_order_app/Services/subscription_services.dart';
import 'package:jus_mobile_order_app/Services/user_services.dart';
import 'package:jus_mobile_order_app/Views/login_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large_loading.dart';
import 'package:jus_mobile_order_app/Widgets/General/text_fields.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final email = ref.watch(emailProvider);
    final password = ref.watch(passwordProvider);
    final confirmPassword = ref.watch(confirmPasswordProvider);
    final firstName = ref.watch(firstNameProvider);
    final lastName = ref.watch(lastNameProvider);
    final phone = ref.watch(phoneProvider);
    final emailError = ref.watch(emailErrorProvider);
    final passwordError = ref.watch(passwordErrorProvider);
    final confirmPasswordError = ref.watch(confirmPasswordErrorProvider);
    final firstNameError = ref.watch(firstNameErrorProvider);
    final lastNameError = ref.watch(lastNameErrorProvider);
    final phoneError = ref.watch(phoneErrorProvider);
    final firebaseError = ref.watch(firebaseErrorProvider);
    final loading = ref.watch(loadingProvider);
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.width * 0.04,
              horizontal: MediaQuery.of(context).size.width * 0.05),
          child: SingleChildScrollView(
            primary: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Create Account',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const JusCloseButton(
                      removePadding: true,
                    ),
                  ],
                ),
                Spacing.vertical(15),
                const Text(
                  'Join now to collect points to redeem for free items, save '
                  'favorite items, and more.',
                ),
                Spacing.vertical(10),
                const Text(
                  'To transfer your points or membership from our legacy programs, register with '
                  'the same phone number and email, respectively. You can update your data later if needed.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                Spacing.vertical(25),
                JusTextField(ref: ref).firstName(user: user),
                JusTextField(ref: ref).error(firstNameError),
                Spacing.vertical(15),
                JusTextField(ref: ref).lastName(user: user),
                JusTextField(ref: ref).error(lastNameError),
                Spacing.vertical(15),
                JusTextField(ref: ref).phone(user: user),
                JusTextField(ref: ref).error(phoneError),
                Spacing.vertical(15),
                JusTextField(ref: ref).email(user: user),
                JusTextField(ref: ref).error(emailError),
                Spacing.vertical(15),
                JusTextField(ref: ref).password(),
                JusTextField(ref: ref).error(passwordError),
                Spacing.vertical(15),
                JusTextField(ref: ref).confirmPassword(),
                JusTextField(ref: ref).error(confirmPasswordError),
                firebaseError == null
                    ? Spacing.vertical(40)
                    : Spacing.vertical(20),
                ShowError(error: firebaseError),
                firebaseError == null
                    ? Spacing.vertical(0)
                    : Spacing.vertical(20),
                loading == true
                    ? const LargeElevatedLoadingButton()
                    : LargeElevatedButton(
                        buttonText: 'Sign Up',
                        onPressed: () {
                          ref.read(loadingProvider.notifier).state = true;
                          RegistrationValidators(ref: ref).validateForm(
                            firstName: firstName,
                            lastName: lastName,
                            email: email,
                            phone: phone,
                            password: password,
                            confirmPassword: confirmPassword,
                          );
                          signUpUser(
                            context: context,
                            ref: ref,
                            email: email,
                            password: password,
                            firstName: firstName,
                            lastName: lastName,
                            phone: phone,
                          );
                        },
                      ),
                Spacing.vertical(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      child: const Text('Sign In'),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        ref.read(emailErrorProvider.notifier).state = null;
                        ref.read(passwordErrorProvider.notifier).state = null;
                        ModalBottomSheet().fullScreen(
                          context: context,
                          builder: (context) => const LoginPage(),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Map> getLegacyMembershipDetails(WidgetRef ref, String email) async {
    var result = await SubscriptionServices()
        .isRegisteringUserLegacyMember(email: email);
    if (result.data['status'] == 'active') {
      String? nonce = await SquarePaymentServices()
          .inputSquareCreditCardForMembershipMigration(onCardEntryCancel: () {
        ref.read(loadingProvider.notifier).state = false;
      });

      DateTime nextPaymentDateTime =
          DateTime.parse(result.data['nextPaymentDate']);
      String formattedStartDate =
          DateFormat('yyyy-MM-dd').format(nextPaymentDateTime);

      return {
        'status': result.data['status'],
        'startDate': formattedStartDate,
        'billingPeriod': result.data['billingPeriod'],
        'membershipId': result.data['membershipId'],
        'nonce': nonce,
      };
    } else {
      return {};
    }
  }

  signUpUser({
    required BuildContext context,
    required WidgetRef ref,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    Map subscription = {};
    if (!ref.read(formValidatedProvider.notifier).state) return;

    ref.read(loadingProvider.notifier).state = true;
    try {
      final membership = await getLegacyMembershipDetails(ref, email);
      if (membership.isNotEmpty) {
        subscription = await SubscriptionServices().migrateToSquareSubscription(
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: phone,
          membershipId: membership['membershipId'],
          billingPeriod: membership['billingPeriod'],
          startDate: membership['startDate'],
          nonce: membership['nonce'],
        );
      }
      final user =
          await AuthServices().registerWithEmailAndPassword(email, password);
      if (user == null) throw Exception('Account creation failed');

      await UserServices(uid: user.uid).createUser(
        uid: user.uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        subscription: subscription.isEmpty ? null : subscription,
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
        ref.read(loadingProvider.notifier).state = false;
      });
    } catch (e) {
      ref.read(firebaseErrorProvider.notifier).state =
          'There was a server error. Please try again later.';
    } finally {
      ref.read(loadingProvider.notifier).state = false;
      ref.invalidate(firstNameProvider);
      ref.invalidate(lastNameProvider);
      ref.invalidate(phoneProvider);
      ref.invalidate(passwordProvider);
      ref.invalidate(confirmPasswordProvider);
    }
  }
}
