import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/delete_account_provider_widget.dart';
import 'package:jus_mobile_order_app/Sheets/delete_account_form_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium.dart';

class DeleteAccountSheet extends StatelessWidget {
  const DeleteAccountSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DeleteAccountProviderWidget(
      builder: (image) => Container(
        padding: const EdgeInsets.only(top: 60.0, bottom: 50.0),
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 22.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delete Account',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const JusCloseButton(
                    removePadding: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 270,
              child: Transform.scale(
                scale: 0.9,
                child: CachedNetworkImage(
                  imageUrl: image.data().containsKey('url') ? image['url'] : '',
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AutoSizeText(
                    image.data().containsKey('title') ? image['title'] : '',
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Spacing.vertical(30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Text(
                    image.data().containsKey('description')
                        ? image['description']
                        : '',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Spacing.vertical(40),
            Center(
              child: MediumElevatedButton(
                buttonText: 'Request Account Deletion',
                onPressed: () {
                  ModalBottomSheet().partScreen(
                    enableDrag: false,
                    isDismissible: false,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => const DeleteAccountFormSheet(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
