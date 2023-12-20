import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/cleanse_text_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/locations_text_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/membership_text_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/menu_text_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/profile_text_button.dart';
import 'package:jus_mobile_order_app/constants.dart';

class WebNavigationDrawer extends StatelessWidget {
  final UserModel user;
  const WebNavigationDrawer({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConstants.screenWidth,
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8.0, right: 8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: JusCloseButton(),
              ),
            ),
            Spacing.vertical(40),
            const MenuTextButton(fontSize: 30),
            Spacing.vertical(20),
            const CleanseTextButton(fontSize: 30),
            Spacing.vertical(20),
            const MembershipTextButton(fontSize: 30),
            Spacing.vertical(20),
            const LocationsTextButton(fontSize: 30),
            Spacing.vertical(20),
            ProfileTextButton(user: user, fontSize: 30),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
