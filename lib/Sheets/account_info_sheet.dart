import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/validators.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Services/auth_services.dart';
import 'package:jus_mobile_order_app/Services/user_services.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium_loading.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outline_button_medium.dart';

class AccountInfoSheet extends ConsumerWidget {
  const AccountInfoSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstName = ref.watch(firstNameProvider);
    final lastName = ref.watch(lastNameProvider);
    final phone = ref.watch(phoneProvider);
    final passwordError = ref.watch(passwordErrorProvider);
    final confirmPasswordError = ref.watch(confirmPasswordErrorProvider);
    final firstNameError = ref.watch(firstNameErrorProvider);
    final lastNameError = ref.watch(lastNameErrorProvider);
    final phoneError = ref.watch(phoneErrorProvider);
    final loading = ref.watch(loadingProvider);
    final firebaseError = ref.watch(firebaseErrorProvider);
    return UserProviderWidget(
      builder: (user) => Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
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
                  TextFormField(
                    initialValue: firstName,
                    onChanged: (value) =>
                        ref.read(firstNameProvider.notifier).state = value,
                    decoration: const InputDecoration(
                      hintText: 'First name',
                    ),
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                  ),
                  firstNameError == null
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 5.0, left: 22.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ShowError(
                              error: firstNameError,
                            ),
                          ),
                        ),
                  Spacing().vertical(15),
                  TextFormField(
                    initialValue: lastName,
                    onChanged: (value) =>
                        ref.read(lastNameProvider.notifier).state = value,
                    decoration: const InputDecoration(
                      hintText: 'Last Name',
                    ),
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                  ),
                  lastNameError == null
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 5.0, left: 22.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ShowError(
                              error: lastNameError,
                            ),
                          ),
                        ),
                  Spacing().vertical(15),
                  TextFormField(
                    initialValue: phone.toString(),
                    onChanged: (value) =>
                        ref.read(phoneProvider.notifier).state = value,
                    decoration: const InputDecoration(
                      hintText: 'Phone #',
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                  phoneError == null
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 5.0, left: 22.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ShowError(
                              error: phoneError,
                            ),
                          ),
                        ),
                  Spacing().vertical(15),
                  TextFormField(
                    onChanged: (value) =>
                        ref.read(passwordProvider.notifier).state = value,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  passwordError == null
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 5.0, left: 22.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ShowError(
                              error: passwordError,
                            ),
                          ),
                        ),
                  Spacing().vertical(15),
                  TextFormField(
                    initialValue: null,
                    onChanged: (value) => ref
                        .read(confirmPasswordProvider.notifier)
                        .state = value,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Confirm Password',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, left: 22.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ShowError(
                        error: confirmPasswordError,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: ShowError(error: firebaseError),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MediumOutlineButton(
                        buttonText: 'Cancel',
                        onPressed: () {
                          Navigator.pop(context);
                          ref.invalidate(firstNameProvider);
                          ref.invalidate(lastNameProvider);
                          ref.invalidate(phoneProvider);
                          ref.invalidate(passwordProvider);
                          ref.invalidate(confirmPasswordProvider);
                        },
                      ),
                      loading == true
                          ? const MediumElevatedLoadingButton()
                          : MediumElevatedButton(
                              buttonText: 'Save',
                              onPressed: () async {
                                ref.read(loadingProvider.notifier).state = true;
                                await validatePasswordData(context, ref, user);
                              },
                            ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void validateUserData(
      BuildContext context, WidgetRef ref, UserModel user) async {
    final firstName = ref.watch(firstNameProvider);
    final lastName = ref.watch(lastNameProvider);
    final phone = ref.watch(phoneProvider);
    final firstNameErrorNotifier = ref.read(firstNameErrorProvider.notifier);
    final lastNameErrorNotifier = ref.read(lastNameErrorProvider.notifier);
    final phoneErrorNotifier = ref.read(phoneErrorProvider.notifier);
    final formValidatedNotifier = ref.read(formValidatedProvider.notifier);

    if (firstName.isEmpty) {
      Validator().firstName(ref);
    } else {
      firstNameErrorNotifier.state = null;
    }

    if (lastName.isEmpty) {
      Validator().lastName(ref);
    } else {
      lastNameErrorNotifier.state = null;
    }

    if (phone.length != 10) {
      Validator().phone(ref);
    } else {
      phoneErrorNotifier.state = null;
    }

    if (firstNameErrorNotifier.state == null &&
        lastNameErrorNotifier.state == null &&
        phoneErrorNotifier.state == null) {
      formValidatedNotifier.state = true;
      await updateUser(context, ref, user);
    }
  }

  validatePasswordData(BuildContext context, WidgetRef ref, UserModel user) {
    //We are using a reference to the context in order to pass the context down the tree to pop the modal.
    //You cannot use the actual BuildContext in an async function. vv
    final currentContext = context;
    final password = ref.watch(passwordProvider);
    final confirmPassword = ref.watch(confirmPasswordProvider);
    final passwordErrorNotifier = ref.read(passwordErrorProvider.notifier);
    final confirmPasswordErrorNotifier =
        ref.read(confirmPasswordErrorProvider.notifier);
    final changePasswordValidatedNotifier =
        ref.read(changePasswordValidatedProvider.notifier);

    if (password.isEmpty) {
      validateUserData(context, ref, user);
      return;
    }

    if (password.isNotEmpty && password != confirmPassword) {
      Validator().confirmPassword(ref);
    } else {
      confirmPasswordErrorNotifier.state = null;
    }

    if (passwordErrorNotifier.state == null &&
        confirmPasswordErrorNotifier.state == null) {
      changePasswordValidatedNotifier.state = true;
      updatePassword(currentContext, ref, user);
    }
  }

  updatePassword(var context, WidgetRef ref, UserModel user) async {
    try {
      await AuthServices().updatePassword(ref.watch(passwordProvider));
      validateUserData(context, ref, user);
    } catch (e) {
      ref.read(loadingProvider.notifier).state = false;
      ref.invalidate(passwordProvider);
      ref.invalidate(confirmPasswordProvider);
      ref.read(firebaseErrorProvider.notifier).state = e.toString();
    }
  }

  updateUser(
    var context,
    WidgetRef ref,
    UserModel user,
  ) async {
    if (ref.read(formValidatedProvider.notifier).state == true) {
      try {
        await UserServices(uid: user.uid).updateUser(
          firstName: ref.read(firstNameProvider),
          lastName: ref.read(lastNameProvider),
          phone: ref.read(phoneProvider),
        );
        ref.invalidate(firstNameProvider);
        ref.invalidate(lastNameProvider);
        ref.invalidate(phoneProvider);
        ref.invalidate(passwordProvider);
        ref.invalidate(confirmPasswordProvider);
        Navigator.pop(context);
      } catch (e) {
        ref.read(loadingProvider.notifier).state = false;
        ref.read(firebaseErrorProvider.notifier).state = e.toString();
      }
    } else {}
  }
}
