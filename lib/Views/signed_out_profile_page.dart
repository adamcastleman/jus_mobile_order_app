import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Views/register_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium.dart';

class SignedOutProfilePage extends ConsumerWidget {
  const SignedOutProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = ref.watch(signInImageProvider);
    return image.when(
      error: (e, _) => ShowError(error: e.toString()),
      loading: () => const Loading(),
      data: (data) => Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 300,
                child: CachedNetworkImage(
                  fit: BoxFit.fitWidth,
                  imageUrl: data.data().containsKey('url') ? data['url'] : '',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 44.0, horizontal: 15.0),
                child: Column(
                  children: [
                    AutoSizeText(
                      data.data().containsKey('title') ? data['title'] : '',
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Spacing().vertical(10),
                    AutoSizeText(
                      data.data().containsKey('description')
                          ? data['description']
                          : '',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Center(
                child: MediumElevatedButton(
                  buttonText: 'Create Account',
                  onPressed: () {
                    ModalBottomSheet().fullScreen(
                      context: context,
                      builder: (context) => const RegisterPage(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
