import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';

class WebFooterBanner extends ConsumerWidget {
  const WebFooterBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(webFooterColorProvider);
    const titleStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    const subtitleStyle = TextStyle(fontSize: 14);
    return ResponsiveLayout(
      mobileBrowser:
          _mobileLayout(context, backgroundColor, titleStyle, subtitleStyle),
      web: _webLayout(context, backgroundColor, titleStyle, subtitleStyle),
    );
  }

  Widget _mobileLayout(BuildContext context, Color backgroundColor,
      TextStyle titleStyle, TextStyle subtitleStyle) {
    return Container(
      height: 230,
      padding: const EdgeInsets.all(20.0),
      color: backgroundColor,
      child: Column(
        children: [
          Expanded(
            child: GridView(
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 9 / 20,
              ),
              children: [
                _resourcesColumn(titleStyle, subtitleStyle),
                _socialMediaColumn(titleStyle, subtitleStyle),
                _supportColumn(context, titleStyle, subtitleStyle),
              ],
            ),
          ),
          Spacing.vertical(30),
          Align(
            alignment: Alignment.bottomRight,
            child: _copyrightInfo(),
          ),
        ],
      ),
    );
  }

  Widget _webLayout(BuildContext context, Color backgroundColor,
      TextStyle titleStyle, TextStyle subtitleStyle) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      height: 220,
      color: backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _resourcesColumn(titleStyle, subtitleStyle),
          Spacing.horizontal(20),
          _socialMediaColumn(titleStyle, subtitleStyle),
          Spacing.horizontal(20),
          _supportColumn(context, titleStyle, subtitleStyle),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: _copyrightInfo(),
          ),
        ],
      ),
    );
  }

  Widget _resourcesColumn(TextStyle titleStyle, TextStyle subtitleStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'RESOURCES',
          style: titleStyle,
        ),
        Spacing.vertical(10),
        TextButton(
          onPressed: () {},
          child: Text(
            'Work with us',
            style: subtitleStyle,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'How to cleanse',
            style: subtitleStyle,
          ),
        ),
      ],
    );
  }

  Widget _socialMediaColumn(TextStyle titleStyle, TextStyle subtitleStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            'SOCIAL',
            style: titleStyle,
          ),
        ),
        Spacing.vertical(10),
        Flexible(
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Instagram',
              style: subtitleStyle,
            ),
          ),
        ),
        Flexible(
          child: TextButton(
            onPressed: () {},
            child: Text(
              'TikTok',
              style: subtitleStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _supportColumn(
      BuildContext context, TextStyle titleStyle, TextStyle subtitleStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            'SUPPORT',
            style: titleStyle,
          ),
        ),
        Spacing.vertical(10),
        Flexible(
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Contact Us',
              style: subtitleStyle,
            ),
          ),
        ),
        Flexible(
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Privacy Policy',
              style: subtitleStyle,
            ),
          ),
        ),
        Flexible(
          child: TextButton(
            onPressed: () {
              NavigationHelpers.navigateToMembershipTermsOfService(context);
            },
            child: Text(
              'Membership Terms of Service',
              style: subtitleStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _copyrightInfo() {
    return const Text('©2024 Jus, Inc.');
  }
}
