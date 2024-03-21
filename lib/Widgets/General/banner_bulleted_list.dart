import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/bulleted_list.dart';
import 'package:jus_mobile_order_app/constants.dart';
import 'package:jus_mobile_order_app/theme_data.dart';

class WebBulletListBanner extends StatelessWidget {
  final Color backgroundColor;
  final String bannerTitle;
  final String firstColumnBulletTitle;
  final String secondColumnBulletTitle;
  final List<String> firstColumnBulletItems;
  final List<String> secondColumnBulletItems;
  const WebBulletListBanner(
      {required this.backgroundColor,
      required this.bannerTitle,
      required this.firstColumnBulletTitle,
      required this.secondColumnBulletTitle,
      required this.firstColumnBulletItems,
      required this.secondColumnBulletItems,
      super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size.width;

// Use mobile aspect ratio for screens up to 800px wide
    var aspectRatio = screenSize <= 800
        ? AppConstants.aspectRatioMobileBrowser
        : AppConstants.aspectRatioWeb;

// Use the mobile layout for screens up to 800px wide, and the web layout for larger screens
    return ResponsiveLayout(
      mobileBrowser: _mobileLayout(context, screenSize),
      tablet: screenSize <= 800
          ? _mobileLayout(context, screenSize)
          : AspectRatio(
              aspectRatio: aspectRatio,
              child: _webLayout(context, screenSize),
            ),
      web: AspectRatio(
        aspectRatio: aspectRatio,
        child: _webLayout(context, screenSize),
      ),
    );
  }

  Widget _mobileLayout(BuildContext context, double screenSize) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      width: double.infinity,
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 12.0),
            child: TitleText(
              text: bannerTitle,
              fontSize: screenSize <= AppConstants.mobilePhoneWidth ? 22 : 30,
            ),
          ),
          _buildCleanseDescriptionWidget(context, screenSize,
              firstColumnBulletTitle, firstColumnBulletItems),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: JusDivider.thick(),
          ),
          _buildCleanseDescriptionWidget(context, screenSize,
              secondColumnBulletTitle, secondColumnBulletItems),
        ],
      ),
    );
  }

  Widget _webLayout(BuildContext context, double screenSize) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveLayout.isMobileBrowser(context) ||
                  ResponsiveLayout.isTablet(context)
              ? const SizedBox()
              : Spacing.vertical(60),
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: TitleText(
              text: bannerTitle,
              fontSize: 40,
            ),
          ),
          ResponsiveLayout.isTablet(context)
              ? const SizedBox()
              : Spacing.vertical(20),
          Flexible(
            child: GridView(
              padding: const EdgeInsets.all(12.0),
              shrinkWrap: true,
              primary: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                childAspectRatio: ResponsiveLayout.isTablet(context) ? 1.8 : 2,
              ),
              children: [
                _buildCleanseDescriptionWidget(context, screenSize,
                    firstColumnBulletTitle, firstColumnBulletItems),
                _buildCleanseDescriptionWidget(context, screenSize,
                    secondColumnBulletTitle, secondColumnBulletItems),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCleanseDescriptionWidget(BuildContext context, double screenSize,
      String title, List<String> items) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      padding: const EdgeInsets.all(12.0),
      color: backgroundColor,
      child: BulletedList(
        title: title,
        items: items,
        titleFontSize: screenSize <= AppConstants.tabletWidth ? 20 : 24,
        bulletFontSize: 18,
      ),
    );
  }
}
