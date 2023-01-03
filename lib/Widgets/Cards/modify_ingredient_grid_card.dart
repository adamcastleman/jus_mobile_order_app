import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/set_standard_ingredients.dart';

class ModifyIngredientGridCard extends ConsumerWidget {
  final Function close;
  const ModifyIngredientGridCard({required this.close, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        StandardIngredients(ref: ref).add();
        close();
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: const SizedBox(
          height: 70,
          width: 70,
          child: Icon(CupertinoIcons.add_circled),
        ),
      ),
    );
  }
}
