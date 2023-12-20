import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/bag_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/logo_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/web_hamburger_menu_button.dart';

class WebNavBarSmallScreen extends StatelessWidget {
  final UserModel user;
  const WebNavBarSmallScreen({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const LogoButton(),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 14.0),
                child: BagButton(),
              ),
              Spacing.horizontal(10),
              WebHamburgerMenuButton(user: user),
            ],
          ),
        ],
      ),
    );
  }
}
