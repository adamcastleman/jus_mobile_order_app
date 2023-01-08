import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(FontAwesomeIcons.heart),
      iconSize: 20,
      onPressed: () {},
    );
  }
}
