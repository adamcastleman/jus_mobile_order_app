import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Sheets/allergies_sheet.dart';

class ModifyAllergyGridCard extends ConsumerWidget {
  const ModifyAllergyGridCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ModalBottomSheet().fullScreen(
          context: context,
          builder: (context) => const AllergiesSheet(),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: const SizedBox(
          height: 100,
          width: 100,
          child: Icon(CupertinoIcons.add_circled),
        ),
      ),
    );
  }
}
