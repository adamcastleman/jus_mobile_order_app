import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Navigation/web_naviagation_drawer.dart';

class WebHamburgerMenuButton extends StatelessWidget {
  final UserModel user;
  const WebHamburgerMenuButton({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      hoverColor: Colors.transparent,
      icon: const Icon(CupertinoIcons.line_horizontal_3),
      onPressed: () {
        ModalTopSheet().fullScreen(
          context: context,
          child: WebNavigationDrawer(user: user),
        );
      },
    );
  }
}
