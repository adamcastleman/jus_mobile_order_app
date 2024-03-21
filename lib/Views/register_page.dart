import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/Validators/registration_validators.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/AbstractModels/abstract_payment_form.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Services/auth_services.dart';
import 'package:jus_mobile_order_app/Services/subscription_services.dart';
import 'package:jus_mobile_order_app/Services/user_services.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large_loading.dart';
import 'package:jus_mobile_order_app/Widgets/General/text_fields.dart';
import 'package:jus_mobile_order_app/constants.dart';

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
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 22.0,
        ),
        child: SingleChildScrollView(
          primary: false,
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.only(
            top: PlatformUtils.isWeb() ? 10.0 : 30.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: ResponsiveLayout.isMobileBrowser(context)
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            mainAxisAlignment: ResponsiveLayout.isMobileBrowser(context)
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              Spacing.vertical(15),
              _buildSignUpInstructions(context),
              Spacing.vertical(25),
              _buildFirstNameTextField(context, ref, user, firstNameError),
              Spacing.vertical(15),
              _buildLastNameTextField(context, ref, user, lastNameError),
              Spacing.vertical(15),
              _buildPhoneTextField(context, ref, user, phoneError),
              Spacing.vertical(15),
              _buildEmailTextField(context, ref, user, emailError),
              Spacing.vertical(15),
              _buildPasswordTextField(context, ref, passwordError),
              Spacing.vertical(15),
              _buildConfirmPasswordTextField(
                  context, ref, confirmPasswordError),
              firebaseError == null
                  ? Spacing.vertical(30)
                  : Spacing.vertical(20),
              ShowError(error: firebaseError),
              firebaseError == null
                  ? Spacing.vertical(0)
                  : Spacing.vertical(20),
              loading == true
                  ? const LargeElevatedLoadingButton()
                  : SizedBox(
                      width: ResponsiveLayout.isMobileBrowser(context)
                          ? double.infinity
                          : AppConstants.formWidthWeb,
                      child: _buildSignUpButton(
                        context: context,
                        ref: ref,
                        firstName: firstName,
                        lastName: lastName,
                        phone: phone,
                        email: email,
                        password: password,
                        confirmPassword: confirmPassword,
                      ),
                    ),
              Spacing.vertical(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  _buildSignInButton(context, ref),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      width: ResponsiveLayout.isMobileBrowser(context)
          ? double.infinity
          : AppConstants.formWidthWeb,
      child: Row(
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
    );
  }

  Widget _buildSignUpInstructions(BuildContext context) {
    return SizedBox(
        width: ResponsiveLayout.isMobileBrowser(context)
            ? double.infinity
            : AppConstants.formWidthWeb,
        child: Column(
          crossAxisAlignment: ResponsiveLayout.isMobileBrowser(context)
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Join now to collect points to redeem for free items, save '
              'favorite items, and more.',
              textAlign: ResponsiveLayout.isMobileBrowser(context)
                  ? TextAlign.start
                  : TextAlign.center,
            ),
            Spacing.vertical(10),
            Text(
              'To transfer your points or membership from our legacy programs, register with '
              'the same phone number and email, respectively. You can update your data later if needed.',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
              textAlign: ResponsiveLayout.isMobileBrowser(context)
                  ? TextAlign.start
                  : TextAlign.center,
            ),
          ],
        ));
  }

  Widget _buildFirstNameTextField(BuildContext context, WidgetRef ref,
      UserModel user, String? firstNameError) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: ResponsiveLayout.isMobileBrowser(context)
              ? double.infinity
              : AppConstants.formWidthWeb,
          child: JusTextField(ref: ref).firstName(user: user),
        ),
        SizedBox(
          child: JusTextField(ref: ref).error(firstNameError),
        ),
      ],
    );
  }

  Widget _buildLastNameTextField(BuildContext context, WidgetRef ref,
      UserModel user, String? lastNameError) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: ResponsiveLayout.isMobileBrowser(context)
              ? double.infinity
              : AppConstants.formWidthWeb,
          child: JusTextField(ref: ref).lastName(user: user),
        ),
        SizedBox(
          child: JusTextField(ref: ref).error(lastNameError),
        ),
      ],
    );
  }

  Widget _buildPhoneTextField(
      BuildContext context, WidgetRef ref, UserModel user, String? phoneError) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: ResponsiveLayout.isMobileBrowser(context)
              ? double.infinity
              : AppConstants.formWidthWeb,
          child: JusTextField(ref: ref).phone(user: user),
        ),
        SizedBox(
          child: JusTextField(ref: ref).error(phoneError),
        ),
      ],
    );
  }

  Widget _buildEmailTextField(
      BuildContext context, WidgetRef ref, UserModel user, String? emailError) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: ResponsiveLayout.isMobileBrowser(context)
              ? double.infinity
              : AppConstants.formWidthWeb,
          child: JusTextField(ref: ref).email(user: user),
        ),
        SizedBox(
          child: JusTextField(ref: ref).error(emailError),
        ),
      ],
    );
  }

  Widget _buildPasswordTextField(
      BuildContext context, WidgetRef ref, String? passwordError) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: ResponsiveLayout.isMobileBrowser(context)
              ? double.infinity
              : AppConstants.formWidthWeb,
          child: JusTextField(ref: ref).password(),
        ),
        SizedBox(
          child: JusTextField(ref: ref).error(passwordError),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordTextField(
      BuildContext context, WidgetRef ref, String? confirmPasswordError) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: ResponsiveLayout.isMobileBrowser(context)
              ? double.infinity
              : AppConstants.formWidthWeb,
          child: JusTextField(ref: ref).confirmPassword(),
        ),
        SizedBox(
          child: JusTextField(ref: ref).error(confirmPasswordError),
        ),
      ],
    );
  }

  Widget _buildSignUpButton({
    required BuildContext context,
    required WidgetRef ref,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) {
    return LargeElevatedButton(
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
    );
  }

  Widget _buildSignInButton(BuildContext context, WidgetRef ref) {
    return TextButton(
      child: const Text(
        'Sign In',
        style: TextStyle(
            color: Colors.black, decoration: TextDecoration.underline),
      ),
      onPressed: () async {
        Navigator.of(context).pop();
        ref.read(emailErrorProvider.notifier).state = null;
        ref.read(passwordErrorProvider.notifier).state = null;
        NavigationHelpers.navigateToLoginPage(context);
      },
    );
  }

  Future<Map> getLegacyMembershipDetails(
      BuildContext context, WidgetRef ref, String email) async {
    String? cardId;
    Completer<String?> completer = Completer<String?>();

    var result = await SubscriptionServices()
        .isRegisteringUserLegacyMember(email: email);
    if (result.data['status'] == SubscriptionStatus.active.name) {
      final paymentFormManager = PaymentFormManager.instance;
      paymentFormManager.generateCreditCardPaymentFormForMembershipMigration(
        context: context,
        ref: ref,
        onSuccess: (nonce) {
          ref.read(loadingProvider.notifier).state = true;
          cardId = nonce;
          completer.complete(cardId);
        },
      );

      // Wait for the completer to complete, which will happen in the onSuccess callback
      await completer.future;

      DateTime nextPaymentDateTime =
          DateTime.parse(result.data['nextPaymentDate']);
      String formattedStartDate =
          DateFormat('yyyy-MM-dd').format(nextPaymentDateTime);

      return {
        'status': result.data['status'],
        'startDate': formattedStartDate,
        'billingPeriod': result.data['billingPeriod'],
        'membershipId': result.data['membershipId'],
        'nonce': cardId, // cardId will now have the nonce value
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
      final membership = await getLegacyMembershipDetails(context, ref, email);
      ref.read(loadingProvider.notifier).state = true;
      if (membership.isNotEmpty) {
        subscription =
            await SubscriptionServices().migrateLegacyWooCommerceSubscription(
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
