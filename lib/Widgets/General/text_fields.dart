import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Sheets/us_states_picker.dart';

class JusTextField {
  final WidgetRef ref;

  JusTextField({
    required this.ref,
  });

  email({bool? autofocus}) {
    return UserProviderWidget(
      builder: (user) => TextFormField(
        autofocus: autofocus ?? false,
        initialValue: user.uid == null ? null : user.email,
        onChanged: (value) => ref.read(emailProvider.notifier).state = value,
        decoration: const InputDecoration(
          hintText: 'Email',
        ),
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
      ),
    );
  }

  phone({bool? autofocus}) {
    return UserProviderWidget(
      builder: (user) => TextFormField(
        initialValue: user.uid == null ? null : user.phone,
        autofocus: autofocus ?? false,
        onChanged: (value) => ref.read(phoneProvider.notifier).state = value,
        decoration: const InputDecoration(
          hintText: 'Phone #',
        ),
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.done,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
      ),
    );
  }

  lastName({bool? autofocus}) {
    return UserProviderWidget(
      builder: (user) => TextFormField(
        initialValue: user.uid == null ? null : user.lastName,
        autofocus: autofocus ?? false,
        onChanged: (value) => ref.read(lastNameProvider.notifier).state = value,
        decoration: const InputDecoration(
          hintText: 'Last Name',
        ),
        autocorrect: true,
        textCapitalization: TextCapitalization.words,
      ),
    );
  }

  firstName({bool? autofocus}) {
    return UserProviderWidget(
      builder: (user) => TextFormField(
        initialValue: user.uid == null ? null : user.firstName,
        autofocus: autofocus ?? false,
        onChanged: (value) =>
            ref.read(firstNameProvider.notifier).state = value,
        decoration: const InputDecoration(
          hintText: 'First name',
        ),
        autocorrect: true,
        textCapitalization: TextCapitalization.words,
      ),
    );
  }

  password({bool? autofocus}) {
    return TextFormField(
      autofocus: autofocus ?? false,
      onChanged: (value) => ref.read(passwordProvider.notifier).state = value,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
      obscureText: true,
    );
  }

  confirmPassword({bool? autofocus}) {
    return TextFormField(
      autofocus: autofocus ?? false,
      onChanged: (value) =>
          ref.read(confirmPasswordProvider.notifier).state = value,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Confirm Password',
      ),
    );
  }

  addressLine1({bool? autofocus}) {
    return TextFormField(
      autofocus: autofocus ?? false,
      onChanged: (value) =>
          ref.read(addressLine1Provider.notifier).state = value,
      decoration: const InputDecoration(
        hintText: 'Address Line 1',
      ),
      autocorrect: false,
      textCapitalization: TextCapitalization.words,
    );
  }

  addressLine2({bool? autofocus}) {
    return TextFormField(
      autofocus: autofocus ?? false,
      onChanged: (value) =>
          ref.read(addressLine2Provider.notifier).state = value,
      decoration: const InputDecoration(
        hintText: 'Address Line 2',
      ),
      autocorrect: false,
      textCapitalization: TextCapitalization.words,
    );
  }

  city({bool? autofocus}) {
    return TextFormField(
      autofocus: autofocus ?? false,
      onChanged: (value) => ref.read(cityProvider.notifier).state = value,
      decoration: const InputDecoration(
        hintText: 'City',
      ),
      autocorrect: false,
      textCapitalization: TextCapitalization.words,
    );
  }

  state(BuildContext context,
      TextEditingController stateNameAbbreviationController,
      {bool? autofocus}) {
    return TextFormField(
      controller: stateNameAbbreviationController,
      autofocus: autofocus ?? false,
      onTap: () {
        ModalBottomSheet().partScreen(
            enableDrag: true,
            isDismissible: true,
            isScrollControlled: true,
            context: context,
            builder: (context) =>
                USStatesPicker(controller: stateNameAbbreviationController));
      },
      readOnly: true,
      decoration: const InputDecoration(
        hintText: 'State',
      ),
      onChanged: (value) =>
          ref.read(usStateNameProvider.notifier).state = value,
    );
  }

  zipCode({bool? autofocus}) {
    return TextFormField(
      autofocus: autofocus ?? false,
      onChanged: (value) => ref.read(zipCodeProvider.notifier).state = value,
      decoration: const InputDecoration(
        hintText: 'Zip Code',
      ),
      autocorrect: false,
      keyboardType: const TextInputType.numberWithOptions(),
    );
  }

  error(String? error) {
    if (error == null) {
      return const SizedBox();
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: ShowError(
          error: error,
        ),
      );
    }
  }
}
