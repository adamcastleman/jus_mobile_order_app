import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Sheets/allergies_sheet.dart';

class ModifyAllergyGridCard extends ConsumerWidget {
  const ModifyAllergyGridCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        NavigationHelpers.navigateToFullScreenSheetOrDialog(
          context,
          const AllergiesSheet(),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
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
