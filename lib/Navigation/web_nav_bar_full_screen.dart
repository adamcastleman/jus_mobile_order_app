import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/bag_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/cleanse_text_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/locations_text_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/logo_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/membership_text_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/menu_text_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/profile_text_button.dart';

class WebNavBarFullScreen extends ConsumerWidget {
  final UserModel user;
  const WebNavBarFullScreen({required this.user, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLogoAndButtons(ref),
        _buildRightSideButtons(),
      ],
    );
  }

  Row _buildLogoAndButtons(WidgetRef ref) {
    return const Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: LogoButton(),
        ),
        MenuTextButton(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0),
          child: CleanseTextButton(),
        ),
        MembershipTextButton(),
      ],
    );
  }

  Row _buildRightSideButtons() {
    return Row(
      children: [
        const LocationsTextButton(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: ProfileTextButton(
            user: user,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0, right: 20.0),
          child: BagButton(),
        ),
      ],
    );
  }
}
