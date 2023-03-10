import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';

class SelectionIncrementer extends StatelessWidget {
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final String quantity;
  final double quantityRadius;
  final double verticalPadding;
  final double horizontalPadding;
  final double iconSize;
  final double buttonSpacing;
  const SelectionIncrementer(
      {required this.onAdd,
      required this.onRemove,
      required this.quantity,
      required this.quantityRadius,
      required this.verticalPadding,
      required this.horizontalPadding,
      required this.iconSize,
      required this.buttonSpacing,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: verticalPadding, horizontal: horizontalPadding),
      child: Row(
        children: [
          InkWell(
            onTap: onRemove,
            child: Icon(
              CupertinoIcons.minus_circled,
              size: iconSize,
            ),
          ),
          Spacing().horizontal(5),
          InkWell(
            onTap: onAdd,
            child: Icon(
              CupertinoIcons.add_circled,
              size: iconSize,
            ),
          ),
          Spacing().horizontal(buttonSpacing),
          CircleAvatar(
            radius: quantityRadius,
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            child: Text(
              quantity,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
