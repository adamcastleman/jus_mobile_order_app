import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/constants.dart';
import 'package:jus_mobile_order_app/theme_data.dart';

class WebBannerStepper extends StatelessWidget {
  final Color backgroundColor;
  final String bannerTitle;
  final String bannerSubtitle;
  final List<StepItem> steps;

  const WebBannerStepper({
    required this.backgroundColor,
    required this.bannerTitle,
    required this.bannerSubtitle,
    required this.steps,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size.width;

// Use mobile aspect ratio for screens up to 800px wide
    var aspectRatio = screenSize < AppConstants.mobilePhoneWidth
        ? 0.5
        : screenSize <= 800
            ? AppConstants.aspectRatioMobileBrowser
            : AppConstants.aspectRatioWeb;

// Use the mobile layout for screens up to 800px wide, and the web layout for larger screens
    return ResponsiveLayout(
      mobileBrowser: AspectRatio(
        aspectRatio: aspectRatio,
        child: _mobileLayout(context),
      ),
      tablet: screenSize <= 800 ? _mobileLayout(context) : _webLayout(context),
      web: _webLayout(context),
    );
  }

  Widget _mobileLayout(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: TitleText(
                text: bannerTitle,
                fontSize: 28,
              ),
            ),
          ),
          for (var step in steps) ...[
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: _stepperStep(context, steps.indexOf(step) + 1, step),
            ),
          ],
        ],
      ),
    );
  }

  Widget _webLayout(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.2, bottom: 22.0),
            child: TitleText(
              text: bannerTitle,
              fontSize: 35,
            ),
          ),
          ResponsiveLayout.isTablet(context)
              ? Spacing.vertical(40)
              : Spacing.vertical(80),
          GridView.count(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            crossAxisCount: 3,
            crossAxisSpacing: 50,
            mainAxisSpacing: 20,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: steps
                .map((step) =>
                    _stepperStep(context, steps.indexOf(step) + 1, step))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _stepperStep(BuildContext context, int index, StepItem step) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _stepperCircle(index),
          Spacing.vertical(8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: AutoSizeText(
              step.title,
              style: TextStyle(
                fontSize: ResponsiveLayout.isWeb(context) ? 20 : 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
          ),
          Flexible(
            child: AutoSizeText(
              step.description,
              textAlign: TextAlign.center,
              maxLines: 10,
              minFontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepperCircle(int index) {
    return CircleAvatar(
      backgroundColor: Colors.green,
      radius: 22,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white,
        child: Text('$index'),
      ),
    );
  }
}

class StepItem {
  final String title;
  final String description;

  StepItem({required this.title, required this.description});
}
