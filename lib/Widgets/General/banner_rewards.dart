import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_web_small.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/rewards_card.dart';
import 'package:jus_mobile_order_app/constants.dart';
import 'package:jus_mobile_order_app/theme_data.dart';

class WebRewardsBanner extends StatelessWidget {
  final Color backgroundColor;
  final List<String> images;
  final String title;
  final String description;
  final PointsDetailsModel points;
  final int? titleMaxLines;
  final int? descriptionMaxLines;
  final String callToActionText;
  final VoidCallback callToActionOnPressed;

  const WebRewardsBanner({
    required this.backgroundColor,
    required this.images,
    required this.title,
    required this.description,
    required this.points,
    required this.titleMaxLines,
    required this.descriptionMaxLines,
    required this.callToActionText,
    required this.callToActionOnPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size.width;

// Use mobile aspect ratio for screens up to 800px wide
    var aspectRatio = screenSize < AppConstants.mobilePhoneWidth
        ? AppConstants.aspectRatioMobilePhone
        : screenSize <= 800
            ? AppConstants.aspectRatioMobileBrowser
            : AppConstants.aspectRatioWeb;

// Use the mobile layout for screens up to 800px wide, and the web layout for larger screens
    return ResponsiveLayout(
      mobilePhone: _mobilePhoneLayout(context),
      mobileBrowser: _mobileBrowserLayout(context),
      tablet: screenSize <= 800
          ? _mobileBrowserLayout(context)
          : AspectRatio(
              aspectRatio: aspectRatio,
              child: _webLayout(context),
            ),
      web: AspectRatio(
        aspectRatio: aspectRatio,
        child: _webLayout(context),
      ),
    );
  }

  Widget _mobilePhoneLayout(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            height: AppConstants.screenHeight * 0.1,
            width: 450,
            child: _textColumn(
              titleFontSize: 28,
              descriptionFontSize: 18,
              buttonHeight: AppConstants.buttonHeightPhone,
              buttonWidth: AppConstants.buttonWidthPhone,
            ),
          ),
          Flexible(
            child: RewardsCard(
              points: points,
              images: images,
            ),
          ),
        ],
      ),
    );
  }

  Widget _mobileBrowserLayout(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(30.0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.0),
              borderRadius: BorderRadius.circular(25),
              color: backgroundColor,
            ),
            height: AppConstants.screenHeight * 0.4,
            width: 450,
            child: _textColumn(
              titleFontSize: 40,
              descriptionFontSize: 20,
              buttonHeight: AppConstants.buttonHeightPhone,
              buttonWidth: AppConstants.buttonWidthPhone,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 24.0, left: 30.0, right: 30.0),
            child: RewardsCard(
              points: points,
              images: images,
            ),
          ),
        ],
      ),
    );
  }

  Widget _webLayout(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 60.0, vertical: 30.0),
            color: backgroundColor,
            child: _textColumn(
              titleFontSize: 40,
              descriptionFontSize: 20,
              buttonHeight: AppConstants.buttonHeightWeb,
              buttonWidth: AppConstants.buttonWidthWeb,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 40.0),
            color: backgroundColor,
            child: Center(
              child: RewardsCard(
                points: points,
                images: images,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _textColumn(
      {required double titleFontSize,
      required double descriptionFontSize,
      required double buttonHeight,
      required double buttonWidth}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TitleText(
          text: title,
          fontSize: titleFontSize,
          maxLines: 2,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: DescriptionText(
            text: description,
            fontSize: descriptionFontSize,
            maxLines: descriptionMaxLines,
          ),
        ),
        SmallElevatedButtonWeb(
          buttonText: callToActionText,
          buttonHeight: buttonHeight,
          buttonWidth: buttonWidth,
          onPressed: callToActionOnPressed,
        ),
      ],
    );
  }
}
